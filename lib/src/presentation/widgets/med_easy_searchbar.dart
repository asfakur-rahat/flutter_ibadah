import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/ibadah_theme.dart';

class MedEasySearchbar extends StatelessWidget {
  final String hintText;
  final double horizontalPadding;
  final double topPadding;
  final Function(String)? onSearchQueryChanged;
  final Function(String)? onQuerySubmit;
  final Function()? onTap;
  final IbadahTheme ibadahTheme;

  const MedEasySearchbar({
    required this.ibadahTheme,
    super.key,
    this.hintText = 'Search district',
    this.onSearchQueryChanged,
    this.horizontalPadding = 24,
    this.topPadding = 24,
    this.onQuerySubmit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          top: topPadding,
          left: horizontalPadding,
          right: horizontalPadding,
        ),
        child: CupertinoSearchTextField(
          style: theme.textTheme.bodyMedium,
          itemColor: ibadahTheme.foregroundOnBackground,
          prefixInsets: const EdgeInsetsDirectional.fromSTEB(
            16,
            12,
            10,
            12,
          ),
          suffixMode: OverlayVisibilityMode.never,
          prefixIcon: Icon(Icons.search_rounded),
          placeholder: hintText,
          onChanged: onSearchQueryChanged,
          onSubmitted: onQuerySubmit,
          onTap: onTap,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ibadahTheme.border),
          ),
          padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 16, 12),
        ),
      ),
    );
  }
}
