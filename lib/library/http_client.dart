import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fluttermovie/library/exception_helper_error.dart';
import 'package:fluttermovie/model/key_model.dart';
import 'package:fluttermovie/repository/service_base.dart';
import 'package:jwt_decode/jwt_decode.dart';

import 'util.dart';

const int receiveTimeout = 12000;
const int connectTimeout = 10000;

class HttpClient implements ServiceBase {
  static final HttpClient _httpClient = HttpClient._internal();
  static HttpClient get instance {
    return _httpClient;
  }

  HttpClient._internal();

  Future<Response> get(String url, int page, String query) async {
    final dio = await _instanceDio(page, query);
    print(page);
    print(dio.options.queryParameters);
    try {
      final response = await dio.get(url);
      if (response.data != null) {
        return response;
      }
    } on DioError catch (error) {
      print(error);
      _buildException(error);
    }
    return null;
  }

  Future<Response> post(String url, String data) async {
    if (data == null || data.isEmpty) return null;
    final dio = await _instanceDio(1);
    try {
      return await dio.post(url, data: data);
    } on DioError catch (error) {
      _buildException(error);
    }
    return null;
  }

  Future<Response> put(String url, String data) async {
    final dio = await _instanceDio(1);
    try {
      final response = await dio.put(url, data: data);
      if (response.data != null) {
        return response;
      }
    } on DioError catch (error) {
      _buildException(error);
    }
    return null;
  }

  Future<Dio> _instanceDio(int page, [String query]) async {
    final key = await _loadKey();
    BaseOptions options = BaseOptions(
      baseUrl: Util.instance.urlBase,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      queryParameters: query != null && query.trim().isNotEmpty
          ? {
              'api_key': key,
              'language': 'pt-BR',
              'page': page,
              'query': Util.instance.normalizeQuery(query),
            }
          : {
              'api_key': key,
              'language': 'pt-BR',
              'page': page,
            },
    );
    return Dio(options);
  }

  /// o ideal eh que esse arquivo nao seja adicionado (no assets) no repositorio por questao de seguranca
  /// vou adiciona-lo por se tratar de um teste
  Future<String> _loadKey() async {
    return await rootBundle.loadStructuredData<String>(
        Util.instance.assetsKey, _paserLoad);
  }

  Future<String> _paserLoad(String value) async {
    try {
      if (value != null) {
        final payload = Jwt.parseJwt(value);
        return KeyModel.fromMap(payload)?.key;
      }
    } catch (e) {
      print(e);
    }
    return '';
  }

  void _buildException(DioError error) {
    final exceptionHandler = ExceptionHelperError.instance;
    final statusCode = error?.response?.statusCode ?? ERRO_SERVIDOR;
    if (error.type == DioErrorType.DEFAULT) {
      throw exceptionHandler.handlerErroConexao();
    } else if (error.type == DioErrorType.CONNECT_TIMEOUT ||
        error.type == DioErrorType.RECEIVE_TIMEOUT) {
      throw exceptionHandler.handlerErroTimeout();
    } else if (statusCode == 404) {
      throw throw exceptionHandler.handlerErroNotFound();
    } else {
      throw throw exceptionHandler.handlerErroServidor();
    }
  }
}
