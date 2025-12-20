import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'welcome_screen.dart';
import 'home_page_screen.dart';

/// Auth gate that checks authentication state and routes accordingly
/// - If user is signed in -> PropertyListingScreen
/// - If user is not signed in -> WelcomeScreen
class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({Key? key}) : super(key: key);

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Small delay to ensure Supabase is fully initialized
    await Future.delayed(const Duration(milliseconds: 100));

    final session = Supabase.instance.client.auth.currentSession;

    if (mounted) {
      if (session != null) {
        // User is signed in, go to home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePageScreen(),
          ),
        );
      } else {
        // User is not signed in, go to welcome screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while checking auth status
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
