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

  _dio.options.baseUrl = 'https://api.nerdlinux.com/deliverer_v1';

  _dio.interceptors
    ..add(alice.getDioInterceptor())
    ..add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      var timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      var token = hash('$mobile$timestamp${hash(password)}');

      options.headers
          .addAll({'mobile': mobile, 'timestamp': timestamp, 'token': token});

      return options;
    }));

  return _dio;
})();

void main() {
  dio.get('https://api.nerdlinux.com/');
}
