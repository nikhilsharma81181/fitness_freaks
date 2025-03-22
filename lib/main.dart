import 'package:fitness_freaks/core/constant/colors/pallate.dart';
import 'package:fitness_freaks/features/homepage/presentation/views/homepage.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/background_gradient.dart';
import 'package:fitness_freaks/features/user/presentation/pages/login_page.dart';
import 'package:fitness_freaks/features/user/presentation/providers/user_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:fitness_freaks/features/user/domain/usecases/usecase_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Custom error widget to filter out mouse tracker errors
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // Ignore specific mouse tracker errors
    if (details.exception is FlutterError && 
        details.exception.toString().contains("mouse_tracker.dart") &&
        details.exception.toString().contains("PointerAddedEvent")) {
      // Return an empty container instead of showing the error
      return const SizedBox.shrink();
    }
    
    // For all other errors, use the default error widget
    return ErrorWidget(details.exception);
  };

  print("App: Initializing Firebase");
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("App: Firebase initialized successfully");
  } catch (e) {
    print("App: Firebase initialization error: $e");
  }

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system overlay style for status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: AppInit()));
}

class AppInit extends ConsumerWidget {
  const AppInit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("AppInit: Starting app initialization");

    // Explicitly trigger repository initialization and wait for it
    // This ensures the repository is initialized before any other providers try to use it
    try {
      ref.watch(initializeRepositoryProvider);
      print("AppInit: Repository initialization triggered");
    } catch (e) {
      print("AppInit: Repository initialization error: $e");
    }

    return const MyApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("MyApp: Building main app");
    return CupertinoApp(
      title: 'Fitness Freaks',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
      ],
      theme: const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: Pallate.accentGreen,
        scaffoldBackgroundColor: Pallate.darkBackground,
        textTheme: CupertinoTextThemeData(
          navLargeTitleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 34,
            color: Colors.white,
          ),
          navTitleTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: Colors.white,
          ),
          textStyle: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("AuthWrapper: Building auth wrapper");

    // Make sure the repository is initialized
    try {
      ref.watch(initializeRepositoryProvider);
    } catch (e) {
      print("AuthWrapper: Repository initialization error: $e");
      // Show error screen if repository initialization fails
      return Scaffold(
        backgroundColor: Pallate.darkBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 20),
              const Text(
                "Failed to initialize app",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                e.toString(),
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Listen to user state changes
    final userState = ref.watch(userNotifierProvider);

    print("AuthWrapper - Current user state: ${userState.status}");

    // Show loading indicator while checking authentication
    if (userState.status == UserStatus.loading ||
        userState.status == UserStatus.initial) {
      return const Scaffold(
        backgroundColor: Pallate.darkBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(),
              SizedBox(height: 20),
              Text(
                "Loading your profile...",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    // Show error screen if there's an authentication error
    if (userState.status == UserStatus.error) {
      return Scaffold(
        backgroundColor: Pallate.darkBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 20),
              const Text(
                "Authentication Error",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                userState.errorMessage ?? "Unknown error",
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              RawMaterialButton(
                fillColor: Pallate.accentGreen,
                onPressed: () {
                  // Retry authentication
                  ref.read(userNotifierProvider.notifier).getCurrentUser();
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    // Navigate based on auth status
    if (userState.status == UserStatus.authenticated) {
      print("User is authenticated, showing HomePage");
      // User is logged in, show the main app
      return const HomePage();
    } else {
      print("User is not authenticated, showing LoginPage");
      // User is not logged in, show the login page
      return const LoginPage();
    }
  }
}

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final titleFontSize = width * 0.065; // ~26 on normal screens
    final subtitleFontSize = width * 0.045; // ~18 on normal screens
    final iconSize = width * 0.16; // ~64 on normal screens

    return Stack(
      children: [
        // Background gradient
        const Positioned.fill(child: BackgroundGradient(tabType: TabType.chat)),

        // Content
        SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.bubble_left_fill,
                  color: Pallate.chatGradient1,
                  size: iconSize,
                ),
                SizedBox(height: width * 0.06), // ~24 on normal screens
                Text(
                  'Chat Feature',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: width * 0.03), // ~12 on normal screens
                Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
