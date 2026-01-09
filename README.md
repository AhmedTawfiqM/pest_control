# Pest Control Field Operations App

A comprehensive Flutter mobile application designed for field supervisors in pest control operations. This app enables supervisors to manage field visits, track time, log pest control activities, and manage team assignments.

## Features

### ✅ Phase 1: Authentication & Profile
- **Login Screen**: Secure authentication with email and password
- **Register Screen**: Create new supervisor accounts
- **Profile Management**: View supervisor profile information
- **Demo Credentials**:
  - Email: `admin@pestcontrol.com`
  - Password: `password123`

### ✅ Phase 2: Visit Management (Dashboard)
- **Customer Selection**: Searchable dropdown to select clients
- **Project Selection**: Dynamic filtering based on selected customer
- **Session Timer**: 
  - Start/End visit tracking
  - Real-time elapsed time display
  - Midnight wraparound handling
  - Confirmation modal to prevent accidental termination
- **Visit Summary**: Display date, start time, and end time
- **Team Assignment**: Select participating team members after visit ends

### ⏳ Phase 3: Service Reporting (In Progress)
- **Pest Identification**: Drag-and-drop interface for controlled pests
- **Chemical Logging**: Select chemicals and input quantities
- **Report Submission**: Save complete visit records to local storage

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

This app uses **flutter_bloc** for state management:
- **AuthBloc**: Manages authentication state
- **VisitBloc**: Handles visit creation, timer, and team assignment (in progress)
- **ServiceReportBloc**: Manages pest and chemical logging (planned)

### Why BLoC?
- Excellent separation of concerns
- Testable business logic
- Predictable state transitions
- Great integration with Clean Architecture

## Technology Stack

- **Framework**: Flutter 3.10+
- **Language**: Dart 3.6+
- **Local Database**: Hive 2.2.3
- **State Management**: flutter_bloc 8.1.3
- **Dependency Injection**: get_it 7.6.4
- **Functional Programming**: dartz 0.10.1

## Getting Started

### Prerequisites

- Flutter SDK (3.10 or higher)
- Dart SDK (3.6 or higher)
- Android Studio / VS Code with Flutter extensions
- iOS Simulator (Mac) or Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pest_control_task
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### First Run

On the first app launch:
- The app automatically seeds mock data (customers, projects, team members, pests, chemicals)
- A default supervisor account is created with the credentials shown above
- Data persists locally using Hive

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

### Database Choice
- **Hive** was chosen for its simplicity, speed, and strong Flutter integration
- No encryption implemented (can be added with `hive_secure_storage`)
- All data stored locally with no backend sync (as per requirements)

### Authentication
- Simple email/password authentication stored in Hive
- Passwords stored in plain text (in production, use bcrypt or similar)
- Session management using Hive box for current user tracking

### Timer Implementation
- Timer updates every second for real-time display
- Handles midnight wraparound by comparing date + time
- Visit duration calculated from start/end DateTime objects

### Color Scheme
- **Primary**: Forest Green (#2E7D32) - Represents nature and pest control
- **Secondary**: Orange (#FF6F00) - For warnings and action items
- **Accent**: Earth tones for a professional, trustworthy appearance

## Testing

### Manual Testing Checklist

- [ ] Login with demo credentials
- [ ] Register new supervisor account
- [ ] View profile information
- [ ] Start a new visit
- [ ] Select customer and project
- [ ] Timer runs correctly
- [ ] End visit confirmation modal
- [ ] Select team members
- [ ] Midnight wraparound handling
- [ ] Logout and re-login

### Unit Testing (Planned)
```bash
flutter test
```

## Known Limitations

1. **Service Reporting**: Drag-and-drop pest interface not yet implemented
2. **Visit History**: History page is a placeholder
3. **Password Security**: Passwords stored in plain text (demo purposes only)
4. **No Network**: Fully offline, no API integration
5. **Limited Validation**: Basic form validation only

## Future Enhancements

- [ ] Complete service reporting with drag-and-drop
- [ ] Visit history with filtering and search
- [ ] Export reports as PDF
- [ ] Charts and analytics dashboard
- [ ] Photo upload for pest evidence
- [ ] Offline sync with backend API
- [ ] Push notifications for reminders
- [ ] Multi-language support
- [ ] Dark mode theme

## Project Structure Highlights

### Clean Code Practices
- Single Responsibility Principle
- Dependency Inversion
- Interface segregation
- Clear naming conventions
- Comprehensive comments

### Git Workflow
- Feature branches for each major component
- Descriptive commit messages
- Atomic commits per logical change

## Contact & Support

For questions or issues, please contact the development team or create an issue in the repository.

## License

This project is created as a technical assessment and is for demonstration purposes only.

---

**Built with ❤️ using Flutter and Clean Architecture**

