import 'package:do_it/screens/s_base.dart';
import 'package:do_it/screens/s_edit.dart';
import 'package:do_it/screens/s_follow.dart';
import 'package:do_it/screens/s_profile.dart';
import 'package:do_it/utils/colors.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: '4bb5c85c38fec83c3d8bc0a182043e5e');
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Do it?",
      theme: ThemeData(fontFamily: "Pretendard"),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: const EditScreen(),
    );
  }
}
