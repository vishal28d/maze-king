import 'package:get/get.dart';

class ReferAndEarnController extends GetxController {
  RxBool animate = false.obs;
  RxList<Map<String, dynamic>> allQuestions = [
    {
      "question": "How do i get my Rewards?",
      "desc": "You'll automatically receive 5% of your friend's first deposit (up to ₹100) as a discount bonus once they've added money to their account.",
      "isDesc": false.obs,
    },
    {
      "question": "How do i utillize my Rewards?",
      "desc": " You can use discount bonus in join the contest according to its usable percentage.",
      "isDesc": false.obs,
    },
    {
      "question": "What is the maximum number of invites I can send?",
      "desc": "There's typically no limit on the number of friends you can invite. The more friends you invite who make a first deposit, the more rewards you can earn (up to the maximum reward per deposit).",
      "isDesc": false.obs,
    },
    {
      "question": "How to invite my friends?",
      "desc": "Look for a Referral Code section within the app. Share this referral code with your friends. When they sign up and make their first deposit using your code you will receive the discount bonus",
      "isDesc": false.obs,
    },
  ].obs;
}
