import 'dart:async';
import 'package:books_app/bloc/auth_cubit.dart';
import 'package:books_app/bloc/books_cubit.dart';
import 'package:books_app/ui/pages/book_detail_page.dart';
import 'package:books_app/ui/size_config.dart';
import 'package:books_app/ui/widgets/book_cont.dart';
import 'package:books_app/ui/widgets/def_button.dart';
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
  Delayer delayer = Delayer(const Duration(milliseconds: 500));
  late TextEditingController searchController = TextEditingController();
  bool showClear = false;

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      if (searchController.text == '') {
        setState(() {
          showClear = false;
        });
      } else {
        setState(() {
          showClear = true;
        });
      }
      if (searchController.text == '' ||
          searchController.text.replaceAll(' ', '').isEmpty) {
        delayer.cancel();

        context.read<BooksCubit>().cancelSearch();
      } else {
        delayer.run(() {
          context.read<BooksCubit>().searchFor(searchController.text);
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
            size: 24,
            color: Colors.grey,
          ),
          Expanded(
            child: TextField(
              autofocus: false,
              controller: searchController,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                  hintText: 'Search for books',
                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: 18),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
            ),
          ),
          showClear
              ? GestureDetector(
                  onTap: () {
                    searchController.text = '';
                  },
                  child: FaIcon(
                    Icons.clear,
                    size: 24,
                    color: Colors.grey[700],
                  ),
                )
              : Container(),
          const SizedBox(
            width: 26,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                      GestureDetector(
                        onTap: () {
                          context.read<AuthCubit>().signOut();
                        },
                        child: Text("Explore thousands of books on the go",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: SizeConfig.ww * .66,
                                fontWeight: FontWeight.bold)),
                      ),
                      _buildSearchBar(),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: BlocBuilder<BooksCubit, BooksState>(
                            builder: (context, state) {
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
                  if (state is GoodBookState) {
                    if (state.books.isNotEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          await context
                              .read<BooksCubit>()
                              .updateRecommendation();
                        },
                        child: ListView.builder(
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
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (c) {
                                          return BlocProvider.value(
                                            value: context.read<AuthCubit>(),
                                            child: BookDetailPage(
                                                book: state.books[index]),
                                          );
                                        }));
                                      },
                                      // width: SizeConfig.w * .86,
                                      height: SizeConfig.w * .46,
                                      book: state.books[index]),
                                ),
                              );
                            }),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(SizeConfig.ww * 1, 0,
                            SizeConfig.ww * 1, SizeConfig.ww * .5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/no_result.png',
                                width: SizeConfig.w * .4, fit: BoxFit.fill),
                            SizedBox(height: SizeConfig.hh / 2),
                            Text(
                              "Sorry, no search reesults !",
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeConfig.ww * .6),
                            ),
                          ],
                        ),
                      );
                    }
                  } else if (state is ExceptionState) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(SizeConfig.ww * 1, 0,
                          SizeConfig.ww * 1, SizeConfig.ww * .5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('assets/images/error.png',
                              width: SizeConfig.w * .4, fit: BoxFit.fill),
                          Text(
                            state.message,
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontWeight: FontWeight.w500,
                                fontSize: SizeConfig.ww * .6),
                          ),
                          state.subMessage != null
                              ? Text(
                                  state.subMessage!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizeConfig.ww * .42),
                                )
                              : Container(),
                          DefButton(
                            text: 'TRY AGAIN',
                            backColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.ww * .7, vertical: 12),
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: SizeConfig.ww * .5),
                            onTap: () {
                              if (searchController.text == '') {
                                context
                                    .read<BooksCubit>()
                                    .updateRecommendation();
                              } else {
                                context
                                    .read<BooksCubit>()
                                    .searchFor(searchController.text);
                              }
                            },
                          )
                        ],
                      ),
                    );
                  }
                  throw (Excpetion());
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}

class Excpetion {}

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
