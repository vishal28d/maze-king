import 'package:get/get.dart';

class MoreScreenController extends GetxController {
  RxBool deleteAccountLoader = false.obs;

  Function() whenCompleteFunction = () {};

  @override
  void onInit() {
    // whenCompleteFunction = Get.arguments["whenCompleteFunction"] ?? () {};
    super.onInit();
  }
}
