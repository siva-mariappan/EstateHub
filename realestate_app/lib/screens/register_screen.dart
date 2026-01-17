import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/glass_widgets.dart';
import '../widgets/animated_buttons.dart';
import '../widgets/utility_widgets.dart';
import '../widgets/page_transitions.dart';
import '../config/theme_config.dart';
import 'login_screen.dart';
import 'home_page_screen.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Focus nodes
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool _isLoading = false;
  bool _isGoogleSignUp = false;
  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Focus states
  bool _nameFocused = false;
  bool _emailFocused = false;
  bool _phoneFocused = false;
  bool _passwordFocused = false;
  bool _confirmPasswordFocused = false;

  // Password strength
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = ThemeConfig.error;

  late AnimationController _successController;
  late Animation<double> _successAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupFocusListeners();
    _passwordController.addListener(_updatePasswordStrength);
  }

  void _setupAnimations() {
    _successController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _successAnimation = CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    );
  }

  void _setupFocusListeners() {
    _nameFocus.addListener(() {
      setState(() => _nameFocused = _nameFocus.hasFocus);
    });
    _emailFocus.addListener(() {
      setState(() => _emailFocused = _emailFocus.hasFocus);
    });
    _phoneFocus.addListener(() {
      setState(() => _phoneFocused = _phoneFocus.hasFocus);
    });
    _passwordFocus.addListener(() {
      setState(() => _passwordFocused = _passwordFocus.hasFocus);
    });
    _confirmPasswordFocus.addListener(() {
      setState(() => _confirmPasswordFocused = _confirmPasswordFocus.hasFocus);
    });
  }

  void _updatePasswordStrength() {
    final password = _passwordController.text;
    double strength = 0.0;
    String text = '';
    Color color = ThemeConfig.error;

    if (password.isEmpty) {
      strength = 0.0;
      text = '';
    } else if (password.length < 6) {
      strength = 0.25;
      text = 'Weak';
      color = ThemeConfig.error;
    } else if (password.length < 8) {
      strength = 0.5;
      text = 'Fair';
      color = ThemeConfig.warning;
    } else if (password.length < 12) {
      strength = 0.75;
      text = 'Good';
      color = ThemeConfig.secondaryBlue;
    } else {
      strength = 1.0;
      text = 'Strong';
      color = ThemeConfig.success;
    }

    // Check for numbers, special chars, uppercase
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.05;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.05;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.05;

    setState(() {
      _passwordStrength = strength.clamp(0.0, 1.0);
      _passwordStrengthText = text;
      _passwordStrengthColor = color;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _successController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() {
      _isLoading = true;
      _isGoogleSignUp = true;
    });

    try {
      final success = await _authService.signInWithGoogle();

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Opening Google Sign-Up...'),
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
          _isGoogleSignUp = false;
        });
      }
    }
  }

  Future<void> _handleEmailSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please agree to the Terms & Conditions'),
          backgroundColor: ThemeConfig.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.isNotEmpty
            ? _phoneController.text.trim()
            : null,
      );

      // Success animation
      await _successController.forward();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Welcome ${_nameController.text}! Please check your email to verify your account.'),
            backgroundColor: ThemeConfig.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
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
        String message = 'Sign up failed';
        if (e.toString().contains('already registered')) {
          message = 'An account already exists for this email';
        } else if (e.toString().contains('Password')) {
          message = 'Password should be at least 6 characters';
        }

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

  void _showTermsModal() {
    GlassModal.show(
      context: context,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: const EdgeInsets.all(ThemeConfig.spacingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Terms & Conditions', style: ThemeConfig.h4),
            const SizedBox(height: ThemeConfig.spacingLG),
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  'By using EstateHub, you agree to the following terms:\n\n'
                  '1. Account Registration: You must provide accurate information when creating an account.\n\n'
                  '2. Privacy: We collect and use your data as described in our Privacy Policy.\n\n'
                  '3. Property Listings: All property information should be accurate and up-to-date.\n\n'
                  '4. User Conduct: You agree to use the platform responsibly and not engage in fraudulent activities.\n\n'
                  '5. Intellectual Property: All content on EstateHub is protected by copyright.\n\n'
                  '6. Limitation of Liability: EstateHub is not liable for any damages arising from use of the service.\n\n'
                  '7. Modifications: We reserve the right to modify these terms at any time.\n\n'
                  'For the complete terms and conditions, please visit our website.',
                  style: ThemeConfig.bodyMedium.copyWith(
                    color: ThemeConfig.textSecondary,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            const SizedBox(height: ThemeConfig.spacingXL),
            AnimatedGradientButton(
              text: 'I Understand',
              onPressed: () => Navigator.pop(context),
              fullWidth: true,
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
            // Floating particles
            ..._buildFloatingIcons(),

            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(ThemeConfig.spacingXL),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) => Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLogo(),
                            const SizedBox(height: ThemeConfig.spacing2XL),
                            _buildTitle(),
                            const SizedBox(height: ThemeConfig.spacingXL),
                            _buildRegistrationForm(),
                            const SizedBox(height: ThemeConfig.spacingXL),
                            _buildSignInLink(),
                          ],
                        ),
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
            Icons.person_add_outlined,
            Icons.verified_user_outlined,
            Icons.security,
            Icons.check_circle_outline
          ][index % 4],
          delay: index,
        ),
      );
    });
  }

  Widget _buildLogo() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: GlassmorphicContainer(
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
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Column(
            children: [
              Text('Create Account', style: ThemeConfig.h2),
              const SizedBox(height: ThemeConfig.spacingXS),
              Text(
                'Sign up to get started with EstateHub',
                style: ThemeConfig.bodyLarge.copyWith(
                  color: ThemeConfig.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return GlassCard(
      padding: const EdgeInsets.all(ThemeConfig.spacing2XL),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name
            _buildGlassTextField(
              controller: _nameController,
              focusNode: _nameFocus,
              isFocused: _nameFocused,
              hintText: 'Full Name',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: ThemeConfig.spacingXL),

            // Email
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

            // Phone
            _buildGlassTextField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              isFocused: _phoneFocused,
              hintText: 'Phone (Optional)',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: ThemeConfig.spacingXL),

            // Password
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
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),

            // Password Strength Indicator
            if (_passwordController.text.isNotEmpty) ...[
              const SizedBox(height: ThemeConfig.spacingMD),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: _passwordStrength),
                duration: ThemeConfig.normalAnimation,
                curve: Curves.easeOutCubic,
                builder: (context, value, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                ThemeConfig.radiusCircular),
                            child: LinearProgressIndicator(
                              value: value,
                              backgroundColor: ThemeConfig.border,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  _passwordStrengthColor),
                              minHeight: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: ThemeConfig.spacingMD),
                        Text(
                          _passwordStrengthText,
                          style: ThemeConfig.caption.copyWith(
                            color: _passwordStrengthColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: ThemeConfig.spacingXS),
                    Text(
                      'Use 8+ characters with numbers & symbols',
                      style: ThemeConfig.caption.copyWith(
                        color: ThemeConfig.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: ThemeConfig.spacingXL),

            // Confirm Password
            _buildGlassTextField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocus,
              isFocused: _confirmPasswordFocused,
              hintText: 'Confirm Password',
              icon: Icons.lock_outline,
              obscureText: _obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: ThemeConfig.textSecondary,
                ),
                onPressed: () {
                  setState(() =>
                      _obscureConfirmPassword = !_obscureConfirmPassword);
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: ThemeConfig.spacingXL),

            // Terms & Conditions
            GlassmorphicContainer(
              blurRadius: 10,
              opacity: 0.1,
              borderRadius: ThemeConfig.radiusMedium,
              padding: const EdgeInsets.all(ThemeConfig.spacingMD),
              child: Row(
                children: [
                  Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      value: _agreedToTerms,
                      onChanged: (value) {
                        setState(() => _agreedToTerms = value ?? false);
                      },
                      activeColor: ThemeConfig.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _agreedToTerms = !_agreedToTerms);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'I agree to the ',
                          style: ThemeConfig.bodySmall.copyWith(
                            color: ThemeConfig.textSecondary,
                          ),
                          children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: _showTermsModal,
                                child: Text(
                                  'Terms & Conditions',
                                  style: ThemeConfig.bodySmall.copyWith(
                                    color: ThemeConfig.primaryGreen,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: ThemeConfig.spacingXL),

            // Sign Up Button
            AnimatedGradientButton(
              text: 'Create Account',
              onPressed: _isLoading ? null : _handleEmailSignUp,
              isLoading: _isLoading && !_isGoogleSignUp,
              fullWidth: true,
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
            const SizedBox(height: ThemeConfig.spacingXL),

            // OR Divider
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: ThemeConfig.border,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConfig.spacingMD,
                  ),
                  child: Text(
                    'OR',
                    style: ThemeConfig.bodySmall.copyWith(
                      color: ThemeConfig.textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: ThemeConfig.border,
                  ),
                ),
              ],
            ),
            const SizedBox(height: ThemeConfig.spacingXL),

            // Google Sign Up Button
            _GoogleSignUpButton(
              onPressed: _isLoading ? null : _handleGoogleSignUp,
              isLoading: _isGoogleSignUp,
            ),
          ],
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
          style: ThemeConfig.bodyMedium,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: ThemeConfig.bodyMedium.copyWith(
              color: ThemeConfig.textTertiary,
            ),
            prefixIcon: Icon(
              icon,
              color: isFocused
                  ? ThemeConfig.primaryGreen
                  : ThemeConfig.textSecondary,
            ),
            suffixIcon: suffixIcon,
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

  Widget _buildSignInLink() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account? ",
              style: ThemeConfig.bodyMedium.copyWith(
                color: ThemeConfig.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {
                PageTransitions.slideUp(context, const LoginScreen());
              },
              child: Text(
                'Sign In',
                style: ThemeConfig.bodyMedium.copyWith(
                  color: ThemeConfig.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Google Sign-Up button with glass effect
class _GoogleSignUpButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _GoogleSignUpButton({
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
              vertical: ThemeConfig.spacingLG,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: ThemeConfig.primaryGreen,
                    ),
                  )
                else
                  Image.network(
                    'https://img.icons8.com/?size=100&id=17949&format=png&color=000000',
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 24,
                        height: 24,
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
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(width: ThemeConfig.spacingMD),
                Text(
                  isLoading ? 'Signing up...' : 'Sign up with Google',
                  style: ThemeConfig.buttonMedium.copyWith(
                    color: ThemeConfig.textPrimary,
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
      end: const Offset(-0.3, -1.2),
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
          _positionAnimation.value.dx * 30,
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
