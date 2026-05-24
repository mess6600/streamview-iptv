# 🚀 Quick Start Guide - Build APK with GitHub Actions (FREE)

## Step 1: Create a GitHub Account (if you don't have one)
- Go to https://github.com/signup
- Sign up for free (takes 2 minutes)

## Step 2: Create a New Public Repository
1. Click the **+** icon → **New repository**
2. Name it: `streamview-iptv` (or any name)
3. Make it **PUBLIC** (important for free unlimited builds)
4. Click **Create repository**

## Step 3: Upload This Code
### Option A: Using Git (Command Line)
```bash
# Extract the ZIP file first
unzip streamview_iptv_project.zip

# Navigate to the project
cd tivimate_clone

# Initialize git
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit - StreamView IPTV"

# Connect to your GitHub repo (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/streamview-iptv.git

# Push
git branch -M main
git push -u origin main
```

### Option B: Using GitHub Web UI (No commands)
1. Go to your new repository on GitHub
2. Click **"Add file"** → **"Upload files"**
3. Drag and drop ALL files from the `tivimate_clone` folder
4. Click **"Commit changes"**

## Step 4: Trigger the Build
The build starts automatically when you push code. To trigger manually:
1. Go to your repository on GitHub
2. Click **"Actions"** tab
3. Click **"Build Flutter APK"**
4. Click **"Run workflow"** → **"Run workflow"**

## Step 5: Download Your APK
1. Wait ~5-10 minutes for build to complete (green checkmark ✅)
2. Click the completed workflow run
3. Scroll down to **"Artifacts"** section
4. Click **"StreamView-IPTV-APK"** to download the ZIP
5. Extract the ZIP - your `app-release.apk` is inside!

## 📱 Install on Android
```bash
# Enable "Unknown Sources" in Android Settings → Security
# Transfer APK to your phone (USB, email, cloud drive, etc.)
# Tap the APK file to install
```

## 🔥 Pro Tips

### Auto-build on every update
Whenever you push new code to the `main` branch, GitHub Actions automatically builds a new APK.

### Get APK via direct link (after first build)
After the first successful build, you can download APKs directly from:
```
https://github.com/YOUR_USERNAME/streamview-iptv/actions
```

### Create a release with APK attached
```bash
# Tag a release
git tag -a v1.0.0 -m "First release"
git push origin v1.0.0
```
The APK will automatically attach to the GitHub Release page!

## ⚠️ Important Notes
- **Public repos = Unlimited free builds**
- **Private repos = 2,000 minutes/month free**
- Build takes 5-10 minutes (installs Flutter + Android SDK + builds)
- APK is unsigned - for personal use only. For Play Store, you need signing keys.

## 🆘 Troubleshooting

### Build fails?
1. Check the **"Actions"** tab for error logs
2. Common fixes:
   - Make sure `pubspec.yaml` is in the root
   - Ensure all files were uploaded (not just some)

### Can't install APK?
- Enable **"Install unknown apps"** for your file manager/browser
- Make sure your Android version is 5.0+ (API 21+)

## 📁 What's in the Build?
The workflow automatically:
1. Sets up Ubuntu Linux runner
2. Installs Java 17 (required for Android)
3. Installs Flutter 3.24.0 (cached for speed)
4. Runs `flutter pub get` (downloads dependencies)
5. Runs `flutter build apk --release` (creates APK)
6. Uploads APK as downloadable artifact

## 🎉 That's It!
You now have a FREE automated build system. Every time you update your code, a new APK is built automatically!
