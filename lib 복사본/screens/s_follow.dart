import 'package:do_it/icons/custom__icons1_icons.dart';
import 'package:do_it/widgets/w_user_list.dart';
import 'package:flutter/material.dart';
import 'package:do_it/screens/s_mission.dart';
import 'package:get/get.dart';

class FollowPage extends StatefulWidget {

  final int initialTabIndex;

  const FollowPage({super.key,required this.initialTabIndex });

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage>
    with SingleTickerProviderStateMixin {


  final controller = PageController();
  late TabController tabController; // Add this

  int currentIndex = 0;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
    tabController.animateTo(index);
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.index=widget.initialTabIndex;
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        onPageChanged(tabController.index);
      }
    });
    // tabController.animation!.addListener(() {
    //   if (tabController.animation!.status == AnimationStatus.completed) {
    //     onPageChanged(tabController.index);
    //   }
    // });
  }

  @override
  void dispose() {
    controller.dispose();
    tabController.dispose(); // Add this line
    super.dispose();
  }

  List<String> nameList = [
    '김영희',
    '이민수',
    '홍은채',
    "전재욱",
    "전준태",
    '윤여준',
    '황동기',
    '천우희',
    '서새봄',
    '최설아',
    '이광수',
    '박영자',
    '윤진오',
    '조준호',
    '김세희',
    '정이별',
    '감스트',
    '김구라',
    '김동현'
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          shape: const Border(
            bottom: BorderSide(color: Colors.grey, width: 0.2),
          ),
          leading: IconButton(
              onPressed: () {Navigator.pop(context);},
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 28,
              )),
          elevation: 0,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          title: const Text("Angela Yu",
              style: TextStyle(color: Colors.black, fontSize: 24)),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(24),
            child: TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              tabs: const <Widget>[
                Tab(
                  child: Text("1500 팔로잉"),
                ), // 데이터 받아와서 넣어야함
                Tab(
                  child: Text('220k 팔로워'),
                ),
              ],
              controller: tabController,
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            UserList(),
            UserList()
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
