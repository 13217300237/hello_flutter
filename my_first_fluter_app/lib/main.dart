import 'package:HankFlutterTest/pages/banner_detail.dart';
import 'package:HankFlutterTest/pages/second_page.dart';
import 'package:HankFlutterTest/widgets/article_item.dart';
import 'package:HankFlutterTest/widgets/drawer_layout.dart';
import 'package:banner_view/banner_view.dart';
import 'package:flutter/material.dart';
import 'package:gradient_bottom_navigation_bar/gradient_bottom_navigation_bar.dart';
import 'data/data_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '这个标题不显示，不知道干啥的',
      home: MyMainWidget(),
    );
  }
}

///为什么改名字都不行,因为createState不会热重载，所以你改名字就会直接报错
///主界面
class MyMainWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomeState();
  }
}

int mCurrentPage = 0; //主界面要根据这个值进行界面更改
var mContext;

///主界面的state
class MyHomeState extends State<MyMainWidget> {
  @override
  void initState() {
    super.initState();
    initBanner(); //发起异步任务
    initListView();

    loginAndGetCollect();
  }

  void loginAndGetCollect() async {
    await DataManager.executeLoginAndGetCollect();
  }

  initBanner() async {
    //异步
    await DataManager.getBannerImages(); //把原本异步的方法转为同步，它执行完毕之后，再往下一行代码执行
    setState(() {}); // 刷新视图,build会重新调用
  }

  initListView() async {
    await DataManager.getArticles(0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('你好Flutter!'),
      ),
      body: getCurrentMainWidget(context), //主界面的body应该要根据不同的情况进行切换
      bottomNavigationBar: GradientBottomNavigationBar(
        backgroundColorStart: Colors.white,
        backgroundColorEnd: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), title: Text('Business')),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), title: Text('School')),
        ],
        currentIndex: mCurrentPage, //当前被选中的index
        fixedColor: Colors.green, // 图片和文字的填充色
        onTap: (i) {
          setState(() {
            mCurrentPage = i;
          });
        },
      ),
      drawer: Drawer(
        // 滑出抽屉
        child: getMainDrawer(context),
      ),
    );
  }
}

/// 根据当前选中页的情况，切换main UI区的显示内容
Widget getCurrentMainWidget(context) {
  //这里应该要换成Stack帧布局，我要想办法对N个View，每次只显示一个,你还真是一切皆Widget
  //卧槽，不行，我试过了Stack布局，然后发现，一层层覆盖之后，除了最外层，其他层的点击事件都没用了，擦

  // Stack stack = Stack(
  //   children: <Widget>[
  //     Opacity(
  //       child: Center(child: Text('第3页')),
  //       opacity: currentPage == 2 ? 1 : 0,
  //     ),
  //     Opacity(
  //       child: getListView(),
  //       opacity: currentPage == 1 ? 1 : 0,
  //     ),
  //     Opacity(
  //       child: Center(child: HomeBannerContainer()),
  //       opacity: currentPage == 0 ? 1 : 0, //
  //     ),
  //   ],
  // );
  // return stack;

  ///要想个办法(暂时还没想到)，把当前显示的widget放在最后
  ///
  ///大坑注意！
  ///
  ///这里有个bug，我用Stack帧布局，来一层一层覆盖的时候，最后这一层的点击事件才会生效

  //然后我又试了一下，Visibility 可见布局，点击事件的问题解决了，然后发现，貌似对象又重新创建了(ps：轮播图又从第一个开始轮了)。擦？！
  Stack stack = Stack(
    children: <Widget>[
      Offstage(
        /// 安卓里面的Visibility属性，对应的好像是这里的Offstage，它居然才是控制显示隐藏，也是很诡异了;
        ///flutter的visibility 为何会触发重新创建
        child: Center(
            child: RaisedButton(
          child: Text('第3页'),
          onPressed: () {
            //点击之后，跳转到另一个页面
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return SecondPage();
            }));
          },
        )),
        offstage: mCurrentPage != 2 ? true : false,
      ),
      Offstage(
        child: getListView(),
        offstage: mCurrentPage != 1 ? true : false,
      ),
      Offstage(
        child: Center(child: HomeBannerContainer()),
        offstage: mCurrentPage != 0 ? true : false, //
      ),
    ],
  );
  return stack;
}

///homeBanner
class HomeBannerContainer extends StatelessWidget {
  const HomeBannerContainer();

  @override
  Widget build(BuildContext context) {
    //这个build会随着setState的触发而多次执行
    Container container = new Container(
      alignment: Alignment.topCenter,
      height: 300.0,
      child: _bannerView(context),
    );

    // 换成一个ListView吧

    ListView listView = new ListView(
      children: <Widget>[container],
      scrollDirection: Axis.vertical,
    );
    return listView;
  }
}

///轮播图控件
Widget _bannerView(context) {
  //  用一个list存储所有的banner控件（其实是Image）
  List<Widget> bannerWidgetList = new List<Widget>();
  //如果数据源是空，就不必去解析加载了.
  if (DataManager.bannerImages == null || DataManager.bannerImages.isEmpty)
    return null;
  //数据源不为空，就去逐个解析
  DataManager.bannerImages.forEach((item) {
    InkWell inkwell = InkWell(
      child: Image.network(
        item['imagePath'],
        fit: BoxFit.cover,
      ),
      onTap: () {
        // 跳转到web页
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return BannerWebView(item);
        }));
      },
    );

    bannerWidgetList.add(inkwell);
  });

  //然后把 bannerWidgetList 传进去，按照返回一个BannerView
  return bannerWidgetList.isNotEmpty
      ? BannerView(
          bannerWidgetList,
          intervalDuration: Duration(seconds: 3),
        )
      : null;
}

///homeBanner的内容,这里返回的是本地图片
class CustomWidget extends StatelessWidget {
  final String text;

  CustomWidget({this.text});

  @override
  Widget build(BuildContext context) {
    print("assets/cat" + text + ".jpg");
    return Image.asset(
      "assets/cat" + text + ".jpg",
      fit: BoxFit.cover,
    ); //Text('略略略');
  }
}

/// 第二页？我想想该怎么用列表
Widget getListView() {
  if (DataManager.articles == null || DataManager.articles.isEmpty) return null;

  List<ArticleItem> listItems = new List();
  DataManager.articles.forEach((item) {
    listItems.add(ArticleItem(
      data: item,
    ));
  });

  //看看如何从网络上获取数据，然后加到这个里面
  return new ListView(
    children: listItems,
    scrollDirection: Axis.vertical,
    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
  );
}
