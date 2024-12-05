import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maze_king/res/empty_element.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../exports.dart';
import 'app_bar.dart';

class AppWebView extends StatefulWidget {
  final String webURL;
  final String? closeWebViewText;
  final String? title;
  final Widget? myWidget;

  const AppWebView({
    super.key,
    required this.webURL,
    this.closeWebViewText,
    this.title,
    this.myWidget,
  });

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  late final WebViewController controller;
  RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    if (!isValEmpty(widget.webURL)) {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
              isLoading.value = false;
            },
            onUrlChange: (UrlChange change) {},
            onWebResourceError: (WebResourceError error) {
              isLoading.value = false;
            },
            onNavigationRequest: (NavigationRequest request) {
              printYellow(request.url);
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              } else {
                /// AUTO BACK FROM WEB VIEW
                if (widget.closeWebViewText != null && widget.closeWebViewText!.trim() == request.url.trim()) Get.back();

                /// OTHER
                if (request.url.startsWith('upi://') || request.url.startsWith('phonepe://') || request.url.startsWith('gpay://') || request.url.startsWith('paytmmp://') || request.url.startsWith('tez://')) {
                  launchUrl(Uri.parse(request.url));
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              }
            },
          ),
          // initialUrl: 'https://yourwebsite.com',
          // javascriptMode: JavascriptMode.unrestricted,
          // navigationDelegate: (NavigationRequest request) {
          //   if (request.url.startsWith('gpay://')) {
          //     _launchURL(request.url);
          //     return NavigationDecision.prevent;
          //   }
          //   return NavigationDecision.navigate;
          // },
        )
        ..loadRequest(Uri.parse(widget.webURL));
    } else {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Column(
          children: [
            if (!isValEmpty(widget.title))
              MyAppBar(
                title: widget.title,
                centerTitle: false,
                showBackIcon: true,
                myAppBarSize: MyAppBarSize.medium,
                backgroundColor: Colors.white,
              ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: isLoading.isFalse
                    ? (!isValEmpty(widget.webURL))
                        ? WebViewWidget(
                            controller: controller,
                          )
                        : const EmptyElement(
                            title: "Please try after some time!",
                          )
                    : CircularLoader(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
