import 'package:flutter/material.dart';
import 'package:flutter_ibadah/src/presentation/widgets/med_easy_searchbar.dart';

import '../core/ibadah_location.dart';
import '../core/ibadah_theme.dart';

class LocationSelectionBottomSheet extends StatefulWidget {
  final Function(IbadahLocation)? onSelect;
  final IbadahTheme ibadahTheme;
  final String searchHintText;
  final List<IbadahLocation> locations;

  const LocationSelectionBottomSheet({
    super.key,
    this.onSelect,
    required this.ibadahTheme,
    required this.searchHintText,
    required this.locations,
  });

  @override
  State<LocationSelectionBottomSheet> createState() =>
      _LocationSelectionBottomSheetState();
}

class _LocationSelectionBottomSheetState
    extends State<LocationSelectionBottomSheet> {
  late final ValueNotifier<List<IbadahLocation>> locationList =
      ValueNotifier(widget.locations);

  /// Whether more than one country is on offer.
  ///
  /// With a single-country list — the default 64 Bangladeshi districts — the
  /// country is noise on every row, so it is only shown when it disambiguates.
  late final bool _showCountry =
      widget.locations.map((e) => e.country).toSet().length > 1;

  @override
  void dispose() {
    locationList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MedEasySearchbar(
            ibadahTheme: widget.ibadahTheme,
            hintText: widget.searchHintText,
            horizontalPadding: 16,
            topPadding: 8,
            onSearchQueryChanged: (query) {
              locationList.value =
                  widget.locations.where((e) => e.matches(query)).toList();
            },
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * .25,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ValueListenableBuilder(
                valueListenable: locationList,
                builder: (_, list, __) {
                  return ListView.separated(
                    itemCount: list.length,
                    itemBuilder: (_, int index) {
                      final location = list[index];
                      return ListTile(
                        title: Text(location.displayName),
                        subtitle: _showCountry ? Text(location.country) : null,
                        titleAlignment: ListTileTitleAlignment.center,
                        onTap: () => widget.onSelect?.call(location),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
