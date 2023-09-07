import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadController extends GetxController {
  var albums = <AssetPathEntity>[];
  RxList<AssetEntity> imageList = <AssetEntity>[].obs;
  Rx<AssetEntity> selectedImage = const AssetEntity(
    id: '0',
    typeInt: 0,
    width: 0,
    height: 0,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    loadPhotos();
  }

  void loadPhotos() async {
    var result = await PhotoManager.requestPermissionExtend();

    if (result.isAuth) {
      albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(
              minHeight: 200,
              minWidth: 200,
            ),
          ),
          orders: [
            // 최신이미지
            const OrderOption(type: OrderOptionType.createDate, asc: false)
          ],
        ),
      );
      _loadData();
    } else {}
  }

  void _loadData() async {
    await _pagePhotos();
  }

  Future<void> _pagePhotos() async {
    var photos = await albums.first.getAssetListPaged(page: 0, size: 20);
    imageList.addAll(photos);
    changeSelectedImage(imageList.first);
  }

  changeSelectedImage(AssetEntity image) {
    selectedImage(image);
  }
}
