import 'package:flutter/material.dart';

class PosterCard extends StatelessWidget {
  const PosterCard({
    Key? key,
    required this.mainTitle,
    required this.subTitle,
    required this.onTap,
    required this.imageAsset,
  }) : super(key: key);
  final String mainTitle;
  final String subTitle;
  final VoidCallback? onTap;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            title: Text(
              mainTitle,
              style: const TextStyle(fontSize: 24.0, color: Color(0xff4725a3), fontFamily: 'texgyreadventor-regular'),
            ),
            subtitle: Text(
              subTitle,
              style: const TextStyle(fontSize: 12.0, color: Colors.black, fontFamily: 'texgyreadventor-regular'),
            ),
            trailing: Image.asset(imageAsset)),
      ),
    );
  }
}
