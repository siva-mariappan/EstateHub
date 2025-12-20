# Google OAuth Redirect Fix for Flutter Web

## Issue Fixed:
The OAuth redirect was trying to go to `localhost:3000` which doesn't exist. I've updated the code to handle web OAuth properly.

## What I Changed:

### 1. Updated [lib/services/auth_service.dart](lib/services/auth_service.dart)
- Added platform detection with `kIsWeb`
- For web: Uses automatic redirect (current URL)
- For mobile: Uses deep link `io.supabase.flutterquickstart://login-callback/`

## Required: Configure Supabase Redirect URLs

You need to add the Flutter web URL to your Supabase allowed redirect URLs:

### Step 1: Find Your Flutter Web URL

When you run `flutter run -d chrome`, note the URL (usually something like):
- `http://localhost:54603` or
- `http://localhost:XXXXX`

### Step 2: Add to Supabase Dashboard

1. Go to your Supabase Dashboard: https://supabase.com/dashboard
2. Select your project
3. Go to **Authentication** → **URL Configuration**
4. Under **Redirect URLs**, add these URLs:

```
http://localhost:54603
http://localhost:54603/
http://localhost:*
```

The wildcard `http://localhost:*` will match any port Flutter uses.

### Step 3: Also Add These Common URLs:

For development and testing:
```
http://localhost:3000
http://localhost:3000/
http://127.0.0.1:54603
http://127.0.0.1:54603/
```

### Step 4: Set Site URL

In the same **URL Configuration** section:
- **Site URL**: Set to `http://localhost:54603` (or your Flutter web URL)

## Testing the Fix:

1. **Restart your Flutter app** (hot reload won't work for this change):
   ```bash
   # Stop the current app (press 'q' in terminal or Ctrl+C)
   flutter run -d chrome
   ```

2. **Note the URL** that Flutter shows (e.g., `http://localhost:54603`)

3. **Add that URL** to Supabase Dashboard redirect URLs

4. **Try Google Sign-In again**:
   - Click "Sign in with Google"
   - Select your Google account
   - Should redirect back to your app successfully

## How It Works Now:

### Before (Broken):
```
User clicks "Sign in with Google"
  ↓
Opens Google OAuth
  ↓
User selects account
  ↓
Tries to redirect to http://localhost:3000 ❌ (doesn't exist)
```

### After (Fixed):
```
User clicks "Sign in with Google"
  ↓
Opens Google OAuth
  ↓
User selects account
  ↓
Redirects back to current Flutter app URL ✅
  ↓
Supabase handles auth token
  ↓
User is signed in ✅
```

## Alternative: Use Specific Redirect URL

If you prefer to always use a specific port, you can update the config:

```dart
// In lib/services/auth_service.dart
final response = await _supabase.auth.signInWithOAuth(
  OAuthProvider.google,
  redirectTo: kIsWeb ? 'http://localhost:54603' : 'io.supabase.flutterquickstart://login-callback/',
);
```

Then make sure `http://localhost:54603` is in your Supabase redirect URLs.

## Troubleshooting:

### Still getting "This site can't be reached"?
1. Make sure the URL in Supabase Dashboard exactly matches your Flutter app URL
2. Include both with and without trailing slash
3. Wait a few seconds after saving in Supabase Dashboard

### "Invalid redirect URL" error?
- The redirect URL is not in your Supabase allowed list
- Add it in Authentication → URL Configuration

### Google OAuth opens but doesn't redirect back?
- Check browser console for errors
- Make sure Site URL is set in Supabase Dashboard

## Quick Test:

After making these changes, run:
```bash
cd "/Users/sivam/Downloads/realestate/My Realetate project/realestate_app"
flutter run -d chrome
```

1. Note the URL (e.g., `http://localhost:54603`)
2. Add it to Supabase Dashboard
3. Try signing in with Google
4. Should work! ✅

The redirect should now work properly for Google OAuth on Flutter web! 🎉
