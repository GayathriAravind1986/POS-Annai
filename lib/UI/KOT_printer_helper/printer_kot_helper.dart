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
    width: 350, // Standard thermal printer width (58mm)
    color: whiteColor,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Business Header
          Center(
            child: Column(
              children: [
                // Business symbol/icon
                Text(
                  businessName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                // Text(
                //   "Order#: $orderNumber",
                //   style: const TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold,
                //     color: blackColor,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                // Text(
                //   "Phone: $phone",
                //   style: const TextStyle(
                //     fontSize: 18,
                //     color: blackColor,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Dashed separator
          _buildDashedLine(),

          // KOT Receipt Title
          const Center(
            child: Text(
              "KOT RECEIPT",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
          ),

          _buildDashedLine(),

          // Order Info Section

          _buildKOTInfoRow("Date:", date),
          _buildKOTInfoRow("Order#:", orderNumber),
          _buildKOTInfoRow("Type:", orderType),
          if (orderType == 'LINE' || orderType == 'AC')
            _buildKOTInfoRow("Table:", tableName),
          // if (orderType == 'LINE' || orderType == 'AC')
          //   _buildKOTInfoRow("Waiter:", waiterName),
          // _buildKOTInfoRow("Status:", status),

          const SizedBox(height: 8),
          Container(
            height: 1,
            color: blackColor,
            margin: const EdgeInsets.symmetric(vertical: 4),
          ),
          // Items header with proper spacing
          Row(
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  "Item",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: blackColor,
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: Text(
                  "Qty",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          // Line under header
          Container(
            height: 1,
            color: blackColor,
            margin: const EdgeInsets.symmetric(vertical: 4),
          ),

          // Items list
          ...items.map((item) => _buildKOTItemRow(
                item['name'] ?? '',
                item['qty'] ?? 0,
              )),

          // Separator before total
          _buildDashedLine(),

          // // Total section
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const Text(
          //       "TOTAL",
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         fontSize: 16,
          //         color: blackColor,
          //       ),
          //     ),
          //     Text(
          //       total.toStringAsFixed(2),
          //       style: const TextStyle(
          //         fontWeight: FontWeight.bold,
          //         fontSize: 16,
          //         color: blackColor,
          //       ),
          //     ),
          //   ],
          // ),
          //
          // _buildDashedLine(),

          const SizedBox(height: 8),

          // Footer
          const Center(
            child: Text(
              "Thank You! Visit Again",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: blackColor,
              ),
            ),
          ),

          // const SizedBox(height: 8),

          // Powered by section
          // const Center(
          //   child: Column(
          //     children: [
          //       Text(
          //         "Powered By",
          //         style: TextStyle(
          //           fontSize: 12,
          //           color: blackColor,
          //         ),
          //       ),
          //       Text(
          //         "www.sentinixtechsolutions.com",
          //         style: TextStyle(
          //           fontSize: 12,
          //           color: blackColor,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // Extra space for thermal printer cutting
          const SizedBox(height: 40),
        ],
      ),
    ),
  );
}

Widget _buildKOTInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.0),
    child: Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 22,
              color: blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              color: blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildKOTItemRow(String name, int qty) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              color: blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '$qty',
            style: const TextStyle(
              fontSize: 22,
              color: blackColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

Widget _buildDashedLine() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: List.generate(
        48, // Number of dashes to fill width
        (index) => Expanded(
          child: Container(
            height: 1,
            color: index % 2 == 0 ? blackColor : Colors.transparent,
          ),
        ),
      ),
    ),
  );
}

Future<Uint8List?> captureMonochromeKOTReceipt(GlobalKey key) async {
  try {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // Capture with higher resolution for thermal printers
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.rawRgba);

    if (byteData == null) return null;

    Uint8List pixels = byteData.buffer.asUint8List();
    int width = image.width;
    int height = image.height;

    // Convert to monochrome with better dithering
    List<int> monochromePixels = [];

    for (int i = 0; i < pixels.length; i += 4) {
      int r = pixels[i];
      int g = pixels[i + 1];
      int b = pixels[i + 2];
      int a = pixels[i + 3];

      // Calculate luminance using standard formula
      double luminance = (0.299 * r + 0.587 * g + 0.114 * b);

      // Use threshold for sharp black/white conversion
      int value =
          luminance > 200 ? 255 : 0; // Higher threshold for cleaner print

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
