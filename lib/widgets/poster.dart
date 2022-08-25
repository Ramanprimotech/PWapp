import 'package:flutter/material.dart';

class PosterCard extends StatelessWidget {
  const PosterCard(
      {Key? key,
      required this.mainTitle,
      required this.subTitle,
      required this.onTap,
      required this.imageAsset})
      : super(key: key);
  final String mainTitle;
  final String subTitle;
  final VoidCallback? onTap;
  final Widget imageAsset;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    '$mainTitle',
                    style: const TextStyle(
                        fontSize: 30.0,
                        color: Color(0xff4725a3),
                        fontFamily: 'texgyreadventor-regular'),
                  ),
                  Text(
                    "$subTitle",
                    style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontFamily: 'texgyreadventor-regular'),
                  )
                ],
              ),
              const SizedBox(
                width: 15.0,
              ),
              imageAsset
            ],
          ),
        ));
  }
}
