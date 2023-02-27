import 'package:flutter/material.dart';
import 'package:pwlp/widgets/AppText.dart';

class CustomBtn extends StatelessWidget {
  const CustomBtn(
      {Key? key, required this.btnLable, required this.onPressed, this.margin})
      : super(key: key);

  final String btnLable;
  final VoidCallback? onPressed;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          backgroundColor: const Color(0xffc22ea1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onPressed: onPressed,
        child: AppText(btnLable, fontSize: 20),
      ),
    );
  }
}
