import 'package:flutter/material.dart';
import 'package:realestate_app/config/theme_config.dart';

/// Animated badge with bounce entrance
class AnimatedBadge extends StatefulWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double size;
  final bool show;

  const AnimatedBadge({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.size = 20.0,
    this.show = true,
  }) : super(key: key);

  @override
  State<AnimatedBadge> createState() => _AnimatedBadgeState();
}

class _AnimatedBadgeState extends State<AnimatedBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    if (widget.show) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show != oldWidget.show) {
      if (widget.show) {
        _controller.forward();
      } else {
        _controller.reverse();
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
    if (!widget.show && _controller.isDismissed) {
      return const SizedBox.shrink();
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.size * 0.4,
          vertical: widget.size * 0.25,
        ),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? ThemeConfig.error,
          shape: BoxShape.circle,
          boxShadow: ThemeConfig.shadowLevel2(
            color: widget.backgroundColor ?? ThemeConfig.error,
          ),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: widget.textColor ?? Colors.white,
            fontSize: widget.size * 0.6,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Section divider with icon
class SectionDivider extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final double thickness;
  final Color? color;

  const SectionDivider({
    Key? key,
    this.icon,
    this.label,
    this.thickness = 1.5,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? ThemeConfig.border;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: thickness,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  dividerColor.withOpacity(0.0),
                  dividerColor,
                ],
              ),
            ),
          ),
        ),
        if (icon != null || label != null) ...[
          const SizedBox(width: 12),
          if (icon != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ThemeConfig.primaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 16,
                color: ThemeConfig.primaryGreen,
              ),
            ),
          if (label != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                label!,
                style: ThemeConfig.caption.copyWith(
                  color: dividerColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Container(
            height: thickness,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  dividerColor,
                  dividerColor.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Empty state widget with illustration
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spacing2XL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeConfig.spacing2XL),
              decoration: BoxDecoration(
                color: ThemeConfig.primaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 80,
                color: ThemeConfig.primaryGreen.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: ThemeConfig.spacingXL),
            Text(
              title,
              style: ThemeConfig.h4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ThemeConfig.spacingMD),
            Text(
              message,
              style: ThemeConfig.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: ThemeConfig.spacingXL),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeConfig.primaryGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConfig.spacing2XL,
                    vertical: ThemeConfig.spacingLG,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(ThemeConfig.radiusMedium),
                  ),
                ),
                child: Text(
                  actionText!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Success animation with checkmark
class SuccessAnimation extends StatefulWidget {
  final double size;
  final Color? color;
  final VoidCallback? onComplete;

  const SuccessAnimation({
    Key? key,
    this.size = 100.0,
    this.color,
    this.onComplete,
  }) : super(key: key);

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _checkAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? ThemeConfig.success;

    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: ThemeConfig.shadowLevel4(color: color),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Expanding circle
                Opacity(
                  opacity: 1.0 - _controller.value,
                  child: Transform.scale(
                    scale: 1.0 + (_controller.value * 0.5),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                // Checkmark
                FadeTransition(
                  opacity: _checkAnimation,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: widget.size * 0.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated info tooltip
class AnimatedInfoTooltip extends StatefulWidget {
  final String message;
  final Widget child;
  final Duration showDuration;

  const AnimatedInfoTooltip({
    Key? key,
    required this.message,
    required this.child,
    this.showDuration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  State<AnimatedInfoTooltip> createState() => _AnimatedInfoTooltipState();
}

class _AnimatedInfoTooltipState extends State<AnimatedInfoTooltip> {
  bool _showTooltip = false;

  void _toggleTooltip() {
    setState(() => _showTooltip = !_showTooltip);
    if (_showTooltip) {
      Future.delayed(widget.showDuration, () {
        if (mounted) {
          setState(() => _showTooltip = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: _toggleTooltip,
          child: widget.child,
        ),
        if (_showTooltip)
          Positioned(
            bottom: -60,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showTooltip ? 1.0 : 0.0,
              duration: ThemeConfig.fastAnimation,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeConfig.textPrimary,
                  borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
                  boxShadow: ThemeConfig.shadowLevel3(),
                ),
                child: Text(
                  widget.message,
                  style: ThemeConfig.caption.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Gradient text widget
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;

  const GradientText({
    Key? key,
    required this.text,
    this.style,
    this.gradient = ThemeConfig.primaryGradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Text(
        text,
        style: (style ?? ThemeConfig.h2).copyWith(color: Colors.white),
      ),
    );
  }
}

/// Pulse indicator (for notifications, live updates)
class PulseIndicator extends StatefulWidget {
  final double size;
  final Color color;

  const PulseIndicator({
    Key? key,
    this.size = 12.0,
    this.color = ThemeConfig.success,
  }) : super(key: key);

  @override
  State<PulseIndicator> createState() => _PulseIndicatorState();
}

class _PulseIndicatorState extends State<PulseIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.8, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 2,
      height: widget.size * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing circle
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          // Static dot
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

/// Status badge widget
class StatusBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const StatusBadge({
    Key? key,
    required this.text,
    required this.backgroundColor,
    this.textColor = Colors.white,
    this.icon,
  }) : super(key: key);

  /// Published status
  factory StatusBadge.published() => const StatusBadge(
        text: 'Published',
        backgroundColor: ThemeConfig.success,
        icon: Icons.check_circle,
      );

  /// Draft status
  factory StatusBadge.draft() => const StatusBadge(
        text: 'Draft',
        backgroundColor: ThemeConfig.textSecondary,
        icon: Icons.edit,
      );

  /// Pending status
  factory StatusBadge.pending() => const StatusBadge(
        text: 'Pending',
        backgroundColor: ThemeConfig.warning,
        icon: Icons.schedule,
      );

  /// Verified badge
  factory StatusBadge.verified() => const StatusBadge(
        text: 'Verified',
        backgroundColor: ThemeConfig.success,
        icon: Icons.verified,
      );

  /// Featured badge
  factory StatusBadge.featured() => const StatusBadge(
        text: 'Featured',
        backgroundColor: ThemeConfig.secondaryOrange,
        icon: Icons.star,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConfig.spacingMD,
        vertical: ThemeConfig.spacingXS,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(ThemeConfig.radiusCircular),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: ThemeConfig.iconSizeSmall,
              color: textColor,
            ),
            const SizedBox(width: ThemeConfig.spacingXS),
          ],
          Text(
            text,
            style: ThemeConfig.caption.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
