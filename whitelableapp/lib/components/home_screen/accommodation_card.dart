
import 'package:flutter/material.dart';
import 'package:whitelabelapp/config.dart';

class AccommodationCard extends StatefulWidget {
  const AccommodationCard({
    Key? key,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.rating,
  }) : super(key: key);

  final String name;
  final String description;
  final String price;
  final List<dynamic> images;
  final double rating;

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
        maxWidth: 370,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      // padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 370,
                  maxHeight: 230,
                  minWidth: 370,
                  minHeight: 230,
                ),
                // decoration: BoxDecoration(
                //   color: kPrimaryColor,
                //   borderRadius: BorderRadius.circular(15),
                //   boxShadow: [
                //     BoxShadow(
                //         color: Colors.black.withOpacity(0.5),
                //         blurRadius: 10
                //     )
                //   ],
                // ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(8) , topLeft: Radius.circular(8)),
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (index){
                      currentPageIndex = index;
                      setState(() {});
                    },
                    children: [
                      for(int i = 0; i < widget.images.length; i++)
                        Image.network(
                          widget.images[i]["image"],
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
                    if(widget.images.length > 1)
                      for(int i = 0; i < widget.images.length; i++)
                        GestureDetector(
                          onTap: (){
                            pageController.animateToPage(i,duration: const Duration(milliseconds: 600), curve: Curves.ease);
                          },
                          child: AnimatedContainer(
                            width: currentPageIndex == i ? 20.0 : 10,
                            height: 5.0,
                            margin: const EdgeInsets.only(bottom: 15.0, left: 4, right: 4, top: 10),
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
              ),
            ],
          ),
          const SizedBox(height: 15,),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     if(widget.images.length > 1)
          //       for(int i = 0; i < widget.images.length; i++)
          //         GestureDetector(
          //           onTap: (){
          //             pageController.animateToPage(i,duration: Duration(milliseconds: 600), curve: Curves.ease);
          //           },
          //           child: AnimatedContainer(
          //             width: currentPageIndex == i ? 20.0 : 10,
          //             height: 5.0,
          //             margin: EdgeInsets.only(bottom: 15.0, left: 4, right: 4, top: 10),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(4),
          //               color: currentPageIndex == i ? kThemeColor  : kSecondaryColor,
          //             ),
          //             duration: const Duration(
          //               milliseconds: 500,
          //             ),
          //           ),
          //         ),
          //
          //   ],
          // ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  widget.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 10,),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Price",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.price,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 5),
                        child: VerticalDivider(
                          color: Colors.grey,
                          width: 30,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Reviews",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.rating.toString(),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10,),
                              for(int i = 0; i < 5; i++)
                                buildStar(context, i),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= widget.rating) {
      icon = const Icon(
        Icons.star_border,
        color: Colors.orange,
      );
    }
    else if (index > widget.rating - 1 && index < widget.rating) {
      icon = const Icon(
        Icons.star_half,
        color: Colors.orange,
      );
    } else {
      icon = const Icon(
        Icons.star,
        color: Colors.orange,
      );
    }
    return icon;
  }

}

