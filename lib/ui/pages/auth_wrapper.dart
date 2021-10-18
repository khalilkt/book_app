import 'package:books_app/bloc/auth_cubit.dart';
import 'package:books_app/bloc/books_cubit.dart';

import 'package:books_app/ui/pages/book_subjects_page.dart';
import 'package:books_app/ui/pages/home_page.dart';
import 'package:books_app/ui/pages/sign_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This is not a wrapper that continully watch the state of the auth and replace the page
///
/// it is just a wrapper that show a logo screen and wait for suth state change to push the page
/// after the homepage is pushed even if the user sign out ntgh will happend
/// I just think for this kind of app there is  no reason to listen to the auth state
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await context.read<AuthCubit>().init();
    AuthState state = context.read<AuthCubit>().state;
    if (state is UserNotLoggedState) {
      Navigator.push(context, MaterialPageRoute(builder: (c) {
        return BlocProvider.value(
          value: context.read<AuthCubit>(),
          child: const SignPage(),
        );
      }));
    } else if (state is UserLogedState) {
      if (state.user.favCategories.isEmpty) {
        Navigator.push(context, MaterialPageRoute(builder: (c) {
          return BlocProvider.value(
              value: context.read<AuthCubit>(), child: const BookSubjPage());
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (c) {
          return MultiBlocProvider(providers: [
            BlocProvider(create: (_) => BooksCubit(state.user)),
            BlocProvider.value(
              value: context.read<AuthCubit>(),
            )
          ], child: const HomePage());
        }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Material(
        child: Center(child: Text("Books App")),
      ),
    );
  }
}
