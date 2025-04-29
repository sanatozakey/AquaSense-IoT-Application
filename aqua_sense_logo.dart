import 'package:flutter/material.dart';
import 'dart:math' as math;

class AquaSenseLogo extends StatefulWidget {
  const AquaSenseLogo({super.key});

  @override
  AquaSenseLogoState createState() => AquaSenseLogoState();
}

class AquaSenseLogoState extends State<AquaSenseLogo> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _waveAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(120, 120),
          painter: AquaSenseLogoPainter(
            waveProgress: _waveAnimation.value,
            rotateProgress: _rotateAnimation.value,
          ),
          child: Container(
            width: 120,
            height: 120,
            alignment: Alignment.center,
            child: const Text(
              'AquaSense',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black87,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AquaSenseLogoPainter extends CustomPainter {
  final double waveProgress;
  final double rotateProgress;

  AquaSenseLogoPainter({
    required this.waveProgress,
    required this.rotateProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final innerRadius = radius - 6;

    // Draw white background
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, bgPaint);

    // Draw dark blue ocean waves with longer wavelengths
    final wavePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.blue[800]!.withValues(alpha: 0.9),
          Colors.blue[900]!,
          Colors.blue[700]!.withValues(alpha: 0.85),
          Colors.white.withValues(alpha: 0.7),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 4; i++) {
      final path = Path();
      final waveHeight = 12.0 + i * 3.0;
      final waveSpeed = 1.2 + i * 0.3;
      for (double x = 0; x <= size.width; x += 1) {
        final y = center.dy +
            math.sin((x / size.width * math.pi) + waveProgress * waveSpeed + i) *
                waveHeight +
            math.cos((x / size.width * math.pi / 2) + waveProgress * 0.7) * 4;
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      final clipPath = Path()
        ..addOval(Rect.fromCircle(center: center, radius: innerRadius));
      canvas.save();
      canvas.clipPath(clipPath);
      canvas.drawPath(path, wavePaint);
      canvas.restore();
    }

    // Draw rotating circle outline with gap
    final outlinePaint = Paint()
      ..color = Colors.blue[600]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    final arcRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      arcRect,
      rotateProgress,
      2 * math.pi * 0.85,
      false,
      outlinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}