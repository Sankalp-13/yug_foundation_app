import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatBotWidget extends StatefulWidget {


  @override
  State<ChatBotWidget> createState() => _ChatBotWidgetState();
}

class _ChatBotWidgetState extends State<ChatBotWidget> {



  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadHtmlString( '''
              <!DOCTYPE html>
              <html lang="en">
              <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <link rel="stylesheet" href="https://www.gstatic.com/dialogflow-console/fast/df-messenger/prod/v1/themes/df-messenger-default.css">
                <script src="https://www.gstatic.com/dialogflow-console/fast/df-messenger/prod/v1/df-messenger.js"></script>
              </head>
              <body>
                <df-messenger
                  project-id="athena-415810"
                  agent-id="7b2953bf-b348-4e3f-b2cb-ffc566fd7e90"
                  language-code="en"
                  max-query-length="-1">
                  <df-messenger-chat-bubble
                   chat-title="">
                  </df-messenger-chat-bubble>
                </df-messenger>
                <style>
                  df-messenger {
                    z-index: 999;
                    position: fixed;
                    --df-messenger-font-color: #000;
                    --df-messenger-font-family: Google Sans;
                    --df-messenger-chat-background: #f3f6fc;
                    --df-messenger-message-user-background: #d3e3fd;
                    --df-messenger-message-bot-background: #fff;
                    bottom: 16px;
                    right: 16px;
                  }
                </style>
              </body>
              </html>
              ''');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Bot'),
      ),
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        height: 300,
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}

