import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ArticleWebView extends StatefulWidget {
  final data;

  ArticleWebView(this.data);

  @override
  State<StatefulWidget> createState() => ArticleWebViewState();
}

//这里的泛型，是为了让State里面，使用ArticleWebView中的字段
class ArticleWebViewState extends State<ArticleWebView> {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: Text(widget.data['title']),
      ),
      url: widget.data['link'],
    );
  }
}
