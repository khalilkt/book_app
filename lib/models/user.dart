import 'package:books_app/models/book.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;

class User {
  String name;
  List<String> favoriteBooks;
  List<String> favCategories;
  User(
      {required this.name,
      required this.favoriteBooks,
      required this.favCategories});

  static User fromData(fireAuth.User firebaseUser, Map<String, dynamic> data) {
    return User(
        name: firebaseUser.displayName ?? 'Reader',
        favCategories: List.from(data["fav-categories"] ?? []),
        favoriteBooks: List.from(data['favorites'] ?? []));
  }

  @override
  String toString() {
    return '$name, favorties : $favoriteBooks, fav catergories : $favCategories';
  }
}
