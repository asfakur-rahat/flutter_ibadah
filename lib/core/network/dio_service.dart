import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../data/utils/ibadah_links.dart';
import 'data_state.dart'; // Replace with actual path if needed

class AppConfig {
  static final shared = AppConfig();
  final String baseUrl = IbadahLinks.instance.baseUrl; // Replace with actual base URL
}

class DioService {
  static final DioService _instance = DioService._();

  late Dio _dio;

  factory DioService() {
    return _instance;
  }

  DioService._() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
      ),
    );

    ///Add interceptors
    _dio.interceptors.addAll(
      [
        _errorInterceptor(),
        _loggingInterceptor(),
        _flavorInterceptor(),
      ],
    );
  }

  /// Internet connectivity checker
  Future<bool> _isConnected() async {
    bool connected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connected = true;
      }
    } on SocketException catch (e) {
      debugPrint(e.toString());
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return connected;
  }

  ///Error handling interceptor
  Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException exception, ErrorInterceptorHandler handler) {
        _debugLog("Dio exception: ${exception.message}");
        _debugLog("Dio exception response: ${exception.response}");
        if (exception.response != null) {
          _debugLog(
              "Status Code inside error interceptor: ${exception.response?.statusCode}");
          switch (exception.response?.statusCode) {
            case 400:
              final errorData = exception.response?.data;
              if (errorData != null &&
                  errorData['detail'] == 'Invalid or expired refresh token') {
              }
              _debugLog("Bad Request");
              break;
            case 401:
              _debugLog("Unauthorized");
              break;
            case 404:
              _debugLog("Bad Response");
            case 500:
              _debugLog("Server Error");
            default:
              _debugLog("Unknown Error");
          }
        }
        return handler.next(exception);
      },
    );
  }

  ///Logging interceptor
  Interceptor _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {

        _debugLog("========Request======");
        _debugLog(options.method);
        _debugLog(options.uri.toString());

        _debugLog("========Headers======");
        _debugLog(jsonEncode(options.headers));
        if (options.data != null) {
          _debugLog("========Data======");
          _debugLog(jsonEncode(options.data));
        }
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        _debugLog("========Response======");
        _debugLog("Status Code: ${response.statusCode}");
        _debugLog(jsonEncode(response.data));

        return handler.next(response);
      },
    );
  }

  ///Flavor specific interceptor
  Interceptor _flavorInterceptor() {
    return InterceptorsWrapper();
  }

  String getErrorMessage(DioException e) {
    String errorMessage = "Unknown Error Occurred";

    if (e.message == "No Internet Connection") {
      errorMessage = "No Internet Connection";
      return errorMessage;
    }

    if(e.type == DioExceptionType.connectionTimeout){
      errorMessage = "Connection timed out! Please try again";
      return errorMessage;
    }

    else if(e.type == DioExceptionType.receiveTimeout){
      errorMessage = "Receive timeout! Please try again";
      return errorMessage;
    }


    try {

      final responseData = e.response?.data;
      if (responseData is Map) {
        if (responseData["errors"] is List) {
          final errorsList = responseData["errors"] as List;
          final descriptions = errorsList
              .map((error) => (error["description"]?.toString() ?? "").trim())
              .where((description) => description.isNotEmpty)
              .toList();
          if (descriptions.length == 1) {
            errorMessage = descriptions.first;
          } else if (descriptions.isNotEmpty) {
            errorMessage = descriptions.join("\n ");
          }
        }
      }
      else{
        if(e.response?.statusCode == 429){
          errorMessage = e.response?.data.toString()??"Unknown Error Occurred";
        }
        // else if(e.response?.statusCode == 502)
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return errorMessage;
  }

  Future<DataState<T>> callApiService<T>({
    required Future<Response<dynamic>> Function() api,
    required Future<T?> Function(dynamic responseData) responseToDataExtractor,
    bool checkNull = true,
  }) async {
    try {
      final response = await api();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final T? data = await responseToDataExtractor(response.data);
        if (checkNull) {
          if (data != null) {
            return DataSuccess(data);
          }
        } else {
          return DataSuccess(data);
        }
      }
    } on DioException catch (e) {
      String? internetError;
      if (e.message == "No Internet Connection") {
        internetError = "No Internet Connection";
      }
      final String errorMessage = internetError ?? getErrorMessage(e);
      debugPrint(errorMessage);
      return DataFailed(message: errorMessage, dioException: e);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      return const DataFailed(message: "Unknown Error Occurred");
    }
    return const DataFailed(message: "Unknown Error Occurred");
  }

  Future<Response> get({
    required String url,
    Map<String, dynamic>? queryParams,
    Options? options,
    int? connectTimeOut,
    int? receiveTimeOut,
  }) async {
    if (!await _isConnected()) {
      throw DioException(
          requestOptions: RequestOptions(path: url),
          type: DioExceptionType.unknown,
          error: 'No Internet Connection',
          message: 'No Internet Connection');
    }
    try {
      Dio finalDio =( connectTimeOut == null && receiveTimeOut==null)
          ? _dio
          : Dio(
              BaseOptions(
                baseUrl: AppConfig.shared.baseUrl,
                // todo: change when needed
                connectTimeout:  Duration(milliseconds: connectTimeOut??30000),
                receiveTimeout:  Duration(milliseconds: receiveTimeOut??30000),
              ),
            );
      final Response response =
          await finalDio.get(url, queryParameters: queryParams, options: options);
      return response;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      rethrow;
    }
  }

  Future<Response> post({
    required String url,
    Map<String, dynamic>? queryParams,
    dynamic payload,
    Function(int, int)? onSendProgress,
  }) async {
    if (!await _isConnected()) {
      debugPrint("no internet");
      throw DioException(
          requestOptions: RequestOptions(path: url),
          type: DioExceptionType.unknown,
          error: 'No Internet Connection',
          message: 'No Internet Connection');
    }
    try {
      final Response response = await _dio.post(url,
          data: payload,
          queryParameters: queryParams,
          onSendProgress: onSendProgress);
      return response;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      rethrow;
    }
  }

  Future<Response> put({
    required String url,
    Map<String, dynamic>? queryParams,
    dynamic payload,
    Function(int, int)? onSendProgress,
  }) async {
    if (!await _isConnected()) {
      debugPrint("no internet");
      throw DioException(
        requestOptions: RequestOptions(path: url),
        type: DioExceptionType.unknown,
        error: 'No Internet Connection',
        message: 'No Internet Connection',
      );
    }
    try {
      final Response response = await _dio.put(url,
          data: payload,
          queryParameters: queryParams,
          onSendProgress: onSendProgress);
      return response;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      rethrow;
    }
  }

  Future<Response> delete({
    required String url,
    Map<String, dynamic>? queryParams,
    dynamic payload,
    Function(int, int)? onSendProgress,
  }) async {
    if (!await _isConnected()) {
      debugPrint("no internet");
      throw DioException(
        requestOptions: RequestOptions(path: url),
        type: DioExceptionType.unknown,
        error: 'No Internet Connection',
        message: 'No Internet Connection',
      );
    }
    try {
      final Response response = await _dio.delete(
        url,
        data: payload,
        queryParameters: queryParams,
      );
      return response;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      rethrow;
    }
  }

  void _debugLog(String logString) {
    if (kDebugMode) {
      log(logString);
    }
  }
}
