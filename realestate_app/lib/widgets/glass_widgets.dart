import 'dart:ui';
import 'package:flutter/material.dart';

/// Base glassmorphic container with blur and opacity effects
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double blurRadius;
  final double opacity;
  final double borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradientBorder;

  const GlassmorphicContainer({
    Key? key,
    required this.child,
    this.blurRadius = 20.0,
    this.opacity = 0.15,
    this.borderRadius = 16.0,
    this.borderColor,
    this.borderWidth = 1.5,
    this.border,
    this.padding,
    this.backgroundColor,
    this.boxShadow,
    this.gradientBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ??
                Border.all(
                  color: borderColor ?? Colors.white.withOpacity(0.3),
                  width: borderWidth,
                ),
            boxShadow: boxShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Glass card with elevation and hover animations
class GlassCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blurRadius;
  final double opacity;
  final VoidCallback? onTap;
  final bool enableHoverEffect;
  final Color? shadowColor;
  final List<BoxShadow>? boxShadow;

  const GlassCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16.0,
    this.blurRadius = 15.0,
    this.opacity = 0.15,
    this.onTap,
    this.enableHoverEffect = true,
    this.shadowColor,
    this.boxShadow,
  }) : super(key: key);

  /// Elevated variant with stronger shadow
  factory GlassCard.elevated({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
  }) {
    return GlassCard(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      onTap: onTap,
      child: child,
    );
  }

  /// Flat variant with minimal shadow
  factory GlassCard.flat({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
  }) {
    return GlassCard(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      onTap: onTap,
      enableHoverEffect: false,
      child: child,
    );
  }

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    if (widget.enableHoverEffect) {
      setState(() => _isHovered = true);
      _controller.forward();
    }
  }

  void _onHoverExit() {
    if (widget.enableHoverEffect) {
      setState(() => _isHovered = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final shadowColor = widget.shadowColor ?? Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => _onHoverEnter(),
        onExit: (_) => _onHoverExit(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              margin: widget.margin,
              child: GlassmorphicContainer(
                blurRadius: widget.blurRadius,
                opacity: widget.opacity,
                borderRadius: widget.borderRadius,
                padding: widget.padding,
                boxShadow: widget.boxShadow ??
                    [
                      BoxShadow(
                        color: _isHovered
                            ? shadowColor.withOpacity(0.15)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: _isHovered ? 16 : 10,
                        offset: Offset(0, _isHovered ? 8 : 4),
                      ),
                    ],
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Transparent app bar with blur effect that intensifies on scroll
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final double scrollProgress; // 0.0 to 1.0
  final Color? backgroundColor;
  final double toolbarHeight;

  const GlassAppBar({
    Key? key,
    this.leading,
    this.title,
    this.actions,
    this.bottom,
    this.elevation = 0,
    this.scrollProgress = 0.0,
    this.backgroundColor,
    this.toolbarHeight = 56.0,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  @override
  Widget build(BuildContext context) {
    final blurAmount = 10.0 + (scrollProgress * 15.0); // 10-25 blur
    final opacity = 0.05 + (scrollProgress * 0.15); // 0.05-0.2 opacity

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: AppBar(
          leading: leading,
          title: title,
          actions: actions,
          bottom: bottom,
          elevation: elevation,
          backgroundColor:
              backgroundColor ?? Colors.white.withOpacity(opacity),
          toolbarHeight: toolbarHeight,
        ),
      ),
    );
  }
}

/// Semi-transparent bottom sheet with blur
class GlassBottomSheet extends StatelessWidget {
  final Widget child;
  final double? height;
  final EdgeInsetsGeometry padding;
  final bool showDragHandle;
  final double borderRadius;

  const GlassBottomSheet({
    Key? key,
    required this.child,
    this.height,
    this.padding = const EdgeInsets.all(24),
    this.showDragHandle = true,
    this.borderRadius = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(borderRadius)),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDragHandle)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }

  /// Show glass bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double? height,
    EdgeInsetsGeometry? padding,
    bool showDragHandle = true,
    double borderRadius = 24.0,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: height != null,
      builder: (context) => GlassBottomSheet(
        height: height,
        padding: padding ?? const EdgeInsets.all(24),
        showDragHandle: showDragHandle,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}

/// Glass modal overlay for dialogs
class GlassModal extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? width;

  const GlassModal({
    Key? key,
    required this.child,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.all(24),
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width ?? MediaQuery.of(context).size.width * 0.85,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: GlassmorphicContainer(
          blurRadius: 20,
          opacity: 0.95,
          borderRadius: borderRadius,
          padding: padding,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
          child: Material(
            color: Colors.transparent,
            child: child,
          ),
        ),
      ),
    );
  }

  /// Show glass modal dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double borderRadius = 20.0,
    EdgeInsetsGeometry? padding,
    double? width,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => GlassModal(
        borderRadius: borderRadius,
        padding: padding ?? const EdgeInsets.all(24),
        width: width,
        child: child,
      ),
    );
  }
}

/// Glass floating action button
class GlassFAB extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const GlassFAB({
    Key? key,
    required this.icon,
    this.onPressed,
    this.size = 56.0,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  State<GlassFAB> createState() => _GlassFABState();
}

class _GlassFABState extends State<GlassFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ??
                        primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: IconTheme(
                      data: IconThemeData(
                        color: widget.iconColor ?? primaryColor,
                        size: widget.size * 0.5,
                      ),
                      child: widget.icon,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
