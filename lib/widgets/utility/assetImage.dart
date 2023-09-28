import 'package:flutter/material.dart';

class BGImageWithChild extends StatelessWidget {
  const BGImageWithChild({Key? key, this.imgUrl, this.child}) : super(key: key);
  final String? imgUrl;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
        image: AssetImage("Assets/${imgUrl ?? "loginBg.png"}"),
      )),
      child: child,
    );
  }
}
