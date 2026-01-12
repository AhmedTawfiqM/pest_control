# Pest Control Field Operations App

A comprehensive Flutter mobile application designed for field supervisors in pest control operations. This app enables supervisors to manage field visits, track time, log pest control activities, and manage team assignments.

## Features

### ✅ Phase 1: Authentication & Profile
- **Login Screen**: Secure authentication with email and password
- **Register Screen**: Create new supervisor accounts
- **Profile Management**: View supervisor profile information and statistics
- **Language Selection**: Switch between English and Arabic
- **Demo Credentials**:
  - Email: `admin@pestcontrol.com`
  - Password: `password123`

### ✅ Phase 2: Visit Management (Dashboard)
- **Animated Dashboard**: Professional animations with pulsing icons and smooth transitions
- **Customer Selection**: Searchable dropdown to select clients
- **Project Selection**: Dynamic filtering based on selected customer
- **Session Timer**: 
  - Start/End visit tracking
  - Real-time elapsed time display
  - Midnight wraparound handling
  - Confirmation modal to prevent accidental termination
- **Visit Summary**: Display date, start time, and end time
- **Team Assignment**: Select participating team members after visit ends
- **Visit History**: View all completed visits with detailed information

### ✅ Phase 3: Service Reporting
- **Pest Identification**: Drag-and-drop interface for controlled pests
- **Chemical Logging**: Select chemicals and input quantities
- **Report Submission**: Save complete visit records to local storage
- **Report Viewing**: View detailed service reports for completed visits

### ✅ Phase 4: Internationalization & UX
- **Multi-language Support**: Complete localization for English and Arabic
- **RTL Support**: Full right-to-left layout support for Arabic
- **Professional Animations**: 
  - Pulsing start visit icon with glow effect
  - Smooth fade-in and slide-up animations
  - Card entry animations
- **Responsive Design**: Adapts to different screen sizes

## Architecture

This project follows **Clean Architecture** principles with a feature-based modular structure:

```
lib/
├── core/                          # Core utilities and shared code
│   ├── constants/                 # App-wide constants
│   ├── database/                  # Hive database initialization
│   ├── di/                        # Dependency injection setup
│   ├── error/                     # Error handling
│   ├── theme/                     # App theme configuration
│   └── widgets/                   # Reusable widgets
│
├── features/                      # Feature modules
│   ├── auth/                      # Authentication feature
│   │   ├── data/
│   │   │   ├── datasources/       # Hive local data source
│   │   │   ├── models/            # Hive models with adapters
│   │   │   └── repositories/      # Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/          # Business entities
│   │   │   ├── repositories/      # Repository interfaces
│   │   │   └── usecases/          # Business logic
│   │   └── presentation/
│   │       ├── bloc/              # State management
│   │       ├── pages/             # UI screens
│   │       └── widgets/           # Feature-specific widgets
│   │
│   ├── dashboard/                 # Dashboard feature
│   ├── visits/                    # Visit management feature
│   └── service_report/            # Service reporting feature
│
└── main.dart                      # App entry point
```

### Key Architectural Layers

1. **Domain Layer** (Entities, Use Cases, Repository Interfaces)
   - Pure Dart code with no dependencies on Flutter or external packages
   - Contains business logic and entities

2. **Data Layer** (Models, Data Sources, Repository Implementations)
   - Handles data persistence using Hive
   - Converts between domain entities and data models

3. **Presentation Layer** (BLoC, Pages, Widgets)
   - Manages UI state with flutter_bloc
   - Handles user interactions and displays data

## State Management

I went with **flutter_bloc** for managing state throughout the app. It keeps business logic completely separate from UI code, which makes everything easier to test and maintain.

### How BLoC Works Here

The pattern is pretty straightforward:
- **Events**: Things that happen (user taps a button, data loads, etc.)
- **States**: Snapshots of what the app looks like at any moment
- **BLoCs**: The brain that takes events and figures out what the new state should be

### The BLoCs in This App

**AuthBloc** - Handles login, registration, and keeping track of who's logged in

