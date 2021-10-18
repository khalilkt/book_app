import 'package:books_app/bloc/auth_cubit.dart';
import 'package:books_app/ui/pages/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:books_app/ui/size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          textTheme:
              const TextTheme(bodyText2: TextStyle(fontFamily: 'Poppins'))),
      home: Builder(builder: (context) {
        SizeConfig.init(MediaQuery.of(context).size);
        return BlocProvider(
          lazy: false,
          create: (context) => AuthCubit(),
          child: const AuthWrapper(),
        );
      }),
    );
  }
}
