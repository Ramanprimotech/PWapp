import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  const CustomBtn({Key? key, required this.btnLable, required this.onPressed})
      : super(key: key);

  final String btnLable;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          primary: const Color(0xffc22ea1),
        ),
        onPressed: onPressed,
        child: Text(
          "$btnLable",
          style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontFamily: 'texgyreadventor-regular'),
        ));
  }
}
