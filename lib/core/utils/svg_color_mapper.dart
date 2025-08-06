import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgColorMapper extends ColorMapper {
  final Color? fromColor;
  final Color toColor;

  const SvgColorMapper({
    this.fromColor,
    required this.toColor,
  });

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    return color == fromColor ? toColor : fromColor == null ? toColor : color;
  }
}
