import 'package:flutter/material.dart';

/// Shimmer loader with gradient effect
class ShimmerLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoader({
    Key? key,
    this.width = double.infinity,
    this.height = 20.0,
    this.borderRadius = 4.0,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? Colors.grey[300]!;
    final highlightColor = widget.highlightColor ?? Colors.grey[100]!;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              baseColor,
              highlightColor,
              baseColor,
            ],
            stops: [
              _controller.value - 0.3,
              _controller.value,
              _controller.value + 0.3,
            ].map((value) => value.clamp(0.0, 1.0)).toList(),
          ),
        ),
      ),
    );
  }
}

/// Skeleton property card that matches PropertyCard dimensions
class SkeletonPropertyCard extends StatelessWidget {
  const SkeletonPropertyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          ShimmerLoader(
            height: 180,
            borderRadius: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title skeleton
                ShimmerLoader(
                  width: double.infinity,
                  height: 16,
                  borderRadius: 4,
                ),
                const SizedBox(height: 8),
                // Location skeleton
                ShimmerLoader(
                  width: 150,
                  height: 14,
                  borderRadius: 4,
                ),
                const SizedBox(height: 12),
                // Stats row skeleton
                Row(
                  children: [
                    ShimmerLoader(
                      width: 60,
                      height: 14,
                      borderRadius: 4,
                    ),
                    const SizedBox(width: 12),
                    ShimmerLoader(
                      width: 60,
                      height: 14,
                      borderRadius: 4,
                    ),
                    const SizedBox(width: 12),
                    ShimmerLoader(
                      width: 70,
                      height: 14,
                      borderRadius: 4,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Price skeleton
                ShimmerLoader(
                  width: 100,
                  height: 18,
                  borderRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for property detail screen
class SkeletonPropertyDetail extends StatelessWidget {
  const SkeletonPropertyDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image carousel skeleton
          ShimmerLoader(
            height: 300,
            borderRadius: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                ShimmerLoader(
                  width: double.infinity,
                  height: 24,
                  borderRadius: 4,
                ),
                const SizedBox(height: 12),
                // Location
                ShimmerLoader(
                  width: 200,
                  height: 16,
                  borderRadius: 4,
                ),
                const SizedBox(height: 24),
                // Price
                ShimmerLoader(
                  width: 150,
                  height: 28,
                  borderRadius: 4,
                ),
                const SizedBox(height: 24),
                // Stats grid
                _buildSkeletonStatsGrid(),
                const SizedBox(height: 24),
                // Description
                _buildSkeletonDescription(),
                const SizedBox(height: 24),
                // Amenities
                _buildSkeletonAmenities(),
                const SizedBox(height: 24),
                // Location section
                ShimmerLoader(
                  height: 200,
                  borderRadius: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: List.generate(
        6,
        (index) => ShimmerLoader(
          height: 60,
          borderRadius: 8,
        ),
      ),
    );
  }

  Widget _buildSkeletonDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerLoader(
          width: 120,
          height: 20,
          borderRadius: 4,
        ),
        const SizedBox(height: 12),
        ShimmerLoader(
          width: double.infinity,
          height: 14,
          borderRadius: 4,
        ),
        const SizedBox(height: 8),
        ShimmerLoader(
          width: double.infinity,
          height: 14,
          borderRadius: 4,
        ),
        const SizedBox(height: 8),
        ShimmerLoader(
          width: 250,
          height: 14,
          borderRadius: 4,
        ),
      ],
    );
  }

  Widget _buildSkeletonAmenities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerLoader(
          width: 100,
          height: 20,
          borderRadius: 4,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            8,
            (index) => ShimmerLoader(
              width: 100,
              height: 36,
              borderRadius: 18,
            ),
          ),
        ),
      ],
    );
  }
}

/// Animated loading indicator with house icon
class AnimatedLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final String? message;

  const AnimatedLoadingIndicator({
    Key? key,
    this.size = 60.0,
    this.color,
    this.message,
  }) : super(key: key);

  @override
  State<AnimatedLoadingIndicator> createState() =>
      _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState extends State<AnimatedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).primaryColor;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) => Transform.scale(
              scale: _pulseAnimation.value,
              child: Icon(
                Icons.home_work_rounded,
                size: widget.size,
                color: color,
              ),
            ),
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.message!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Progressive image loader with blur-to-sharp effect
class ProgressiveImageLoader extends StatefulWidget {
  final String imageUrl;
  final String? placeholderUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? placeholderColor;

  const ProgressiveImageLoader({
    Key? key,
    required this.imageUrl,
    this.placeholderUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderColor,
  }) : super(key: key);

  @override
  State<ProgressiveImageLoader> createState() =>
      _ProgressiveImageLoaderState();
}

class _ProgressiveImageLoaderState extends State<ProgressiveImageLoader> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: Stack(
        children: [
          // Placeholder
          Container(
            width: widget.width,
            height: widget.height,
            color:
                widget.placeholderColor ?? Theme.of(context).primaryColor.withOpacity(0.1),
            child: _isLoading
                ? Center(
                    child: ShimmerLoader(
                      width: widget.width ?? double.infinity,
                      height: widget.height ?? 200,
                      borderRadius: 0,
                    ),
                  )
                : null,
          ),
          // Actual image
          if (!_hasError)
            AnimatedOpacity(
              opacity: _isLoading ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Image.network(
                widget.imageUrl,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() => _isLoading = false);
                      }
                    });
                    return child;
                  }
                  return const SizedBox.shrink();
                },
                errorBuilder: (context, error, stackTrace) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                        _hasError = true;
                      });
                    }
                  });
                  return const SizedBox.shrink();
                },
              ),
            ),
          // Error state
          if (_hasError)
            Container(
              width: widget.width,
              height: widget.height,
              color: Colors.grey[200],
              child: Icon(
                Icons.broken_image_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
        ],
      ),
    );
  }
}

/// Skeleton list loader
class SkeletonListLoader extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry? padding;

  const SkeletonListLoader({
    Key? key,
    this.itemCount = 5,
    this.itemHeight = 80.0,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => Container(
        height: itemHeight,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ShimmerLoader(
              width: 60,
              height: 60,
              borderRadius: 8,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShimmerLoader(
                    width: double.infinity,
                    height: 16,
                    borderRadius: 4,
                  ),
                  const SizedBox(height: 8),
                  ShimmerLoader(
                    width: 150,
                    height: 14,
                    borderRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid skeleton loader
class SkeletonGridLoader extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;

  const SkeletonGridLoader({
    Key? key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding ?? const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const SkeletonPropertyCard(),
    );
  }
}
