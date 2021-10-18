import 'package:bloc/bloc.dart';
import 'package:books_app/logg.dart';
import 'package:books_app/models/book.dart';
import 'package:books_app/models/user.dart';
import 'package:books_app/repository/auth_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;

import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late AuthRepo authRepo;

  AuthCubit() : super(AuthInitial()) {
    authRepo = AuthRepo(this);
    // _init();
  }

  Future<void> init() async {
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
      emit(UserLogedState(user));
    } else {}
  }

  Future<void> signOut() async {
    try {
      await authRepo.signOut();
      logg('sign out succesfully', AUTH_CUBIT);
    } catch (e) {
      logg("exception caught while signing out : $e", AUTH_CUBIT);
    }
  }

  Future<void> updateUserCategories(List<String> categories) async {
    try {
      await authRepo.updateUserCategories(categories);
    } catch (e) {
      logg(
          'Exception caught while trying to update the user categoriees to $categories : $e',
          AUTH_CUBIT);
    }
  }

  Future<void> addFavBook(Book book) async {
    try {
      await authRepo.addFavBook(book.id);
    } catch (e) {
      logg('Exception caught while adding the book $book to favorites : $e');
    }
  }

  Future<void> removeFavBook(Book book) async {
    try {
      await authRepo.removeFavBook(book.id);
    } catch (e) {
      logg(
          'Exception caught while removing the book $book from favorites : $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await authRepo.emailLogIn(email, password);
    } catch (e) {
      if (e is fire_auth.FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            throw (AuthException('Email not found', AuthExType.signInEmail));
          case 'invalid-email':
            throw (AuthException('invalid email', AuthExType.signInEmail));
          case 'wrong-password':
            throw (AuthException(
                'Icorrect password', AuthExType.signInPassword));
        }
      }
      throw AuthException.uknown();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await authRepo.googleSignIn();
    } catch (e) {
      throw AuthException.uknown();
    }
  }

  Future<void> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    if (name.isEmpty) {
      throw AuthException('PLease enter a name', AuthExType.signUpName);
    } else if (password.isEmpty) {
      throw AuthException('Please enter a password', AuthExType.signUpPassword);
    } else if (email.isEmpty) {
      throw AuthException('Please enter an email', AuthExType.signUpEmail);
    }
    try {
      await authRepo.emailSignUp(name, email, password);
    } catch (e) {
      if (e is fire_auth.FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            throw (AuthException('email already used', AuthExType.signUpEmail));
          case 'invalid-email':
            throw (AuthException('invalid email', AuthExType.signUpEmail));
          case 'weak-password':
            throw (AuthException('Weak password', AuthExType.signUpPassword));
        }
      }
      throw AuthException.uknown();
    }
  }
}
