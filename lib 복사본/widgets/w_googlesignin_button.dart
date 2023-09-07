import 'package:do_it/resources/auth_methods.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButton();
}

class _GoogleSignInButton extends State<GoogleSignInButton> {
  final FirebaseAuthMethods _authMethods = FirebaseAuthMethods();

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        await _authMethods.signInWithGoogle(context);
      },
      icon: const Image(
        image: AssetImage("assets/images/google-logo.png"),
        width: 30,
        height: 30,
      ),
      label: const Text(
        "구글 계정으로 시작",
        style: TextStyle(
          color: Color.fromARGB(255, 70, 164, 241),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      style: TextButton.styleFrom(
        minimumSize: Size((MediaQuery.of(context).size.width / 1.1),
            MediaQuery.of(context).size.height / 16),
        backgroundColor: const Color(0xffCEDDED),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
