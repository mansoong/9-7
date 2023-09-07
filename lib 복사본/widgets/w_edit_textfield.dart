import 'package:flutter/material.dart';


class EdiTextField extends StatefulWidget {
  final FocusNode focusNode;
  const EdiTextField({super.key,required this.focusNode});

  @override
  State<EdiTextField> createState() => _EdiTextFieldState();
}

class _EdiTextFieldState extends State<EdiTextField> {
  late String inputText;
  final TextEditingController _textEditingController =
  TextEditingController(text: 'Angela Yu');
  final int maxLength = 20;

  @override
  void initState() {
    super.initState();
    // Add a listener to the controller to update the state when text changes.
    _textEditingController.addListener(() {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode ,
        autofocus: true,
        textAlign: TextAlign.center,
        cursorColor: Colors.red,
        style: const TextStyle(color: Colors.white, fontSize: 24),
        controller: _textEditingController,
        maxLength: maxLength,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
          counter: Center(child: Text('${_textEditingController.text.length} / $maxLength',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)),

          // OR you can use a custom style for the counter:
          // counter: Text('${_textEditingController.text.length}/$maxLength'),
        ),
      );
    }

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      _textEditingController.dispose();
      super.dispose();
    }
  }

