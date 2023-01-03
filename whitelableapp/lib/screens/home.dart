
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/components/drawer.dart';
import 'package:whitelabelapp/config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final String title = "Products";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool showProgress = false;
  bool gettingProducts = false;

  late Timer _timer;

  List<dynamic> productList = [];

  int currentSliderPageIndex = 0;
  PageController imageSliderController = PageController();
  int currentBannerIndex = 0;
  PageController bannerController = PageController();

  Map<dynamic, dynamic>? appHomePage;

  @override
  void initState() {
    getHomePageData();
    super.initState();
  }

  void getHomePageData(){
    appHomePage = SharedPreference.getBusinessConfig()!.appHomePage;
    setState(() {});
    if(appHomePage!["slider"].length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
        if (currentSliderPageIndex == appHomePage!["slider"].length - 1) {
          imageSliderController.animateToPage(
              0, duration: const Duration(milliseconds: 600),
              curve: Curves.ease);
        } else {
          imageSliderController.nextPage(
              duration: const Duration(milliseconds: 600), curve: Curves.ease);
        }
        if (currentBannerIndex == appHomePage!["bannerCard"].length - 1) {
          bannerController.animateToPage(
              0, duration: const Duration(milliseconds: 600),
              curve: Curves.ease);
        } else {
          bannerController.nextPage(
              duration: const Duration(milliseconds: 600), curve: Curves.ease);
        }
      });
    }
    if(appHomePage!["topProducts"].isNotEmpty){
      gettingProducts = true;
      setState(() {});
      getProducts(ids: appHomePage!["topProducts"].toString().replaceAll("[", "").replaceAll("]", ""));
    }
  }

  Future<void> getProducts({String? ids})async{
    var response = await BusinessServices().getTopProductList(
      ids: ids
    );
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      productList = data;
      gettingProducts = false;
      setState(() {});
    } else {
      gettingProducts = false;
      setState(() {});
      if(!mounted) return;
      CommonFunctions().showError(data: data, context: context);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    imageSliderController.dispose();
    bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(getTranslated(context, ["menu","home"])),
      ),
      drawer: DrawerItem().drawer(context, setState),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 1000,
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Center(
            child: RefreshIndicator(
              onRefresh: ()async{

              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: showProgress ? const Center(
                  child: CircularProgressIndicator(
                    color: kThemeColor,
                  ),
                ) : Column(
                  children: appHomePage != null ? [
                    if(!kIsWeb)
                      const SizedBox(height: 20,),
                    if(!kIsWeb)
                      Widgets().appLogo(
                        height: 100,
                        width: 100,
                        radius: 5,
                      ),
                    const SizedBox(height: 40,),
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          constraints: const BoxConstraints(
                            maxHeight: 150,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: PageView(
                              controller: imageSliderController,
                              onPageChanged: (index){
                                currentSliderPageIndex = index;
                                setState(() {});
                              },
                              children: [
                                for(int i = 0; i < appHomePage!["slider"].length; i++)
                                  Image.network(
                                    appHomePage!["slider"][i]["image"],
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress){
                                      if(loadingProgress != null){
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: kThemeColor,
                                            strokeWidth: 3,
                                          ),
                                        );
                                      }else{
                                        return child;
                                      }
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          left: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if(appHomePage!["slider"].length > 1)
                                for(int i = 0; i < appHomePage!["slider"].length; i++)
                                  GestureDetector(
                                    onTap: (){
                                      imageSliderController.animateToPage(i,duration: const Duration(milliseconds: 600), curve: Curves.ease);
                                    },
                                    child: AnimatedContainer(
                                      width: currentSliderPageIndex == i ? 24.0 : 12,
                                      height: 8.0,
                                      margin: const EdgeInsets.only(bottom: 15.0, left: 4, right: 4, top: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: currentSliderPageIndex == i ? kThemeColor  : Colors.black.withOpacity(0.3),
                                      ),
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if(gettingProducts || productList.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Top Products",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  if(!gettingProducts)
                                    Stack(
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              for(int i = 0; i < productList.length; i++)
                                                Container(
                                                  height: 250,
                                                  width: 200,
                                                  margin: const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius: BorderRadius.circular(10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.3),
                                                        blurRadius: 6,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: SizedBox(
                                                          width: 200,
                                                          child: ClipRRect(
                                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10),),
                                                            child: Image.network(
                                                              productList[i]["images"][0]["photo"],
                                                              fit: BoxFit.cover,
                                                              loadingBuilder: (context, child, loadingProgress){
                                                                if(loadingProgress != null){
                                                                  return const Center(
                                                                    child: CircularProgressIndicator(
                                                                      color: kThemeColor,
                                                                      strokeWidth: 3,
                                                                    ),
                                                                  );
                                                                }else{
                                                                  return child;
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              productList[i]["name"],
                                                              style: const TextStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "₹ ${productList[i]["price"]}",
                                                                  style: const TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 5),
                                                                // if(double.parse(productList[i]["discount"]) != 0 )
                                                                  Text(
                                                                    "${double.parse(productList[i]["price"]) + ((double.parse(productList[i]["price"]) * double.parse(productList[i]["discount"]))/100)}",
                                                                    style: const TextStyle(
                                                                      fontSize: 16,
                                                                      decoration: TextDecoration.lineThrough
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Center(
                                      child: Column(
                                        children: const [
                                          CircularProgressIndicator(
                                            color: kThemeColor,
                                          ),
                                          Text("getting products"),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20,),
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          constraints: const BoxConstraints(
                            maxHeight: 150,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: PageView(
                              controller: bannerController,
                              onPageChanged: (index){
                                currentBannerIndex = index;
                                setState(() {});
                              },
                              children: [
                                for(int i = 0; i < appHomePage!["bannerCard"].length; i++)
                                  Image.network(
                                    appHomePage!["bannerCard"][i]["image"],
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress){
                                      if(loadingProgress != null){
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: kThemeColor,
                                            strokeWidth: 3,
                                          ),
                                        );
                                      }else{
                                        return child;
                                      }
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          left: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if(appHomePage!["bannerCard"].length > 1)
                                for(int i = 0; i < appHomePage!["bannerCard"].length; i++)
                                  GestureDetector(
                                    onTap: (){
                                      bannerController.animateToPage(i,duration: const Duration(milliseconds: 600), curve: Curves.ease);
                                    },
                                    child: AnimatedContainer(
                                      width: currentBannerIndex == i ? 24.0 : 12,
                                      height: 8.0,
                                      margin: const EdgeInsets.only(bottom: 15.0, left: 4, right: 4, top: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: currentBannerIndex == i ? kThemeColor  : Colors.black.withOpacity(0.3),
                                      ),
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                  ] : [],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
