####🏋️ TrackFit - Smart Fitness Tracking App

TrackFit is a modern fitness tracking application built with Flutter that helps users monitor their fitness journey, track activities, visualize progress, and stay motivated through an intuitive and feature-rich experience. The application follows a freemium model, providing essential fitness tracking features for free while offering advanced capabilities for premium users.

🚀 Features
👤 User Authentication
Secure sign up and login using Firebase Authentication
Email and password authentication
Persistent user sessions
📊 Fitness Progress Tracking
Track daily workouts and fitness activities
Monitor fitness goals and achievements
Store and manage user fitness records
📈 Interactive Analytics Dashboard
Beautiful graphical representation of fitness data
Progress visualization using FL Chart
Daily, weekly, and monthly performance insights
🗺️ Location Tracking
Real-time activity tracking using Flutter Maps
Monitor running, walking, and cycling routes
View tracked paths and activity locations
💾 Offline Data Storage
Fast local data persistence using Hive
Seamless offline access to fitness records
Efficient data management and retrieval
💎 Freemium Business Model
Free access to core fitness tracking features
Premium features for advanced analytics and enhanced user experience
Scalable subscription-ready architecture
🛠️ Tech Stack
Frontend
Flutter
Dart
State Management
BLoC Pattern
Backend Services
Firebase Authentication
Local Storage
Hive Database
Data Visualization
FL Chart
Maps & Location Services
Flutter Maps
🏗️ Architecture

The application follows a scalable and maintainable architecture using the BLoC pattern.

lib/
│
├── presentation/
│   ├── screens/
│   ├── widgets/
│   └── bloc/
│
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
│
├── core/
│   ├── constants/
│   ├── utilities/
│   └── themes/
│
└── main.dart
Architecture Highlights
Separation of concerns
Scalable code structure
Reusable components
Testable business logic
Efficient state management
📱 Screens
Authentication
Login Screen
Registration Screen
Dashboard
Fitness Overview
Activity Summary
Progress Analytics
Activity Tracking
Route Tracking
Workout Monitoring
Goal Management
Profile
User Information
Fitness Statistics
Premium Features
🔥 Key Learning Outcomes

Through TrackFit, I gained practical experience in:

Building production-ready Flutter applications
Implementing BLoC state management
Integrating Firebase Authentication
Managing offline data with Hive
Creating data visualizations with FL Chart
Implementing map-based tracking features
Designing scalable mobile application architecture
Developing freemium-based product models
⚡ Installation
Clone the Repository
git clone https://github.com/yourusername/trackfit.git
cd trackfit
Install Dependencies
flutter pub get
Configure Firebase
Create a Firebase project
Add Android/iOS apps
Download configuration files
Place:
google-services.json in Android app folder
GoogleService-Info.plist in iOS Runner folder
Run the Application
flutter run
📸 Screenshots

Add your application screenshots here:

assets/screenshots/login.png
assets/screenshots/dashboard.png
assets/screenshots/tracking.png
assets/screenshots/analytics.png
🎯 Future Enhancements
Social fitness challenges
AI-powered workout recommendations
Wearable device integration
Nutrition tracking
Workout plans and coaching
Subscription management system
Cloud synchronization
👨‍💻 Developer

Vedant Verma

Flutter Developer | Mobile App Developer | AI Enthusiast

Skills
Flutter
Dart
Firebase
BLoC
Hive
REST APIs
Mobile App Architecture
📄 License

This project is licensed under the MIT License.

⭐ If you found this project useful, consider giving it a star!
