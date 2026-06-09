# 🏋️ TrackFit — Smart Fitness Tracking App

> A modern, production-ready Flutter application that helps users monitor their fitness journey, track activities, visualize progress, and stay motivated — all through an intuitive, feature-rich experience.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)


## 🚀 Features

### 👤 User Authentication
- Secure sign-up and login via **Firebase Authentication**
- Email and password authentication
- Persistent user sessions across app restarts

### 📊 Fitness Progress Tracking
- Track daily workouts and fitness activities
- Monitor fitness goals and achievements
- Store and manage personal fitness records

### 📈 Interactive Analytics Dashboard
- Beautiful graphical representation of fitness data
- Progress visualization using **FL Chart**
- Daily, weekly, and monthly performance insights

### 🗺️ Location Tracking
- Real-time activity tracking using **Flutter Maps**
- Monitor running, walking, and cycling routes
- View tracked paths and activity locations on an interactive map

### 💾 Offline Data Storage
- Fast local data persistence using **Hive**
- Seamless offline access to fitness records
- Efficient data management and retrieval

### 💎 Freemium Business Model
- Free access to all core fitness tracking features
- Premium tier for advanced analytics and enhanced UX
- Scalable, subscription-ready architecture

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Flutter, Dart |
| **State Management** | BLoC Pattern |
| **Backend / Auth** | Firebase Authentication |
| **Local Storage** | Hive Database |
| **Data Visualization** | FL Chart |
| **Maps & Location** | Flutter Maps |

---

## 🏗️ Architecture

TrackFit follows a clean, scalable architecture using the **BLoC pattern** with a clear separation of concerns.

```
lib/
│
├── presentation/
│   ├── screens/          # All app screens
│   ├── widgets/          # Reusable UI components
│   └── bloc/             # BLoC state management
│
├── data/
│   ├── models/           # Data models
│   ├── repositories/     # Data access layer
│   └── services/         # External service integrations
│
├── core/
│   ├── constants/        # App-wide constants
│   ├── utilities/        # Helper functions
│   └── themes/           # App theming
│
└── main.dart
```

**Architecture Highlights:**
- Strict separation of concerns
- Scalable and maintainable code structure
- Reusable UI components
- Testable business logic
- Efficient state management via BLoC

---

## 📱 Screens

| Section | Screens |
|---------|---------|
| **Authentication** | Login, Registration |
| **Dashboard** | Fitness Overview, Activity Summary, Progress Analytics |
| **Activity Tracking** | Route Tracking, Workout Monitoring, Goal Management |
| **Profile** | User Information, Fitness Statistics, Premium Features |

---

## ⚡ Installation

### 1. Clone the Repository

```bash
git clone [https://github.com/vedant1780/Fitness-Tracker]
cd trackfit
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

1. Create a new [Firebase project](https://console.firebase.google.com/)
2. Add Android and/or iOS apps to the project
3. Download the configuration files and place them:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`

### 4. Run the Application

```bash
flutter run
```

---

## 🔥 Key Learning Outcomes

Through building TrackFit, practical experience was gained in:

- Building production-ready Flutter applications
- Implementing the **BLoC** state management pattern
- Integrating **Firebase Authentication**
- Managing offline data with **Hive**
- Creating interactive data visualizations with **FL Chart**
- Implementing map-based real-time tracking with **Flutter Maps**
- Designing scalable mobile application architecture
- Developing a **freemium-based product model**

---

## 🎯 Future Enhancements

- [ ] Social fitness challenges and leaderboards
- [ ] AI-powered personalized workout recommendations
- [ ] Wearable device integration (Apple Watch, Fitbit, etc.)
- [ ] Nutrition and calorie tracking
- [ ] Curated workout plans and live coaching
- [ ] Subscription management system (RevenueCat / Stripe)
- [ ] Cloud synchronization across devices

---

## 👨‍💻 Developer

**Vedant Verma**
*Flutter Developer | Mobile App Developer | AI Enthusiast*

**Skills:** Flutter · Dart · Firebase · BLoC · Hive · REST APIs · Mobile App Architecture

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

> ⭐ If you found this project useful, consider giving it a star!
