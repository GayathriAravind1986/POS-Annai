import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simple/Reusable/color.dart';

Widget getProductReceiptWidget({
  required String businessName,
  required String tamilTagline,
  required String address,
  required String gst,
  required String phone,
  required List<Map<String, dynamic>> itemsLine,
  required String reportDate,
  required String totalCat,
  required String totalCount,
}) {
  return Container(
    width: 384,
    color: whiteColor,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Text(
                  businessName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(
                    fontSize: 16,
                    color: blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "GST: $gst",
                  style: const TextStyle(
                    fontSize: 16,
                    color: blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Phone: $phone",
                  style: const TextStyle(
                    fontSize: 16,
                    color: blackColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Separator
          Divider(thickness: 4, color: blackColor),

          // Report Title
          const Center(
            child: Text(
              "Products Report (Category-wise)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: blackColor,
              ),
            ),
          ),
          Divider(thickness: 4, color: blackColor),
          const SizedBox(height: 8),
          // Report Details
          _buildThermalLabelRow("Generated Date", reportDate),
          _buildThermalLabelRow("Total Categories", totalCat),
          _buildThermalLabelRow("Total Products", totalCount),
          const SizedBox(height: 8),
          if (itemsLine.isNotEmpty) ...[
            Divider(thickness: 4, color: blackColor),
            ..._buildCategoryWiseItems(itemsLine),
          ],
          const SizedBox(height: 8),
          const Center(
            child: Text(
              "Thank You!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: blackColor,
              ),
            ),
          ),
          const SizedBox(height: 80), // Footer padding
        ],
      ),
    ),
  );
}

Widget _buildThermalItemRow(
    int sno, String name, String code, double price, double parcel, double ac) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.0),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$sno',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: blackColor),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            name,
            style: const TextStyle(fontSize: 14, color: blackColor),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            code,
            style: const TextStyle(fontSize: 14, color: blackColor),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            price.toStringAsFixed(2),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: blackColor),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            parcel.toStringAsFixed(2),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: blackColor),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            ac.toStringAsFixed(2),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: blackColor),
          ),
        ),
      ],
    ),
  );
}

Widget _buildThermalLabelRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: blackColor,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: blackColor,
          ),
        ),
      ],
    ),
  );
}

List<Widget> _buildCategoryWiseItems(List<Map<String, dynamic>> itemsLine) {
  Map<String, List<Map<String, dynamic>>> grouped = {};

  // Group products by categoryName
  for (var item in itemsLine) {
    String catName = item["categoryName"] ?? "";
    grouped.putIfAbsent(catName, () => []);
    grouped[catName]!.add(item);
  }

  List<Widget> widgets = [];

  grouped.forEach((category, products) {
    int sno = 1;
    if (category.isNotEmpty) {
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Center(
          child: Text(
            category,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: blackColor,
            ),
          ),
        ),
      ));
      widgets.add(Divider(thickness: 4, color: blackColor));
    }

    // Table header
    widgets.add(Row(
      children: const [
        Expanded(
          flex: 2,
          child: Text(
            "S.No",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            "Name",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            "Code",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Price",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            "Parcel",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            "AC",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    ));

    widgets.add(Divider(thickness: 4, color: blackColor));

    // Product rows under this category
    for (var item in products) {
      widgets.add(_buildThermalItemRow(
        sno++,
        item['name'],
        item['code'],
        (item['price'] ?? 0).toDouble(),
        (item['parcel'] ?? 0).toDouble(),
        (item['ac'] ?? 0).toDouble(),
      ));
    }

    // Only add separator if category name is not empty
    if (category.isNotEmpty) {
      widgets.add(Divider(thickness: 4, color: blackColor));
    }
  });

  return widgets;
}

Future<Uint8List?> captureMonochromeProducts(GlobalKey key) async {
  try {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // Capture the widget as an image
    ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.rawRgba);

    if (byteData == null) return null;

    Uint8List pixels = byteData.buffer.asUint8List();
    int width = image.width;
    int height = image.height;

    // Convert to monochrome (black and white only)
    List<int> monochromePixels = [];

    for (int i = 0; i < pixels.length; i += 4) {
      int r = pixels[i];
      int g = pixels[i + 1];
      int b = pixels[i + 2];
      int a = pixels[i + 3];

      // Calculate luminance
      double luminance = (0.299 * r + 0.587 * g + 0.114 * b);

      // Convert to black or white based on threshold
      int value = luminance > 128 ? 255 : 0;

      monochromePixels.addAll([value, value, value, a]);
    }

    // Create new image from monochrome pixels
    ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(
        Uint8List.fromList(monochromePixels));

    ui.ImageDescriptor descriptor = ui.ImageDescriptor.raw(
      buffer,
      width: width,
      height: height,
      pixelFormat: ui.PixelFormat.rgba8888,
    );

    ui.Codec codec = await descriptor.instantiateCodec();
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image monochromeImage = frameInfo.image;

    ByteData? finalByteData =
        await monochromeImage.toByteData(format: ui.ImageByteFormat.png);

    return finalByteData?.buffer.asUint8List();
  } catch (e) {
    debugPrint("Error creating monochrome image: $e");
    return null;
  }
}
