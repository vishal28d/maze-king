import 'package:get/get.dart';
import 'package:maze_king/exports.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isWithdrawButtonLoading = false.obs;
  RxBool addCashLoader = false.obs;

  @override
  void onInit() {
    super.onInit();
    printOkStatus(LocalStorage.userName);
    printOkStatus(LocalStorage.userMobile);
    printOkStatus(LocalStorage.userImage);
  }
}
