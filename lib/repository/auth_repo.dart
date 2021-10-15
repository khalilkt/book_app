import 'dart:async';

import 'package:books_app/bloc/auth_cubit.dart';
import 'package:books_app/logg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:books_app/models/user.dart' as loc;

class AuthRepo {
  late FirebaseAuth _auth;
  AuthCubit _authCubit;
  late CollectionReference _usersCollection;

  AuthRepo(this._authCubit);

  Future<loc.User?> init() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
    _usersCollection = FirebaseFirestore.instance.collection('Users');

    loc.User? ret = await getUser();
    return ret;
    // listenToAuthState(); I was planing in the begingin to make a stream and listen to the auth state with a wrapper page to return to the sign page if the user disconnect, but I think for this type of app the best is to just check the state at the start of the app
  }

  Future<loc.User?> getUser() async {
    loc.User? ret;
    if (_auth.currentUser == null) {
      print("currrent user is  null");
      return null;
    }
    print("user : $_auth.currentUser");
    DocumentSnapshot docSnap =
        await _usersCollection.doc(_auth.currentUser!.uid).get();
    if (!docSnap.exists) {
      await createUserDoc(_auth.currentUser!.uid);
      docSnap = await _usersCollection.doc(_auth.currentUser!.uid).get();
    }
    return loc.User.fromData(
        _auth.currentUser!, docSnap.data() as Map<String, dynamic>);

    //check if the user have a firestore dataBase if not create it
  }

  Future<void> createUserDoc(String uid) async {
    await _usersCollection
        .doc(uid)
        .set({'fav-categories': [], 'favorites': []});
  }

  Future<void> emailSignUp(String name, String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await userCredential.user!.updateDisplayName(name);

    _authCubit.userUpdated(await getUser());
  }
}
