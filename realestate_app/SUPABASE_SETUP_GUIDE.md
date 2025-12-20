# Supabase Google Authentication Setup Guide

Your app is now fully integrated with Supabase! Follow these steps to complete the setup.

## ✅ What's Already Done:

1. ✅ Supabase package installed (`supabase_flutter: ^2.0.0`)
2. ✅ Supabase initialized in `main.dart`
3. ✅ `AuthService` fully implemented with Google OAuth
4. ✅ Login screen updated with Supabase authentication
5. ✅ Register screen updated with Supabase authentication
6. ✅ Home screen updated to use Supabase User type
7. ✅ Configuration file created at `lib/config/supabase_config.dart`

## 🔑 Step 1: Get Your Supabase Anon Key

1. Go to your Supabase Dashboard: https://supabase.com/dashboard
2. Select your project (or create a new one)
3. Go to **Settings** → **API**
4. Copy your **anon public** key
5. Open `lib/config/supabase_config.dart` and replace `YOUR_SUPABASE_ANON_KEY_HERE` with your actual anon key

```dart
// lib/config/supabase_config.dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://rthjbtgsrdjasyxbohez.supabase.co';
  static const String supabaseAnonKey = 'YOUR_ACTUAL_ANON_KEY_HERE'; // ← Paste here
}
```

## 🔐 Step 2: Set Up Google OAuth in Supabase

### A. Create Google OAuth Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable **Google+ API**:
   - Go to **APIs & Services** → **Library**
   - Search for "Google+ API"
   - Click **Enable**

4. Create OAuth 2.0 credentials:
   - Go to **APIs & Services** → **Credentials**
   - Click **+ CREATE CREDENTIALS** → **OAuth client ID**
   - Application type: **Web application**
   - Name: `EstateHub Supabase`

5. Add Authorized redirect URIs:
   ```
   https://rthjbtgsrdjasyxbohez.supabase.co/auth/v1/callback
   ```

6. Click **Create** and copy:
   - **Client ID**
   - **Client Secret**

### B. Configure Google OAuth in Supabase

1. Go to your Supabase Dashboard
2. Navigate to **Authentication** → **Providers**
3. Find **Google** and click to expand
4. Enable the Google provider
5. Paste your:
   - **Client ID** (from Google Cloud Console)
   - **Client Secret** (from Google Cloud Console)
6. Click **Save**

## 📱 Step 3: Configure Deep Links (for mobile apps)

### For Android:

1. Open `android/app/src/main/AndroidManifest.xml`
2. Add the following inside the `<activity>` tag:

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data
    android:scheme="io.supabase.flutterquickstart"
    android:host="login-callback" />
</intent-filter>
```

### For iOS:

1. Open `ios/Runner/Info.plist`
2. Add the following before the closing `</dict>`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>io.supabase.flutterquickstart</string>
    </array>
  </dict>
</array>
```

### For Web:

No additional configuration needed! Google OAuth will work in the browser automatically.

## 🌐 Step 4: Test on Web (Easiest)

1. Open terminal in your project directory
2. Run:
   ```bash
   flutter run -d chrome
   ```

3. Test the authentication:
   - Click **Sign in with Google** → Should open Google account picker
   - Click **Sign up with Google** → Should open Google account picker
   - Try **Email/Password** sign-up and sign-in

## 📧 Step 5: Configure Email Templates (Optional)

Supabase sends confirmation emails for new sign-ups. To customize:

1. Go to **Authentication** → **Email Templates**
2. Edit the templates:
   - **Confirm signup** - Sent when new users sign up
   - **Reset password** - Sent when users request password reset
   - **Magic Link** - Sent for passwordless login

## 🔒 Step 6: Configure Site URL (Important!)

1. Go to **Authentication** → **URL Configuration**
2. Set **Site URL** to your app's URL:
   - For development: `http://localhost:3000`
   - For production: Your actual domain

## ✨ Features Now Available:

### Email/Password Authentication:
- ✅ Sign up with email, password, name, and phone
- ✅ Sign in with email and password
- ✅ Password reset via email
- ✅ Email verification

### Google OAuth:
- ✅ Sign in with Google
- ✅ Sign up with Google
- ✅ Automatic profile picture from Google
- ✅ Display name from Google account

### User Management:
- ✅ User profile display (name, email, photo)
- ✅ Sign out functionality
- ✅ User metadata stored (full_name, phone)

## 🔍 How Google OAuth Works:

1. User clicks "Sign in with Google"
2. App opens Google OAuth consent screen in browser/webview
3. User selects Google account and grants permissions
4. Google redirects back to your app via callback URL
5. Supabase creates/updates user record automatically
6. User is signed in!

## 🎯 Testing Checklist:

- [ ] Updated `supabase_config.dart` with anon key
- [ ] Enabled Google provider in Supabase Dashboard
- [ ] Added Google OAuth credentials
- [ ] Tested email/password sign-up
- [ ] Tested email/password sign-in
- [ ] Tested Google sign-in (opens Google account picker)
- [ ] Tested password reset
- [ ] Tested sign-out

## 🐛 Troubleshooting:

### "Invalid API key" error:
- Make sure you replaced `YOUR_SUPABASE_ANON_KEY_HERE` in `supabase_config.dart`
- Check that the anon key is correct in Supabase Dashboard

### Google OAuth not working:
- Verify Google provider is enabled in Supabase Dashboard
- Check that redirect URI matches exactly: `https://rthjbtgsrdjasyxbohez.supabase.co/auth/v1/callback`
- Make sure Google+ API is enabled in Google Cloud Console

### Email not being sent:
- Check Supabase email rate limits (free tier has limits)
- Verify email templates are configured
- Check spam folder

### Deep links not working on mobile:
- Verify AndroidManifest.xml or Info.plist configuration
- Check that the scheme matches: `io.supabase.flutterquickstart`

## 📚 Useful Links:

- [Supabase Dashboard](https://supabase.com/dashboard)
- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Supabase Flutter Documentation](https://supabase.com/docs/reference/dart/introduction)

## 🎉 You're All Set!

Once you've completed Step 1 (adding the anon key) and Step 2 (Google OAuth setup), your app will be fully functional with Supabase authentication!

The callback URL you provided is already configured in the code:
```
https://rthjbtgsrdjasyxbohez.supabase.co/auth/v1/callback
```

Just add your anon key and you're ready to go! 🚀