**VisitSetupBloc** - Manages the whole visit lifecycle: starting visits, tracking time, ending them

**TeamSelectionBloc** - Takes care of selecting which team members worked on a visit

**ServiceReportBloc** - Handles creating service reports with pests and chemicals

**LanguageCubit** - Simple one for switching between English and Arabic

### Why BLoC?

I chose BLoC because:
- It keeps UI and logic completely separate
- Makes testing way easier
- State changes are predictable and easy to debug
- Fits perfectly with Clean Architecture
- Scales well as the app grows

Considered alternatives like Provider and GetX, but BLoC gives better structure for apps with complex business logic like this one.

## Technology Stack

- **Flutter**: 3.35.6 (stable channel)
- **Dart**: 3.6+
- **Database**: Hive 2.2.3
- **State Management**: flutter_bloc 8.1.3
- **DI**: get_it 7.6.4
- **Functional Programming**: dartz 0.10.1
- **Code Gen**: build_runner 2.4.6

### Key Dependencies

#### Core
- `flutter_bloc: ^8.1.3` - State management
- `hive: ^2.2.3` - Local NoSQL database
- `hive_flutter: ^1.1.0` - Hive Flutter integration
- `equatable: ^2.0.5` - Value equality for BLoC states

#### Code Generation
- `hive_generator: ^2.0.1` - Hive type adapter generation
- `build_runner: ^2.4.6` - Code generation runner

#### Utilities
- `get_it: ^7.6.4` - Dependency injection
- `dartz: ^0.10.1` - Functional programming (Either, Option)
- `intl: ^0.18.1` - Internationalization and date formatting

## Feature Implementation Timeline

### ✅ Completed Features

#### Phase 1: Foundation (Week 1)
- [x] Project setup with Clean Architecture
- [x] Hive database integration
- [x] Authentication system (login/register)
- [x] BLoC setup for state management
- [x] Mock data seeding
- [x] Profile page with statistics
- [x] Language selection (English/Arabic)

#### Phase 2: Visit Management (Week 2)
- [x] Dashboard with animated UI
- [x] Customer and project selection
- [x] Visit lifecycle management
- [x] Real-time timer with midnight handling
- [x] End visit confirmation dialog
- [x] Team member selection page
- [x] Visit history page with details

#### Phase 3: Service Reporting (Week 3)
- [x] Service report creation page
- [x] Drag-and-drop pest selection
- [x] Chemical selection with quantities
- [x] Report submission and persistence
- [x] Report viewing functionality
- [x] Integration with visit lifecycle

#### Phase 4: Polish & UX (Week 4)
- [x] Complete internationalization (English/Arabic)
- [x] RTL layout support for Arabic
- [x] Professional animations (pulse, fade, slide)
- [x] Localization of all pages
- [x] Error handling improvements
- [x] UI/UX refinements

## Getting Started

### Prerequisites

Make sure you have these installed before running the app:

- **Flutter SDK 3.35.6** (stable channel)
  - Get it from: https://docs.flutter.dev/get-started/install
- **Dart 3.6+** (bundled with Flutter)
- **Android Studio** or **VS Code** with Flutter plugin
- **An emulator** or **physical device**:
  - iOS Simulator (Mac only)
  - Android Emulator
  - USB-connected phone

### Quick Setup Check

Run this to make sure everything's working:
```bash
flutter doctor
```

Fix any issues it finds before moving forward.

### Installation & Build Instructions

#### 1. Clone and Navigate
```bash
git clone <repository-url>
cd pest_control
```

#### 2. Get Dependencies
```bash
flutter pub get
```

This grabs all the packages from `pubspec.yaml`.

#### 3. Generate Hive Adapters
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This creates the type adapters needed for Hive database. The flag just makes sure old files get cleaned up.

#### 4. Run It!

**From Terminal:**
```bash
# Simple run
flutter run

# Pick a specific device
flutter devices
flutter run -d <device-id>

# Release mode (faster, no debug info)
flutter run --release
```

