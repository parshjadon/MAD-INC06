// In-Class Activity 06 — Drawing with Flutter
// Student: Parsh Jadon
// Date: September 29, 2026

import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const SmileyApp());

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smiley Painter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DrawingPlayground(),
    );
  }
}

enum FaceType {
  classic,
  sleepy,
  surprised,
}

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() =>
      _DrawingPlaygroundState();
}

class _DrawingPlaygroundState
    extends State<DrawingPlayground> {
  double mood = 0.8;
  double eyeRadius = 12;

  FaceType faceType = FaceType.classic;

  Color faceColor = Colors.orange.shade300;

  // Graduate test:
  // true = shouldRepaint always returns true
  // false = painter compares its fields
  bool alwaysRepaint = false;

  final math.Random _random = math.Random();

  Color _colorForMood(double value) {
    if (value < 0.35) {
      return Colors.lightBlue.shade300;
    } else if (value <= 0.70) {
      return Colors.yellow.shade600;
    } else {
      return Colors.orange.shade300;
    }
  }

  void _updateMood(double value) {
    setState(() {
      mood = value;
      faceColor = _colorForMood(value);
    });
  }

  void _cycleFace() {
    final values = FaceType.values;

    final nextIndex =
        (values.indexOf(faceType) + 1) % values.length;

    setState(() {
      faceType = values[nextIndex];
    });

    _showMessage(
      'Face changed to ${faceType.name}.',
    );
  }

  void _randomizeFace() {
    final newMood = _random.nextDouble();

    final colors = <Color>[
      Colors.pink.shade300,
      Colors.orange.shade300,
      Colors.amber.shade400,
      Colors.lightBlue.shade300,
      Colors.lightGreen.shade300,
      Colors.purple.shade200,
    ];

    setState(() {
      mood = newMood;

      faceColor =
          colors[_random.nextInt(colors.length)];

      faceType = FaceType.values[
          _random.nextInt(FaceType.values.length)];
    });

    _showMessage(
      'Randomized mood, color, and face (${faceType.name}).',
    );
  }

  void _showMessage(String message) {
    final messenger =
        ScaffoldMessenger.of(context);

    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('CustomPainter Smiley Lab'),
        centerTitle: true,
      ),

      // Entire page is now scrollable.
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape =
                MediaQuery.of(context).orientation ==
                    Orientation.landscape;

            // Smaller face in landscape.
            final side = isLandscape
                ? constraints.maxHeight * 0.55
                : constraints.maxWidth * 0.75;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _cycleFace,
                      onLongPress:
                          _randomizeFace,

                      child: CustomPaint(
                        size: Size(side, side),

                        painter:
                            SmileyPainter(
                          mood: mood,
                          faceColor:
                              faceColor,
                          eyeRadius:
                              eyeRadius,
                          faceType:
                              faceType,
                          alwaysRepaint:
                              alwaysRepaint,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Mood: ${mood.toStringAsFixed(2)}',
                    textAlign:
                        TextAlign.center,
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  Slider(
                    value: mood,
                    min: 0,
                    max: 1,
                    divisions: 100,
                    label:
                        mood.toStringAsFixed(2),
                    onChanged:
                        _updateMood,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Eye size: ${eyeRadius.toStringAsFixed(0)}',
                    textAlign:
                        TextAlign.center,
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  Slider(
                    value: eyeRadius,
                    min: 7,
                    max: 20,
                    divisions: 13,
                    label:
                        eyeRadius.toStringAsFixed(0),

                    onChanged: (value) {
                      setState(() {
                        eyeRadius = value;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<
                      FaceType>(
                    value: faceType,

                    decoration:
                        const InputDecoration(
                      labelText: 'Face style',
                      border:
                          OutlineInputBorder(),
                    ),

                    items: FaceType.values
                        .map(
                          (type) =>
                              DropdownMenuItem(
                            value: type,
                            child: Text(
                              type.name,
                            ),
                          ),
                        )
                        .toList(),

                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        faceType = value;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  SwitchListTile(
                    contentPadding:
                        EdgeInsets.zero,

                    title: const Text(
                      'Graduate repaint test',
                    ),

                    subtitle: Text(
                      alwaysRepaint
                          ? 'shouldRepaint: always true'
                          : 'shouldRepaint: compare painter fields',
                    ),

                    value: alwaysRepaint,

                    onChanged: (value) {
                      setState(() {
                        alwaysRepaint =
                            value;
                      });
                    },
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Tap the face to cycle styles.\n'
                    'Long-press to randomize.',
                    textAlign:
                        TextAlign.center,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  SmileyPainter({
    required this.mood,
    required this.faceColor,
    required this.eyeRadius,
    required this.faceType,
    required this.alwaysRepaint,
  });

  final double mood;
  final Color faceColor;
  final double eyeRadius;
  final FaceType faceType;
  final bool alwaysRepaint;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        size.shortestSide * 0.40;

    // -----------------------------
    // FACE
    // -----------------------------

    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      radius,
      facePaint,
    );

    // Face border
    final borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          math.max(3, radius * 0.035);

    canvas.drawCircle(
      center,
      radius,
      borderPaint,
    );

    // Reusable paints
    final darkFill = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final darkStroke = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          math.max(4, radius * 0.045)
      ..strokeCap = StrokeCap.round;

    final eyeY =
        center.dy - radius * 0.22;

    final eyeDx =
        radius * 0.35;

    final scaledEyeRadius =
        eyeRadius *
            (radius / 120.0)
                .clamp(0.65, 1.35);

    // -----------------------------
    // EYES
    // -----------------------------

    switch (faceType) {
      case FaceType.classic:
        canvas.drawCircle(
          Offset(
            center.dx - eyeDx,
            eyeY,
          ),
          scaledEyeRadius,
          darkFill,
        );

        canvas.drawCircle(
          Offset(
            center.dx + eyeDx,
            eyeY,
          ),
          scaledEyeRadius,
          darkFill,
        );

        break;

      case FaceType.sleepy:
        final eyeWidth =
            radius * 0.22;

        canvas.drawLine(
          Offset(
            center.dx -
                eyeDx -
                eyeWidth / 2,
            eyeY,
          ),
          Offset(
            center.dx -
                eyeDx +
                eyeWidth / 2,
            eyeY,
          ),
          darkStroke,
        );

        canvas.drawLine(
          Offset(
            center.dx +
                eyeDx -
                eyeWidth / 2,
            eyeY,
          ),
          Offset(
            center.dx +
                eyeDx +
                eyeWidth / 2,
            eyeY,
          ),
          darkStroke,
        );

        break;

      case FaceType.surprised:
        final bigEye =
            scaledEyeRadius * 1.35;

        canvas.drawCircle(
          Offset(
            center.dx - eyeDx,
            eyeY,
          ),
          bigEye,
          darkFill,
        );

        canvas.drawCircle(
          Offset(
            center.dx + eyeDx,
            eyeY,
          ),
          bigEye,
          darkFill,
        );

        break;
    }

    // -----------------------------
    // MOUTH
    // -----------------------------

    if (faceType ==
        FaceType.surprised) {
      final mouthPaint = Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.fill;

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(
            center.dx,
            center.dy +
                radius * 0.28,
          ),
          width:
              radius * 0.38,
          height:
              radius * 0.52,
        ),
        mouthPaint,
      );

      return;
    }

    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          math.max(4, radius * 0.05)
      ..strokeCap =
          StrokeCap.round;

    // -----------------------------
    // SLEEPY FACE
    // -----------------------------

    if (faceType ==
        FaceType.sleepy) {
      final mouthRect =
          Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy +
              radius * 0.28,
        ),
        width:
            radius * 0.55,
        height:
            radius * 0.22,
      );

      canvas.drawArc(
        mouthRect,
        0.15 * math.pi,
        0.70 * math.pi,
        false,
        mouthPaint,
      );

      return;
    }

    // -----------------------------
    // CLASSIC FACE
    // -----------------------------

    // Sad
    if (mood < 0.35) {
      final frownRect =
          Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy +
              radius * 0.38,
        ),
        width:
            radius * 1.0,
        height:
            radius * 0.55,
      );

      canvas.drawArc(
        frownRect,
        1.15 * math.pi,
        0.70 * math.pi,
        false,
        mouthPaint,
      );
    }

    // Neutral / Happy
    else {
      final smileHeight =
          radius *
              (0.30 +
                  mood * 0.55);

      final mouthRect =
          Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy +
              radius * 0.12,
        ),
        width:
            radius * 1.0,
        height:
            smileHeight,
      );

      canvas.drawArc(
        mouthRect,
        0.15 * math.pi,
        0.70 * math.pi,
        false,
        mouthPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant SmileyPainter
        oldDelegate,
  ) {
    // Graduate test mode
    if (alwaysRepaint) {
      return true;
    }

    // Recommended version:
    // repaint only when painter inputs change.
    return oldDelegate.mood != mood ||
        oldDelegate.faceColor !=
            faceColor ||
        oldDelegate.eyeRadius !=
            eyeRadius ||
        oldDelegate.faceType !=
            faceType ||
        oldDelegate.alwaysRepaint !=
            alwaysRepaint;
  }
}