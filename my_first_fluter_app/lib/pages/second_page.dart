import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // // 这种写法，不会有返回箭头
    // return MaterialApp(
    //     title: '第二页', //这个是显示在recent任务里面的那个文本
    //     home: Scaffold(
    //         appBar: AppBar(title: Text('data')),
    //         body: Column(
    //           children: <Widget>[
    //             Text('第二页的data'),
    //             RaisedButton(
    //               child: Text('回到第一页'),
    //               onPressed: () {
    //                 Navigator.pop(context);
    //               },
    //             )
    //           ],
    //         )));

//这种写法会有返回箭头
    return Scaffold(
        appBar: AppBar(title: Text('data')),
        body: Column(
          children: <Widget>[
            Text('第二页的data'),
            RaisedButton(
              child: Text('回到第一页'),
              onPressed: () {
                Navigator.of(context).pop(context);
              },
            )
          ],
        ));
  }
}
