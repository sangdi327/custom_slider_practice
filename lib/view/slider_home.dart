import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SliderHome extends StatefulWidget {
  const SliderHome({super.key});

  @override
  State<SliderHome> createState() => _SliderHomeState();
}

class _SliderHomeState extends State<SliderHome> {
  double sliderValue = 0;
  ui.Image? sliderImage;

  @override
  void initState() {
    super.initState();
    load('image/icon_star.png').then((image) {
      setState(() {
        sliderImage = image;
      });
    });
  }

  Future<ui.Image> load(String path) async {
    var data = await rootBundle.load(path);
    final ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slider home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(sliderValue.toStringAsFixed(2)),
            if (sliderImage != null)
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 5,
                  thumbShape: SliderShape(sliderImage!),
                ),
                child: Slider(
                  value: sliderValue,
                  onChanged: (value) {
                    setState(() {
                      sliderValue = value;
                    });
                  },
                  activeColor: Colors.amber,
                  inactiveColor: Colors.grey,
                  min: 0,
                  max: 10,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class SliderShape extends SliderComponentShape {
  final ui.Image image;
  SliderShape(this.image);

  @override
  Size getPreferredSize(Object isEnabled, bool isDiscrete) {
    return const Size(0, 0);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final imageWidth = image.width;
    final imageHeight = image.height;

    Offset imageOffset = Offset(
      center.dx - (imageWidth / 2),
      center.dy - (imageHeight / 2),
    );

    Paint paint = Paint()..filterQuality = FilterQuality.high;
    canvas.drawImage(image, imageOffset, paint);
  }
}
