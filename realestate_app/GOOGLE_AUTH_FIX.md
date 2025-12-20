# ✅ Google OAuth Fix - Complete Solution

## What I Fixed in the Code:

Updated [lib/services/auth_service.dart](lib/services/auth_service.dart:21-24) to:
- Automatically use the current Flutter app URL as the redirect
- Uses `Uri.base.origin` to get the actual running URL
- No more hardcoded URLs!

## 🚨 REQUIRED: Update Supabase Dashboard

**The code fix alone won't work!** You MUST add the redirect URLs to Supabase Dashboard.

### Step-by-Step Fix:

#### 1. Start Your Flutter App First

```bash
cd "/Users/sivam/Downloads/realestate/My Realetate project/realestate_app"
flutter run -d chrome
```

**Note the URL** that appears in the output. For example:
```
A Dart VM Service on Chrome is available at: http://127.0.0.1:54603/...
                                              ^^^^^^^^^^^^^^^^^^
                                              This is your URL!
```

#### 2. Go to Supabase Dashboard

Direct link: https://supabase.com/dashboard/project/rthjbtgsrdjasyxbohez/auth/url-configuration

Or manually:
1. Go to https://supabase.com/dashboard
2. Click on your project: `rthjbtgsrdjasyxbohez`
3. Click **Authentication** (left sidebar)
4. Click **URL Configuration**

#### 3. Update Redirect URLs

In the **Redirect URLs** section, you should see `http://localhost:3000` - **this is the problem!**

**Remove** `http://localhost:3000` and **add ALL of these**:

```
http://localhost:54603/
http://localhost:54604/
http://localhost:54605/
http://127.0.0.1:54603/
http://127.0.0.1:54604/
http://127.0.0.1:54605/
http://localhost:*/
```

The last one (`http://localhost:*/`) is a **wildcard** that matches any port!

#### 4. Update Site URL

In the same page, find **Site URL** and set it to:
```
http://localhost:54603
```

(Use the actual port number from step 1)

#### 5. Save Changes

Click **Save** at the bottom of the page.

#### 6. Test Google Sign-In

1. Go back to your Flutter app
2. Hot restart: Press `R` in the terminal (capital R)
3. Click "Sign in with Google"
4. Should now redirect correctly! ✅

## Why This Happens:

1. **Flutter uses random ports** (54603, 54604, etc.) - NOT port 3000
2. **Supabase needs to know** which URLs are allowed for OAuth redirects
3. **Security feature**: Prevents unauthorized redirect URLs

## Troubleshooting:

### Still Getting "This site can't be reached"?

**Check 1**: Make sure the URL in Supabase exactly matches your Flutter app URL
```bash
# In Flutter terminal, look for this line:
A Dart VM Service on Chrome is available at: http://127.0.0.1:XXXXX/
# Add http://127.0.0.1:XXXXX/ to Supabase Dashboard
```

**Check 2**: Did you click Save in Supabase Dashboard?

**Check 3**: Try hot restart (press `R`) instead of hot reload

**Check 4**: Clear browser cache or use incognito mode

### "Invalid redirect URL" Error?

This means the URL is NOT in your Supabase allowed list. Solution:
1. Check what URL appears in the browser address bar
2. Add that EXACT URL to Supabase Dashboard
3. Include trailing slash: `http://localhost:54603/`

### OAuth Opens But Doesn't Come Back?

1. Check browser console (F12) for errors
2. Make sure you added the wildcard: `http://localhost:*/`
3. Try adding both with and without trailing slash

## Quick Copy-Paste for Supabase:

Add these to **Redirect URLs** section:

```
http://localhost:54603/
http://localhost:54604/
http://localhost:54605/
http://127.0.0.1:54603/
http://127.0.0.1:54604/
http://127.0.0.1:54605/
http://localhost:*/
```

## Visual Guide:

```
┌─────────────────────────────────────────┐
│  Supabase Dashboard                     │
│  ├─ Project Settings                    │
│  ├─ API                                 │
│  └─ Authentication                      │
│     └─ URL Configuration  ← GO HERE     │
│        ├─ Site URL                      │
│        │  └─ http://localhost:54603    │
│        └─ Redirect URLs                 │
│           ├─ http://localhost:*/       │
│           ├─ http://localhost:54603/   │
│           └─ [Add your URLs here]      │
└─────────────────────────────────────────┘
```

## Summary:

✅ **Code**: Fixed - now uses correct redirect URL automatically
⏳ **Supabase Dashboard**: You need to add URLs (5 minutes)
✅ **Backend API**: Already using port 8001

After updating Supabase Dashboard, Google Sign-In will work perfectly! 🎉

---

**Need Help?**
- Supabase Dashboard: https://supabase.com/dashboard/project/rthjbtgsrdjasyxbohez
- This guide: You're reading it! 📖
