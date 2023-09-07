import 'package:do_it/icons/custom__icons2_icons.dart';
import 'package:do_it/screens/s_follow.dart';
import 'package:do_it/widgets/w_overlay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  
  late VideoPlayerController _videoPlayercontroller;
  late Future<void> _initializeVideoPlayerFuture;

  String? videoPath;
  bool _stopOldVideoBeforeInitializingNewOne = false;
  late VideoPlayerController _newlyPickedVideoController;

  void initializeNewVideo(VideoPlayerController newController) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _stopOldVideoBeforeInitializingNewOne = false;
        _videoPlayercontroller.dispose(); // Dispose the old controller
        _videoPlayercontroller = newController;
        _initializeVideoPlayerFuture = Future<void>.value(null);
      });
    });
  }
  void checkIfVideoStopped() {
    if (!_stopOldVideoBeforeInitializingNewOne) return;

    if (!_videoPlayercontroller.value.isPlaying) {
      _videoPlayercontroller.removeListener(checkIfVideoStopped);
      initializeNewVideo(_newlyPickedVideoController!);
    }
  }


  Future<String?> pickVideoFromGallery() async {
    final ImagePicker picker = ImagePicker();

    try {
      XFile? pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
      return pickedVideo?.path;
    } catch (e) {
      print('Error picking video: $e');
      return null;
    }
  }

  void loadVideo() async {
    if (_videoPlayercontroller.value.isInitialized) {
      _videoPlayercontroller.pause();
    }

    PermissionStatus status = await Permission.photos.status;

    if (!status.isGranted) {
      status = await Permission.photos.request();
      if (!status.isGranted) {
        return;
      }
    }

    try {
      videoPath = await pickVideoFromGallery();
      if (videoPath != null) {
        VideoPlayerController newController = VideoPlayerController.file(
            File(videoPath!));

        newController.initialize().then((_) {
          _videoPlayercontroller.removeListener(checkIfVideoStopped);
          _videoPlayercontroller.addListener(checkIfVideoStopped);
          if (_videoPlayercontroller.value.isPlaying) {
            _stopOldVideoBeforeInitializingNewOne = true;
            _newlyPickedVideoController = newController;
            _videoPlayercontroller.pause();
          } else {
            initializeNewVideo(newController);
          }
          // ensure we're on the main thread when calling setState
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   // Pause the old controller
          //   setState(() {
          //     _videoPlayercontroller.pause();
          //     _videoPlayercontroller.dispose(); // Dispose the old controller
          //     _videoPlayercontroller = newController;
          //     _initializeVideoPlayerFuture = Future<void>.value(null);
          //   });
          // });
        });
      }
    } catch (e) {
      print(e);
      return;
    }
  }// 근데 버튼이 눌리자마자 꺼지는거 보면 그게 문제일수도 재생중인 동영상을 정지시키고 해야하나? 완전 처음에 할 때(갤러리에서 골라온 비디오가 없을 때)에는 에러가 안남. 그런데 갤러리에서 비디오를 골라오고 새로고침을 하고 다시 버튼을 누르면 에러가 뜨는거임

  Future<XFile?> pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    try {
      XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      return pickedImage;
    } catch (e) {
      //print('Error picking image: $e');
      return null;
    }
  }

  Future<void> changeProfilePhoto() async {
    XFile? pickedImage = await pickImageFromGallery();
//예외 처리 다 해야함
    PermissionStatus status = await Permission.photos.status;

    if (!status.isGranted) {
      status = await Permission.photos.request();
      if (!status.isGranted) {
        return;
      }
    }

    if (pickedImage != null) {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 700,
          maxWidth: 700,
          compressFormat: ImageCompressFormat.jpg,
          cropStyle: CropStyle.circle // 크기조정도 할 수 있어야함

          );
      if (croppedFile != null) {
        setState(() {
          profileImage = XFile(croppedFile.path);
        });
      }
    }
  }



  @override
  void initState() {
    _videoPlayercontroller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'));
    _initializeVideoPlayerFuture = _videoPlayercontroller.initialize();
    // ..initialize().then((_) {
    // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    // setState(() {});
    _videoPlayercontroller.setVolume(0); // 볼륨을 0으로 설정
    _videoPlayercontroller.play();
    _videoPlayercontroller.setLooping(true);
    super.initState();
  }

  // @override
  // void dispose() {
  //   _videoPlayercontroller.dispose();
  //   super.dispose();
  // }

  String name = 'Angela Yu';
  XFile? profileImage;

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(clipBehavior: Clip.none, children: [
              Container(
                height: 328,
                child: AspectRatio(
                  aspectRatio: _videoPlayercontroller.value.aspectRatio,
                  child: VideoPlayer(_videoPlayercontroller),
                ),
              ),
              // Container(
              //   height: 328,
              //   decoration: const BoxDecoration(
              //       image: DecorationImage(
              //           image: AssetImage('assets/images/뚱이.webp'),
              //           fit: BoxFit.cover)),
              // ),
              Positioned(
                top: 250,
                left: MediaQuery.of(context).size.width / 2 - (137 / 2),
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () {
                    changeProfilePhoto();
                  },
                  child: Stack(
                    children: [
                      Container(
                          height: 137,
                          width: 137,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: (profileImage != null)
                                      ? FileImage(File(profileImage!.path))
                                          as ImageProvider
                                      : AssetImage("assets/images/은채.jpeg"),
                                  fit: BoxFit.cover))),
                      const Positioned(
                          bottom: 0,
                          right: 10,
                          child: Icon(
                            Icons.photo_camera_rounded,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                    onPressed: () {
                      loadVideo();
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    )),
              )
            ]),
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 2),
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 0.3, color: Colors.black),
                      ),
                    ),
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(bottom: 0))),
                      child: SizedBox(
                        width: 300,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                name,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.edit, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        showOverlayTextField(context);
                      },
                      // String? result = await showDialog<String>(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return AlertDialog(
                      //         content: TextField(
                      //           autofocus: false,
                      //           decoration:
                      //           InputDecoration(labelText: "Angela Yu"),
                      //         ),
                      //       );
                      //     });
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      size: 15,
                      Icons.logout_outlined,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Done",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.only(left: 20, right: 20)),
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
                        onPressed: () {},
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
                            Text("팔로잉",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey))
                          ],
                        ),
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("220k",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text('팔로워',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey))
                        ],
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("24",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text("Do it",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey))
                        ],
                      )
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
