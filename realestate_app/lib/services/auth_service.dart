import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  // Get Supabase client instance
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Auth state changes stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign in with Google OAuth
  Future<bool> signInWithGoogle() async {
    try {
      print('🔵 Starting Google Sign-In with Supabase...');

      if (kIsWeb) {
        // For web, use current origin as redirect
        // Add prompt=select_account to force account selection screen
        final response = await _supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: kIsWeb
            ? '${Uri.base.origin}/'
            : 'io.supabase.flutterquickstart://login-callback/',
          queryParams: {
            'prompt': 'select_account', // Force account selection screen
            'access_type': 'offline', // Request offline access
          },
        );
        print('✅ Google Sign-In initiated successfully');
        return response;
      } else {
        // For mobile, use deep link
        // Add prompt=select_account to force account selection screen
        final response = await _supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: 'io.supabase.flutterquickstart://login-callback/',
          queryParams: {
            'prompt': 'select_account', // Force account selection screen
            'access_type': 'offline', // Request offline access
          },
        );
        print('✅ Google Sign-In initiated successfully');
        return response;
      }
    } catch (e) {
      print('❌ Error signing in with Google: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    try {
      print('🔵 Starting email sign-in...');

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('✅ Email sign-in successful');
      return response;
    } catch (e) {
      print('❌ Error signing in with email: $e');
      rethrow;
    }
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    try {
      print('🔵 Starting email sign-up...');

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          if (fullName != null) 'full_name': fullName,
          if (phone != null) 'phone': phone,
        },
      );

      print('✅ Email sign-up successful');
      return response;
    } catch (e) {
      print('❌ Error signing up with email: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      print('🔵 Starting sign out...');
      await _supabase.auth.signOut();
      print('✅ Sign out successful');
    } catch (e) {
      print('❌ Error signing out: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      print('🔵 Sending password reset email...');
      await _supabase.auth.resetPasswordForEmail(email);
      print('✅ Password reset email sent');
    } catch (e) {
      print('❌ Error sending password reset email: $e');
      rethrow;
    }
  }

  // Check if user is signed in
  bool isSignedIn() {
    return _supabase.auth.currentUser != null;
  }

  // Get user display name
  String? getUserDisplayName() {
    final user = _supabase.auth.currentUser;
    // Try to get full_name from user metadata, fallback to email
    return user?.userMetadata?['full_name'] ??
           user?.userMetadata?['name'] ??
           user?.email?.split('@')[0];
  }

  // Get user email
  String? getUserEmail() {
    return _supabase.auth.currentUser?.email;
  }

  // Get user photo URL
  String? getUserPhotoUrl() {
    final user = _supabase.auth.currentUser;
    // Try different possible avatar fields
    return user?.userMetadata?['avatar_url'] ??
           user?.userMetadata?['picture'];
  }

  // Get user phone
  String? getUserPhone() {
    return _supabase.auth.currentUser?.phone ??
           _supabase.auth.currentUser?.userMetadata?['phone'];
  }

  // Update user profile
  Future<UserResponse> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      print('🔵 Updating user profile...');

      final response = await _supabase.auth.updateUser(
        UserAttributes(
          data: {
            if (fullName != null) 'full_name': fullName,
            if (phone != null) 'phone': phone,
            if (avatarUrl != null) 'avatar_url': avatarUrl,
          },
        ),
      );

      print('✅ Profile updated successfully');
      return response;
    } catch (e) {
      print('❌ Error updating profile: $e');
      rethrow;
    }
  }
}
