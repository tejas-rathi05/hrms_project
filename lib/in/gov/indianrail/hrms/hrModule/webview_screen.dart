/*import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class WebViewLoad extends StatefulWidget {
  var webhtml;
  WebViewLoad(this.webhtml);

  WebViewLoadUI createState() => WebViewLoadUI();
}

class WebViewLoadUI extends State<WebViewLoad> {
  late WebViewController webViewController;

  loadLocalHTML() async {
    String fileHtmlContents = await rootBundle.loadString(widget.webhtml);
    webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("HR Calculation",
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
      ),
      body: WebView(
        initialUrl: '',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController tmp) {
          webViewController = tmp;
          loadLocalHTML();
        },
      ),
    );
  }
}*/
