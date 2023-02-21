import 'package:coincapapp/models/app_config.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();
  AppConfig? appConFig;
  String? baseURL;
  HTTPService() {
    appConFig = GetIt.instance.get<AppConfig>();
    baseURL = appConFig!.COIN_API_BASE_URL;
  }
  Future<Response<String>?> get(String path) async {
    try {
      String url = "$baseURL$path";
      Future<Response<String>> repsonse = dio.get<String>(url);
      return repsonse;
    } catch (e) {
      print('HTTPService: unable to perform get request!');
      print(e);
    }
  }
}
