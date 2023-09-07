import 'dart:typed_data';
import 'package:do_it/screens/s_modifypost.dart';
import 'package:do_it/src/binding/controller/upload_controller.dart';
import 'package:do_it/widgets/w_circleiconbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class AddPostScreen extends GetView<UploadController> {
  const AddPostScreen({
    super.key,
  });

  Widget _imagePreview() {
    var width = Get.width;
    return Obx(
      () => Container(
        width: width,
        height: width,
        color: Colors.grey,
        child: _photoWidget(
          controller.selectedImage.value,
          width.toInt(),
          builder: (data) {
            return Image.memory(
              data,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "사진",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "동영상",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Row(
            children: [
              CircleIconButton(
                icon: CupertinoIcons.selection_pin_in_out,
                onPressed: () {},
                size: 20,
                backgroundcolor: const Color(0xff3B3B3B),
              ),
              const SizedBox(width: 15),
              CircleIconButton(
                icon: CupertinoIcons.photo,
                onPressed: () {},
                size: 20,
                backgroundcolor: const Color(0xff3B3B3B),
              ),
              const SizedBox(width: 15),
              CircleIconButton(
                icon: CupertinoIcons.camera,
                onPressed: () {},
                size: 20,
                backgroundcolor: const Color(0xff3B3B3B),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _imageSelectList() {
    return Obx(
      () => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 한 줄에 몇개가 들어갈 지
          childAspectRatio: 1, // 정사각형으로 만들기
          // 가로세로 틈
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
        ),
        itemCount: controller.imageList.length,
        itemBuilder: (BuildContext context, int index) {
          return _photoWidget(controller.imageList[index], 200,
              builder: (data) {
            return GestureDetector(
              onTap: () {
                controller.changeSelectedImage(controller.imageList[index]);
              },
              child: Obx(
                () => Opacity(
                  opacity: controller.imageList[index] ==
                          controller.selectedImage.value
                      ? 0.3
                      : 1,
                  child: Image.memory(
                    data,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _photoWidget(AssetEntity asset, int size,
      {required Widget Function(Uint8List) builder}) {
    return FutureBuilder(
      future: (asset.type == AssetType.image || asset.type == AssetType.video)
          ? asset.thumbnailDataWithSize(ThumbnailSize(size, size))
          : Future.value(null),
      builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.hasData) {
          return builder(snapshot.data!);
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UploadController(), permanent: true);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.all(15),
            child: Icon(
              CupertinoIcons.clear,
              color: Colors.white,
            ),
          ),
        ),
        title: const Text(
          "새 게시물",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(
                const ModifyPostScreen(),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              child: Text(
                "다음",
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _imagePreview(),
          _header(),
          Expanded(
            child: _imageSelectList(),
          ),
        ],
      ),
    );
  }
}
