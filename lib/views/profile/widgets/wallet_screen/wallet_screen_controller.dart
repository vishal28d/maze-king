import 'package:get/get.dart';
import 'package:maze_king/data/models/wallet/wallet_model.dart';
import 'package:maze_king/repositories/wallet/wallet_repository.dart';


class WalletScreenController extends GetxController {
  Rx<WalletModel> walletModel = WalletModel().obs;
  RxBool isLoader = false.obs;


  @override
  void onReady() {
    super.onReady();
    WalletRepository.getWalletDetailsAPI(isWalletFlow: true, isLoader: isLoader, walletType: WalletType.wallet);
  }
}
