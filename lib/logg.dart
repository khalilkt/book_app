import 'package:flutter/foundation.dart';

const String AUTH_CUBIT = 'Auth Cubit';
const String AUTH_REPO = 'Auth Repo';
const String BOOK_REPO = 'Books Repo';
const String BOOK_CUBIT = 'Books Cubit';

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
