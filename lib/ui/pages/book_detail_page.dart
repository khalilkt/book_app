import 'dart:ui';
import 'package:books_app/bloc/auth_cubit.dart';
import 'package:books_app/models/book.dart';
import 'package:books_app/ui/constants.dart';
import 'package:books_app/ui/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../size_config.dart';

class Param {
  final String name;
  final String value;
  Param(this.name, this.value);
}

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  double headerSize = SizeConfig.h * .3;
  double _op =
      1; //opacity  for the widget that will disapear when the user scroll
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {
        headerSize = (-SizeConfig.hh * 3 / 200) * scrollController.offset +
            SizeConfig.hh * 3;
        double x = headerSize / (SizeConfig.hh * 3);
        if (headerSize < SizeConfig.hh) {
          headerSize = SizeConfig.hh;
        } else if (headerSize > 1.7 * SizeConfig.hh * 3) {
          headerSize = 1.7 * SizeConfig.hh * 3;
        }
        _op = (x / (1 - .6)) - (.6 / (1 - .6));
        if (_op < 0) {
          _op = 0;
        } else if (_op > 1) {
          _op = 1;
        }
      });
    });
  }

  Widget _buildParam(List<Param> params) {
    return Opacity(
      opacity: _op,
      child: LayoutBuilder(builder: (context, constr) {
        double w = constr.maxWidth;
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(params.length, (index) {
            BorderRadius borderRadius = BorderRadius.zero;
            if (index == 0) {
              borderRadius =
                  const BorderRadius.horizontal(left: Radius.circular(14));
            } else if (index == params.length - 1) {
              borderRadius =
                  const BorderRadius.horizontal(right: Radius.circular(14));
            }
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: borderRadius,
              ),
              width: w / params.length - 2,
              child: Column(
                children: [
                  Text(
                    params[index].value,
                    style: TextStyle(
                        fontSize: 20 * _op,
                        color: mainColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(params[index].name,
                      style: TextStyle(
                          fontSize: 16 * _op,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500)),
                ],
              ),
            );
          }),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(
      children: [
        SizedBox(
            width: double.infinity,
            height: headerSize,
            child: Stack(
              children: [
                ClipRect(
                  child: Builder(builder: (context) {
                    ImageProvider prv;
                    if (widget.book.thumbnail != null) {
                      prv = NetworkImage(widget.book.thumbnail!);
                    } else {
                      prv = const AssetImage("assets/images/no_cover.gif");
                    }
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: prv,
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 8),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    );
                  }),
                ),
                Positioned(
                    top: headerSize * .1,
                    left: SizeConfig.ww * .8,
                    child: DefTapAnimation(
                      end: 1.1,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          height: SizeConfig.ww * 1.1,
                          width: SizeConfig.ww * 1.1,
                          decoration: BoxDecoration(
                            color: mainColor,
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(3, 3),
                                  color: Colors.black.withOpacity(0.16),
                                  blurRadius: 6)
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                              child: SizedBox(
                            height: 16,
                            width: 24,
                            child: Image.asset(
                              'assets/images/back_arrow.png',
                              fit: BoxFit.fill,
                            ),
                          ))),
                    )),
                Positioned(
                  top: headerSize * .1,
                  right: SizeConfig.ww * .8,
                  child: DefTapAnimation(
                    end: 1.2,
                    onTap: () {
                      if ((context.read<AuthCubit>().state as UserLogedState)
                          .user
                          .favoriteBooks
                          .contains(widget.book.id)) {
                        context.read<AuthCubit>().removeFavBook(widget.book);
                      } else {
                        context.read<AuthCubit>().addFavBook(widget.book);
                      }
                    },
                    child: Icon(
                      Icons.favorite,
                      size: 34,
                      color:
                          (context.watch<AuthCubit>().state as UserLogedState)
                                  .user
                                  .favoriteBooks
                                  .contains(widget.book.id)
                              ? Colors.red
                              : Colors.grey,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, headerSize * .25),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          color: Colors.white,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Hero(
                              tag: widget.book.thumbnail ?? UniqueKey(),
                              child: Image.network(
                                widget.book.thumbnail ?? '',
                                height: headerSize,
                                fit: BoxFit.fitHeight,
                                errorBuilder: (c, _, __) {
                                  return Image.asset(
                                    "assets/images/no_cover.gif",
                                    height: headerSize,
                                    fit: BoxFit.fitHeight,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
              ],
            )),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.ww),
            child: Column(
              children: [
                SizedBox(
                  height: headerSize * .25,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.ww * .3),
                  child: Text(
                    widget.book.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: SizeConfig.ww * .54,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(widget.book.authors
                    .toString()
                    .substring(1, widget.book.authors.toString().length - 1)),
                const SizedBox(
                  height: 12,
                ),
                _buildParam(
                  [
                    if (widget.book.avRating != null)
                      Param(
                          'rating',
                          widget.book.avRating!.toString() +
                              "/" +
                              widget.book.ratingCount.toString()),
                    Param('Pages', widget.book.pageCount?.toString() ?? "0"),
                    Param(
                        'Langage', widget.book.langage.toString().toUpperCase())
                  ],
                ),
                // : Container(),
                SizedBox(
                  height: _op * 18,
                ),
                _op == 0
                    ? Container()
                    : Align(
                        alignment: Alignment.topLeft,
                        child: Opacity(
                          opacity: _op,
                          child: Text(
                              widget.book.description != null
                                  ? 'Desciption'
                                  : '',
                              style: TextStyle(
                                  fontSize: SizeConfig.ww * .62,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                // : Container(),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        widget.book.description ?? '',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: SizeConfig.ww * .48,
                            fontWeight: FontWeight.w400),
                      )),
                ),
              ],
            ),
          ),
        )
      ],
    )));
  }
}
