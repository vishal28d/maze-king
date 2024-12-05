import 'package:get/get.dart';

import '../../../../data/models/wallet/wallet_model.dart';
import '../../../../repositories/wallet/wallet_repository.dart';

class KycDetailScreenController extends GetxController {
  RxBool isLoader = false.obs;

  RxBool bankVerified = false.obs;
  RxBool panCardVerify = false.obs;

  @override
  void onReady() {
    initApi();
    super.onReady();
  }

  void initApi() async {
    WalletModel? walletModel = await WalletRepository.getWalletDetailsAPI(isLoader: isLoader);
    bankVerified.value = walletModel?.bankVerified ?? false;
    panCardVerify.value = walletModel?.panCardVerify ?? false;
  }
}
