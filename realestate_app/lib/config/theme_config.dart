import 'package:flutter/material.dart';

/// Theme configuration constants for consistent styling across the app
class ThemeConfig {
  // Prevent instantiation
  ThemeConfig._();

  // ============================================================================
  // COLORS
  // ============================================================================

  /// Primary Colors
  static const Color primaryGreen = Color(0xFF10B981);
  static const Color primaryDark = Color(0xFF059669);
  static const Color primaryLight = Color(0xFF34D399);

  /// Secondary Colors
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color secondaryOrange = Color(0xFFF59E0B);
  static const Color secondaryPurple = Color(0xFF8B5CF6);

  /// Neutral Colors
  static const Color background = Color(0xFFF8FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  /// Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ============================================================================
  // GLASS EFFECT
  // ============================================================================

  static const double glassOpacity = 0.15;
  static const double glassBlur = 20.0;
  static const double glassBorderOpacity = 0.3;
  static const double glassBorderWidth = 1.5;

  // ============================================================================
  // ANIMATION DURATIONS
  // ============================================================================

  static const Duration instantAnimation = Duration(milliseconds: 100);
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration verySlowAnimation = Duration(milliseconds: 800);

  // ============================================================================
  // ANIMATION CURVES
  // ============================================================================

  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve entranceCurve = Curves.easeOut;
  static const Curve exitCurve = Curves.easeIn;

  // ============================================================================
  // SPACING
  // ============================================================================

  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 12.0;
  static const double spacingLG = 16.0;
  static const double spacingXL = 24.0;
  static const double spacing2XL = 32.0;
  static const double spacing3XL = 40.0;
  static const double spacing4XL = 48.0;
  static const double spacing5XL = 60.0;
  static const double spacing6XL = 80.0;

  // ============================================================================
  // BORDER RADIUS
  // ============================================================================

  static const double radiusXSmall = 4.0;
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radius2XLarge = 24.0;
  static const double radiusCircular = 999.0;

  // ============================================================================
  // TYPOGRAPHY
  // ============================================================================

  /// Heading Styles
  static const TextStyle h1 = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
    letterSpacing: -1.0,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
    letterSpacing: -0.8,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.3,
    letterSpacing: -0.5,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
    letterSpacing: -0.3,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle h6 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  /// Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.6,
  );

  /// Button Styles
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  /// Caption Style
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textTertiary,
    height: 1.4,
  );

  // ============================================================================
  // SHADOWS
  // ============================================================================

  static List<BoxShadow> shadowLevel1({Color? color}) => [
        BoxShadow(
          color: (color ?? Colors.black).withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> shadowLevel2({Color? color}) => [
        BoxShadow(
          color: (color ?? Colors.black).withOpacity(0.06),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> shadowLevel3({Color? color}) => [
        BoxShadow(
          color: (color ?? Colors.black).withOpacity(0.1),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> shadowLevel4({Color? color}) => [
        BoxShadow(
          color: (color ?? Colors.black).withOpacity(0.1),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> shadowLevel5({Color? color}) => [
        BoxShadow(
          color: (color ?? Colors.black).withOpacity(0.15),
          blurRadius: 40,
          offset: const Offset(0, 20),
        ),
      ];

  /// Glass shadow with colored tint
  static List<BoxShadow> glassShadow({required Color color}) => [
        BoxShadow(
          color: color.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];

  // ============================================================================
  // GRADIENTS
  // ============================================================================

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryBlue, secondaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFE0E0E0),
      Color(0xFFF5F5F5),
      Color(0xFFE0E0E0),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ============================================================================
  // BUTTON HEIGHTS
  // ============================================================================

  static const double buttonHeightSmall = 44.0;
  static const double buttonHeightMedium = 52.0;
  static const double buttonHeightLarge = 60.0;

  // ============================================================================
  // ICON SIZES
  // ============================================================================

  static const double iconSizeSmall = 18.0;
  static const double iconSizeMedium = 22.0;
  static const double iconSizeLarge = 26.0;
  static const double iconSizeXLarge = 36.0;

  // ============================================================================
  // APP BAR
  // ============================================================================

  static const double appBarHeight = 56.0;
  static const double appBarElevation = 0.0;

  // ============================================================================
  // CARD
  // ============================================================================

  static const double cardElevation = 2.0;
  static const double cardBorderRadius = radiusMedium;
  static const EdgeInsets cardPadding = EdgeInsets.all(spacingLG);

  // ============================================================================
  // INPUT
  // ============================================================================

  static const double inputHeight = 60.0;
  static const double inputBorderRadius = radiusLarge;
  static const EdgeInsets inputPadding =
      EdgeInsets.symmetric(horizontal: spacingXL, vertical: spacingLG);

  // ============================================================================
  // LAYOUT CONSTRAINTS
  // ============================================================================

  static const double maxContentWidth = 1200.0;
  static const EdgeInsets screenPaddingMobile =
      EdgeInsets.symmetric(horizontal: spacingLG);
  static const EdgeInsets screenPaddingTablet =
      EdgeInsets.symmetric(horizontal: spacingXL);
  static const EdgeInsets screenPaddingDesktop =
      EdgeInsets.symmetric(horizontal: spacing2XL);

  // ============================================================================
  // BREAKPOINTS
  // ============================================================================

  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 900.0;
  static const double breakpointDesktop = 1200.0;

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get responsive padding based on screen width
  static EdgeInsets getScreenPadding(double width) {
    if (width < breakpointMobile) {
      return screenPaddingMobile;
    } else if (width < breakpointTablet) {
      return screenPaddingTablet;
    } else {
      return screenPaddingDesktop;
    }
  }

  /// Check if screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpointMobile;
  }

  /// Check if screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= breakpointMobile && width < breakpointTablet;
  }

  /// Check if screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= breakpointDesktop;
  }

  /// Get grid cross axis count based on screen width
  static int getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < breakpointMobile) {
      return 1; // Mobile: 1 column
    } else if (width < breakpointTablet) {
      return 2; // Tablet: 2 columns
    } else {
      return 3; // Desktop: 3 columns
    }
  }
}
