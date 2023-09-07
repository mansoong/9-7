import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/resources/auth_methods.dart';
import 'package:do_it/resources/auth_kakofirebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;

class KakaoSignInButton extends StatefulWidget {
  const KakaoSignInButton({Key? key}) : super(key: key);

  @override
  State<KakaoSignInButton> createState() => _KakaoSignInButton();
}

class _KakaoSignInButton extends State<KakaoSignInButton> {
  final FirebaseAuthMethods _authMethods = FirebaseAuthMethods();
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  kakao.User? user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        if (await _authMethods.signInWithKakatalk(context)) {
          user = await kakao.UserApi.instance.me();
          final token = await _firebaseAuthDataSource.createCustomToken({
            'uid': user!.id.toString(),
            'displayName': user!.kakaoAccount?.profile?.nickname,
            'photoURL': user!.kakaoAccount?.profile?.profileImageUrl,
          });

          UserCredential kakaouserCredential =
              await FirebaseAuth.instance.signInWithCustomToken(token);
          User? kakaouser = kakaouserCredential.user;
          if (kakaouser != null) {
            if (kakaouserCredential.additionalUserInfo!.isNewUser) {
              await _firestore.collection('users').doc(kakaouser.uid).set(
                {
                  'username': kakaouser.displayName,
                  'uid': kakaouser.uid,
                  'profilePhoto': kakaouser.photoURL,
                },
              );
            }
          }
          Navigator.pushNamed(context, '/home');
        } else {
          return;
        }
      },
      icon: const Image(
        image: AssetImage("assets/images/kakao-logo.png"),
        width: 30,
        height: 30,
      ),
      label: const Text(
        "카카오톡으로 시작",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      style: TextButton.styleFrom(
        minimumSize: Size((MediaQuery.of(context).size.width / 1.1),
            MediaQuery.of(context).size.height / 16),
        backgroundColor: const Color(0xffFDDC3F),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
