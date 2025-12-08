
import 'package:go_router/go_router.dart';
import 'package:tarckfit/screens/account/account_and_security_page.dart';
import 'package:tarckfit/screens/account/accountpage1.dart';
import 'package:tarckfit/screens/account/add_payment.dart';
import 'package:tarckfit/screens/account/helpndsupport.dart';
import 'package:tarckfit/screens/account/light_achievements.dart';
import 'package:tarckfit/screens/account/light_weight_tracker.dart';
import 'package:tarckfit/screens/account/linked_account_page.dart';
import 'package:tarckfit/screens/account/payment_method.dart';
import 'package:tarckfit/screens/account/preferences.dart';
import 'package:tarckfit/screens/account/premium_subscription.dart';
import 'package:tarckfit/screens/account/terms.dart';
import 'package:tarckfit/screens/account/water_tracker.dart';
import 'package:tarckfit/screens/history/history.dart';
import 'package:tarckfit/screens/home/light_home_screen.dart';
import 'package:tarckfit/screens/onboarding/forgot_password.dart';
import 'package:tarckfit/screens/onboarding/light_settings.dart';
import 'package:tarckfit/screens/onboarding/light_welcome_screen.dart';
import 'package:tarckfit/screens/onboarding/onboarding_step_screen.dart';
import 'package:tarckfit/screens/onboarding/otp_screen.dart';
import 'package:tarckfit/screens/onboarding/personal_info.dart';
import 'package:tarckfit/screens/onboarding/select_your_gender_screen.dart';
import 'package:tarckfit/screens/onboarding/sign_in.dart';
import 'package:tarckfit/screens/onboarding/sign_up.dart';
import 'package:tarckfit/screens/report/data_analytic_page.dart';
import 'package:tarckfit/screens/report/report_page.dart';
import 'package:tarckfit/screens/splash/light_splash_screen.dart';
import 'package:tarckfit/screens/steplive/track_screen.dart';
import 'package:tarckfit/services/billing_and_subscription.dart';
import 'package:tarckfit/services/payment_methods_for_subscription.dart';

class MyAppRoutes {
  final GoRouter router = GoRouter(
    initialLocation: '/', // default route
    routes: [
      GoRoute(
        name: 'splash',
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: 'welcome',
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        name: 'signup',
        path: '/signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        name: 'signin',
        path: '/signin',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        name: 'gender',
        path: '/gender',
        builder: (context, state) => const GenderSelectionScreen(),
      ),

      GoRoute(
        name: 'onboarding',
        path: '/onboarding',
        builder: (context, state) => const OnboardingFlow(),
      ),
      GoRoute(
        name: 'forgot',
        path: '/forgot',
        builder: (context, state) => const Screen19(),
      ),

      GoRoute(
        name: 'apphome',
        path: '/apphome',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        name: 'track',
        path: '/track',
        builder: (context, state) => TrackScreen(),
      ),
      GoRoute(
        name: 'report',
        path: '/report',
        builder: (context, state) => ReportPage(),
      ),

      GoRoute(
        name: 'history',
        path: '/history',
        builder: (context, state) => Screen34(),
      ),
      GoRoute(
        name: 'acccountpage',
        path: '/accountpage',
        builder: (context, state) => AccountPage1(),
      ),
      GoRoute(
        name: 'planupgrade',
        path: '/planupgrade',
        builder: (context, state) => Screen38(),
      ),
      GoRoute(
        name: 'paymentmethods',
        path: '/paymentmethods',
        builder: (context, state) => Screen40(),
      ),
      GoRoute(
        name: 'addpaymentmethods',
        path: '/addpaymentmethods',
        builder: (context, state) => AddPaymentScreen(),
      ),
      GoRoute(
        name: 'preferences',
        path: '/preferences',
        builder: (context, state) => PreferencesScreen(),
      ),
      GoRoute(
        name: 'linkedaccounts',
        path: '/linkedaccounts',
        builder: (context, state) => LinkedAccountsPage(),
      ),
      GoRoute(
        name: 'billingandsubs',
        path: '/billingandsubs',
        builder: (context, state) => BillingAndSubscriptionPage(),
      ),
      GoRoute(
        name: 'accountsandsecurity',
        path: '/accountsandsecurity',
        builder: (context, state) => AccountAndSecurityPage(),
      ),
      GoRoute(
        name: 'personalinfo',
        path: '/personalinfo',
        builder: (context, state) => PersonalInfoPage(),
      ),
      GoRoute(
        name: 'watertracker',
        path: '/watertracker',
        builder: (context, state) => Screen47(),
      ),
      GoRoute(
        name: 'weighttracker',
        path: '/weighttracker',
        builder: (context, state) => WeightTrackerScreen(),
      ),
      GoRoute(
        name: 'dataanalytics',
        path: '/dataanalytics',
        builder: (context, state) => DataAnalyticsPage(),
      ),
      GoRoute(
        name: 'helpandsupp',
        path: '/helpandsupp',
        builder: (context, state) => HelpSupportScreen(),
      ),
      GoRoute(
        name: 'achievements',
        path: '/achievements',
        builder: (context, state) => AchievementsScreen(),
      ),

      GoRoute(
        name: 'terms',
        path: '/terms',
        builder: (context, state) => TermsOfServiceScreen(),
      ),
      GoRoute(
        name: 'appappear',
        path: '/appappear',
        builder: (context, state) => LightSettings(),
      ),
      GoRoute(
        name: 'accpay',
        path: '/accpay',
        builder: (context, state) => PaymentMethodsScreen(),
      ),
      GoRoute(
        name: 'otp',
        path: '/otp',
        builder: (context, state) => Screen20(),
      )


    ],
  );
}
