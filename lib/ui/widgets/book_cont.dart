import 'package:books_app/ui/constants.dart';
import 'package:flutter/material.dart';
import 'package:books_app/models/book.dart';

class BookContainer extends StatelessWidget {
  final Book book;
  final double width;
  final double height;
  const BookContainer(
      {Key? key,
      required this.height,
      required this.book,
      this.width = double.infinity})
      : super(key: key);

  Widget _buildCategory(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.blue[100],
      ),
      child: Text(
        name,
        style: TextStyle(color: Colors.blue[800]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("wid : $width");
    return Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12)
            ]),
        width: width,
        height: height,
        child: Row(children: [
          SizedBox(
            width: (height * (1 - .84)) / 2,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              book.thumbnail,
              height: height * .84,
              fit: BoxFit.fitHeight,
            ),
          ),
          SizedBox(
            width: (height * (1 - .84)) / 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 26, bottom: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("by ${book.authors[0]}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  Text(book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow[600]),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(book.avRating.toString(),
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  _buildCategory("Business"),
                ],
              ),
            ),
          )
        ]));
  }
}
