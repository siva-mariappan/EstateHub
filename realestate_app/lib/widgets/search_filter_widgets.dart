import 'package:flutter/material.dart';
import 'package:realestate_app/config/theme_config.dart';
import 'package:realestate_app/widgets/glass_widgets.dart';
import 'dart:ui';

/// Glassmorphic search bar with expand/collapse animation
class GlassSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onSearch;
  final ValueChanged<String>? onChanged;
  final bool autoFocus;
  final List<String>? recentSearches;

  const GlassSearchBar({
    Key? key,
    this.controller,
    this.hintText = 'Search properties...',
    this.onSearch,
    this.onChanged,
    this.autoFocus = false,
    this.recentSearches,
  }) : super(key: key);

  @override
  State<GlassSearchBar> createState() => _GlassSearchBarState();
}

class _GlassSearchBarState extends State<GlassSearchBar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _animationController = AnimationController(
      duration: ThemeConfig.normalAnimation,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
      if (_focusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) => GlassmorphicContainer(
        blurRadius: 15 + (_expandAnimation.value * 5),
        opacity: 0.15 + (_expandAnimation.value * 0.05),
        borderRadius: ThemeConfig.radiusMedium,
        boxShadow: _isFocused
            ? ThemeConfig.shadowLevel3(color: ThemeConfig.primaryGreen)
            : ThemeConfig.shadowLevel2(),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          onSubmitted: (_) => widget.onSearch?.call(),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: ThemeConfig.bodyMedium.copyWith(
              color: ThemeConfig.textTertiary,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: _isFocused
                  ? ThemeConfig.primaryGreen
                  : ThemeConfig.textSecondary,
            ),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged?.call('');
                    },
                    color: ThemeConfig.textSecondary,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: ThemeConfig.spacingLG,
              vertical: ThemeConfig.spacingLG,
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated filter chip with selection animation
class AnimatedFilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final int? count;

  const AnimatedFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.count,
  }) : super(key: key);

  @override
  State<AnimatedFilterChip> createState() => _AnimatedFilterChipState();
}

class _AnimatedFilterChipState extends State<AnimatedFilterChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: ThemeConfig.fastAnimation,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedFilterChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
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
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: ThemeConfig.fastAnimation,
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConfig.spacingLG,
              vertical: ThemeConfig.spacingMD,
            ),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? ThemeConfig.primaryGreen
                  : ThemeConfig.surface,
              borderRadius: BorderRadius.circular(ThemeConfig.radiusCircular),
              border: Border.all(
                color: widget.isSelected
                    ? ThemeConfig.primaryGreen
                    : ThemeConfig.border,
                width: 1.5,
              ),
              boxShadow: widget.isSelected
                  ? ThemeConfig.shadowLevel2(color: ThemeConfig.primaryGreen)
                  : ThemeConfig.shadowLevel1(),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: ThemeConfig.iconSizeSmall,
                    color: widget.isSelected
                        ? Colors.white
                        : ThemeConfig.textSecondary,
                  ),
                  const SizedBox(width: ThemeConfig.spacingXS),
                ],
                Text(
                  widget.label,
                  style: ThemeConfig.bodyMedium.copyWith(
                    color: widget.isSelected
                        ? Colors.white
                        : ThemeConfig.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.count != null) ...[
                  const SizedBox(width: ThemeConfig.spacingXS),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? Colors.white.withOpacity(0.3)
                          : ThemeConfig.primaryGreen.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(ThemeConfig.radiusCircular),
                    ),
                    child: Text(
                      widget.count.toString(),
                      style: ThemeConfig.caption.copyWith(
                        color: widget.isSelected
                            ? Colors.white
                            : ThemeConfig.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Glass bottom sheet for filters
class FilterBottomSheet extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback? onApply;
  final VoidCallback? onReset;
  final String applyButtonText;
  final String resetButtonText;

  const FilterBottomSheet({
    Key? key,
    required this.title,
    required this.children,
    this.onApply,
    this.onReset,
    this.applyButtonText = 'Apply Filters',
    this.resetButtonText = 'Reset',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: ThemeConfig.h4,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                color: ThemeConfig.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: ThemeConfig.spacingLG),

          // Content
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),

          const SizedBox(height: ThemeConfig.spacingXL),

          // Action buttons
          Row(
            children: [
              if (onReset != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: ThemeConfig.spacingLG,
                      ),
                      side: const BorderSide(
                        color: ThemeConfig.border,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(ThemeConfig.radiusMedium),
                      ),
                    ),
                    child: Text(
                      resetButtonText,
                      style: ThemeConfig.buttonMedium.copyWith(
                        color: ThemeConfig.textSecondary,
                      ),
                    ),
                  ),
                ),
              if (onReset != null) const SizedBox(width: ThemeConfig.spacingMD),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeConfig.primaryGreen,
                    padding: const EdgeInsets.symmetric(
                      vertical: ThemeConfig.spacingLG,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(ThemeConfig.radiusMedium),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    applyButtonText,
                    style:
                        ThemeConfig.buttonMedium.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Show filter bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<Widget> children,
    VoidCallback? onApply,
    VoidCallback? onReset,
    String applyButtonText = 'Apply Filters',
    String resetButtonText = 'Reset',
  }) {
    return GlassBottomSheet.show<T>(
      context: context,
      child: FilterBottomSheet(
        title: title,
        children: children,
        onApply: onApply,
        onReset: onReset,
        applyButtonText: applyButtonText,
        resetButtonText: resetButtonText,
      ),
    );
  }
}

/// Filter section widget
class FilterSection extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isExpanded;
  final VoidCallback? onToggle;

  const FilterSection({
    Key? key,
    required this.title,
    required this.child,
    this.isExpanded = true,
    this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: ThemeConfig.spacingMD),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: ThemeConfig.h6,
                ),
                if (onToggle != null)
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: ThemeConfig.fastAnimation,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: ThemeConfig.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: child,
          secondChild: const SizedBox.shrink(),
          crossFadeState:
              isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: ThemeConfig.fastAnimation,
        ),
        const SizedBox(height: ThemeConfig.spacingLG),
      ],
    );
  }
}

/// Range slider with glass effect
class GlassRangeSlider extends StatelessWidget {
  final RangeValues values;
  final double min;
  final double max;
  final ValueChanged<RangeValues> onChanged;
  final String Function(double)? labelFormatter;

  const GlassRangeSlider({
    Key? key,
    required this.values,
    required this.min,
    required this.max,
    required this.onChanged,
    this.labelFormatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = labelFormatter ?? (value) => value.toStringAsFixed(0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatter(values.start),
              style: ThemeConfig.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: ThemeConfig.primaryGreen,
              ),
            ),
            Text(
              formatter(values.end),
              style: ThemeConfig.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: ThemeConfig.primaryGreen,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: ThemeConfig.primaryGreen,
            inactiveTrackColor: ThemeConfig.border,
            thumbColor: ThemeConfig.primaryGreen,
            overlayColor: ThemeConfig.primaryGreen.withOpacity(0.2),
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 10,
            ),
            rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
          ),
          child: RangeSlider(
            values: values,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
