import 'package:flutter/material.dart';
import 'dart:ui';
import '../config/theme_config.dart';

/// Custom search bar widget with glass morphism effect
class CustomSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onSearch;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool autoFocus;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final double? borderRadius;
  final EdgeInsets? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final bool showClearButton;

  const CustomSearchBar({
    Key? key,
    this.controller,
    this.hintText = 'Search...',
    this.onSearch,
    this.onChanged,
    this.enabled = true,
    this.autoFocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.borderRadius,
    this.contentPadding,
    this.hintStyle,
    this.textStyle,
    this.showClearButton = true,
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    _animationController = AnimationController(
      duration: ThemeConfig.normalAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
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

    _controller.addListener(() {
      setState(() {}); // Rebuild to show/hide clear button
    });
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

  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
    _focusNode.requestFocus();
  }

  void _handleSearch() {
    widget.onSearch?.call();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? ThemeConfig.radiusMedium,
            ),
            boxShadow: [
              BoxShadow(
                color: _isFocused
                    ? ThemeConfig.primaryGreen.withOpacity(0.2 * _glowAnimation.value)
                    : Colors.black.withOpacity(0.05),
                blurRadius: _isFocused ? 16 : 8,
                offset: Offset(0, _isFocused ? 4 : 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? ThemeConfig.radiusMedium,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _isFocused ? 15 : 10,
                sigmaY: _isFocused ? 15 : 10,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor ??
                      Colors.white.withOpacity(_isFocused ? 0.95 : 0.9),
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? ThemeConfig.radiusMedium,
                  ),
                  border: Border.all(
                    color: _isFocused
                        ? ThemeConfig.primaryGreen.withOpacity(0.5)
                        : Colors.white.withOpacity(0.3),
                    width: _isFocused ? 2 : 1.5,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  onChanged: widget.onChanged,
                  onSubmitted: (_) => _handleSearch(),
                  style: widget.textStyle ?? ThemeConfig.bodyMedium,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: widget.hintStyle ??
                        ThemeConfig.bodyMedium.copyWith(
                          color: ThemeConfig.textTertiary,
                        ),
                    prefixIcon: widget.prefixIcon ??
                        Icon(
                          Icons.search,
                          color: _isFocused
                              ? ThemeConfig.primaryGreen
                              : ThemeConfig.textSecondary,
                          size: 24,
                        ),
                    suffixIcon: _buildSuffixIcon(),
                    border: InputBorder.none,
                    contentPadding: widget.contentPadding ??
                        const EdgeInsets.symmetric(
                          horizontal: ThemeConfig.spacingLG,
                          vertical: ThemeConfig.spacingLG,
                        ),
                    isDense: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }

    if (widget.showClearButton && _controller.text.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.clear, size: 20),
            onPressed: _handleClear,
            color: ThemeConfig.textSecondary,
            tooltip: 'Clear',
          ),
          if (widget.onSearch != null) ...[
            Container(
              width: 1,
              height: 24,
              color: ThemeConfig.border,
            ),
            IconButton(
              icon: const Icon(Icons.search, size: 20),
              onPressed: _handleSearch,
              color: ThemeConfig.primaryGreen,
              tooltip: 'Search',
            ),
          ],
        ],
      );
    }

    if (widget.onSearch != null) {
      return IconButton(
        icon: const Icon(Icons.search, size: 20),
        onPressed: _handleSearch,
        color: _isFocused
            ? ThemeConfig.primaryGreen
            : ThemeConfig.textSecondary,
        tooltip: 'Search',
      );
    }

    return null;
  }
}

/// Compact search bar variant for app bars
class CompactSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  const CompactSearchBar({
    Key? key,
    this.controller,
    this.hintText = 'Search properties...',
    this.onTap,
    this.onChanged,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: readOnly ? onTap : null,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(ThemeConfig.radiusCircular),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          readOnly: readOnly,
          enabled: !readOnly,
          style: ThemeConfig.bodySmall.copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: ThemeConfig.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white.withOpacity(0.9),
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: ThemeConfig.spacingMD,
              vertical: ThemeConfig.spacingMD,
            ),
            isDense: true,
          ),
        ),
      ),
    );
  }
}

/// Expandable search bar that grows from icon
class ExpandableSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onSearch;
  final ValueChanged<String>? onChanged;
  final Color? iconColor;
  final Color? backgroundColor;

  const ExpandableSearchBar({
    Key? key,
    this.controller,
    this.hintText = 'Search...',
    this.onSearch,
    this.onChanged,
    this.iconColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<ExpandableSearchBar> createState() => _ExpandableSearchBarState();
}

class _ExpandableSearchBarState extends State<ExpandableSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _widthAnimation = Tween<double>(begin: 48, end: 250).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _controller.text.isEmpty) {
        _collapse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _expand() {
    setState(() => _isExpanded = true);
    _animationController.forward();
    _focusNode.requestFocus();
  }

  void _collapse() {
    setState(() => _isExpanded = false);
    _animationController.reverse();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (context, child) => Container(
        width: _widthAnimation.value,
        height: 48,
        decoration: BoxDecoration(
          color: widget.backgroundColor ??
              Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(ThemeConfig.radiusCircular),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                _isExpanded ? Icons.arrow_back : Icons.search,
                color: widget.iconColor ?? ThemeConfig.primaryGreen,
              ),
              onPressed: _isExpanded ? _collapse : _expand,
            ),
            if (_isExpanded)
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: widget.onChanged,
                  onSubmitted: (_) {
                    widget.onSearch?.call();
                    _collapse();
                  },
                  style: ThemeConfig.bodyMedium,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: ThemeConfig.bodyMedium.copyWith(
                      color: ThemeConfig.textTertiary,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: ThemeConfig.spacingSM,
                    ),
                    isDense: true,
                  ),
                ),
              ),
            if (_isExpanded && _controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged?.call('');
                },
                color: ThemeConfig.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
