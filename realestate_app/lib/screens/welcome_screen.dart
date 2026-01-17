import 'package:flutter/material.dart';
import '../widgets/glass_widgets.dart';
import '../widgets/animated_buttons.dart';
import '../widgets/page_transitions.dart';
import '../config/theme_config.dart';
import 'property_listing_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Shimmer animation for gradient text
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Pulse animation for button
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeConfig.primaryGreen.withOpacity(0.05),
              Colors.white,
              ThemeConfig.secondaryBlue.withOpacity(0.05),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating glass cards background
            ..._buildFloatingGlassCards(),

            // Floating particles
            ..._buildFloatingParticles(),

            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConfig.spacingXL,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _OrderlyFall(
                        delay: 0,
                        child: _buildLogo(),
                      ),
                      const SizedBox(height: ThemeConfig.spacing3XL),
                      _OrderlyFall(
                        delay: 200,
                        child: _buildTitle(),
                      ),
                      const SizedBox(height: ThemeConfig.spacingLG),
                      _OrderlyFall(
                        delay: 400,
                        child: _buildSubtitle(),
                      ),
                      const SizedBox(height: ThemeConfig.spacingMD),
                      _OrderlyFall(
                        delay: 600,
                        child: _buildDescription(),
                      ),
                      const SizedBox(height: ThemeConfig.spacing3XL),
                      _buildFeatureBadges(),
                      const SizedBox(height: ThemeConfig.spacing3XL),
                      _OrderlyFall(
                        delay: 1200,
                        child: _buildButtons(),
                      ),
                      const SizedBox(height: ThemeConfig.spacing3XL),
                      _OrderlyFall(
                        delay: 1400,
                        child: _buildTrustBadge(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFloatingGlassCards() {
    return [
      Positioned(
        top: 80,
        right: 30,
        child: _OrderlyFall(
          delay: 0,
          startY: -250,
          child: _FloatingGlassCard(
            icon: Icons.home_rounded,
            size: 120,
            delay: 0,
          ),
        ),
      ),
      Positioned(
        top: 200,
        left: 20,
        child: _OrderlyFall(
          delay: 100,
          startY: -280,
          child: _FloatingGlassCard(
            icon: Icons.apartment_rounded,
            size: 100,
            delay: 1,
          ),
        ),
      ),
      Positioned(
        bottom: 150,
        right: 40,
        child: _OrderlyFall(
          delay: 200,
          startY: -300,
          child: _FloatingGlassCard(
            icon: Icons.location_city_rounded,
            size: 90,
            delay: 2,
          ),
        ),
      ),
      Positioned(
        bottom: 100,
        left: 30,
        child: _OrderlyFall(
          delay: 300,
          startY: -320,
          child: _FloatingGlassCard(
            icon: Icons.key_rounded,
            size: 80,
            delay: 3,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildFloatingParticles() {
    return List.generate(8, (index) {
      return Positioned(
        top: 80.0 + (index * 100),
        left: (index % 2 == 0) ? 15.0 : null,
        right: (index % 2 != 0) ? 15.0 : null,
        child: _FloatingParticle(
          icon: index % 3 == 0
              ? Icons.home
              : index % 3 == 1
                  ? Icons.key
                  : Icons.location_on,
          delay: index,
        ),
      );
    });
  }

  Widget _buildLogo() {
    return GlassmorphicContainer(
      blurRadius: 15,
      opacity: 0.2,
      borderRadius: ThemeConfig.radiusCircular,
      padding: const EdgeInsets.all(ThemeConfig.spacingXL),
      boxShadow: ThemeConfig.shadowLevel4(
        color: ThemeConfig.primaryGreen,
      ),
      child: Container(
        padding: const EdgeInsets.all(ThemeConfig.spacingLG),
        decoration: BoxDecoration(
          gradient: ThemeConfig.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ThemeConfig.primaryGreen.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.home_work_rounded,
          size: 80,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        final double baseValue = _shimmerController.value;
        final double start = (baseValue - 0.3).clamp(0.0, 1.0);
        final double middle = baseValue.clamp(0.0, 1.0);
        final double end = (baseValue + 0.3).clamp(0.0, 1.0);

        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: const [
              ThemeConfig.primaryGreen,
              ThemeConfig.secondaryBlue,
              ThemeConfig.primaryGreen,
            ],
            stops: [start, middle, end],
            tileMode: TileMode.clamp,
          ).createShader(bounds),
          child: const Text(
            'EstateHub',
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1,
              height: 1.2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Find Your Dream Home',
      style: ThemeConfig.h2.copyWith(
        color: ThemeConfig.textPrimary,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'Discover thousands of verified properties.\nGet expert assistance and transparent pricing.',
      textAlign: TextAlign.center,
      style: ThemeConfig.bodyLarge.copyWith(
        color: ThemeConfig.textSecondary,
        height: 1.6,
      ),
    );
  }

  Widget _buildFeatureBadges() {
    final badges = [
      {'icon': Icons.verified_rounded, 'label': 'Verified Properties'},
      {'icon': Icons.support_agent_rounded, 'label': 'Expert Support'},
      {'icon': Icons.price_check_rounded, 'label': 'Best Prices'},
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: ThemeConfig.spacingMD,
      runSpacing: ThemeConfig.spacingMD,
      children: badges.asMap().entries.map((entry) {
        final index = entry.key;
        final badge = entry.value;
        return _OrderlyFall(
          delay: 800 + (index * 100),
          startY: -100,
          child: GlassmorphicContainer(
            blurRadius: 10,
            opacity: 0.2,
            borderRadius: ThemeConfig.radiusCircular,
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConfig.spacingLG,
              vertical: ThemeConfig.spacingMD,
            ),
            boxShadow: ThemeConfig.shadowLevel2(
              color: ThemeConfig.primaryGreen,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  badge['icon'] as IconData,
                  color: ThemeConfig.primaryGreen,
                  size: 18,
                ),
                const SizedBox(width: ThemeConfig.spacingXS),
                Text(
                  badge['label'] as String,
                  style: ThemeConfig.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ThemeConfig.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        // Pulsing Get Started button
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) => Transform.scale(
            scale: 1.0 + (_pulseController.value * 0.03),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: ThemeConfig.primaryGreen.withOpacity(
                        0.3 + (_pulseController.value * 0.2)),
                    blurRadius: 20 + (_pulseController.value * 10),
                    spreadRadius: 0,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SizedBox(
                width: 280,
                child: AnimatedGradientButton(
                  text: 'Get Started',
                  onPressed: () {
                    PageTransitions.slideUp(context, const LoginScreen());
                  },
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                  fullWidth: false,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: ThemeConfig.spacingLG),
        // Glass outline button
        SizedBox(
          width: 280,
          child: GlassmorphicContainer(
            blurRadius: 10,
            opacity: 0.15,
            borderRadius: ThemeConfig.radiusMedium,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  PageTransitions.fadeScale(
                    context,
                    const PropertyListingScreen(),
                  );
                },
                borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: ThemeConfig.spacingLG,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.explore_rounded,
                        size: 20,
                        color: ThemeConfig.primaryGreen,
                      ),
                      const SizedBox(width: ThemeConfig.spacingXS),
                      Text(
                        'Browse Properties',
                        style: ThemeConfig.buttonMedium.copyWith(
                          color: ThemeConfig.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrustBadge() {
    return GlassmorphicContainer(
      blurRadius: 10,
      opacity: 0.2,
      borderRadius: ThemeConfig.radiusCircular,
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConfig.spacingLG,
        vertical: ThemeConfig.spacingMD,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.stars_rounded,
            color: ThemeConfig.warning,
            size: 20,
          ),
          const SizedBox(width: ThemeConfig.spacingXS),
          Text(
            'Trusted by 10,000+ customers',
            style: ThemeConfig.bodyMedium.copyWith(
              color: ThemeConfig.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Orderly falling animation - smooth drop with no bounce
class _OrderlyFall extends StatefulWidget {
  final Widget child;
  final int delay;
  final double startY;

  const _OrderlyFall({
    required this.child,
    required this.delay,
    this.startY = -150,
  });

  @override
  State<_OrderlyFall> createState() => _OrderlyFallState();
}

class _OrderlyFallState extends State<_OrderlyFall>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Smooth fall from top to position - no bounce
    _positionAnimation = Tween<double>(
      begin: widget.startY,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut, // Smooth deceleration
      ),
    );

    // Fade in smoothly
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Start animation after delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _positionAnimation.value),
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Floating glass card with animated movement
class _FloatingGlassCard extends StatefulWidget {
  final IconData icon;
  final double size;
  final int delay;

  const _FloatingGlassCard({
    required this.icon,
    required this.size,
    this.delay = 0,
  });

  @override
  State<_FloatingGlassCard> createState() => _FloatingGlassCardState();
}

class _FloatingGlassCardState extends State<_FloatingGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3 + widget.delay),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.3),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: 800 + (widget.delay * 200)), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(
          0,
          _offsetAnimation.value.dy * widget.size,
        ),
        child: GlassmorphicContainer(
          blurRadius: 15,
          opacity: 0.1,
          borderRadius: ThemeConfig.radiusMedium,
          padding: EdgeInsets.all(widget.size * 0.2),
          child: Icon(
            widget.icon,
            size: widget.size * 0.5,
            color: ThemeConfig.primaryGreen.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

/// Floating particle with continuous movement
class _FloatingParticle extends StatefulWidget {
  final IconData icon;
  final int delay;

  const _FloatingParticle({
    required this.icon,
    this.delay = 0,
  });

  @override
  State<_FloatingParticle> createState() => _FloatingParticleState();
}

class _FloatingParticleState extends State<_FloatingParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5 + widget.delay),
      vsync: this,
    );

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.4), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.4, end: 0.0), weight: 1),
    ]).animate(_controller);

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -2.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: 1200 + (widget.delay * 300)), () {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(
          0,
          _positionAnimation.value.dy * 100,
        ),
        child: Opacity(
          opacity: _opacityAnimation.value.clamp(0.0, 1.0),
          child: Icon(
            widget.icon,
            size: 20,
            color: ThemeConfig.primaryGreen.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}