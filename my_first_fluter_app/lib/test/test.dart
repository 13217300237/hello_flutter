import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {//不要使用StatelessWidget的context，因为它内部不包含Navigator对象
    return new MaterialApp(title: 'Flutter Demo', home: Main());
  }
}

//解决方式1：不要使用stateless或者statefulWidget的context，而要使用 MaterialApp提供的context
//就像上面的这种做法，用MaterialApp包起来的body，body是一个StatelessWidget，它的context其实是来自MaterialApp的

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("主页"),
      ),
      body: Column(
        children: <Widget>[
          Text("第一个页面"),
          RaisedButton(
            onPressed: () {
              ///Navigator.push内部其实就是 Navigator.of(context).push
              // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              //   return new SecondRoute();
              // }));

              ///Navigator的push所使用的context，必须是包含 Navigator对象的，不然就会报错：
              ///Navigator operation requested with a context that does not include a Navigator.
              ///那么，解决方式有三种，第一，,把Navigator动作放在MaterialApp定义里面，拿它的context就行了
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return new SecondRoute();
              }));
            },
            child: Text("进入第二页"),
          )
        ],
      ),
    );
  }
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
