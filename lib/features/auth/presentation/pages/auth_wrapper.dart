import 'package:flutter/material.dart';
import '../../../home/presentation/pages/main_wrapper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../user/presentation/providers/user_providers.dart';
import '../../../user/presentation/providers/user_state.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_state.dart';
import 'login_page.dart';
// Import the actual ProfilePage when available
// import '../../../user/presentation/pages/profile_page.dart';

/// Provider to track onboarding completion
final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

/// Wrapper widget that handles navigation based on authentication state
class AuthWrapper extends HookConsumerWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for authentication changes to trigger user fetch
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      // When becoming authenticated, fetch user data if not already loaded/loading
      if (next.isAuthenticated && !(previous?.isAuthenticated ?? false)) {
        final userState = ref.read(userNotifierProvider);
        // Check if user data isn't already loaded or in the process of loading
        if (userState.user == null && userState.status != UserStatus.loading) {
          ref.read(userNotifierProvider.notifier).getUser();
        }
      }
    });

    final authState = ref.watch(authNotifierProvider);
    // Removed userState watch as it's not directly needed for navigation logic here
    // final userState = ref.watch(userNotifierProvider);
    // Removed onboarding watch for now, focus on user loading fix
    // final onboardingComplete = ref.watch(onboardingCompleteProvider);

    // Show loading screen while checking auth status
    if (authState.status == AuthStatus.loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If not authenticated, show login page
    if (!authState.isAuthenticated) {
      return const LoginPage();
    }

    // If authenticated and onboarding is complete, show main wrapper
    return const MainWrapper();
  }
}

// Placeholder for onboarding page
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Fitness AI!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Complete your profile to get personalized workouts',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Complete onboarding
                final container = ProviderScope.containerOf(context);
                container.read(onboardingCompleteProvider.notifier).state =
                    true;
              },
              child: const Text('Complete Onboarding'),
            ),
          ],
        ),
      ),
    );
  }
}

// Home page is now implemented in the home/presentation/pages folder

// Profile page is now implemented in the profile/presentation/pages folder
