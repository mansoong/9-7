import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/screens/s_base.dart';
import 'package:do_it/widgets/w_circleiconbutton.dart';
import 'package:do_it/widgets/w_custom_button.dart';
import 'package:do_it/widgets/w_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:do_it/models/user.dart' as model;

class ProfileRegisterScreen extends StatefulWidget {
  final User phoneuser;
  const ProfileRegisterScreen({
    super.key,
    required this.phoneuser,
  });

  @override
  State<ProfileRegisterScreen> createState() => _ProfileRegisterScreenState();
}

class _ProfileRegisterScreenState extends State<ProfileRegisterScreen> {
  final TextEditingController _usernamecontroller = TextEditingController();
  File? _image;

  @override
  void dispose() {
    super.dispose();
    _usernamecontroller.dispose();
  }

  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Stack(
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: (_image != null)
                          ? FileImage(_image!)
                          : const NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSf8xdLG78TMYzKtF09m3yqmzo8-NmjgdxR3g&usqp=CAU")
                              as ImageProvider<Object>,
                      radius: 100,
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 0,
                    child: CircleIconButton(
                      icon: CupertinoIcons.camera_circle,
                      onPressed: getImage,
                      size: 30,
                      backgroundcolor: const Color.fromARGB(255, 194, 194, 194),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40),
              TextFieldInput(
                  textEditingController: _usernamecontroller,
                  hintText: "이름을 입력해주세요.",
                  textInputType: TextInputType.name),
              const SizedBox(height: 40),
              SizedBox(
                width: (MediaQuery.of(context).size.width / 2),
                child: CustomButton(
                    onTap: () async {
                      model.User user = model.User(
                          uid: widget.phoneuser.uid,
                          photoUrl: (_image != null)
                              ? _image!.path
                              : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSf8xdLG78TMYzKtF09m3yqmzo8-NmjgdxR3g&usqp=CAU",
                          username: _usernamecontroller.text);
                      await firestore
                          .collection('users')
                          .doc(user.uid)
                          .set(
                            user.toJson(), // Map 반환
                          )
                          .then(
                            (_) => Get.offAll(const MainHome()),
                          );
                    },
                    text: "완료"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
