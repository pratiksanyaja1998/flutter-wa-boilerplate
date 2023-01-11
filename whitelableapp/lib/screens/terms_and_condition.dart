
import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:webviewx/webviewx.dart';
import 'package:whitelabelapp/config.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionScreen> createState() => _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {

  String terms = "$baseUrl/business/terms-of-use/${SharedPreference.getBusinessConfig()!.businessId}";
  String policy = "$baseUrl/business/privacy-policy/${SharedPreference.getBusinessConfig()!.businessId}";

  @override
  void initState() {
    super.initState();
  }

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
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text("Terms & Policies"),
              backgroundColor: Colors.transparent,
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 60),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: kThemeColor,
                    border: Border.all(color: kPrimaryColor, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TabBar(
                      labelStyle: const TextStyle(
                        fontSize: 16,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        // decoration: TextDecoration.underline,
                        decorationThickness: 2,
                      ),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.white,
                      indicator: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      tabs: const [
                        Tab(
                          text: "Terms of Use",
                        ),
                        Tab(
                          text: "Privacy Policy",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 6,
                  )
                ],
              ),
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  WebViewX(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    initialContent: terms,
                    initialSourceType: SourceType.url,
                  ),
                  WebViewX(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    initialContent: policy,
                    initialSourceType: SourceType.url,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
