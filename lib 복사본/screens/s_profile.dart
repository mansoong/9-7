import 'package:do_it/icons/custom__icons2_icons.dart';
import 'package:do_it/screens/s_follow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {



  late VideoPlayerController _videoPlayercontroller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    loadvideo();
    super.initState();
  }

  void loadvideo() {
    _videoPlayercontroller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
    );
    _initializeVideoPlayerFuture = _videoPlayercontroller.initialize();
    _videoPlayercontroller.setVolume(0); // 볼륨을 0으로 설정
    _videoPlayercontroller.play();
    _videoPlayercontroller.setLooping(true);
  }

  @override
  void dispose() {
    _videoPlayercontroller.dispose();
    super.dispose();
  }

  //동영상 재생 기능 넣어야함
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(clipBehavior: Clip.none, children: [
              SizedBox(
                height: Get.height / 2.5,
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // 비디오 플레이어가 완전히 초기화된 경우에만 AspectRatio와 VideoPlayer를 렌더링합니다.
                      return AspectRatio(
                        aspectRatio: _videoPlayercontroller.value.aspectRatio,
                        child: VideoPlayer(_videoPlayercontroller),
                      );
                    } else {
                      // 아직 비디오 플레이어가 초기화되지 않은 경우 로딩 스피너를 보여줍니다.
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Positioned(
                top: Get.height / 3.3,
                left: Get.width / 3,
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: EdgeInsets.zero,
                          child: Hero(
                            tag: 'hero1',
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: PhotoView(
                                imageProvider:
                                    const AssetImage("assets/images/은채.jpeg"),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Hero(
                    tag: 'hero1',
                    child: Container(
                      height: Get.width / 3,
                      width: Get.width / 3,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                            image: AssetImage("assets/images/은채.jpeg"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 2),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu),
                        color: Colors.black,
                        padding: const EdgeInsets.all(0),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    //텍스트 수정은 showdialog 사용
                    "Angela Yu",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      size: 15,
                      Custom_Icons2.icon__2_,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Edit",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.only(left: 20, right: 20),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey.shade300),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed:(){Get.to(const FollowPage(initialTabIndex: 0,));} ,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "1500",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              "팔로잉",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: (){Get.to(const FollowPage(initialTabIndex: 1,));},
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "220k",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              '팔로워',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: (){},
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "24",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              "Do it",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            crossAxisCount: 3,
                            childAspectRatio: 130 / 142),
                    itemCount: 11,
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.greenAccent,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
