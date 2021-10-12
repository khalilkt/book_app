import 'package:books_app/ui/pages/sign_page.dart';
import 'package:flutter/material.dart';
import 'package:books_app/ui/size_config.dart';

void main() {
  runApp(const BooksApp());
}

class BooksApp extends StatelessWidget {
  const BooksApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Books App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(bodyText2: TextStyle(fontFamily: 'Poppins'))),
      home: Builder(builder: (context) {
        SizeConfig.init(MediaQuery.of(context).size);

        return const SignPage();
      }),
    );
  }
}
