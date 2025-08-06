import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:guardian_app/app_config.dart';
import 'package:guardian_app/core/network/links/links.dart';
import 'package:guardian_app/core/resources/device_info_service.dart';
import 'package:guardian_app/core/resources/secure_storage.dart';

import '../../resources/data_state.dart';
import '../../resources/global_variables/global_variables.dart';

class DioService {
  static final DioService _instance = DioService._();

  late Dio _dio;

  factory DioService() {
    return _instance;
  }

  DioService._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.shared.baseUrl,
        // todo: change when needed
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
      ),
    );

    ///Add interceptors
    _dio.interceptors.addAll(
      [
        _headerInterceptor(),
        _authInterceptor(),
        _refreshTokenInterceptor(),
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

  ///Auth interceptor
  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (
        RequestOptions options,
        RequestInterceptorHandler handler,
      ) async {
        String? accessToken = await SecureStorage().getAccessToken();
        _debugLog("access token: $accessToken");
        if (accessToken != null) {
          options.headers["Authorization"] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
    );
  }

  ///header interceptor
  Interceptor _headerInterceptor() {
    return InterceptorsWrapper(
      onRequest: (
        RequestOptions options,
        RequestInterceptorHandler handler,
      ) async {
        String? deviceId = await DeviceInfoService.instance.getDeviceId();
        _debugLog("deviceId: $deviceId");
        if (deviceId != null) {
          options.headers["ClientId"] = deviceId;
        }
        return handler.next(options);
      },
    );
  }

  ///Refresh interceptor
  Interceptor _refreshTokenInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException exception, ErrorInterceptorHandler handler) async {
        if (exception.response?.statusCode == 401) {
          final String? refreshToken = await SecureStorage().getRefreshToken();
          final String? expiryTime = await SecureStorage().getExpiryTime();
          DateTime? convertedExpiryTime;
          if (expiryTime != null) {
            convertedExpiryTime = DateTime.parse(expiryTime);
          }
          if (DateTime.now().isBefore(convertedExpiryTime ?? DateTime.now())) {
            if (refreshToken != null && expiryTime != null) {
              try {
                final response = await _dio.post(
                  '${AppConfig.shared.baseUrl}${Links().refreshTokenUrl}',
                  data: {'refreshToken': refreshToken},
                );

                String newAccessToken = response.data["token"];
                String newRefreshToken = response.data["refreshToken"];
                String refreshTokenExpiryTime =
                    response.data["refreshTokenExpiryTime"];
                await Future.wait([
                  SecureStorage().saveAccessToken(newAccessToken),
                  SecureStorage().saveRefreshToken(newRefreshToken),
                  SecureStorage().saveExpiryTime(refreshTokenExpiryTime),
                ]);

                ///Retry the original request with the new access token
                final options = exception.requestOptions;
                options.headers['Authorization'] = 'Bearer $newAccessToken';
                final cloneReq = await _dio.request(
                  options.path,
                  data: options.data,
                  queryParameters: options.queryParameters,
                  options: Options(
                    method: options.method,
                    headers: options.headers,
                  ),
                );

                return handler.resolve(cloneReq);
              } on DioException catch (e) {
                if (e.response?.statusCode == 400) {
                  final errorData = e.response?.data;
                  if (errorData != null &&
                      errorData['detail'] ==
                          'Invalid or expired refresh token') {
                    _handleRefreshTokenExpired();
                  }
                }
                debugPrint(e.toString());
                return handler.next(exception);
              } catch (e, s) {
                if (e is DioException && e.response?.statusCode == 400) {
                  final errorData = e.response?.data;
                  if (errorData != null &&
                      errorData['detail'] ==
                          'Invalid or expired refresh token') {
                    _handleRefreshTokenExpired();
                  }
                }
                debugPrint(e.toString());
                debugPrint(s.toString());
                return handler.next(exception);
              }
            }
          } else {
            _handleRefreshTokenExpired();
          }
        }
        return handler.next(exception);
      },
    );
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
                _handleRefreshTokenExpired();
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

  void _handleRefreshTokenExpired() async {
    await SecureStorage().clearTokens();

    appLogoutNotifier.value = true;
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