**From Android Studio:**
- Open project
- Pick your device/emulator from dropdown
- Hit the green play button (or Shift+F10)

**From VS Code:**
- Open project
- Press F5
- Pick a device if prompted

### Building for Production

**Android:**
```bash
flutter build apk --release              # APK file
flutter build appbundle --release        # For Play Store
```
You'll find the APK in `build/app/outputs/flutter-apk/app-release.apk`

**iOS (Mac only):**
```bash
flutter build ios --release
```
Then open `ios/Runner.xcworkspace` in Xcode to create the archive.

### First Run Experience

On the first app launch:
1. **Automatic Data Seeding**: The app automatically seeds mock data including:
   - 2 customers with 5 projects total
   - 3 team members
   - 10 pest types
   - 5 chemical types
   - 1 default supervisor account

2. **Demo Account**: Use these credentials to login:
   - Email: `admin@pestcontrol.com`
   - Password: `password123`

3. **Data Persistence**: All data is stored locally using Hive and persists between app sessions

### Troubleshooting

#### Common Issues:

**1. Build Runner Errors**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**2. Hive Type Adapter Missing**
- Ensure all `@HiveType` and `@HiveField` annotations are correct
- Run build_runner command again

**3. Dependencies Not Resolving**
```bash
flutter pub cache repair
flutter pub get
```

**4. iOS Build Issues (macOS)**
```bash
cd ios
pod install --repo-update
cd ..
flutter clean
flutter run
```

**5. Android Build Issues**
- Check `android/local.properties` for correct SDK path
- Ensure Java 11 or higher is installed
- Update Android SDK tools in Android Studio

## Mock Data

The app is pre-seeded with the following data:

### Customers & Projects

**Global Logistics Hub (C001)**
- Warehouse A - Pest Exclusion (P-101)
- Main Office - General Disinfection (P-102)

**Sunshine Hospitality Group (C002)**
- Kitchen Sanitation Suite (P-201)
- Guest Rooms - Bedbug Prevention (P-202)
- Outdoor Pool Perimeter (P-203)

### Team Members
- Ahmed Hassan (T-01)
- Maria Garcia (T-02)
- John Doe (T-03)

### Pests
Ants, Cockroaches, Flies, Rodents, Termites, Bedbugs, Mosquitoes, Spiders, Fleas, Ticks

### Chemicals
- Pyrethroid Spray (ml)
- Boric Acid Powder (g)
- Fipronil Gel (drops)
- Permethrin Solution (ml)
- Diatomaceous Earth (g)

## Design Decisions & Assumptions

### Why Clean Architecture?

Went with Clean Architecture because it makes the codebase way more maintainable and testable. Features are isolated, so you can work on one without breaking others. It's a bit more setup initially, but totally worth it for a project like this.

### Why BLoC for State Management?

BLoC was the clear winner here. It keeps business logic separate from UI, which makes testing easier and the code more predictable. Considered Provider and GetX, but BLoC's structure is better for complex apps with lots of business logic.

### Local Storage with Hive

Chose Hive because it's fast, lightweight, and doesn't need native dependencies. Perfect for an offline-first app like this. No backend needed means the app works anywhere, even with zero connectivity.

**Note**: This is a demo, so passwords aren't hashed and there's no encryption. In production, you'd want to add proper security with bcrypt for passwords and encrypted storage for sensitive data.

### Authentication Approach

Kept it simple with email/password stored locally. Good enough for a single-device demo app. For production, you'd want JWT tokens, biometric auth, and a proper backend.

### UI/UX Choices

- **Material Design 3**: Modern, accessible, and familiar to users
- **Animations**: Added pulse/fade/slide animations to make the app feel more polished
- **Internationalization**: English and Arabic with full RTL support
- **Drag-and-Drop**: More intuitive than checkboxes for selecting controlled pests

### Timer Implementation

The visit timer updates every second so supervisors can see it's actually running. Handles edge cases like midnight wraparound (when a visit spans across two days) and app suspension.

### Team Selection Flow

