import 'package:flutter/material.dart';

class PosterCard extends StatelessWidget {
  const PosterCard({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.onTap,
    this.imageAsset = "",
  }) : super(key: key);
  final String title;
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          title: Text(
            title,
            style: const TextStyle(
                fontSize: 24.0,
                color: Color(0xff4725a3),
                fontFamily: 'texgyreadventor-regular'),
          ),
          subtitle: Text(
            subTitle,
            style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontFamily: 'texgyreadventor-regular'),
          ),
          trailing: imageAsset.isEmpty
              ? Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.indigo.shade800),
                  child: Icon(Icons.camera_alt_outlined,
                      color: Colors.blue.shade400, size: 32),
                )
              : Image.asset(imageAsset),
        ),
      ),
    );
  }
}
