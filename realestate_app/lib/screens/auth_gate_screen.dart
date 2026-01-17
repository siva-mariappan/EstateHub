import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/glass_widgets.dart';
import '../widgets/page_transitions.dart';
import '../config/theme_config.dart';
import 'welcome_screen.dart';
import 'home_page_screen.dart';

/// Auth gate that checks authentication state and routes accordingly
/// - If user is signed in -> HomePageScreen
/// - If user is not signed in -> WelcomeScreen
class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({Key? key}) : super(key: key);

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen>
    with TickerProviderStateMixin {
  bool _hasNavigated = false;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkInitialSession();
  }

  void _setupAnimations() {
    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Rotation animation
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    // Fade in animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _checkInitialSession() async {
    // Small delay to ensure Supabase is fully initialized and show animation
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted || _hasNavigated) return;

    final session = Supabase.instance.client.auth.currentSession;

    _hasNavigated = true;

    if (session != null) {
      // User is signed in, go to home page
      Navigator.pushReplacement(
        context,
        PageTransitions.buildFadeScale(
          builder: (context) => const HomePageScreen(),
        ),
      );
    } else {
      // User is not signed in, go to welcome screen
      Navigator.pushReplacement(
        context,
        PageTransitions.buildFadeScale(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    }
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
              ThemeConfig.primaryGreen.withOpacity(0.1),
              Colors.white,
              ThemeConfig.secondaryBlue.withOpacity(0.1),
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _pulseAnimation,
                    _rotationAnimation,
                  ]),
                  builder: (context, child) => Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * 2 * 3.14159,
                      child: GlassmorphicContainer(
                        blurRadius: 20,
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
                          ),
                          child: const Icon(
                            Icons.home_work_rounded,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: ThemeConfig.spacing3XL),

                // Brand Name
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            ThemeConfig.primaryGradient.createShader(bounds),
                        child: const Text(
                          'EstateHub',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: ThemeConfig.spacingMD),

                // Loading Text
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: Text(
                      'Loading your experience...',
                      style: ThemeConfig.bodyMedium.copyWith(
                        color: ThemeConfig.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: ThemeConfig.spacingXL),

                // Progress Indicator
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ThemeConfig.primaryGreen,
                        ),
                      ),
                    ),
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
