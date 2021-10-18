import 'package:flutter/material.dart';
import 'package:books_app/models/book.dart';

class BookContainer extends StatelessWidget {
  final Book book;
  final double width;
  final double height;
  final Function onTap;
  const BookContainer(
      {Key? key,
      required this.onTap,
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
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
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
            Hero(
              tag: book.thumbnail ?? 's',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Builder(builder: (context) {
                  ImageProvider prv;
                  if (book.thumbnail != null) {
                    prv = NetworkImage(book.thumbnail!);
                  } else {
                    prv = const AssetImage("assets/images/no_cover.gif");
                  }
                  return Image(
                    image: prv,
                    height: height * .84,
                    width: height * .6,
                    fit: BoxFit.fitHeight,
                    errorBuilder: (c, _, __) {
                      return Image.asset(
                        "assets/images/no_cover.gif",
                        height: height * .84,
                        width: height * .6,
                        fit: BoxFit.fitHeight,
                      );
                    },
                  );
                }),
              ),
            ),
            SizedBox(
              width: (height * (1 - .84)) / 2,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 26, bottom: 14, right: (height * (1 - .84)) / 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (c) {
                        String t = '';
                        for (String name in book.authors) {
                          t += name + ',';
                        }
                        return Text("by $t",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]));
                      },
                    ),
                    Text(book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    book.avRating == null
                        ? Container()
                        : Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.yellow[600], size: 16),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(book.avRating.toString(),
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children:
                              List.generate(book.categories.length, (index) {
                        return _buildCategory(book.categories[index]);
                      })),
                    ),
                  ],
                ),
              ),
            )
          ])),
    );
  }
}
