import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac/core/theme/app_theme.dart';

class CutCornerContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final BorderSide side;
  final double cut;
  final EdgeInsetsGeometry padding;
  CutCornerContainer({
    required this.child,
    super.key,
    this.color = AppColors.card,
    this.side = BorderSide.none,
    double? cut,
    EdgeInsetsGeometry? padding,
  }) : cut = cut ?? 16.r,
       padding = padding ?? EdgeInsets.all(16.w);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CutCornerPainter(cut: cut, side: side),
      child: ClipPath(
        clipper: _CutCornerClipper(cut: cut),
        child: Container(padding: padding, color: color, child: child),
      ),
    );
  }
}

class _CutCornerPainter extends CustomPainter {
  final double cut;
  final BorderSide side;
  _CutCornerPainter({required this.cut, required this.side});

  @override
  void paint(Canvas canvas, Size size) {
    if (side.style == BorderStyle.none) return;
    final path = _cutCornerPath(Offset.zero & size, cut);
    final paint = Paint()
      ..color = side.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = side.width;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CutCornerPainter oldDelegate) =>
      oldDelegate.cut != cut || oldDelegate.side != side;
}

Path _cutCornerPath(Rect rect, double cut) {
  return Path()
    ..moveTo(rect.left, rect.top)
    ..lineTo(rect.right, rect.top)
    ..lineTo(rect.right, rect.bottom - cut)
    ..lineTo(rect.right - cut, rect.bottom)
    ..lineTo(rect.left, rect.bottom)
    ..close();
}

class _CutCornerClipper extends CustomClipper<Path> {
  const _CutCornerClipper({required this.cut});

  final double cut;

  @override
  Path getClip(Size size) => _cutCornerPath(Offset.zero & size, cut);

  @override
  bool shouldReclip(_CutCornerClipper oldClipper) => oldClipper.cut != cut;
}
