import 'package:flutter/cupertino.dart';

const Book richDadPoorDadBook = Book(
    title: 'Rich dad poor dad',
    authors: ['Robert kyosaki'],
    pageCount: 325,
    categories: ["Business"],
    avRating: 4.2,
    ratingCount: 30,
    langage: "En",
    thumbnail:
        'https://books.google.com/books/content?id=mmA9EAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api');

const Book thinkAndGrowRichBook = Book(
    title: 'Think and grow rich',
    authors: ['Napoleon hill'],
    pageCount: 400,
    categories: ['money'],
    avRating: 3.8,
    ratingCount: 10,
    langage: "En",
    thumbnail:
        'https://books.google.com/books/content?id=0eLbDwAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api');

const sellAnythingToAnyBody = Book(
    title: 'How to sell anything to anybody',
    authors: ['Joe girard', 'Stanley H. Brow'],
    pageCount: 179,
    categories: ['usiness & Economics'],
    avRating: 3.9,
    ratingCount: 84,
    langage: "Fr",
    thumbnail:
        'https://books.google.com/books/content?id=shy_qCdGFLkC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api');

class Book {
  final String title;
  final List<String> authors;
  final int pageCount;
  final List<String> categories;
  final double avRating;
  final int ratingCount;
  final String langage;
  final String thumbnail;
//  late final  ImageProvider image;
  final String? description;

  const Book(
      {required this.title,
      required this.authors,
      required this.pageCount,
      required this.categories,
      required this.avRating,
      required this.ratingCount,
      required this.langage,
      required this.thumbnail,
      this.description});
}
