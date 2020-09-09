import 'package:dio/dio.dart';

abstract class ServiceBase {
  Future<Response> get(String url, int page);

  Future<Response> post(String url, String data);

  Future<Response> put(String url, String data);
}