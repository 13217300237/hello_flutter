import 'package:dio/dio.dart';
// import 'package:toast/toast.dart';

import 'http_manager.dart';

class DataManager {
  static List bannerImages; //轮播图list
  static List articles; //文章list
  static List websiteCollects; //网站收藏
  static List articleCollects; //文章收藏

  static const String baseUrl = "https://www.wanandroid.com/";
  static const String _article_url = 'article/list/';
  static const String _banner_url = 'banner/json';

  ///异步拿到轮播图的数据
  static getBannerImages() async {
    Map resultMap =
        await HttpManager.getInstance().request(_banner_url); //banner 图的url后缀
    if (resultMap == null) {
      print(_banner_url + '接口返回为空');
    }
    bannerImages = resultMap['data']; //这里才是一个list
  }

  ///异步拿到文章的数据集
  ///文章，有页数，所以要加参数page
  static getArticles(int page) async {
    Map map =
        await HttpManager.getInstance().request('$_article_url$page/json');
    if (map == null) {
      print(_banner_url + '接口返回为空');
    }
    articles = map['data']['datas'];
  }

  //登录
  static const String LOGIN = "user/login";
  //登录
  static login(String username, String password) async {
    var formData = FormData.from({
      "username": username,
      "password": password,
    });
    return await HttpManager.getInstance()
        .request(LOGIN, data: formData, method: "post");
  }

  //收藏
  static const String COLLECT = "lg/collect/list/";
  static getCollects(int page) async {
    return await HttpManager.getInstance().request("$COLLECT/$page/json");
  }

  //登录，取收藏，一条龙服务
  static executeLoginAndGetCollect() async {
    var result = await login('zhouzhou', '123456'); //登录完成，//诶！？？？为什么自动登录会报302？
    if (result['errorCode'] == -1) {
      print(result['errorMsg']);
    } else {}
    //现在取收藏
    var res2 = await getCollects(0);
    //解析结果，将结果注入到websiteCollects,articleCollects
    print('取得了收藏数据' + res2.runtimeType.toString()); // 现在可以正常取数据了，接下来只需要摆布局
  }
}
