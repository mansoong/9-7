import 'package:get/get.dart';

class ScrollPositionController extends GetxController {
  var lastFriendsPosition = 0.0.obs;
  var lastHotPosition = 0.0.obs;


  void saveFriendsScrollPosition(double position) {
    lastFriendsPosition.value = position;
  }
  void saveHotScrollPosition(double position) {
    lastHotPosition.value = position;
  }
}
