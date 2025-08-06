import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MedEasySearchbar extends StatelessWidget {
  final String hintText;
  final double horizontalPadding;
  final double topPadding;
  final Function(String)? onSearchQueryChanged;
  final Function(String)? onQuerySubmit;
  final Function()? onTap;

  const MedEasySearchbar({
    super.key,
    this.hintText = 'Search medicine',
    this.onSearchQueryChanged,
    this.horizontalPadding = 24,
    this.topPadding = 24,
    this.onQuerySubmit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final node = FocusNode();
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          top: topPadding,
          left: horizontalPadding,
          right: horizontalPadding,
        ),
        child: CupertinoSearchTextField(
          // focusNode: node,
          style: theme.textTheme.bodyMedium,
          itemColor: theme.hintColor,
          prefixInsets: const EdgeInsetsDirectional.fromSTEB(
            16,
            12,
            10,
            12,
          ),
          suffixMode: OverlayVisibilityMode.never,
          placeholder: hintText,
          onChanged: onSearchQueryChanged,
          onSubmitted: onQuerySubmit,
          onTap: onTap,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 16, 12),
        ),
      ),
    );
  }
}
