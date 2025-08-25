import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:simple/Reusable/color.dart';

Widget getThermalReceiptKOTWidget({
  required String businessName,
  required String tamilTagline,
  required String address,
  required String gst,
  required String phone,
  required List<Map<String, dynamic>> items,
  required double subtotal,
  required double tax,
  required double total,
  required String orderNumber,
  required String tableName,
  required String waiterName,
  required String orderType,
  required String paidBy,
  required String date,
  required String status,
}) {
  return Container(
    width: 384, // Standard thermal printer width
    color: whiteColor, // Ensure white background
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header section
          Center(
            child: Column(
              children: [
                Text(
                  businessName,
                  style: const TextStyle(
                    fontSize: 24, // Increased from 18
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(
                    fontSize: 18, // Increased from 12
                    color: blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (gst != "N/A")
                  Text(
                    "GST: $gst",
                    style: const TextStyle(
                      fontSize: 18, // Increased from 12
                      color: blackColor,
                    ),
                  ),
                Text(
                  "Phone: $phone",
                  style: const TextStyle(
                    fontSize: 18, // Increased from 12
                    color: blackColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Separator line
          Container(
            height: 4,
            color: blackColor,
            margin: const EdgeInsets.symmetric(vertical: 4),
          ),

          // Order details
          _buildThermalLabelRow("Order#: ", orderNumber),
          _buildThermalLabelRow("Date: ", date),
          _buildThermalLabelRow("Type: ", orderType),
          _buildThermalLabelRow("Status: ", status),
          if (orderType == 'LINE' || orderType == 'AC')
            _buildThermalLabelRow("Table: ",
                orderType == 'LINE' || orderType == 'AC' ? tableName : "N/A"),
          if (orderType == 'LINE' || orderType == 'AC')
            _buildThermalLabelRow("Waiter: ",
                orderType == 'LINE' || orderType == 'AC' ? waiterName : "N/A"),
          Container(
            height: 4,
            color: blackColor,
            margin: const EdgeInsets.symmetric(vertical: 4),
          ),

          // Items header
          _buildThermalHeaderRow(),

          // Separator line
          Container(
            height: 4,
            color: blackColor,
            margin: const EdgeInsets.symmetric(vertical: 2),
          ),

          // Items
          ...items.map((item) => Column(
                children: [
                  _buildThermalItemRow(item['name'], item['qty']),
                  const SizedBox(height: 5),
                ],
              )),

          // Separator line
          Container(
            height: 4,
            color: blackColor,
            margin: const EdgeInsets.symmetric(vertical: 4),
          ),
          Text(
            "Paid via: $paidBy",
            style: const TextStyle(
              fontSize: 18, // Increased from 12
              color: blackColor,
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              "Thank You, Visit Again!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20, // Increased from 12
                color: blackColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              "Powered By",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14, // Keep smaller for footer
                color: blackColor,
              ),
            ),
          ),
          const Center(
            child: Text(
              "www.sentinixtechsolutions.com",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: blackColor,
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    ),
  );
}

Widget _buildThermalLabelRow(String label, String value) {
  final bool isOrderRow = label.trim().toLowerCase().contains("order#");

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isOrderRow ? FontWeight.bold : FontWeight.w500,
            fontSize: isOrderRow ? 20 : 18,
            color: blackColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isOrderRow ? FontWeight.bold : FontWeight.normal,
            fontSize: isOrderRow ? 20 : 18,
            color: blackColor,
          ),
        ),
      ],
    ),
  );
}

Widget _buildThermalHeaderRow() {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        flex: 4,
        child: Text(
          "Item",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: blackColor), // Increased from 12
          textAlign: TextAlign.left,
        ),
      ),
      Expanded(
        flex: 2,
        child: Text(
          "Qty",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: blackColor), // Increased from 12
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}

Widget _buildThermalItemRow(String name, int qty) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            name,
            style: const TextStyle(
                fontSize: 18, color: blackColor), // Increased from 12
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            '$qty',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 18, color: blackColor), // Increased from 12
          ),
        ),
      ],
    ),
  );
}

Future<Uint8List?> captureMonochromeKOTReceipt(GlobalKey key) async {
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
