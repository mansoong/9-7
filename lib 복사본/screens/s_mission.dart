import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissionPage extends StatefulWidget {
  const MissionPage({super.key});

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 24,
        leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.ice_skating,
              color: Colors.blue,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "햄버거 한입에 다 먹기",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        shape: const Border(bottom: BorderSide(color: Colors.grey)),
        actions: const [
          SizedBox(
            width: 24,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                crossAxisCount: 2,
                childAspectRatio: 180 / 216,
                children: List.generate(
                    11,
                    (index) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.greenAccent,
                          ),
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
