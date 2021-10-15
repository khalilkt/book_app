import 'dart:async';

import 'package:books_app/bloc/books_cubit.dart';
import 'package:books_app/models/book.dart';
import 'package:books_app/ui/size_config.dart';
import 'package:books_app/ui/widgets/book_cont.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Book> booksList = [];
  Delayer delayer = Delayer(const Duration(milliseconds: 700));
  late TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      if (searchController.text == '') {
        delayer.cancel();
        print("2325 : stop the delayer and show recomendation");
        setState(() {
          // booksList = context.read<BooksCubit>().recommended;
        });
      } else {
        delayer.run(() {
          context
              .read<BooksCubit>()
              .searchFor(searchController.text)
              .then((results) {
            print("2325 : searching for ${searchController.text}");
            setState(() {
              // booksList = results;
            });
          });
        });
      }
    });
  }

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
              controller: searchController,
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
                        child: BlocBuilder<BooksCubit, BooksState>(
                          builder: (context, state) {
                            print('state is $state');
                            if (state is RecommendedState) {
                              return Text("Books for you",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: SizeConfig.ww * .56,
                                      fontWeight: FontWeight.bold));
                            } else {
                              return Container();
                            }
                          },
                        ))
                  ],
                ),
              )),
          Expanded(
            child: BlocBuilder<BooksCubit, BooksState>(
              builder: (context, state) {
                return ListView.builder(
                    // itemCount: booksList.length,
                    itemCount: state.books.length,
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
                              book: state.books[index]),
                        ),
                      );
                    });
              },
            ),
          )
        ],
      ),
    ));
  }
}

class Delayer {
  final Duration _duration;
  late Timer _timer = Timer(Duration.zero, () {});
  Delayer(this._duration);

  void run(VoidCallback fct) {
    _timer.cancel();

    _timer = Timer(_duration, fct);
  }

  void cancel() {
    _timer.cancel();
  }
}
