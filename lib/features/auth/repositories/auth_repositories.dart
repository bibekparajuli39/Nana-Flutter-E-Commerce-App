import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositories {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepositories(this.auth, this.firestore);

  Future<void> saveUserToFirestore(
    User user, {
    String provider = 'email',
    String? name,
  }) async {
    await firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'fullName': name ?? user.displayName ?? '',
      'email': user.email ?? '',
      'photoUrl': user.photoURL ?? '',
      'provider': provider,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // EMAIL SIGN UP
  Future<UserCredential> signUp(
    String name,
    String email,
    String password,
  ) async {
    final UserCredential userCredential = await auth
        .createUserWithEmailAndPassword(email: email, password: password);

    final User user = userCredential.user!;

    await user.updateDisplayName(name);
    await user.reload();

    final User updatedUser = auth.currentUser!;

    await saveUserToFirestore(updatedUser, provider: 'email', name: name);

    return userCredential;
  }

  // email login
  Future<UserCredential> signIn(String email, String password) async {
    final UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await saveUserToFirestore(userCredential.user!, provider: 'email');

    return userCredential;
  }

  // google login
  Future<UserCredential> googleLogin() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    if (googleAuth.idToken == null) {
      throw Exception('Google ID token is null');
    }

    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await auth.signInWithCredential(
      credential,
    );

    await saveUserToFirestore(userCredential.user!, provider: 'google');

    return userCredential;
  }

  // facebook login
  Future<UserCredential> facebookLogin() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status != LoginStatus.success) {
      throw Exception('Facebook login cancelled or failed');
    }

    final AccessToken? accessToken = result.accessToken;

    if (accessToken == null) {
      throw Exception('Facebook access token is null');
    }

    final OAuthCredential credential = FacebookAuthProvider.credential(
      accessToken.tokenString,
    );

    final UserCredential userCredential = await auth.signInWithCredential(
      credential,
    );

    await saveUserToFirestore(userCredential.user!, provider: 'facebook');

    return userCredential;
  }

  // logout
  Future<void> logout() async {
    await auth.signOut();

    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}

    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
  }

  // forget password
  Future<void> forget(String email) async {
    await auth.sendPasswordResetEmail(email: email.trim());
  }
}
