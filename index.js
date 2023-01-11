const fs = require("fs");
const envfile = require("envfile");
const axios = require("axios");
const { exec, execSync } = require("child_process");

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
    const kDarkTheme = ${response.data?.data?.theme.dark};
    const kDomain = "${response.data?.data?.domain}";
    const kAppName = "${response.data?.data?.appName}";
    `;
    fs.writeFileSync("./whitelableapp/lib/config.dart", theme);

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
      await axios
        .get(response.data?.data?.logo, { responseType: "arraybuffer" })
        .then(async (res) => {
          try {
            fs.writeFileSync("./logo.png", res.data);
            fs.writeFileSync(
              "./whitelableapp/assets/images/logo.png",
              res.data
            );
            console.log("--- logo updated successfully ---");
          } catch (error) {
            console.log("error update logo", error);
          }
        });
    }

    let cmdStatus = "";
    // active rename app
    cmdStatus = execSync(
      `cd ./whitelableapp && flutter pub global activate rename`
    );
    console.log("--- activate rename app done ---");

    // rename app name
    cmdStatus = execSync(
      `cd ./whitelableapp && flutter pub global run rename --appname "${response.data?.data?.appName}"`
    );
    console.log("--- rename app done ---");

    // update app android package name
    console.log(`--- updating package name to "${response.data?.data?.androidPackageName}"" ---`);
    cmdStatus = execSync(
      `cd ./whitelableapp && flutter pub global run rename --bundleId "${response.data?.data?.androidPackageName}" -t android`
    );
    console.log("--- update package name done ---");

    // update ios bundle identifier
    cmdStatus = execSync(
      `cd ./whitelableapp && flutter pub global run rename --bundleId "${response.data?.data?.iosBundleIdentifier}" -t ios`
    );
    console.log("--- update ios bundle name done ---");

    // update app icon
    cmdStatus = execSync(
      `cd ./whitelableapp && flutter pub run flutter_launcher_icons`
    );
    console.log("--- update app icon done ---");

    // check if firebase_option.dart exist then remove
    if (fs.existsSync("./whitelableapp/lib/firebase_options.dart")) {
      fs.rmSync("./whitelableapp/lib/firebase_options.dart");
    }
    // check if firebase_app_id_file.json exist then remove
    if (fs.existsSync("./whitelableapp/ios/firebase_app_id_file.json")) {
      fs.rmSync("./whitelableapp/ios/firebase_app_id_file.json");
    }
    console.log("--- delete option file and firebase app id file done ---");

    // update firebase_option.dart file for firebase
    cmdStatus = execSync(
      `cd ./whitelableapp && flutterfire configure -p "${response.data?.data?.firebase_project_id || "kalpvruksh-foundation"}"`,
      {
        encoding: "utf-8",
        stdio: "inherit",
      }
    );
    console.log("--- firebase config done ---");

    setTimeout(() => {}, 1500);
    console.log("--- Setup is done ---");
    process.exit();

  })

  .catch((error) => {
    console.log("error", error?.response?.data || error);
  });
