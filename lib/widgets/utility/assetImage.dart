import 'package:flutter/material.dart';

class AssetImages extends StatelessWidget {
  AssetImages(
      {Key? key, required this.imageFromAsset, required this.widgetName})
      : super(key: key);
  ImageProvider<Object> imageFromAsset;
  Widget widgetName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageFromAsset,
              fit: BoxFit.fill,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        SingleChildScrollView(
          child: widgetName,
        ),
      ],
    );
  }
}
