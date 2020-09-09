import 'package:fluttermovie/model/exception_model.dart';

const int ERRO_CONEXAO = 100;
const int ERRO_TIMEOUT = 200;
const int ERRO_NOT_FOUND = 300;
const int ERRO_SERVIDOR = 400;

class ExceptionHelperError {
  static final ExceptionHelperError _handler = ExceptionHelperError._internal();
  static ExceptionHelperError get instance { return _handler; }
  ExceptionHelperError._internal();

  ExceptionModel handlerErroConexao() {
    return ExceptionModel(codigo: ERRO_CONEXAO, msg: 'Erro de conexão');
  }

  ExceptionModel handlerErroTimeout() {
    return ExceptionModel(codigo: ERRO_TIMEOUT, msg: 'Erro de tempo de execução');
  }

  ExceptionModel handlerErroNotFound() {
    return ExceptionModel(codigo: ERRO_NOT_FOUND, msg: 'Servidor não encontrado');
  }

  ExceptionModel handlerErroServidor() {
    return ExceptionModel(codigo: ERRO_SERVIDOR, msg: 'Erro de servidor');
  }
}