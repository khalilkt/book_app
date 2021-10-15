import 'package:books_app/bloc/auth_cubit.dart';
import 'package:books_app/bloc/books_cubit.dart';
import 'package:books_app/ui/pages/animated_in_out.dart';
import 'package:books_app/ui/pages/book_subjects_page.dart';
import 'package:books_app/ui/pages/home_page.dart';
import 'package:books_app/ui/pages/sign_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  Widget curPage = const Material(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prevState, curState) {
        return prevState.runtimeType != curState.runtimeType;
      },
      listener: (context, state) async {
        print("state is $state");
        if (curPage is OutAnimatedPage) {
          await (curPage as OutAnimatedPage).animateOut();
        }
        if (state is UserNotLoggedState) {
          setState(() {
            curPage = const SignPage();
          });
        } else if (state is UserLogedState) {
          setState(() {
            if (state.user.favCategories.isEmpty) {
              curPage = const BookSubjPage();
            } else {
              curPage = BlocProvider(
                create: (context) => BooksCubit(
                    (context.read<AuthCubit>().state as UserLogedState).user),
                child: const HomePage(),
              );
            }
          });
        }
      },
      child: curPage,
    );
  }
}
