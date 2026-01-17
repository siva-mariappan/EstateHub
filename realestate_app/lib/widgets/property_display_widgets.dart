import 'package:flutter/material.dart';
import 'package:realestate_app/config/theme_config.dart';
import 'package:realestate_app/models/property_model.dart';
import 'package:realestate_app/widgets/glass_widgets.dart';
import 'package:realestate_app/widgets/utility_widgets.dart';

/// Enhanced property card with glassmorphic overlay and animations
class EnhancedPropertyCard extends StatefulWidget {
  final Property property;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;
  final bool isFavorite;

  const EnhancedPropertyCard({
    Key? key,
    required this.property,
    required this.onTap,
    this.onFavorite,
    this.onShare,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  State<EnhancedPropertyCard> createState() => _EnhancedPropertyCardState();
}

class _EnhancedPropertyCardState extends State<EnhancedPropertyCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: ThemeConfig.fastAnimation,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    setState(() => _isHovered = true);
    _controller.forward();
  }

  void _onHoverExit() {
    setState(() => _isHovered = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                boxShadow: [],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image with glass overlay
                        _buildImage(),

                        // Property details
                        Expanded(
                          child: _buildDetails(),
                        ),
                      ],
                    ),

                    // Floating action buttons
                    if (_isHovered || widget.isFavorite || widget.onShare != null)
                      _buildFloatingActions(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = widget.property.images.isNotEmpty
        ? widget.property.images.first
        : '';

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ThemeConfig.primaryGreen.withOpacity(0.1),
        ),
        child: Stack(
        children: [
          // Property image
          if (imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: ThemeConfig.textTertiary,
                ),
              ),
            )
          else
            const Center(
              child: Icon(
                Icons.home_work,
                size: 48,
                color: ThemeConfig.textTertiary,
              ),
            ),

          // Badges overlay
          Positioned(
            top: ThemeConfig.spacingSM,
            left: ThemeConfig.spacingSM,
            child: _buildBadges(),
          ),

          // Price tag with glass effect
          Positioned(
            bottom: ThemeConfig.spacingSM,
            right: ThemeConfig.spacingSM,
            child: GlassmorphicContainer(
              blurRadius: 10,
              opacity: 0.2,
              borderRadius: ThemeConfig.radiusSmall,
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConfig.spacingSM,
                vertical: 4,
              ),
              child: Text(
                widget.property.getPriceFormatted(),
                style: ThemeConfig.h6.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildBadges() {
    return Wrap(
      spacing: ThemeConfig.spacingXS,
      runSpacing: ThemeConfig.spacingXS,
      children: [
        if (widget.property.featured)
          StatusBadge.featured(),
        StatusBadge(
          text: widget.property.purpose.toUpperCase(),
          backgroundColor: widget.property.purpose == 'buy'
              ? ThemeConfig.primaryGreen
              : ThemeConfig.secondaryBlue,
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mobile-first: aggressive optimization for phones
        final isMobile = constraints.maxWidth < 450;
        final spacing = isMobile ? 6.0 : 8.0;
        final padding = isMobile ? 8.0 : 10.0;
        final iconSize = isMobile ? 14.0 : 16.0;
        final fontSize = isMobile ? 13.0 : 14.0;

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(padding * 0.9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top content section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title - Compact for mobile
                  Text(
                    widget.property.title,
                    style: ThemeConfig.h5.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      fontSize: isMobile ? 16 : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: spacing * 0.7),

                  // Location - Compact
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: iconSize,
                        color: ThemeConfig.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${widget.property.locality}, ${widget.property.location}',
                          style: ThemeConfig.bodyMedium.copyWith(
                            fontSize: fontSize,
                            color: ThemeConfig.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing * 0.9),

                  // Property stats - Compact and flexible
                  Wrap(
                    spacing: spacing,
                    runSpacing: 4,
                    children: [
                      _buildCompactStat(
                        Icons.bed_outlined,
                        widget.property.getBHKString(),
                        isMobile,
                      ),
                      _buildCompactStat(
                        Icons.bathtub_outlined,
                        '${widget.property.bathrooms ?? 0} Bath',
                        isMobile,
                      ),
                      _buildCompactStat(
                        Icons.square_foot,
                        '${widget.property.area.toInt()} sqft',
                        isMobile,
                      ),
                    ],
                  ),

                  // Amenities chips - Only show if available
                  if (widget.property.amenities != null && widget.property.amenities!.isNotEmpty) ...[
                    SizedBox(height: spacing * 0.9),
                    _buildAmenities(),
                  ],
                ],
              ),

              // Price and View Details button (at bottom)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Price - Compact
                  Expanded(
                    flex: 2,
                    child: Text(
                      widget.property.getPriceFormatted(),
                      style: ThemeConfig.h4.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ThemeConfig.textPrimary,
                        fontSize: isMobile ? 18 : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(width: isMobile ? 6 : 8),

                  // View Details button - Compact for mobile
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: widget.onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeConfig.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 8 : 16,
                          vertical: isMobile ? 7 : 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: isMobile ? 11 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: ThemeConfig.iconSizeSmall,
          color: ThemeConfig.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: ThemeConfig.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLargeStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: ThemeConfig.textPrimary,
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: ThemeConfig.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactStat(IconData icon, String value, bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: isMobile ? 16 : 18,
          color: ThemeConfig.textPrimary,
        ),
        SizedBox(width: isMobile ? 4 : 6),
        Text(
          value,
          style: TextStyle(
            fontSize: isMobile ? 13 : 14,
            fontWeight: FontWeight.w600,
            color: ThemeConfig.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAmenities() {
    final amenities = widget.property.amenities!.take(3).toList();
    final hasMore = widget.property.amenities!.length > 3;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...amenities.map((amenity) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: ThemeConfig.background,
            borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
          ),
          child: Text(
            amenity,
            style: ThemeConfig.caption.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        )),
        if (hasMore)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ThemeConfig.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
            ),
            child: Text(
              '+${widget.property.amenities!.length - 3}',
              style: ThemeConfig.caption.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ThemeConfig.primaryGreen,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFloatingActions() {
    return Positioned(
      top: ThemeConfig.spacingMD,
      right: ThemeConfig.spacingMD,
      child: Column(
        children: [
          if (widget.onFavorite != null)
            GlassFAB(
              icon: Icon(
                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: widget.onFavorite,
              size: 40,
              iconColor: widget.isFavorite ? Colors.red : Colors.white,
            ),
          if (widget.onShare != null) ...[
            const SizedBox(height: ThemeConfig.spacingXS),
            GlassFAB(
              icon: const Icon(Icons.share),
              onPressed: widget.onShare,
              size: 40,
              iconColor: Colors.white,
            ),
          ],
        ],
      ),
    );
  }
}

/// Property carousel with snap scrolling
class PropertyCarousel extends StatefulWidget {
  final List<Property> properties;
  final Function(Property) onPropertyTap;
  final double height;
  final bool autoPlay;

  const PropertyCarousel({
    Key? key,
    required this.properties,
    required this.onPropertyTap,
    this.height = 300,
    this.autoPlay = false,
  }) : super(key: key);

  @override
  State<PropertyCarousel> createState() => _PropertyCarouselState();
}

class _PropertyCarouselState extends State<PropertyCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemCount: widget.properties.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConfig.spacingMD,
            ),
            child: EnhancedPropertyCard(
              property: widget.properties[index],
              onTap: () => widget.onPropertyTap(widget.properties[index]),
            ),
          );
        },
      ),
    );
  }
}

/// Property stats widget with animated circular progress
class PropertyStatsWidget extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  final double? progress; // 0.0 to 1.0

  const PropertyStatsWidget({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    this.color,
    this.progress,
  }) : super(key: key);

  @override
  State<PropertyStatsWidget> createState() => _PropertyStatsWidgetState();
}

class _PropertyStatsWidgetState extends State<PropertyStatsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress ?? 0.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? ThemeConfig.primaryGreen;

    return GlassCard(
      padding: const EdgeInsets.all(ThemeConfig.spacingLG),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(ThemeConfig.spacingMD),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.icon,
              size: ThemeConfig.iconSizeLarge,
              color: color,
            ),
          ),
          const SizedBox(height: ThemeConfig.spacingMD),

