import 'package:dio/dio.dart';

abstract class DataState<T> {
  final T? data;
  final DioException? dioException;
  final String? message;

  const DataState({this.data, this.dioException, this.message});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T? data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed({super.dioException, super.message});
}