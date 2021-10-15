import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

const String AUTH_CUBIT = 'Auth Cubit';
const String AUTH_REPO = 'Auth Repo';
const String BOOK_REPO = 'Books Repo';

void logg(String message, [String from = 'All']) {
  if (kDebugMode) {
    print("--" + from + "-- " + message);
  }
}

void loggList(List<dynamic> list, {String from = 'All', String? header}) {
  if (header != null) {
    print(header);
  }
  for (int i = 0; i < list.length; i++) {
    print("[$i] : ${list[i]}");
  }
}
