import 'package:flutter/material.dart';
// import 'package:toast/toast.dart';

///收藏列表
class FavorList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FavorState();
}

class FavorState extends State<FavorList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的收藏'),
      ),
      body: mainBody(context),
      bottomSheet: getFavorType((i) {
        setState(() {
          if (mCurrentTab != i) mCurrentTab = i;
        });
      }), //底部
    );
  }
}

/// 有两列，我可以用之前的那个导航栏来做切换，也可以自己写切换代码
/// 自己写吧，看看导航栏切换的实现代码
///
typedef SwitchTab = void Function(int i);

//自定义两个按钮，用于切换当前类别(文章/网站)
Widget getFavorType(SwitchTab func) {
  Row row = Row(
    children: <Widget>[
      Expanded(
        child: InkWell(
          child: Container(
            alignment: Alignment.center,
            color: Colors.greenAccent,
            height: 50,
            child: Text(
              '文章',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          onTap: () {
            func(0);
          },
        ),
      ),
      Expanded(
        child: InkWell(
          child: Container(
            alignment: Alignment.center,
            color: Colors.yellow,
            height: 50,
            child: Text(
              '网站',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          onTap: () {
            func(1);
          },
        ),
      )
    ],
  );
  return row;
}

int mCurrentTab = 0;
Widget mainBody(context) {
  //文章list
  List<Widget> articleItemWidget = List();
  for (var i = 0; i < 100; i++) {
    articleItemWidget.add(Card(
        elevation: 3,
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Text('文章$i'),
          height: 60,
        )));
  }

  ListView articleList = ListView(
    children: articleItemWidget,
  );

  // 网站list
  List<Widget> websiteItemWidget = List();
  for (var i = 0; i < 100; i++) {
    websiteItemWidget.add(Card(
        elevation: 3,
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Text('网站$i'),
          height: 60,
        )));
  }

  ListView websiteList = ListView(
    children: websiteItemWidget,
  );

  Stack stack = Stack(
    children: <Widget>[
      Offstage(
        child: articleList,
        offstage: mCurrentTab != 0,
      ),
      Offstage(
        child: websiteList,
        offstage: mCurrentTab != 1,
      )
    ],
  );

  return stack;
}
