# App Icon Setup Instructions

## Current Status
The app is configured to use a custom pest control icon located at:
`assets/icons/app_icon.png`

## To Add Your Icon:

### Option 1: Use a Ready-Made Icon
1. Download a pest control icon (1024x1024 PNG) from:
   - https://www.flaticon.com (search "pest control")
   - https://www.iconfinder.com (search "pest control")
   - https://iconscout.com (search "pest control")

2. Save it as `app_icon.png` in `assets/icons/` directory

3. Run the icon generator:
```bash
fvm flutter pub get
fvm flutter pub run flutter_launcher_icons
```

### Option 2: Create Custom Icon
1. Use a design tool (Canva, Figma, Photoshop)
2. Create a 1024x1024 PNG with:
   - Green background (#4CAF50)
   - White pest/bug icon in center
   - Simple, bold design
3. Save as `app_icon.png` in `assets/icons/`
4. Run the generator (see step 3 above)

### Option 3: Use Material Icon Temporarily
Until you have a custom icon, the app will use the default Flutter icon.

## Recommended Icon Design:
- **Background**: Green (#4CAF50) - matches app theme
- **Icon**: White bug/pest symbol
- **Style**: Simple, flat design
- **Size**: 1024x1024 pixels (will be scaled automatically)

## Example Searches:
- "pest control icon"
- "bug spray icon"
- "exterminator icon"
- "insect control icon"
- "pest management icon"

## After Adding Icon:
The icon will appear on:
- ✅ Android home screen
- ✅ iOS home screen
- ✅ App drawer
- ✅ Recent apps
- ✅ Notifications

