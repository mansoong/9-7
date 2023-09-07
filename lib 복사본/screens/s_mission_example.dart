import 'package:flutter/material.dart';

class MissionPopUp extends StatefulWidget {
  const MissionPopUp({super.key});

  @override
  State<MissionPopUp> createState() => _MissionPopUpState();
}

class _MissionPopUpState extends State<MissionPopUp> {
  @override
  Widget build(BuildContext context) {
     return Container(
        decoration: const BoxDecoration(color:Colors.red,borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))),
     );
  }
}
