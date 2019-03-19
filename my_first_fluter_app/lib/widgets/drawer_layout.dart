import 'package:HankFlutterTest/pages/favor_list.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

///抽屉单独提取出来作为一个文件，
Widget getMainDrawer(context) {
  Widget userHeader = DrawerHeader(
    decoration: BoxDecoration(color: Colors.white),
    duration: Duration(seconds: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: CircleAvatar(
              backgroundImage: AssetImage('assets/cat3.jpg'), maxRadius: 38),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text(
                '波澜不惊',
                style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontSize: 18),
              ),
              Padding(
                child: Text(
                  '申请认证',
                  style: TextStyle(
                      color: Colors.green,
                      fontStyle: FontStyle.italic,
                      fontSize: 12),
                ),
                padding: EdgeInsets.all(10),
              )
            ],
          ),
        )
      ],
    ),
  ); //Flutter框架自带的DrawerHeader控件，表示抽屉的头

  //菜单
  Widget menuWidget = Column(
    children: <Widget>[
      InkWell(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            // image: DecorationImage(image: AssetImage('assets/cat3.jpg'))//背景图片. 注意，背景图片和背景颜色不能同时存在
            // border: new Border.all(width: 2.0, color: Colors.red),//边框
          ),
          child: ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            title: Text(
              '收藏',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  fontSize: 18),
            ),
          ),
          padding: EdgeInsets.all(10),
        ),
        onTap: () {
          Toast.show('点击进入收藏列表', context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FavorList();
          }));
        },
      ),
    ],
  );

  ListView listView = new ListView(
    padding: EdgeInsets.zero, //看来像是让状态栏沉浸式？
    children: <Widget>[userHeader, menuWidget],
  );
  return listView;
}
