
import 'package:flutter/material.dart';
import 'package:whitelableapp/config.dart';

class AccommodationCard extends StatelessWidget {
  AccommodationCard({
    Key? key,
    required this.name,
    required this.description,
    required this.imageUrl,
  }) : super(key: key);

  String name;
  String description;
  String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(imageUrl),
            ),
          ),
          SizedBox(height: 15,),
          Text(
            name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
          // SizedBox(height: ,),
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16
            ),
          ),
        ],
      ),
    );
  }
}
