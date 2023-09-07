import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/screens/s_base.dart';
import 'package:do_it/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;

class FirebaseAuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        res = false;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        User? googleuser = userCredential.user;

        if (googleuser != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            await _firestore.collection('users').doc(googleuser.uid).set(
              {
                'username': googleuser.displayName,
                'uid': googleuser.uid,
                'profilePhoto': googleuser.photoURL,
              },
            );
            Get.offAll(const MainHome());
          } else {
            Get.offAll(const MainHome());
          }
        }
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      res = false;
    }
    return res;
  }

  Future<bool> signInWithFacebook(BuildContext context) async {
    bool res = false;
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.accessToken != null) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        UserCredential userCredential =
            await _auth.signInWithCredential(facebookAuthCredential);
        User? facebookuser = userCredential.user;

        if (facebookuser != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            await _firestore.collection('users').doc(facebookuser.uid).set(
              {
                'username': facebookuser.displayName,
                'uid': facebookuser.uid,
                'profilePhoto': facebookuser.photoURL,
              },
            );
            Get.offAll(const MainHome());
          } else {
            Get.offAll(const MainHome());
          }
        }
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      res = false;
    }
    return res;
  }

  Future<bool> signInWithKakatalk(BuildContext context) async {
    bool res = false;
    if (await kakao.isKakaoTalkInstalled()) {
      try {
        await kakao.UserApi.instance.loginWithKakaoTalk();
        res = true;
      } catch (e) {
        if (e is PlatformException && e.code == 'CANCELED') {
          res = false;
        }
        try {
          await kakao.UserApi.instance.loginWithKakaoAccount();
          res = true;
        } catch (e) {
          res = false;
        }
      }
    } else {
      try {
        await kakao.UserApi.instance.loginWithKakaoAccount();
        res = true;
      } catch (e) {
        res = false;
      }
    }
    return res;
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}
