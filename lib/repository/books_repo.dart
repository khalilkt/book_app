import 'dart:convert';
import 'dart:math';

import 'package:books_app/models/book.dart';
import 'package:http/http.dart' as http;

class BooksRepo {
  static const String BASE = 'https://www.googleapis.com/books/v1/volumes';
  List<Book> recommendation = []; // it is like a cache

  Future<List<Book>> getRecommended(List<String> categories) async {
    List<Book> ret = [];
    //get 40 books per categorie and pick some random books

    for (String cat in categories) {
      List items =
          (await getSearchResponse('subject:$cat&maxResults=30'))['items'];
      for (int i = 0; i < 20 ~/ categories.length; i++) {
        int ran = Random().nextInt(items.length);
        ret.add(
            Book.fromVolumeInfo(items[ran]["volumeInfo"], items[ran]["id"]));
      }
    }
    ret.shuffle();
    recommendation = List.from(ret);
    return ret;
  }

  Future<Map<String, dynamic>> getSearchResponse(String param) async {
    http.Response response = await http.get(Uri.parse(BASE + '?q=' + param));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('repoonse code is not 200');
    }
  }

  Future<List<Book>> seachForBooks(String param) async {
    List<Book> ret = [];
    List? items = (await getSearchResponse(param))['items'];
    if (items != null && items.isNotEmpty) {
      for (Map<String, dynamic> map in items) {
        Map<String, dynamic> volumeInfo = map['volumeInfo'];

        ret.add(Book.fromVolumeInfo(volumeInfo, map['id']));
      }
    }

    return ret;
  }
}
