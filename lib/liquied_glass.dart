import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlassCard extends StatelessWidget {
  final double borderRadius;
  final double padding;
  final Widget child;
  final double lightAngle;
  final double noLightRange;
  final double degreeRange;
  final double borderWith;
  final Color backgroundColor;
  final bool isFullyTransparent;

  const LiquidGlassCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = 0,
    this.lightAngle = 0.68,
    this.noLightRange = 0.3,
    this.degreeRange = 0.08,
    this.borderWith = 3,
    this.backgroundColor = const Color.fromRGBO(0, 0, 0, 0.2),
    this.isFullyTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: isFullyTransparent
          ? CustomPaint(
              painter: _LiquidGlassBorderPainter(
                borderRadius: borderRadius,
                colorScheme: colorScheme,
                lightAngle: lightAngle,
                noLightRange: noLightRange,
                degreeRange: degreeRange,
                borderWith: borderWith,
                backgroundColor: backgroundColor,
              ),
              child: Padding(padding: EdgeInsets.all(padding), child: child),
            )
          : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: CustomPaint(
                painter: _LiquidGlassBorderPainter(
                  borderRadius: borderRadius,
                  colorScheme: colorScheme,
                  lightAngle: lightAngle,
                  noLightRange: noLightRange,
                  degreeRange: degreeRange,
                  borderWith: borderWith,
                  backgroundColor: backgroundColor,
                ),
                child: Padding(padding: EdgeInsets.all(padding), child: child),
              ),
            ),
    );
  }
}

class _LiquidGlassBorderPainter extends CustomPainter {
  final double borderRadius;
  final ColorScheme colorScheme;
  final double lightAngle;
  final double noLightRange;
  final double degreeRange;
  final double borderWith;
  final Color backgroundColor;

  _LiquidGlassBorderPainter({
    required this.borderRadius,
    required this.colorScheme,
    required this.lightAngle,
    required this.noLightRange,
    required this.degreeRange,
    required this.borderWith,
    required this.backgroundColor,
  });

  Offset normalize(Offset vector) {
    final magnitude = sqrt(vector.dx * vector.dx + vector.dy * vector.dy);
    return magnitude != 0
        ? Offset(vector.dx / magnitude, vector.dy / magnitude)
        : Offset.zero;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final backgroundPaint = Paint()
      ..color = backgroundColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),
      backgroundPaint,
    );

    final lightVector = normalize(Offset(cos(lightAngle), sin(lightAngle)));

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWith;

    final adjustedNoLightRange = noLightRange.clamp(0.0, 1.0);
    final lightRange = 0.5 - (adjustedNoLightRange * degreeRange);

    final gradient = LinearGradient(
      begin: Alignment(-lightVector.dx, -lightVector.dy),
      end: Alignment(lightVector.dx, lightVector.dy),
      colors: [
        Colors.white.withValues(alpha: 0.3),
        Colors.white.withValues(alpha: 0.25),
        Colors.white.withValues(alpha: 0.15),
        Colors.white.withValues(alpha: 0.05),
        Colors.transparent,
        Colors.white.withValues(alpha: 0.05),
        Colors.white.withValues(alpha: 0.15),
        Colors.white.withValues(alpha: 0.25),
        Colors.white.withValues(alpha: 0.3),
      ],
      stops: [
        0.0,
        lightRange - 0.04,
        lightRange - 0.03,
        lightRange - 0.02,
        lightRange,
        1.0 - lightRange,
        1.0 - (lightRange - 0.02),
        1.0 - (lightRange - 0.03),
        1.0 - (lightRange - 0.04),
      ],
    );

    borderPaint.shader = gradient.createShader(rect);

    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _LiquidGlassBorderPainter oldDelegate) {
    return oldDelegate.lightAngle != lightAngle ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.colorScheme != colorScheme ||
        oldDelegate.noLightRange != noLightRange;
  }
}
