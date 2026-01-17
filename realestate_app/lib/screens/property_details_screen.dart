import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/property.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailsScreen({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen>
    with SingleTickerProviderStateMixin {
  final PageController _imagePageController = PageController();
  final ScrollController _desktopScrollController = ScrollController();
  late AnimationController _animationController;
  int _currentImageIndex = 0;
  bool _isFavorite = false;
  double _contactCardTop = 624.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _desktopScrollController.addListener(_onDesktopScroll);
  }

  void _onDesktopScroll() {
    final scrollOffset = _desktopScrollController.offset;
    final carouselHeight = 600.0;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = 520.0;

    setState(() {
      if (scrollOffset < carouselHeight) {
        _contactCardTop = carouselHeight - scrollOffset + 24;
      } else {
        _contactCardTop = (screenHeight - cardHeight) / 2;
        if (_contactCardTop < 24) _contactCardTop = 24;
      }
    });
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    _animationController.dispose();
    _desktopScrollController.dispose();
    super.dispose();
  }

  // -------------------- LAUNCHERS --------------------

  Future<void> _launchPhone() async {
    final uri = Uri(
      scheme: 'tel',
      path: widget.property.contactMobile,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWhatsApp() async {
    final cleanNumber = widget.property.contactMobile.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse(
      'https://wa.me/$cleanNumber?text=Hi, I am interested in your property: ${widget.property.propertyName}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail() async {
    final email = widget.property.contactEmail;
    if (email == null || email.isEmpty) return;

    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Inquiry about ${widget.property.propertyName}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchMaps() async {
    final mapLink = widget.property.googleMapsLink;
    if (mapLink == null || mapLink.isEmpty) return;

    final uri = Uri.parse(mapLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // -------------------- BUILD --------------------

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: isDesktop ? _buildDesktopView() : _buildMobileView(),
      bottomNavigationBar: isDesktop ? null : _buildBottomBar(),
      floatingActionButton: isDesktop ? null : _buildFavoriteButton(),
    );
  }

  Widget _buildDesktopView() {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomScrollView(
            controller: _desktopScrollController,
            slivers: [
              _buildImageCarousel(),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _animationController,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, top: 24, bottom: 24, right: 448),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPropertyHeader(),
                        const SizedBox(height: 24),
                        _buildPriceCard(),
                        const SizedBox(height: 24),
                        _buildSpecificationsCard(),
                        const SizedBox(height: 24),
                        _buildDescriptionSection(),
                        const SizedBox(height: 24),
                        if (_hasAmenities())
                          _buildAmenitiesSection(),
                        if (_hasAmenities())
                          const SizedBox(height: 24),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 24,
          top: _contactCardTop,
          width: 400,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - _contactCardTop - 24,
            ),
            child: SingleChildScrollView(
              child: _buildStickyContactCard(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileView() {
    return CustomScrollView(
      slivers: [
        _buildImageCarousel(),
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _animationController,
            child: _buildMobileLayout(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPropertyHeader(),
        _buildPriceCard(),
        _buildSpecificationsCard(),
        _buildDescriptionSection(),
        if (_hasAmenities())
          _buildAmenitiesSection(),
        _buildAgentContactCard(),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildStickyContactCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.support_agent,
                  color: Color(0xFF10B981),
                  size: 28,
                ),
                SizedBox(width: 14),
                Text(
                  'Contact Agent',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.property.contactName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.property.contactName,
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                              letterSpacing: 0.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.property.listedBy ?? 'Property Agent',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: _launchPhone,
                    icon: const Icon(Icons.phone, size: 22),
                    label: const Text('Call Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                if (widget.property.contactEmail != null && widget.property.contactEmail!.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: OutlinedButton.icon(
                      onPressed: _launchEmail,
                      icon: const Icon(Icons.email_outlined, size: 22),
                      label: const Text('Send Email'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF10B981),
                        side: const BorderSide(
                          color: Color(0xFF10B981),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                if (widget.property.contactEmail != null && widget.property.contactEmail!.isNotEmpty)
                  const SizedBox(height: 14),
                if (widget.property.whatsappAvailable == true)
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: OutlinedButton.icon(
                      onPressed: _launchWhatsApp,
                      icon: const Icon(Icons.chat, size: 22),
                      label: const Text('WhatsApp'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF25D366),
                        side: const BorderSide(
                          color: Color(0xFF25D366),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 26),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'By contacting the agent, you agree to our Terms of Service and Privacy Policy. Property details are subject to verification.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    final images = widget.property.imageUrls ?? [];

    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
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
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
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
          child: IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF111827)),
            onPressed: () {},
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (images.isNotEmpty)
              PageView.builder(
                controller: _imagePageController,
                itemCount: images.length,
                onPageChanged: (index) {
                  if (!mounted) return;
                  setState(() => _currentImageIndex = index);
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Image not available',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              )
            else
              Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.home,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            if (images.length > 1)
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SmoothPageIndicator(
                      controller: _imagePageController,
                      count: images.length,
                      effect: const WormEffect(
                        dotWidth: 8,
                        dotHeight: 8,
                        activeDotColor: Colors.white,
                        dotColor: Colors.white54,
                        spacing: 8,
                      ),
                    ),
                  ),
                ),
              ),
            if (images.length > 1)
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF111827)),
                      iconSize: 24,
                      onPressed: () {
                        if (_imagePageController.hasClients) {
                          final currentPage = _imagePageController.page?.round() ?? 0;
                          if (currentPage > 0) {
                            _imagePageController.animateToPage(
                              currentPage - 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            if (images.length > 1)
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF111827)),
                      iconSize: 24,
                      onPressed: () {
                        if (_imagePageController.hasClients) {
                          final currentPage = _imagePageController.page?.round() ?? 0;
                          if (currentPage < images.length - 1) {
                            _imagePageController.animateToPage(
                              currentPage + 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.property.propertyName,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (isDesktop) ...[
                // Video button
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.play_circle_outline),
                    iconSize: 36,
                    color: const Color(0xFF6B7280),
                    onPressed: _showVideoDialog,
                    tooltip: 'Video Tour',
                  ),
                ),
                const SizedBox(width: 12),
                // 360 View button
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: _build360Icon(),
                    iconSize: 36,
                    onPressed: _show360ViewDialog,
                    tooltip: '360° View',
                  ),
                ),
                const SizedBox(width: 12),
                // AR View button
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.view_in_ar_outlined),
                    iconSize: 36,
                    color: const Color(0xFF6B7280),
                    onPressed: _showARViewDialog,
                    tooltip: 'AR View',
                  ),
                ),
                const SizedBox(width: 12),
                // VR View button
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.vrpano_outlined),
                    iconSize: 36,
                    color: const Color(0xFF6B7280),
                    onPressed: _showVRViewDialog,
                    tooltip: 'VR View',
                  ),
                ),
                const SizedBox(width: 12),
                // Location button
                if (widget.property.googleMapsLink != null && widget.property.googleMapsLink!.isNotEmpty)
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.location_on_outlined),
                      iconSize: 36,
                      color: const Color(0xFF6B7280),
                      onPressed: _launchMaps,
                      tooltip: 'View on Map',
                    ),
                  ),
                if (widget.property.googleMapsLink != null && widget.property.googleMapsLink!.isNotEmpty)
                  const SizedBox(width: 12),
                // Share button
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.share_outlined),
                    iconSize: 36,
                    color: const Color(0xFF6B7280),
                    onPressed: () {},
                    tooltip: 'Share',
                  ),
                ),
                const SizedBox(width: 12),
                // Favorite button
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _isFavorite
                        ? const Color(0xFFEF4444).withOpacity(0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    iconSize: 36,
                    color: _isFavorite
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF6B7280),
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                    tooltip: 'Add to favorites',
                  ),
                ),
                const SizedBox(width: 12),
              ],
              _buildPropertyTypeChip(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Color(0xFFEF4444),
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.property.location,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyTypeChip() {
    final isSell = widget.property.propertyFor == 'sell';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isSell
            ? [const Color(0xFF3B82F6), const Color(0xFF2563EB)]
            : [const Color(0xFFF59E0B), const Color(0xFFD97706)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isSell ? const Color(0xFF3B82F6) : const Color(0xFFF59E0B)).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isSell ? Icons.sell : Icons.key, color: Colors.white, size: 20),
          const SizedBox(width: 6),
          Text(
            isSell ? 'For Sale' : 'For Rent',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  // Dialog Methods
  void _show360ViewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.threesixty, color: Color(0xFF10B981)),
            SizedBox(width: 12),
            Text('360° View'),
          ],
        ),
        content: const Text('360° view feature coming soon! Experience the property from every angle.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF10B981))),
          ),
        ],
      ),
    );
  }

  void _showARViewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.view_in_ar, color: Color(0xFF10B981)),
            SizedBox(width: 12),
            Text('AR View'),
          ],
        ),
        content: const Text('Augmented Reality view coming soon! Visualize the property in your space.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF10B981))),
          ),
        ],
      ),
    );
  }

  void _showVRViewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.vrpano, color: Color(0xFF10B981)),
            SizedBox(width: 12),
            Text('VR View'),
          ],
        ),
        content: const Text('Virtual Reality tour coming soon! Immerse yourself in the property.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF10B981))),
          ),
        ],
      ),
    );
  }

  void _showVideoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.play_circle, color: Color(0xFF10B981)),
            SizedBox(width: 12),
            Text('Video Tour'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_outline, size: 64, color: Color(0xFF10B981)),
                    SizedBox(height: 12),
                    Text('Video tour coming soon!', style: TextStyle(color: Color(0xFF6B7280))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Watch a complete walkthrough of this property with our video tour feature.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF10B981))),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF10B981).withOpacity(0.1),
            const Color(0xFF3B82F6).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF10B981).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.property.formattedPrice,
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF10B981),
                    letterSpacing: -1,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Color(0xFF10B981),
              size: 38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsCard() {
    final specs = <Map<String, dynamic>>[];

    if (widget.property.bedrooms != null) {
      specs.add({
        'icon': Icons.bed_outlined,
        'value': '${widget.property.bedrooms}',
        'label': 'Bedrooms',
        'color': const Color(0xFF3B82F6),
        'bgColor': const Color(0xFFEFF6FF),
      });
    }

    if (widget.property.bathrooms != null) {
      specs.add({
        'icon': Icons.bathroom_outlined,
        'value': '${widget.property.bathrooms}',
        'label': 'Bathrooms',
        'color': const Color(0xFF8B5CF6),
        'bgColor': const Color(0xFFF5F3FF),
      });
    }

    if (widget.property.builtUpArea != null) {
      specs.add({
        'icon': Icons.square_foot_outlined,
        'value': '${widget.property.builtUpArea!.toInt()}',
        'label': 'Sq Ft',
        'color': const Color(0xFF10B981),
        'bgColor': const Color(0xFFECFDF5),
      });
    }

    if (widget.property.furnishingStatus != null) {
      specs.add({
        'icon': Icons.chair_outlined,
        'value': widget.property.furnishingStatus!,
        'label': 'Furnishing',
        'color': const Color(0xFFF59E0B),
        'bgColor': const Color(0xFFFEF3C7),
      });
    }

    if (widget.property.facingDirection != null) {
      specs.add({
        'icon': Icons.explore_outlined,
        'value': widget.property.facingDirection!,
        'label': 'Facing',
        'color': const Color(0xFFEC4899),
        'bgColor': const Color(0xFFFCE7F3),
      });
    }

    if (widget.property.floorNo != null) {
      specs.add({
        'icon': Icons.layers_outlined,
        'value': 'Floor ${widget.property.floorNo}',
        'label': 'Floor',
        'color': const Color(0xFF6366F1),
        'bgColor': const Color(0xFFEEF2FF),
      });
    }

    if (widget.property.ageOfProperty != null) {
      specs.add({
        'icon': Icons.access_time,
        'value': widget.property.ageOfProperty!,
        'label': 'Age',
        'color': const Color(0xFF14B8A6),
        'bgColor': const Color(0xFFCCFBF1),
      });
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Property Details',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 24),
          ...specs.map((spec) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildSpecItem(
                  spec['icon'] as IconData,
                  spec['label'] as String,
                  spec['value'] as String,
                  spec['color'] as Color,
                  spec['bgColor'] as Color,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSpecItem(
    IconData icon,
    String label,
    String value,
    Color color,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    if (widget.property.propertyDescription == null ||
        widget.property.propertyDescription!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF10B981),
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            widget.property.propertyDescription!,
            style: const TextStyle(
              fontSize: 17,
              height: 1.7,
              color: Color(0xFF4B5563),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    final amenities = widget.property.nearbyAmenities;
    if (amenities == null || amenities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.star,
                  color: Color(0xFF10B981),
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                'Nearby Amenities',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: amenities.map((amenity) {
              return _buildAmenityItem(amenity);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(String amenity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF10B981).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            size: 22,
            color: Color(0xFF10B981),
          ),
          const SizedBox(width: 10),
          Text(
            amenity,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentContactCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF10B981).withOpacity(0.1),
            const Color(0xFF059669).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF10B981).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.support_agent,
                color: Color(0xFF10B981),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Contact Agent',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.property.contactName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.property.contactName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.property.listedBy ?? 'Property Agent',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _launchPhone,
                  icon: const Icon(Icons.phone, size: 20),
                  label: const Text('Call Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (widget.property.whatsappAvailable == true)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _launchWhatsApp,
                    icon: const Icon(Icons.message, size: 20),
                    label: const Text('WhatsApp'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF25D366),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(
                        color: Color(0xFF25D366),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (widget.property.contactEmail != null && widget.property.contactEmail!.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _launchEmail,
                icon: const Icon(Icons.email_outlined, size: 20),
                label: const Text('Send Email'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF10B981),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(
                    color: Color(0xFF10B981),
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: widget.property.whatsappAvailable == true
              ? _launchWhatsApp
              : _launchPhone,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.property.whatsappAvailable == true
                    ? Icons.chat_bubble_outline
                    : Icons.phone,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.property.whatsappAvailable == true
                    ? 'Contact Agent Now'
                    : 'Call Agent Now',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      },
      backgroundColor: Colors.white,
      elevation: 4,
      child: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
        size: 28,
      ),
    );
  }

  Widget _build360Icon() {
    return SizedBox(
      width: 36,
      height: 36,
      child: CustomPaint(
        painter: _360IconPainter(color: const Color(0xFF6B7280)),
      ),
    );
  }

  bool _hasAmenities() {
    return widget.property.nearbyAmenities != null &&
        widget.property.nearbyAmenities!.isNotEmpty;
  }
}

class _360IconPainter extends CustomPainter {
  final Color color;

  _360IconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '360°',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.3,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );

    final arrowRect = Rect.fromCenter(
      center: center,
      width: size.width * 1.05,
      height: size.height * 0.85,
    );

    canvas.drawArc(
      arrowRect,
      1.1,
      3.8,
      false,
      paint,
    );

    canvas.drawArc(
      arrowRect,
      1.1,
      -2.45,
      false,
      paint,
    );

    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final arrowPath = Path();
    final arrowX = center.dx + size.width * 0.15;
    final arrowY = center.dy + size.height * 0.38;

    arrowPath.moveTo(arrowX - 8, arrowY);
    arrowPath.lineTo(arrowX + 3, arrowY - 6);
    arrowPath.lineTo(arrowX + 3, arrowY + 6);
    arrowPath.close();

    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
