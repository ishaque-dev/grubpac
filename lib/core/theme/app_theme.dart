import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const bg = Color(0xFF0B0C0E);
  static const card = Color(0xFF151619);
  static const card2 = Color(0xFF1C1E22);
  static const line = Color(0xFF2A2C31);

  static const lime = Color(0xFFD4FF3D); // primary
  static const orange = Color(0xFFFF4D1C); // secondary
  static const limeDim = Color(0x1FD4FF3D);
  static const orangeDim = Color(0x1FFF4D1C);

  static const textPrimary = Color(0xFFF2F1EA);
  static const textMuted = Color(0xFF7A7C85);
  static const textFaint = Color(0xFF4E5057);

  static const success = Color(0xFF3ADB76);
  static const danger = Color(0xFFFF4D6A);
}

class CutCornerBorder extends ShapeBorder {
  final double cut;
  const CutCornerBorder({this.cut = 14});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right, rect.bottom - cut)
      ..lineTo(rect.right - cut, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => CutCornerBorder(cut: cut * t);
}

class AppText {
  AppText._();

  static TextStyle display({double size = 32, Color? color, double? height}) =>
      GoogleFonts.bebasNeue(
        fontSize: size,
        color: color ?? AppColors.textPrimary,
        letterSpacing: 0.5,
        height: height ?? 1.0,
      );

  static TextStyle mono({
    double size = 11,
    Color? color,
    FontWeight weight = FontWeight.w500,
  }) => GoogleFonts.jetBrainsMono(
    fontSize: size,
    color: color ?? AppColors.textMuted,
    letterSpacing: 0.8,
    fontWeight: weight,
  );

  static TextStyle body({
    double size = 14,
    Color? color,
    FontWeight weight = FontWeight.w500,
  }) => GoogleFonts.inter(
    fontSize: size,
    color: color ?? AppColors.textPrimary,
    fontWeight: weight,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.bg,
        primary: AppColors.lime,
        onPrimary: AppColors.bg,
        secondary: AppColors.orange,
        onSecondary: AppColors.textPrimary,
        error: AppColors.danger,
        onError: AppColors.textPrimary,
        outline: AppColors.line,
      ),

      textTheme: TextTheme(
        displayLarge: AppText.display(size: 44, color: AppColors.lime),
        displayMedium: AppText.display(size: 30),
        headlineLarge: AppText.display(size: 26),
        headlineMedium: AppText.display(size: 20),
        bodyLarge: AppText.body(size: 15),
        bodyMedium: AppText.body(size: 13.5),
        bodySmall: AppText.body(
          size: 12,
          color: AppColors.textMuted,
          weight: FontWeight.w400,
        ),
        labelLarge: AppText.mono(size: 12, weight: FontWeight.w700),
        labelMedium: AppText.mono(size: 10.5),
        labelSmall: AppText.mono(size: 9.5),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppText.display(size: 28),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      cardTheme: const CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: CutCornerBorder(cut: 16),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lime,
          foregroundColor: AppColors.bg,
          textStyle: AppText.mono(size: 12, weight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const BeveledRectangleBorder(),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.line),
          textStyle: AppText.mono(size: 12, weight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const BeveledRectangleBorder(),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        hintStyle: AppText.body(size: 13, color: AppColors.textFaint),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.line),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.line),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.lime, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }
}
