import 'package:bloc/bloc.dart';
import 'package:books_app/logg.dart';
import 'package:books_app/models/user.dart';
import 'package:books_app/repository/auth_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late AuthRepo authRepo;

  AuthCubit() : super(AuthInitial()) {
    authRepo = AuthRepo(this);
    _init();
  }

  void _init() async {
    try {
      User? user = await authRepo.init();
      logg('user after intializing auth cubit : $user', AUTH_CUBIT);
      if (user != null) {
        emit(UserLogedState(user));
        return;
      }
    } catch (e) {
      logg('Excpetion caught while trying to init the auth : $e ', AUTH_CUBIT);
    }
    emit(UserNotLoggedState());
  }

  void userUpdated(User? user) {
    logg('User updated : $user', AUTH_CUBIT);
    if (user != null) {
    } else {}
  }

  Future<void> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      await authRepo.emailSignUp(name, email, password);
    } on fireAuth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
