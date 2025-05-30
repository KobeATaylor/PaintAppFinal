import 'package:flutter/material.dart';
import 'PaintingSubmission.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'LocalGalleryPage.dart';

class CanvasPage extends StatefulWidget
{
  const CanvasPage({super.key});

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class ColoredPoint {
  final Offset point;
  final Color color;

  ColoredPoint(this.point, this.color);
}

class _CanvasPageState extends State<CanvasPage> {
  final GlobalKey _canvasKey = GlobalKey();
  List<ColoredPoint?> _points = [];
  Color _selectedColor = Colors.pink;

  void _undoLastStroke() {
    if (_points.isEmpty) return;
    while (_points.isNotEmpty) {
      final removed = _points.removeLast();
      if (removed == null) break;
    }
    setState(() {});
  }

  Future<void> _saveCanvasToImage() async {
    try {
      RenderRepaintBoundary boundary = _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'canvas_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved to: $filePath')));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaintingSubmission(imageFilename: fileName),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Draw Your Painting")),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            final localPosition = details.localPosition;
            _points.add(ColoredPoint(localPosition, _selectedColor));
          });
        },
        onPanEnd: (_) => _points.add(null),
        child: Stack(
          children: [
            RepaintBoundary(
              key: _canvasKey,
              child: CustomPaint(
                size: Size.infinite,
                painter: _Sketcher(_points),
              ),
            ),
            // Save Image button and go to PaintingSubmission
            Positioned(
              bottom: 40,
              right: 20,
              child: ElevatedButton(
                onPressed: _saveCanvasToImage,
                child: const Text("Save Image"),
              ),
            ),

            // View Saved Gallery button
            Positioned(
              bottom: 160,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LocalGalleryPage()),
                  );
                },
                child: const Text("View Saved"),
              ),
            ),

            // Color selection
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildColorDot(Colors.black),
                    _buildColorDot(Colors.red),
                    _buildColorDot(Colors.green),
                    _buildColorDot(Colors.blue),
                    _buildColorDot(Colors.orange),
                    _buildColorDot(Colors.purple),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _undoLastStroke,
        child: const Icon(Icons.undo),
      ),
    );
  }

  Widget _buildColorDot(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == color ? Colors.white : Colors.grey,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class _Sketcher extends CustomPainter {
  final List<ColoredPoint?> points;

  _Sketcher(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];

      if (p1 != null && p2 != null) {
        final paint = Paint()
          ..color = p1.color
          ..strokeWidth = 9.0
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(p1.point, p2.point, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_Sketcher oldDelegate) => true;
}