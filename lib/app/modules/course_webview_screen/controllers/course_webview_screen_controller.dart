import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CourseWebviewScreenController extends GetxController {
  WebViewController? webViewController;
  final RxBool isLoading = true.obs;
  final RxBool isWebViewReady = false.obs;
  late final String url;
  late final String title;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    url = args['url'];
    title = args['title'];
  }

  @override
  void onReady() {
    super.onReady();

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => isLoading.value = true,
          onPageFinished: (_) => isLoading.value = false,
        ),
      )
      ..loadRequest(Uri.parse(url));
    isWebViewReady.value = true;
  }

  Future<bool> onWillPop() async {
    if (webViewController != null &&
        await webViewController!.canGoBack()) {
      webViewController!.goBack();
      return false;
    }
    return true;
  }
}
