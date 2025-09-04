import 'package:flutter_ibadah/src/core/local/hive_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ibadah/src/presentation/bloc/ibadah_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main() {
  group('IbadahBloc', () {
    late IbadahBloc bloc;

    setUp(()async {
      // await Hive.initFlutter();
      // await HiveService.instance.init();
      bloc = IbadahBloc();
    });

    test('initial state is IbadahInitial', () {
      expect(bloc.state, IbadahInitial());
    });

    test('FetchSalatTime emits correct states', () async {
      bloc.add(FetchSalatTime(district: 'Dhaka'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<SalatTimeFetching>(),
          isA<SalatTimeFetchSuccess>(),
        ]),
      );
    });
  });
}

