import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/image.dart';
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

  bool _isNetworkImage(String path) {
    return path.startsWith("http") || path.startsWith("https");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final String fallbackAsset = Images.all;

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
              child: (imagePath.isEmpty)
                  ? Image.asset(
                      fallbackAsset,
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    )
                  : _isNetworkImage(imagePath)
                      ? CachedNetworkImage(
                          imageUrl: imagePath,
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Image.asset(
                            fallbackAsset,
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  const SpinKitCircle(
                            color: appPrimaryColor,
                            size: 30,
                          ),
                        )
                      : Image.asset(
                          imagePath,
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                        ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: MyTextStyle.f14(blackColor),
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
