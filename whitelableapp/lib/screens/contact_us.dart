
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/config.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kThemeColor,
                Colors.white,
              ]
          )
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(getTranslated(context, ["contactUs", "title"]),),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: Container(
              margin: const EdgeInsets.all(20.0),
              constraints: const BoxConstraints(
                maxWidth: 370,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      constraints: const BoxConstraints(
                        maxWidth: 370,
                      ),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                SharedPreference.getBusinessConfig()!.contactUs.bussinessName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Text(
                            getTranslated(context, ["contactUs", "label", "contact"]),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            SharedPreference.getBusinessConfig()!.contactUs.mobile,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text(
                            getTranslated(context, ["contactUs", "label", "email"]),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            SharedPreference.getBusinessConfig()!.contactUs.email,
                            // textAlign: TextAlign.end,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       getTranslated(context, ["contactUs", "label", "contact"]),
                          //       style: const TextStyle(
                          //         color: Colors.black,
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //     const SizedBox(width: 10,),
                          //     Expanded(child: Text(
                          //       SharedPreference.getBusinessConfig()!.contactUs.mobile,
                          //       textAlign: TextAlign.end,
                          //     )),
                          //   ],
                          // ),
                          // const SizedBox(height: 10,),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       getTranslated(context, ["contactUs", "label", "email"]),
                          //       style: const TextStyle(
                          //         color: Colors.black,
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //     const SizedBox(width: 10,),
                          //     Expanded(child: Text(
                          //       SharedPreference.getBusinessConfig()!.contactUs.email,
                          //       // textAlign: TextAlign.end,
                          //     )),
                          //   ],
                          // ),
                          const SizedBox(height: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getTranslated(context, ["contactUs", "label", "address"]),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // const SizedBox(height: 5,),
                              Text(SharedPreference.getBusinessConfig()!.contactUs.address,),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await launchUrl(Uri.parse("https://${SharedPreference.getBusinessConfig()!.domain}"));
                                },
                                child: Text(
                                  "https://${SharedPreference.getBusinessConfig()!.domain}",
                                  style: const TextStyle(
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
