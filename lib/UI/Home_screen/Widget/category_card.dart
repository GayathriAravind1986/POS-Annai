import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';

class CategoryCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.label,
    required this.imagePath,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size.width * 0.1,
        height: size.height * 0.15,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? whiteColor : greyColor.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? appPrimaryColor.shade300 : greyColor.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            ClipOval(
                child: CachedNetworkImage(
              imageUrl: imagePath,
              width: 35,
              height: 35,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                return const Icon(
                  Icons.error,
                  size: 30,
                  color: appHomeTextColor,
                );
              },
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  const SpinKitCircle(color: appPrimaryColor, size: 30),
            )),
            SizedBox(height: 6),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: MyTextStyle.f12(blackColor),
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
