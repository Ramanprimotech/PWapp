import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String? label;
  final double? fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final int maxLines;
  final TextAlign textAlign;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final TextDecoration? textDecoration;

  const AppText(
    this.label, {
    Key? key,
    this.fontSize = 16,
    this.color,
    this.fontWeight = FontWeight.w500,
    this.maxLines = 1,
    this.textAlign = TextAlign.left,
    this.padding,
    this.onTap,
    this.textDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: Text(
        label!,
        textAlign: textAlign,
        style: TextStyle(
          color: Colors.white,
          fontWeight: fontWeight,
          fontSize: fontSize!,
          decoration: textDecoration,
          fontFamily: 'texgyreadventor-regular',
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
      ),
    );
  }
}