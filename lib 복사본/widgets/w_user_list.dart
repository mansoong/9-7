import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList>with AutomaticKeepAliveClientMixin  {

  @override
  bool get wantKeepAlive => true;

  bool following= false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(0.5),
            child: TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border:
                        Border.all(color: Colors.white, width: 1),
                        shape: BoxShape.circle,
                        color: Colors.green),
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("이름",
                          style: TextStyle(
                              fontSize: 20, color: Colors.black)),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        '소개',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  TextButton(
                      onPressed: () {
                        following == false
                            ? following = true
                            : following = false;
                        setState(() {});
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            following == false
                                ? Colors.blue
                                : Colors.white),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                side: BorderSide(
                                    color: following == false
                                        ? Colors.white
                                        : Colors.black),
                                borderRadius:
                                BorderRadius.circular(10))),
                      ),
                      child: Text(
                        "팔로우",
                        style: TextStyle(
                            color: following == false
                                ? Colors.white
                                : Colors.black),
                      ))
                ],
              ),
            ),
          );
        });
  }
}
