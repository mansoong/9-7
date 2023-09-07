import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/screens/s_base.dart';
import 'package:do_it/screens/s_profileregister.dart';
import 'package:do_it/screens/s_signinphone.dart';
import 'package:do_it/widgets/w_custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class VerifyScreen extends StatefulWidget {
  final String verificationId;
  final String firebasesmsCode;
  const VerifyScreen({
    super.key,
    required this.verificationId,
    required this.firebasesmsCode,
  });

  @override
  State<VerifyScreen> createState() => _VerifyScreen();
}

class _VerifyScreen extends State<VerifyScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? smscode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.offAll(const SignInPhoneScreen());
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
              child: Column(
                children: [
                  const Text(
                    "문자로 받은 인증번호를 입력해주세요.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    keyboardType: TextInputType.phone,
                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red),
                      ),
                      textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    onChanged: (value) {
                      setState(() {
                        smscode = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: CustomButton(
                      onTap: () async {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        if (smscode != null) {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: widget.verificationId,
                                  smsCode: smscode!);

                          UserCredential userCredential =
                              await auth.signInWithCredential(credential);
                          User? phoneuser = userCredential.user;

                          if (phoneuser != null) {
                            if (userCredential.additionalUserInfo!.isNewUser) {
                              await _firestore
                                  .collection('users')
                                  .doc(phoneuser.uid)
                                  .set(
                                {
                                  'username': phoneuser.displayName,
                                  'uid': phoneuser.uid,
                                  'profilePhoto': phoneuser.photoURL,
                                },
                              ).then(
                                (_) => Get.to(
                                  ProfileRegisterScreen(
                                    phoneuser: phoneuser,
                                  ),
                                ),
                              );
                            } else {
                              Get.offAll(const MainHome());
                            }
                          }
                        } else {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  content: const Text(
                                    "인증번호가 일치하지 않습니다.",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "다시 입력하기",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              });
                        }
                      },
                      text: "확인",
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "인증번호를 받지 못했나요?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Get.offAll(const SignInPhoneScreen());
                    },
                    child: const Text(
                      "인증번호 다시 받기",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
