import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animated gradient button with shimmer and ripple effects
class AnimatedGradientButton extends StatefulWidget {
  final String text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double? width;
  final bool fullWidth;
  final List<Color>? gradientColors;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final bool enableShimmer;

  const AnimatedGradientButton({
    Key? key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.height = 54.0,
    this.width,
    this.fullWidth = false,
    this.gradientColors,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.textStyle,
    this.enableShimmer = true,
  }) : super(key: key);

  @override
  State<AnimatedGradientButton> createState() =>
      _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<AnimatedGradientButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    if (widget.enableShimmer && widget.onPressed != null) {
      _shimmerController.repeat();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _scaleController.forward();
  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() => _scaleController.reverse();

  @override
  Widget build(BuildContext context) {
    final defaultGradient = [
      const Color(0xFF10B981),
      const Color(0xFF059669),
    ];
    final gradientColors = widget.gradientColors ?? defaultGradient;

    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _shimmerController]),
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: widget.isLoading
              ? widget.height
              : (widget.fullWidth ? double.infinity : widget.width),
          height: widget.height,
          padding: widget.isLoading ? EdgeInsets.zero : widget.padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed != null && !widget.isLoading
                  ? widget.onPressed
                  : null,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Shimmer effect
                  if (widget.enableShimmer && !widget.isLoading)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        child: Transform.translate(
                          offset: Offset(
                            -1.0 +
                                (_shimmerController.value * 2.0) *
                                    (widget.width ?? 200),
                            0,
                          ),
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white.withOpacity(0.3),
                                  Colors.white.withOpacity(0.0),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Content
                  widget.isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              IconTheme(
                                data: const IconThemeData(
                                  color: Colors.white,
                                  size: 20,
                                ),
                                child: widget.icon!,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              widget.text,
                              style: widget.textStyle ??
                                  const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pulse button for CTAs that need attention
class PulseButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double pulseScale;
  final Duration pulseDuration;
  final Color? pulseColor;

  const PulseButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.pulseScale = 1.1,
    this.pulseDuration = const Duration(milliseconds: 1000),
    this.pulseColor,
  }) : super(key: key);

  @override
  State<PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<PulseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.pulseScale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulse effect
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.pulseColor ??
                        Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
          // Main button
          widget.child,
        ],
      ),
    );
  }
}

/// Toggle animated button (for favorites, likes, etc.)
class ToggleAnimatedButton extends StatefulWidget {
  final bool isToggled;
  final ValueChanged<bool> onToggle;
  final Widget? toggledIcon;
  final Widget? untoggledIcon;
  final IconData? icon;
  final double? iconSize;
  final Color? toggledColor;
  final Color? untoggledColor;
  final double size;

  const ToggleAnimatedButton({
    Key? key,
    required this.isToggled,
    required this.onToggle,
    this.toggledIcon,
    this.untoggledIcon,
    this.icon,
    this.iconSize,
    this.toggledColor,
    this.untoggledColor,
    this.size = 32.0,
  }) : assert(
          (toggledIcon != null && untoggledIcon != null) || icon != null,
          'Either provide both toggledIcon and untoggledIcon, or just icon',
        ),
        super(key: key);

  @override
  State<ToggleAnimatedButton> createState() => _ToggleAnimatedButtonState();
}

class _ToggleAnimatedButtonState extends State<ToggleAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isToggled) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ToggleAnimatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isToggled != oldWidget.isToggled) {
      if (widget.isToggled) {
        _controller.forward(from: 0.0);
      } else {
        _controller.reverse(from: 1.0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final toggledColor = widget.toggledColor ?? Colors.red;
    final untoggledColor = widget.untoggledColor ?? Colors.grey[400]!;

    // Determine which icon to show
    Widget getIcon() {
      if (widget.icon != null) {
        // Use the provided icon parameter
        return Icon(
          widget.icon,
          size: widget.iconSize ?? widget.size,
          color: widget.isToggled ? toggledColor : untoggledColor,
        );
      } else {
        // Use the toggledIcon/untoggledIcon widgets
        return IconTheme(
          data: IconThemeData(
            color: widget.isToggled ? toggledColor : untoggledColor,
            size: widget.size,
          ),
          child: widget.isToggled ? widget.toggledIcon! : widget.untoggledIcon!,
        );
      }
    }

    return GestureDetector(
      onTap: () => widget.onToggle(!widget.isToggled),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: Container(
              key: ValueKey(widget.isToggled),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(child: getIcon()),
            ),
          ),
        ),
      ),
    );
  }
}

/// Gradient icon button
class GradientIconButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final double size;
  final List<Color>? gradientColors;
  final bool showRipple;

  const GradientIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.size = 48.0,
    this.gradientColors,
    this.showRipple = true,
  }) : super(key: key);

  @override
  State<GradientIconButton> createState() => _GradientIconButtonState();
}

class _GradientIconButtonState extends State<GradientIconButton>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final gradientColors = widget.gradientColors ?? [
      const Color(0xFF10B981),
      const Color(0xFF059669),
    ];

    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: gradientColors.first.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                customBorder: const CircleBorder(),
                splashColor:
                    widget.showRipple ? Colors.white.withOpacity(0.3) : null,
                highlightColor:
                    widget.showRipple ? Colors.white.withOpacity(0.1) : null,
                child: Center(
                  child: IconTheme(
                    data: IconThemeData(
                      color: Colors.white,
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
    );
  }
}

/// Outlined button with animation
class AnimatedOutlineButton extends StatefulWidget {
  final String text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? textColor;
  final double height;
  final double? width;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const AnimatedOutlineButton({
    Key? key,
    required this.text,
    this.icon,
    this.onPressed,
    this.borderColor,
    this.textColor,
    this.height = 48.0,
    this.width,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  }) : super(key: key);

  @override
  State<AnimatedOutlineButton> createState() => _AnimatedOutlineButtonState();
}

class _AnimatedOutlineButtonState extends State<AnimatedOutlineButton>
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
  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.borderColor ?? Theme.of(context).primaryColor;
    final textColor = widget.textColor ?? Theme.of(context).primaryColor;

    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: widget.padding,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      IconTheme(
                        data: IconThemeData(
                          color: textColor,
                          size: 20,
                        ),
                        child: widget.icon!,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
