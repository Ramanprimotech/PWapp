import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.isDescription = false,
    this.onTap,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.showBorder = true,
    this.onChanged,
    this.obscureText = false,
    this.padding,
    this.borderRadius,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.autofocus = false,
    this.borderWidth,
    this.borderColor,
    this.validator,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool isDescription;
  final bool showBorder;
  final bool obscureText;
  final void Function(String)? onChanged;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? autofocus;
  final double? borderWidth;
  final Color? borderColor;
  final String Function(String)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      margin: const EdgeInsets.only(left: 25.0, right: 25.0),
      padding: const EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Color.fromRGBO(255, 255, 255, 0.12)),
      child: TextField(
        autocorrect: false,
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        cursorColor: Colors.white,
        inputFormatters: inputFormatters,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'texgyreadventor-regular'),
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: label,
          hintStyle: const TextStyle(
              color: Colors.white, fontFamily: 'texgyreadventor-regular'),
          suffixIcon: suffixIcon,
        ),
        onTap: onTap,
        keyboardType: keyboardType,
      ),
    );
  }
}
