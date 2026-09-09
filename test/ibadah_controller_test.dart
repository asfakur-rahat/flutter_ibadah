import 'package:flutter_ibadah/flutter_ibadah.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHandle implements IbadahRefreshHandle {
  int calls = 0;

  @override
  Future<void> refreshSalatTime() async => calls++;
}

void main() {
  group('IbadahController', () {
    test('starts detached and in the initial status', () {
      final controller = IbadahController();
      addTearDown(controller.dispose);

      expect(controller.isAttached, isFalse);
      expect(controller.status, IbadahFetchStatus.initial);
      expect(controller.district, isNull);
      expect(controller.lastUpdated, isNull);
      expect(controller.errorMessage, isNull);
    });

    test('refresh() on a detached controller is a no-op', () async {
      final controller = IbadahController();
      addTearDown(controller.dispose);

      await expectLater(controller.refresh(), completes);
    });

    test('attach/detach flips isAttached and routes refresh()', () async {
      final controller = IbadahController();
      addTearDown(controller.dispose);
      final handle = _FakeHandle();

      controller.attach(handle);
      expect(controller.isAttached, isTrue);

      await controller.refresh();
      expect(handle.calls, 1);

      controller.detach(handle);
      expect(controller.isAttached, isFalse);

      await controller.refresh();
      expect(handle.calls, 1, reason: 'detached controller must not refresh');
    });

    test('detach from a different handle is ignored', () {
      final controller = IbadahController();
      addTearDown(controller.dispose);
      final handle = _FakeHandle();

      controller.attach(handle);
      controller.detach(_FakeHandle());

      expect(controller.isAttached, isTrue);
    });

    test('attaching twice asserts', () {
      final controller = IbadahController();
      addTearDown(controller.dispose);

      controller.attach(_FakeHandle());
      expect(() => controller.attach(_FakeHandle()), throwsAssertionError);
    });

    test('sync() updates the getters and notifies once per change', () {
      final controller = IbadahController();
      addTearDown(controller.dispose);
      var notifications = 0;
      controller.addListener(() => notifications++);

      final at = DateTime(2026, 1, 1, 5, 30);
      controller.sync(
        status: IbadahFetchStatus.success,
        district: 'Sylhet',
        lastUpdated: at,
      );

      expect(controller.status, IbadahFetchStatus.success);
      expect(controller.district, 'Sylhet');
      expect(controller.lastUpdated, at);
      expect(controller.errorMessage, isNull);
      expect(notifications, 1);

      // Same values again: no further notification.
      controller.sync(
        status: IbadahFetchStatus.success,
        district: 'Sylhet',
        lastUpdated: at,
      );
      expect(notifications, 1);

      controller.sync(
        status: IbadahFetchStatus.failure,
        district: 'Sylhet',
        lastUpdated: at,
        errorMessage: 'No Internet Connection',
      );
      expect(controller.status, IbadahFetchStatus.failure);
      expect(controller.errorMessage, 'No Internet Connection');
      expect(
        controller.lastUpdated,
        at,
        reason: 'a failure keeps the last successful fetch time',
      );
      expect(notifications, 2);
    });
  });

  group('ibadahRetryDelay', () {
    test('walks the backoff ladder', () {
      expect(ibadahRetryDelay(0), const Duration(seconds: 15));
      expect(ibadahRetryDelay(1), const Duration(seconds: 30));
      expect(ibadahRetryDelay(2), const Duration(minutes: 1));
      expect(ibadahRetryDelay(3), const Duration(minutes: 2));
      expect(ibadahRetryDelay(4), const Duration(minutes: 5));
    });

    test('clamps at five minutes for later attempts', () {
      for (final attempt in [5, 6, 20, 1000]) {
        expect(ibadahRetryDelay(attempt), const Duration(minutes: 5));
      }
    });

    test('handles a negative attempt defensively', () {
      expect(ibadahRetryDelay(-1), const Duration(seconds: 15));
    });
  });
}
