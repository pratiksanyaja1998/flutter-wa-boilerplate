const fs = require("fs");
const envfile = require("envfile");
const axios = require("axios");

require("dotenv").config();

let baseUrl;
if (process.env.ENV == "local") {
  baseUrl = "http://192.168.1.11:9000";
}
if (process.env.ENV == "development") {
  baseUrl = "https://wa.dev.spyhunteritsolution.in";
} else {
  baseUrl = "https://api.whitelabelapp.in";
}

axios
  .get(`${baseUrl}/business/app/config/${process.env.DOMAIN}`)
  .then(async (response) => {
    console.log("response -->", response?.data?.data);

    // update env file
    let parsedFile = envfile.parse(".env");
    parsedFile.DOMAIN = response.data?.data?.domain;
    parsedFile.ENV = "production";
    parsedFile.APP_NAME = response.data?.data?.appName;
    parsedFile.BUNDLE_IDENTIFIER = response.data?.data?.iosBundleIdentifier;
    parsedFile.PACKAGE = response.data?.data?.androidPackageName;
    parsedFile.DARK = response.data?.data?.theme.dark;
    parsedFile.PRIMARY_COLOR = response.data?.data?.theme.primaryColor;
    parsedFile.SECONDARY_COLOR = response.data?.data?.theme.secondaryColor;
    parsedFile.THEME_COLOR = response.data?.data?.theme.themeColor;
    fs.writeFileSync("./.env", envfile.stringify(parsedFile));

    //update theme.dart file in lib

    let theme = `import 'package:flutter/material.dart';
    const kPrimaryColor = Color(0xff${response.data?.data?.theme.primaryColor.replace(
      "#",
      ""
    )});
    const kSecondaryColor = Color(0xff${response.data?.data?.theme.secondaryColor.replace(
      "#",
      ""
    )});
    const kThemeColor = Color(0xff${response.data?.data?.theme.themeColor.replace(
      "#",
      ""
    )});
    `;
    fs.writeFileSync("./whitelableapp/lib/theme.dart", theme);

    // update google service file and info plist file
    if (
      response.data?.data?.google_android_file &&
      response.data?.data?.google_ios_file
    ) {
      //write google-service file
      await axios
        .get(response.data?.data?.google_android_file, {
          responseType: "arraybuffer",
        })
        .then(async (res) => {
          return fs.writeFileSync(
            "./whitelableapp/android/app/google-services.json",
            res.data
          );
        })
        .catch((error) => console.log("error", error));

      //write google-Apple file
      await axios
        .get(response.data?.data?.google_ios_file, {
          responseType: "arraybuffer",
        })
        .then(async (res) => {
          return fs.writeFileSync(
            "./whitelableapp/ios/GoogleService-Info.plist",
            res.data
          );
        })
        .catch((error) => console.log("error", error));
    }

    // update logo in assets
    if (response.data?.data?.logo) {
      axios
        .get(response.data?.data?.logo, { responseType: "arraybuffer" })
        .then(async (res) => {
          try {
            fs.writeFileSync("./logo.png", res.data);
          } catch (error) {
            console.log("error update logo", error);
          }
          setTimeout(() => {}, 1500);
          console.log("--- Setup is done ---");
          process.exit();
        });
    }
  })
  .catch((error) => {
    console.log("error", error?.response?.data || error);
  });
