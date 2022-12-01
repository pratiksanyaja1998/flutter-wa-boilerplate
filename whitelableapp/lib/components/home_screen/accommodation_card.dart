
import 'package:flutter/material.dart';
import 'package:whitelableapp/config.dart';
import 'package:whitelableapp/widgets/widgets.dart';

class AccommodationCard extends StatefulWidget {
  const AccommodationCard({
    Key? key,
    required this.name,
    required this.description,
    required this.images,
  }) : super(key: key);

  final String name;
  final String description;
  final List<dynamic> images;

  @override
  State<AccommodationCard> createState() => _AccommodationCardState();
}

class _AccommodationCardState extends State<AccommodationCard> {

  PageController pageController = PageController();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 420,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 370,
                    maxHeight: 230,
                    minWidth: 370,
                    minHeight: 230,
                  ),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (index){
                        currentPageIndex = index;
                        setState(() {});
                      },
                      children: [
                        for(int i = 0; i < widget.images.length; i++)
                          Image.network(
                            widget.images[i]["image"], fit: BoxFit.cover,
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
              ),
              // Positioned(
              //   top: 0,
              //   left: 0,
              //   bottom: 0,
              //   child: Center(
              //     child: Container(
              //       margin: const EdgeInsets.all(10),
              //       width: 35,
              //       height: 35,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(15),
              //         boxShadow: [
              //           BoxShadow(
              //               color: Colors.black.withOpacity(0.4),
              //               blurRadius: 8
              //           )
              //         ],
              //       ),
              //       child: Widgets().textButton(
              //         onPressed: (){
              //           pageController.previousPage(duration: Duration(milliseconds: 600), curve: Curves.ease);
              //         },
              //         text: "Go back",
              //         backgroundColor: Colors.white,
              //         padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              //         child: const Icon(Icons.arrow_back_ios_rounded, color: kThemeColor, size: 18,),
              //       ),
              //     ),
              //   ),
              // ),
              // Positioned(
              //   top: 0,
              //   right: 0,
              //   bottom: 0,
              //   child: Center(
              //     child: Container(
              //       margin: const EdgeInsets.all(10),
              //       height: 35,
              //       width: 35,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(15),
              //         boxShadow: [
              //           BoxShadow(
              //               color: Colors.black.withOpacity(0.4),
              //               blurRadius: 8
              //           )
              //         ],
              //       ),
              //       child: Widgets().textButton(
              //         onPressed: (){
              //           pageController.nextPage(duration: Duration(milliseconds: 600), curve: Curves.ease);
              //         },
              //         text: "Go forward",
              //         backgroundColor: Colors.white,
              //         padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              //         child: const Icon(Icons.arrow_forward_ios_rounded, color: kThemeColor, size: 18,),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(widget.images.length > 1)
                for(int i = 0; i < widget.images.length; i++)
                  GestureDetector(
                    onTap: (){
                      pageController.animateToPage(i,duration: Duration(milliseconds: 600), curve: Curves.ease);
                    },
                    child: AnimatedContainer(
                      width: currentPageIndex == i ? 20.0 : 10,
                      height: 5.0,
                      margin: EdgeInsets.only(bottom: 15.0, left: 4, right: 4, top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: currentPageIndex == i ? kThemeColor  : kSecondaryColor,
                      ),
                      duration: const Duration(
                        milliseconds: 500,
                      ),
                    ),
                  ),

            ],
          ),
          // const SizedBox(height: 10,),
          Container(
            // width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(10),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withOpacity(0.4),
            //       blurRadius: 6,
            //     )
            //   ],
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  widget.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

