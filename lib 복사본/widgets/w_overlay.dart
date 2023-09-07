import 'package:do_it/widgets/w_edit_textfield.dart';
import 'package:flutter/material.dart';

void showOverlayTextField(BuildContext context) {
  double statusBarHeight = MediaQuery.of(context).padding.top;

  TextEditingController _textEditingController =
      TextEditingController(text: 'Angela Yu');

  FocusNode _focusNode = FocusNode();

  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.7),
        ),
        Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: statusBarHeight,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    overlayEntry.remove();
                  },
                  child: const Text("취소",
                      style: TextStyle(fontSize: 20, color: Colors.white))),
              const Text(
                "이름",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
              TextButton(
                  onPressed: () {

                  },
                  child: const Text("확인",
                      style: TextStyle(fontSize: 20, color: Colors.white)))
            ],
          ),
          const SizedBox(
            height: 150,
          ),
          Material(
            color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                // 텍스트 입력 받고 적용되는 것 까지 만들기
                child: EdiTextField(
                  focusNode: _focusNode,
                ) //TextField(
                //focusNode: _focusNode,
                ),
          ),
        ])
      ],
    ),
  );

  WidgetsBinding.instance!.addPostFrameCallback((_) {
    Overlay.of(context)!.insert(overlayEntry);
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      _focusNode.requestFocus();
    });
  });
}
