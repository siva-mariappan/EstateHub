import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/glass_widgets.dart';
import '../widgets/animated_buttons.dart';
import '../widgets/page_transitions.dart';
import '../config/theme_config.dart';
import 'register_screen.dart';
import 'home_page_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _isLoading = false;
  bool _isGoogleSignIn = false;
  bool _rememberMe = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  bool _emailFocused = false;
  bool _passwordFocused = false;

  late AnimationController _shakeController;
  late AnimationController _successController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _successAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupFocusListeners();
  }

  void _setupAnimations() {
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _successAnimation = CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    );
  }

  void _setupFocusListeners() {
    _emailFocus.addListener(() {
      setState(() => _emailFocused = _emailFocus.hasFocus);
    });
    _passwordFocus.addListener(() {
      setState(() => _passwordFocused = _passwordFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _shakeController.dispose();
    _successController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailSignIn() async {
    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) {
      _shakeController.forward().then((_) => _shakeController.reverse());
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // Success animation
      await _successController.forward();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Welcome back!'),
            backgroundColor: ThemeConfig.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          PageTransitions.buildFadeScale(
            builder: (context) => const HomePageScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String message = 'Sign in failed';
        if (e.toString().contains('Invalid login credentials')) {
          message = 'Invalid email or password';
        } else if (e.toString().contains('Email not confirmed')) {
          message = 'Please verify your email first';
        }

        setState(() => _errorMessage = message);
        _shakeController.forward().then((_) => _shakeController.reverse());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: ThemeConfig.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _isGoogleSignIn = true;
    });

    try {
      final success = await _authService.signInWithGoogle();

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Opening Google Sign-In...'),
            backgroundColor: ThemeConfig.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: ThemeConfig.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isGoogleSignIn = false;
        });
      }
    }
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();

    GlassModal.show(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spacingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reset Password', style: ThemeConfig.h4),
            const SizedBox(height: ThemeConfig.spacingLG),
            Text(
              'Enter your email address to receive a password reset link.',
              style: ThemeConfig.bodyMedium.copyWith(
                color: ThemeConfig.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ThemeConfig.spacingXL),
            GlassmorphicContainer(
              blurRadius: 10,
              opacity: 0.15,
              borderRadius: ThemeConfig.radiusMedium,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(ThemeConfig.spacingLG),
                ),
              ),
            ),
            const SizedBox(height: ThemeConfig.spacingXL),
            Row(
              children: [
                Expanded(
                  child: AnimatedOutlineButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: ThemeConfig.spacingMD),
                Expanded(
                  flex: 2,
                  child: AnimatedGradientButton(
                    text: 'Send',
                    onPressed: () async {
                      if (emailController.text.isNotEmpty) {
                        try {
                          await _authService
                              .resetPassword(emailController.text.trim());
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text('Password reset email sent!'),
                                backgroundColor: ThemeConfig.success,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      ThemeConfig.radiusMedium),
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.toString()}'),
                                backgroundColor: ThemeConfig.error,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      ThemeConfig.radiusMedium),
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
            // Floating particles background
            ..._buildFloatingIcons(),

            // Main content
            SafeArea(
              child: Center(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(ThemeConfig.spacingXL),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 550),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _OrderlyFall(
                            delay: 0,
                            child: _buildLogo(),
                          ),
                          const SizedBox(height: ThemeConfig.spacing2XL),
                          _OrderlyFall(
                            delay: 150,
                            child: _buildTitle(),
                          ),
                          const SizedBox(height: ThemeConfig.spacing2XL),
                          _OrderlyFall(
                            delay: 300,
                            child: _buildLoginForm(),
                          ),
                          const SizedBox(height: ThemeConfig.spacingXL),
                          _OrderlyFall(
                            delay: 450,
                            child: _buildSignUpLink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFloatingIcons() {
    return List.generate(8, (index) {
      return Positioned(
        top: 50.0 + (index * 100),
        left: (index % 2 == 0) ? 20.0 : null,
        right: (index % 2 != 0) ? 20.0 : null,
        child: _FloatingIcon(
          icon: [
            Icons.lock_outline,
            Icons.vpn_key_outlined,
            Icons.security,
            Icons.shield_outlined
          ][index % 4],
          delay: index,
        ),
      );
    });
  }

  Widget _buildLogo() {
    return GlassmorphicContainer(
      blurRadius: 20,
      opacity: 0.2,
      borderRadius: ThemeConfig.radiusCircular,
      padding: const EdgeInsets.all(ThemeConfig.spacingXL),
      boxShadow: ThemeConfig.shadowLevel3(
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
          size: 72,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text('Welcome Back!', style: ThemeConfig.h2),
        const SizedBox(height: ThemeConfig.spacingSM),
        Text(
          'Sign in to continue to EstateHub',
          style: ThemeConfig.bodyLarge.copyWith(
            color: ThemeConfig.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(_shakeAnimation.value, 0),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: ThemeConfig.spacing2XL,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Email Field
                _buildGlassTextField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  isFocused: _emailFocused,
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: ThemeConfig.spacingXL),

                // Password Field
                _buildGlassTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  isFocused: _passwordFocused,
                  hintText: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: ThemeConfig.textSecondary,
                      size: 26,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: ThemeConfig.spacingXL),

                // Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.0,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() => _rememberMe = value ?? false);
                            },
                            activeColor: ThemeConfig.primaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Text(
                          'Remember me',
                          style: ThemeConfig.bodyMedium.copyWith(
                            color: ThemeConfig.textSecondary,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: _showForgotPasswordDialog,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ThemeConfig.spacingMD,
                          vertical: ThemeConfig.spacingSM,
                        ),
                      ),
                      child: Text(
                        'Forgot Password?',
                        style: ThemeConfig.bodyMedium.copyWith(
                          color: ThemeConfig.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: ThemeConfig.spacingXL),

                // Sign In Button
                SizedBox(
                  height: 60,
                  child: AnimatedGradientButton(
                    text: 'Sign In',
                    onPressed: _isLoading ? null : _handleEmailSignIn,
                    isLoading: _isLoading && !_isGoogleSignIn,
                    fullWidth: true,
                  ),
                ),
                const SizedBox(height: ThemeConfig.spacingXL),

                // OR Text Only (No Lines)
                Center(
                  child: Text(
                    'OR',
                    style: ThemeConfig.bodyMedium.copyWith(
                      color: ThemeConfig.textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: ThemeConfig.spacingXL),

                // Google Sign-In Button
                SizedBox(
                  height: 60,
                  child: _GoogleSignInButton(
                    onPressed: _isLoading ? null : _handleGoogleSignIn,
                    isLoading: _isGoogleSignIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isFocused,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return AnimatedContainer(
      duration: ThemeConfig.fastAnimation,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
        boxShadow: isFocused
            ? ThemeConfig.shadowLevel3(color: ThemeConfig.primaryGreen)
            : ThemeConfig.shadowLevel1(),
      ),
      child: GlassmorphicContainer(
        blurRadius: 10,
        opacity: isFocused ? 0.2 : 0.15,
        borderRadius: ThemeConfig.radiusMedium,
        border: Border.all(
          color: isFocused
              ? ThemeConfig.primaryGreen
              : Colors.white.withOpacity(0.3),
          width: isFocused ? 2 : 1.5,
        ),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: ThemeConfig.bodyLarge.copyWith(fontSize: 17),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: ThemeConfig.bodyLarge.copyWith(
              color: ThemeConfig.textTertiary,
              fontSize: 17,
            ),
            prefixIcon: Icon(
              icon,
              color: isFocused
                  ? ThemeConfig.primaryGreen
                  : ThemeConfig.textSecondary,
              size: 26,
            ),
            suffixIcon: suffixIcon,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 22,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: ThemeConfig.bodyMedium.copyWith(
            color: ThemeConfig.textSecondary,
            fontSize: 15,
          ),
        ),
        TextButton(
          onPressed: () {
            PageTransitions.slideUp(context, const RegisterScreen());
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConfig.spacingSM,
              vertical: ThemeConfig.spacingSM,
            ),
          ),
          child: Text(
            'Sign Up',
            style: ThemeConfig.bodyMedium.copyWith(
              color: ThemeConfig.primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
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
        curve: Curves.easeOut,
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

/// Google Sign-In button with glass effect
class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _GoogleSignInButton({
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      blurRadius: 10,
      opacity: 0.15,
      borderRadius: ThemeConfig.radiusMedium,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: ThemeConfig.primaryGreen,
                    ),
                  )
                else
                  Image.network(
                    'https://img.icons8.com/?size=100&id=17949&format=png&color=000000',
                    width: 26,
                    height: 26,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4285F4),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'G',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    isLoading ? 'Signing in...' : 'Sign in with Google',
                    style: ThemeConfig.buttonMedium.copyWith(
                      color: ThemeConfig.textPrimary,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.visible,
                    maxLines: 1,
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

/// Floating icon with fade and movement animation
class _FloatingIcon extends StatefulWidget {
  final IconData icon;
  final int delay;

  const _FloatingIcon({
    required this.icon,
    this.delay = 0,
  });

  @override
  State<_FloatingIcon> createState() => _FloatingIconState();
}

class _FloatingIconState extends State<_FloatingIcon>
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
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 0.0), weight: 1),
    ]).animate(_controller);

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1.2),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(seconds: widget.delay), () {
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
          _positionAnimation.value.dy * 80,
        ),
        child: Opacity(
          opacity: _opacityAnimation.value,
          child: Icon(
            widget.icon,
            size: 32,
            color: ThemeConfig.primaryGreen,
          ),
        ),
      ),
    );
  }
}