          // Value
          Text(
            widget.value,
            style: ThemeConfig.h4.copyWith(color: color),
          ),
          const SizedBox(height: ThemeConfig.spacingXS),

          // Label
          Text(
            widget.label,
            style: ThemeConfig.caption,
            textAlign: TextAlign.center,
          ),

          // Progress indicator
          if (widget.progress != null) ...[
            const SizedBox(height: ThemeConfig.spacingMD),
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) => LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Property image gallery widget
class PropertyImageGallery extends StatefulWidget {
  final List<String> images;
  final double height;

  const PropertyImageGallery({
    Key? key,
    required this.images,
    this.height = 400,
  }) : super(key: key);

  @override
  State<PropertyImageGallery> createState() => _PropertyImageGalleryState();
}

class _PropertyImageGalleryState extends State<PropertyImageGallery> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Images
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Image.network(
                widget.images[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: ThemeConfig.background,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 64,
                      color: ThemeConfig.textTertiary,
                    ),
                  ),
                ),
              );
            },
          ),

          // Page indicator
          Positioned(
            bottom: ThemeConfig.spacingLG,
            left: 0,
            right: 0,
            child: Center(
              child: GlassmorphicContainer(
                blurRadius: 10,
                opacity: 0.2,
                borderRadius: ThemeConfig.radiusCircular,
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConfig.spacingMD,
                  vertical: ThemeConfig.spacingXS,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    widget.images.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: ThemeConfig.spacingXS / 2,
                      ),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Navigation buttons
          Positioned(
            left: ThemeConfig.spacingLG,
            top: 0,
            bottom: 0,
            child: Center(
              child: GlassFAB(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  if (_currentIndex > 0) {
                    _pageController.previousPage(
                      duration: ThemeConfig.normalAnimation,
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            right: ThemeConfig.spacingLG,
            top: 0,
            bottom: 0,
            child: Center(
              child: GlassFAB(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  if (_currentIndex < widget.images.length - 1) {
                    _pageController.nextPage(
                      duration: ThemeConfig.normalAnimation,
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
