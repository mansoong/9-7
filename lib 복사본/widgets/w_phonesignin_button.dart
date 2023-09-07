import 'package:do_it/screens/s_signinphone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneSignInButton extends StatefulWidget {
  const PhoneSignInButton({super.key});

  @override
  State<PhoneSignInButton> createState() => _PhoneSignInButtonState();
}

class _PhoneSignInButtonState extends State<PhoneSignInButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        //Navigator.pushNamed(context, '/phone');
        Get.to(const SignInPhoneScreen());
      },
      icon: const Image(
        image: AssetImage("assets/images/phone.png"),
        width: 30,
        height: 30,
      ),
      label: const Text(
        "휴대폰번호로 시작",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      style: TextButton.styleFrom(
        minimumSize: Size((MediaQuery.of(context).size.width / 1.1),
            MediaQuery.of(context).size.height / 16),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        side: const BorderSide(color: Colors.green, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
