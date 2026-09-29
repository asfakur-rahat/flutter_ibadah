import 'package:flutter_ibadah/flutter_ibadah.dart';
import 'package:flutter_ibadah/src/data/utils/ibadah_links.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IbadahLinks.getSalatTimeUrl', () {
    Uri build({
      required IbadahLocation location,
      IbadahCalculationMethod method = IbadahCalculationMethod.karachi,
      IbadahSchool school = IbadahSchool.hanafi,
    }) =>
        Uri.parse(
          IbadahLinks.instance.getSalatTimeUrl(
            date: '29-09-2026',
            location: location,
            method: method,
            school: school,
          ),
        );

    test('builds the address as "<city>,<country>"', () {
      final uri = build(
        location: const IbadahLocation(city: 'Dhaka', country: 'Bangladesh'),
      );

      expect(uri.host, 'api.aladhan.com');
      expect(uri.path, '/v1/timingsByAddress/29-09-2026');
      expect(uri.queryParameters['address'], 'Dhaka,Bangladesh');
      expect(uri.queryParameters['iso8601'], 'true');
    });

    test('escapes apostrophes and spaces rather than sending them raw', () {
      final uri = build(
        location:
            const IbadahLocation(city: "Cox's Bazar", country: 'Bangladesh'),
      );

      // Decoded value is intact...
      expect(uri.queryParameters['address'], "Cox's Bazar,Bangladesh");
      // ...and the wire form carries no bare space.
      expect(uri.toString(), isNot(contains("Cox's Bazar,Bangladesh")));
      expect(uri.toString(), contains('address=Cox'));
      expect(uri.query, isNot(contains(' ')));
    });

    test('escapes a country containing a space', () {
      final uri = build(
        location: const IbadahLocation(city: 'Mecca', country: 'Saudi Arabia'),
      );

      expect(uri.queryParameters['address'], 'Mecca,Saudi Arabia');
      expect(uri.query, isNot(contains(' ')));
    });

    test('carries the method and school ids', () {
      final uri = build(
        location: const IbadahLocation(city: 'Toronto', country: 'Canada'),
        method: IbadahCalculationMethod.isna,
        school: IbadahSchool.shafi,
      );

      expect(uri.queryParameters['method'], '2');
      expect(uri.queryParameters['school'], '0');
    });

    test('the defaults still produce the pre-globalization request', () {
      final uri = build(
        location: const IbadahLocation(city: 'Dhaka', country: 'Bangladesh'),
      );

      expect(uri.queryParameters['method'], '1', reason: 'Karachi');
      expect(uri.queryParameters['school'], '1', reason: 'Hanafi');
    });
  });

  group('IbadahLocation', () {
    test('displayName prefers the label, address never does', () {
      const location = IbadahLocation(
        city: 'Dhaka',
        country: 'Bangladesh',
        label: 'ঢাকা',
      );

      expect(location.displayName, 'ঢাকা');
      expect(location.address, 'Dhaka,Bangladesh');
    });

    test('matches on city, country and label', () {
      const location = IbadahLocation(
        city: 'Mecca',
        country: 'Saudi Arabia',
        label: 'Makkah',
      );

      expect(location.matches('mec'), isTrue);
      expect(location.matches('saudi'), isTrue);
      expect(location.matches('makk'), isTrue);
      expect(location.matches(''), isTrue);
      expect(location.matches('toronto'), isFalse);
    });

    test('encode/decode round-trips', () {
      const location = IbadahLocation(
        city: 'Toronto',
        country: 'Canada',
        label: 'Toronto, ON',
      );

      expect(IbadahLocation.decode(location.encode()), location);
    });

    test('decodes a pre-multi-country cache entry as a Bangladeshi district',
        () {
      expect(
        IbadahLocation.decode('Sylhet'),
        const IbadahLocation(city: 'Sylhet', country: 'Bangladesh'),
      );
    });

    test('decodes null and empty as null', () {
      expect(IbadahLocation.decode(null), isNull);
      expect(IbadahLocation.decode(''), isNull);
    });
  });
}
