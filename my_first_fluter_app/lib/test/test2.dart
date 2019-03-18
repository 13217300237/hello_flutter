import 'package:flutter/material.dart';

void main() => runApp(MyApp());

final String roterName = '/second';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //不要使用StatelessWidget的context，因为它内部不包含Navigator对象
    return new MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/': (context) {
          return mainLayout();
        },
        roterName: (context) {
          return SecondRoute();
        }
      },
      // home:mainLayout()  //home和'/'的路由配置居然还冲突了,666,有你没我！
    );
  }
}

Widget mainLayout() {
  return Scaffold(
    //home和'/'的路由配置居然还冲突了
    appBar: AppBar(
      title: Text("主页"),
    ),
    body: Column(
      children: <Widget>[
        Text("第一个页面"),

        //这是什么原理呢
        //报那个错，是因为 在一层一层widget往上找，找到root的为止，看这个root是不是有 NavigatorState
        //这里使用Build把 按钮包起来，那现在，就是从Builder的父，开始查找NavigatorState
        Builder(builder: (context) {
          return RaisedButton(
            onPressed: () {
              ///Navigator的push所使用的context，必须是包含 Navigator对象的，不然就会报错：
              ///Navigator operation requested with a context that does not include a Navigator.
              ///那么，解决方式有这是第二种方式，把拿到的context
              // Navigator.push(context, MaterialPageRoute(builder: (_) {
              //   return new SecondRoute();
              // }));

              Navigator.pushNamed(context, roterName+"");
              ///如果我要跳到一个没有注册的路由里，那么就会报
              ///Could not find a generator for route RouteSettings("/second11", null) in the _WidgetsAppState.
            },
            child: Text("进入第二页"),
          );
        }),
      ],
    ),
  );
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第二页"),
      ),
      body: Column(
        children: <Widget>[
          Text("第一个页面"),
          RaisedButton(
            onPressed: () {
              //路由pop弹出
              Navigator.pop(context);
            },
            child: Text("返回"),
          )
        ],
      ),
    );
  }
}
