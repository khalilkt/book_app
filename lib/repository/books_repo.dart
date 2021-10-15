import 'dart:convert';
import 'dart:math';

import 'package:books_app/logg.dart';
import 'package:books_app/models/book.dart';
import 'package:http/http.dart' as http;

class BooksRepo {
  String BASE = 'https://www.googleapis.com/books/v1/volumes';
  // 'volumes?q';

  Future<List<Book>> getRecommended(List<String> categories) async {
    // this.recommendation  = ret;
    // eveytimet this function is called the recc changes and the function return recc
    List<Book> ret = [];
    //get 40 books per categorie and pick 3 random

    for (String cat in categories) {
      Map<String, dynamic> items =
          (await getSearchResponse('subject:$cat&maxResults=30'))['items'];
      for (int i = 0; i < 20 ~/ categories.length; i++) {
        int ran = Random().nextInt(items.length);
        ret.add(Book.fromVolumeInfo(items[ran]["volumeInfo"]));
      }
    }
    ret.shuffle();
    return ret;
  }

//15 do crit 4%crit
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

    for (Map<String, dynamic> map
        in (await getSearchResponse(param))['items']) {
      Map<String, dynamic> volumeInfo = map['volumeInfo'];

      ret.add(Book.fromVolumeInfo(volumeInfo));
    }
    loggList(ret, header: 'result for search : $param : ', from: BOOK_REPO);
    return ret;
  }

  // Future<Book> getBookById() async{

  // }
}
