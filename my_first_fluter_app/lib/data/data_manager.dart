import 'http_manager.dart';

class DataManager {
  static List bannerImages; //轮播图list
  static List articles; //文章list

  static const String baseUrl = "http://www.wanandroid.com/";
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
}
