import 'package:flutter/material.dart';

Future CommonShowDialog(context, {Widget? child, contentPadding}){
  return showDialog(
      barrierColor: Colors.black87,
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6),
          backgroundColor: Colors.white24,
          content: Container(
            padding: contentPadding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white),
            height: 240,
            child: child ?? const SizedBox(),
          ),
        );
      });
}
