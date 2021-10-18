import 'package:firebase_auth/firebase_auth.dart' as fire_auth;

class User {
  String name;
  List<String> favoriteBooks;
  List<String> favCategories;
  User(
      {required this.name,
      required this.favoriteBooks,
      required this.favCategories});

  static User fromData(fire_auth.User firebaseUser, Map<String, dynamic> data) {
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
