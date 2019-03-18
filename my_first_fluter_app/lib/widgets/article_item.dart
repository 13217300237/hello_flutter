import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

/// 
///文章item的布局在这里完成
/// 布局嵌套：一层套一层。下面的层级关系是: 
/// Card{
///  {
///   Column{Row,Text,Text}
///  }
/// }
/// 最外层一个Card布局(也是谷歌materialDesign支持包里面的新布局),
/// 往内是一个纵向布局，纵向布局里面，有3个child，一个是Row横向布局，另外两个是2个Text
class ArticleItem extends StatelessWidget {
  final data;

  const ArticleItem({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //知道套路了，一层包一层
    //先试一下横向布局Row
    Row row = new Row(
      children: <Widget>[
        new Expanded(
          child: Text.rich(TextSpan(children: [//Text.rich富文本，TextSpan的组合
            TextSpan(text: '作者  '),
            TextSpan(
                text: data['author'],
                style: new TextStyle(color: Theme.of(context).primaryColor))
          ])),
        ),
        Text(data['niceDate'])
      ],
    );

    // return row;

    //给title加上样式
    Text title = Text(
      data['title'],
      style: new TextStyle(fontSize: 16, color: Colors.black),
      textAlign: TextAlign.left,
    );

    Text chapterName = new Text(
      data['chapterName'],
      style: new TextStyle(fontSize: 16, color: Colors.green),
      textAlign: TextAlign.left,
    );

    // return title;

    // 纵向布局
    Column column = new Column(
      children: <Widget>[
        new Padding(
          //间距
          padding: EdgeInsets.all(10.0), //上左下右全都间距10
          child: row,
        ),
        new Padding(
          padding: EdgeInsets.all(10.0),
          child: title,
        ),
        new Padding(
          padding: EdgeInsets.all(10.0),
          child: chapterName,
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );

    // return column;

    Card card = Card(
      child: InkWell(
        child: column,
        onTap: () {
          Toast.show(data['title'], context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        },
      ),
      elevation: 10,
      margin: EdgeInsets.all(8),
    );
    return card;
  }
}
