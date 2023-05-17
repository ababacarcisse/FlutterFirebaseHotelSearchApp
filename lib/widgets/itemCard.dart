import 'package:flutter/material.dart';

import '../misc/colors.dart';
import '../misc/style.dart';
import '../pages/detail_page.dart';

class ItemCard extends StatelessWidget {
  final String name;
  final String imageURL;
  final String destination;
  final String phone;
  final String price;
  final String description;
  const ItemCard({
    Key? key,
    required this.name,
    required this.imageURL,
    required this.destination,
    required this.phone,
    required this.price,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(
                  destination: destination,
                  imageURL: imageURL as String,
                  name: name,
                  phone: phone,
                  price: price,
                  description: description)),
        );
      },
      child: Container(
        color: AppColors.textColor1,
        height: 140.0,
        margin: const EdgeInsets.only(bottom: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 140.0,
              child: imageURL != null ? Image.network(imageURL) : Placeholder(),
            ),
            // complet
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      name,
                      style: itemCardHeading,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      destination,
                      maxLines: 3,
                      style: itemCardDes,
                    ),
                    //      const SizedBox(height: 15.0),
                    Text(
                      "Fran Cfa ${price}",
                      style: itemCardPrice,
                    )
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              splashColor: Colors.transparent,
              icon: const Icon(
                Icons.favorite_border_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
