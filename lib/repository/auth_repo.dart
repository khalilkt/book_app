import 'dart:async';

import 'package:books_app/bloc/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:books_app/models/user.dart' as loc;
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepo {
  late FirebaseAuth _auth;
  final AuthCubit _authCubit;
  late CollectionReference _usersCollection;
  DocumentReference? _userDoc;

  AuthRepo(this._authCubit);

  Future<void> signOut() async {
    await _auth.signOut();
    _userDoc = null;
  }

  Future<loc.User?> init() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
    _usersCollection = FirebaseFirestore.instance.collection('Users');

    loc.User? ret = await getUser();
    return ret;
    // listenToAuthState(); I was planing in the begingin to make a stream and listen to the auth state with a wrapper page to return to the sign page if the user disconnect, but I think for this type of app the best is to just check the state at the start of the app
  }

  Future<void> addFavBook(String id) async {
    if (_userDoc == null) {
      throw Exception('user doc is null');
    } else {
      await _userDoc!.update({
        'favorites': FieldValue.arrayUnion([id])
      });
      await updateUser();
    }
  }

  Future<void> removeFavBook(String id) async {
    if (_userDoc == null) {
      throw Exception('user doc is null');
    } else {
      await _userDoc!.update({
        'favorites': FieldValue.arrayRemove([id])
      });
      await updateUser();
    }
  }

  Future<void> updateUser() async {
    _authCubit.userUpdated(await getUser());
  }

  Future<loc.User?> getUser() async {
    if (_auth.currentUser == null) {
      return null;
    }

    DocumentSnapshot docSnap =
        await _usersCollection.doc(_auth.currentUser!.uid).get();
    if (!docSnap.exists) {
      await createUserDoc(_auth.currentUser!.uid);
      docSnap = await _usersCollection.doc(_auth.currentUser!.uid).get();
    }
    _userDoc = _usersCollection.doc(_auth.currentUser!.uid);

    return loc.User.fromData(
        _auth.currentUser!, docSnap.data() as Map<String, dynamic>);
  }

  Future<void> updateUserCategories(List<String> categories) async {
    if (_userDoc != null) {
      await _userDoc!.update({"fav-categories": categories});
      await updateUser();
    } else {
      throw Exception('user-doc is null');
    }
  }

  Future<void> createUserDoc(String uid) async {
    await _usersCollection
        .doc(uid)
        .set({'fav-categories': [], 'favorites': []});
  }

  Future<void> emailSignUp(String name, String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await userCredential.user!.updateDisplayName(name);

    await updateUser();
  }

  Future<void> googleSignIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      await updateUser();
    } else {
      throw Exception('google user is null');
    }
  }

  Future<void> emailLogIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    await updateUser();
  }
}
