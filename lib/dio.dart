import 'package:alice/alice.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

Alice alice = Alice(showNotification: true);

Dio dio = (() {
  Dio _dio = Dio();

  var mobile = '7788913369';
  var password = '123456';

  String hash(String str) => md5.convert(utf8.encode(str)).toString();

  _dio.options.baseUrl = 'https://api.nerdlinux.com/delivery_v1';

  _dio.interceptors
    ..add(LogInterceptor(responseBody: true, responseHeader: true))
    ..add(alice.getDioInterceptor())
    ..add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      var timestamp = DateTime.now().microsecondsSinceEpoch ~/ 1000;
      var token = hash('$mobile$timestamp${hash(password)}');

      options.headers
          .addAll({'mobile': mobile, 'timestamp': timestamp, 'token': token});

      print('$mobile, $timestamp, $token');

      return options;
    }));

  return _dio;
})();

void main() {
  dio.get('https://api.nerdlinux.com/');
}