Decided to have supervisors select team members AFTER the visit ends, not before. In reality, team members might join/leave during a visit, so this gives more accurate tracking.

### Data Model

Visit lifecycle is straightforward: Created → Active → Ended → Completed (with report). Only one visit can be active at a time to keep things simple.

### Mock Data

Auto-seeded realistic data (customers, projects, team members, pests, chemicals) so you can test the app immediately without manual setup.

### Performance

Used ValueListenableBuilder for Hive to get efficient reactive updates. Animation controllers are properly disposed to prevent memory leaks. Everything runs smoothly at 60fps.

### Key Assumptions

- **Users**: Field supervisors with smartphone experience
- **Environment**: Often offline or poor connectivity
- **Data**: Single-user, local storage is enough
- **Security**: Demo-level (not production-grade)
- **Scale**: One supervisor, dozens of visits per month
- **Devices**: Modern smartphones (iOS/Android)
- **Languages**: English and Arabic cover the main markets

## Testing

### Manual Testing Checklist

#### Authentication Flow
- [ ] Login with demo credentials
- [ ] Login with invalid credentials (error handling)
- [ ] Register new supervisor account
- [ ] Register with existing email (duplicate check)
- [ ] Logout and re-login (session persistence)

#### Dashboard & Visits
- [ ] View welcome card with supervisor name
- [ ] Observe pulsing animation on start visit icon
- [ ] Navigate to visit history
- [ ] Start a new visit
- [ ] Select customer and project
- [ ] Verify timer runs correctly (second-by-second)
- [ ] End visit with confirmation modal
- [ ] Cancel end visit dialog
- [ ] Select team members after visit ends
- [ ] Verify visit appears in history

#### Service Reports
- [ ] Create service report from active visit
- [ ] Drag and drop pests
- [ ] Select chemicals and enter quantities
- [ ] Submit report successfully
- [ ] View submitted report
- [ ] Verify report data persistence

#### Localization
- [ ] Switch language to Arabic
- [ ] Verify RTL layout
- [ ] Switch back to English
- [ ] Verify all screens are translated
- [ ] Check language persists after app restart

#### Edge Cases
- [ ] Midnight wraparound during active visit
- [ ] App suspension/resumption with active timer
- [ ] Device rotation handling
- [ ] Low memory conditions
- [ ] Concurrent user actions

### Running Automated Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Test Coverage

Currently basic tests are implemented. A comprehensive test suite covering unit tests, widget tests, and integration tests would be needed for production.

## Known Limitations

This is a demo app, so some things are kept simple:

**Security**
- Passwords are in plain text (would use bcrypt in production)
- No data encryption
- No session timeout

**Features Not Included**
- Photo uploads for pest evidence
- PDF report export
- Analytics dashboard
- Push notifications
- Backend API / cloud sync

**Testing**
- Basic tests only
- Would need comprehensive unit/widget/integration tests for production

For a production app, you'd want to add proper security, comprehensive testing, backend integration, and more features.

## Future Enhancements

Some ideas for future versions:

**High Priority**
- Backend API and data sync
- Photo uploads for pest evidence
- PDF report export
- Push notifications
- Better security (password hashing, encryption)

**Nice to Have**
- Analytics dashboard with charts
- Dark mode
- More languages (Spanish, French)
- Geolocation for visit verification
- QR code scanning for projects
- Voice notes

**Down the Road**
- Tablet layouts
- Web dashboard
- CRM integration
- Customer portal

## Contact & Support

For questions or issues, please contact the development team or create an issue in the repository.

## Project Status

All core features are implemented and working:
- ✅ Authentication & Profile
- ✅ Visit Management with Timer
- ✅ Team Member Selection
- ✅ Service Reports
- ✅ English/Arabic Support
- ✅ Animations and Polish

The app is fully functional for demo purposes. For production use, you'd want to add security improvements, comprehensive tests, and backend integration.

## License

This project is created as a technical assessment and is for demonstration purposes only.

---

**Built with ❤️ using Flutter and Clean Architecture**

**Last Updated**: January 12, 2026

