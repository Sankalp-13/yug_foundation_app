import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:yug_foundation_app/utils/colors.dart';

class ChatBotWidget extends StatefulWidget {


  InAppWebViewKeepAlive keepAlive;

  ChatBotWidget({Key? key, required this.keepAlive}) : super(key: key);

  @override
  State<ChatBotWidget> createState() => _ChatBotWidgetState();
}

class _ChatBotWidgetState extends State<ChatBotWidget> {

  bool offstage = false;

  // WebViewController controller = WebViewController()
  //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //   ..setBackgroundColor(const Color(0x00000000))
  //   ..loadRequest(Uri.parse("https://storage.googleapis.com/athena-chat/index.html"));


  // late InAppWebViewController inAppWebViewController;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    // final screenSize = MediaQuery.of(context).size;
    // double screenHeight = screenSize.height;
    // double screenWidth = screenSize.width;
    return PopScope(
      onPopInvoked: (v){
        setState(() {
          offstage = true;
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: 0,
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstants.accentColor,
        ),
        backgroundColor: ColorConstants.accentColor,
        body: SafeArea(
          child: SizedBox(
            // height: screenHeight*0.5,
            // width: screenWidth*0.5,
            // child: WebViewWidget(
            //   controller: controller,
            // ),
            child: Offstage(
              offstage: offstage,
              child: InAppWebView(
                keepAlive: widget.keepAlive,
                initialUrlRequest: URLRequest(
                  url: WebUri("https://storage.googleapis.com/athena-chat/index.html"),
                ),
                initialSettings: InAppWebViewSettings(
                  // preferredContentMode: UserPreferredContentMode.DESKTOP,
                  supportZoom: false,
                  builtInZoomControls: false
                ),
                // onWebViewCreated: (InAppWebViewController controller){
                //   inAppWebViewController = controller;
                // },
                onProgressChanged: (InAppWebViewController controller , int progress){
                  setState(() {
                    _progress = progress / 100;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // // TODO: implement wantKeepAlive
  //
  // bool get wantKeepAlive => true;
  // bool get wantKeepAlive => throw UnimplementedError();
}

