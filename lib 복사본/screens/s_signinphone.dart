import 'package:country_picker/country_picker.dart';
import 'package:do_it/screens/s_login.dart';
import 'package:do_it/screens/s_verification.dart';
import 'package:do_it/utils/utils.dart';
import 'package:do_it/widgets/w_custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInPhoneScreen extends StatefulWidget {
  const SignInPhoneScreen({super.key});

  @override
  State<SignInPhoneScreen> createState() => _SignInPhoneScreenState();
}

class _SignInPhoneScreenState extends State<SignInPhoneScreen> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  bool _codeSent = false;
  late String _verificationId;
  late String _smsCode;

  Country selectedcountry = Country(
    phoneCode: "82",
    countryCode: "KR",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Korea",
    example: "Korea",
    displayName: "Korea",
    displayNameNoCountryCode: "KR",
    e164Key: "",
  );

  @override
  void dispose() {
    _phoneController.dispose();
    _smsCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: _phoneController.text.length),
    );

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
            //Navigator.pop(context);
            Get.offAll(const LoginScreen());
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 25),
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    cursorColor: Colors.grey,
                    controller: _phoneController,
                    onChanged: (value) {
                      setState(() {
                        _phoneController.text = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Enter phone number",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(8),
                          child: InkWell(
                            onTap: () {
                              showCountryPicker(
                                  context: context,
                                  countryListTheme: const CountryListThemeData(
                                    bottomSheetHeight: 650,
                                  ),
                                  onSelect: (value) {
                                    setState(() {
                                      selectedcountry = value;
                                    });
                                  });
                            },
                            child: Text(
                              '${selectedcountry.flagEmoji}+${selectedcountry.phoneCode}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        suffixIcon: _phoneController.text.length == 11
                            ? Container(
                                height: 15,
                                width: 15,
                                margin: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                child: const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              )
                            : null),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onTap: () async {
                      if (_key.currentState!.validate()) {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        await auth.verifyPhoneNumber(
                          phoneNumber:
                              '+${selectedcountry.phoneCode}${_phoneController.text}',
                          verificationCompleted:
                              (PhoneAuthCredential credential) async {
                            //works only on android !!!
                            await auth.signInWithCredential(credential);
                          },
                          verificationFailed: (FirebaseAuthException e) {
                            if (e.code == 'invalid-phone-number') {
                              showSnackBar(context, e.message!);
                            }
                          },
                          codeSent: (String verificationId,
                              forceResendingToken) async {
                            setState(() {
                              _smsCode = _smsCodeController.text;
                              _codeSent = true;
                              _verificationId = verificationId;
                            });
                            if (_codeSent) {
                              Get.to(
                                VerifyScreen(
                                  verificationId: _verificationId,
                                  firebasesmsCode: _smsCode,
                                ),
                              );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: ((context) => VerifyScreen(
                              //           verificationId: _verificationId,
                              //           firebasesmsCode: _smsCode,
                              //         )),
                              //   ),
                              // );
                            }
                          },
                          codeAutoRetrievalTimeout: (verificationId) {
                            showSnackBar(context, "시간초과");
                          },
                        );
                      }
                    },
                    text: "인증번호 전송",
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
