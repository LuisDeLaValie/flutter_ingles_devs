// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../data/model/questions_model.dart';
import '../data/model/registro_model.dart';
import '../data/model/tecnologias_model.dart';

class IngesDevApi {
  static final _uri = "http://localhost:5015/api";

  static RegistroApi registro() => RegistroApi(baseUrl: "$_uri/Registro");
  static TestApi test() => TestApi(baseUrl: "$_uri/Test");
}

class RegistroApi {
  final String baseUrl;

  RegistroApi({required this.baseUrl});

  Future<List<TecnologiasModel>?> getTecnologias() async {
    try {
      final dio = Dio();
      final response = await dio.get('$baseUrl/tecnologias');
      final res = (response.data as List<dynamic>)
          .map((e) => TecnologiasModel.fromMap(e as Map<String, dynamic>))
          .toList();

      return res;
    } catch (e) {
      log(e.toString(), name: "getTecnologias");
    }
    return null;
  }

  Future<RegistroModel?> registrar(RegistroModel registro) async {
    final dio = Dio();
    try {
      final response =
          await dio.post('$baseUrl/registrar', data: registro.toJson());
      final newRegistro = RegistroModel.fromMap(response.data);

      return newRegistro;
    } catch (e) {
      log(e.toString(), name: "registrar");
    }
    return null;
  }
}

class TestApi {
  final String baseUrl;
  TestApi({required this.baseUrl});

  Future<List<QuestionsModel>?> getquestions() async {
    try {
      final dio = Dio();
      final response = await dio.get('$baseUrl/getquestions');
      final questions = (response.data as List<dynamic>)
          .map((e) => QuestionsModel.fromMap(e as Map<String, dynamic>))
          .toList();

      return questions;
    } catch (e) {
      log(e.toString(), name: "getquestions");
    }
    return null;
  }

  Future<bool> calificar(int user, List<QuestionsModel> respuestas) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('http://localhost:5015/api/Test/calificar?usuario=$user'));
      request.body = json.encode(respuestas.map((e) => e.toMap()).toList());
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 204) {
        return true;
      } else {
        // print(response.statusMessage);
        return false;
      }
    } on DioException catch (e) {
      log(e.toString(), name: "calificar");

      print(json.encode(<String, dynamic>{
        'message': e.message,
        'uri': e.requestOptions.uri.toString(),
        'statusCode': e.response?.statusCode,
        'statusMessage': e.response?.statusMessage,
        'data': e.requestOptions.data,
        'error': e.response?.data
      }));
      return false;
    } catch (e) {
      log(e.toString(), name: "calificar");
      throw e;
    }
  }
}

class DioError extends DioException {
  DioError({required super.requestOptions});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': super.message,
      'uri': super.requestOptions.uri.toString(),
      'statusCode': super.response?.statusCode,
      'statusMessage': super.response?.statusMessage,
      'data': super.requestOptions.data
    };
  }

  String toJson() => json.encode(<String, dynamic>{
        'message': super.message,
        'uri': super.requestOptions.uri.toString(),
        'statusCode': super.response?.statusCode,
        'statusMessage': super.response?.statusMessage,
        'data': super.requestOptions.data
      });
}