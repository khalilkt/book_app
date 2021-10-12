import 'package:books_app/models/book.dart';
import 'package:books_app/ui/size_config.dart';
import 'package:books_app/ui/widgets/book_cont.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> booksList = [
    thinkAndGrowRichBook,
    richDadPoorDadBook,
    sellAnythingToAnyBody,
    thinkAndGrowRichBook,
    richDadPoorDadBook,
    sellAnythingToAnyBody
  ];

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2)
          ]),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          const FaIcon(
            FontAwesomeIcons.search,
            color: Colors.grey,
          ),
          Expanded(
            child: TextField(
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                  // prefix: ,

                  hintText: 'Search for books',
                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: 18),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfig.hh * .4),
          SizedBox(
              height: SizeConfig.h * .32,
              child: Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.ww * .8, right: SizeConfig.ww / 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Explore thousands of books on the go",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.ww * .66,
                            fontWeight: FontWeight.bold)),
                    _buildSearchBar(),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Books for you",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: SizeConfig.ww * .56,
                                fontWeight: FontWeight.bold)))
                  ],
                ),
              )),
          Expanded(
            child: ListView.builder(
                itemCount: booksList.length,
                padding: const EdgeInsets.only(top: 14),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 18,
                          left: SizeConfig.ww * .7,
                          right: SizeConfig.ww / 2),
                      child: BookContainer(
                          // width: SizeConfig.w * .86,
                          height: SizeConfig.w * .46,
                          book: booksList[index]),
                    ),
                  );
                }),
          )
        ],
      ),
    ));
  }
}
