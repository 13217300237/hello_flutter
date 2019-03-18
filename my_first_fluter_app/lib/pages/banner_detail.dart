import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class BannerWebView extends StatefulWidget {
  final data;

  BannerWebView(this.data);

  @override
  State<StatefulWidget> createState() => BannerWebViewState();
}

//这里的泛型，是为了让State里面，使用ArticleWebView中的字段
class BannerWebViewState extends State<BannerWebView> {
  bool ifLoading = false;// 控制进度条透明度的变量
  FlutterWebviewPlugin flutterWebviewPlugin;

  // 对于一个StatefulWidget而言，其实也就是对于State对象而言，initState方法一次生命周期之内，只会执行一次
  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin = FlutterWebviewPlugin();
    flutterWebviewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.finishLoad) {
        //当加载状态发生改变
        setState(() {
          ifLoading = false;
        });
      } else if (state.type == WebViewState.startLoad) {
        setState(() {
          ifLoading = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebviewPlugin.dispose();
  }

  //下面的代码已经可以正常打开网页了，现在，我要让它可以显示网页的加载进度
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: Text(
          widget.data['title'],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: const LinearProgressIndicator(),
        ),
        bottomOpacity: ifLoading ? 1.0 : 0.0,
      ),
      url: widget.data['url'],
    );
  }
}
