import 'package:fitness_freaks/core/constant/colors/pallate.dart';
import 'package:fitness_freaks/features/fitness/presentation/views/fitness_tab.dart';
import 'package:fitness_freaks/features/homepage/presentation/views/home_view.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/background_gradient.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/glass_tab_bar.dart';
import 'package:fitness_freaks/features/user/domain/entities/user.dart';
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
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Google Sign-In with scopes
  GoogleSignIn().signInSilently();

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
    // Explicitly trigger repository initialization and wait for it
    // This ensures the repository is initialized before any other providers try to use it
    ref.watch(initializeRepositoryProvider);

    return const MyApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
    // Make sure the repository is initialized
    ref.watch(initializeRepositoryProvider);

    // Use a try-catch to safely handle potential errors during initialization
    try {
      // Listen to user state changes
      final userState = ref.watch(userNotifierProvider);

      // Show loading indicator while checking authentication
      if (userState.status == UserStatus.loading ||
          userState.status == UserStatus.initial) {
        return const Center(child: CupertinoActivityIndicator());
      }

      // Navigate based on auth status
      if (userState.status == UserStatus.authenticated) {
        // User is logged in, show the main app
        return const HomePage();
      } else {
        // User is not logged in, show the login page
        return const LoginPage();
      }
    } catch (e) {
      // Handle initialization errors gracefully
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.exclamationmark_circle,
              color: CupertinoColors.systemRed,
              size: 50,
            ),
            const SizedBox(height: 16),
            const Text(
              'Initialization Error',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'There was a problem initializing the app: ${e.toString()}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 24),
            CupertinoButton(
              color: Pallate.accentGreen,
              onPressed: () {
                // Attempt to restart app initialization
                ref.invalidate(initializeRepositoryProvider);
                ref.invalidate(userNotifierProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeView(),
    const FitnessTab(),
    const ChatTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Current tab content
          _tabs[_currentIndex],

          // Custom glass tab bar positioned at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlassTabBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.house_fill),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.heart_fill),
                  label: 'Fitness',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.bubble_left_fill),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_fill),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userNotifierProvider);
    final isAuthenticated = userState.status == UserStatus.authenticated;
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Background gradient
        const Positioned.fill(
          child: BackgroundGradient(tabType: TabType.profile),
        ),

        // Content
        SafeArea(
          child:
              isAuthenticated
                  ? _buildAuthenticatedContent(
                    context,
                    ref,
                    userState.user,
                    width,
                  )
                  : _buildUnauthenticatedContent(context, width),
        ),
      ],
    );
  }

  Widget _buildAuthenticatedContent(
    BuildContext context,
    WidgetRef ref,
    User? user,
    double width,
  ) {
    final titleFontSize = width * 0.06; // ~24 on normal screens
    final subtitleFontSize = width * 0.04; // ~16 on normal screens

    return Padding(
      padding: EdgeInsets.all(width * 0.06), // ~24 on normal screens
      child: Column(
        children: [
          // Profile header
          Row(
            children: [
              // Profile image
              Container(
                width: width * 0.2, // ~80 on normal screens
                height: width * 0.2, // ~80 on normal screens
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Pallate.accentGreen, width: 2),
                ),
                child: Center(
                  child: Icon(
                    CupertinoIcons.person_fill,
                    size: width * 0.1, // ~40 on normal screens
                    color: Pallate.accentGreen,
                  ),
                ),
              ),
              SizedBox(width: width * 0.04), // ~16 on normal screens
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'User',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: width * 0.01), // ~4 on normal screens
                    Text(
                      user?.email ?? '',
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: width * 0.1), // ~40 on normal screens
          // Settings/options
          _buildSettingsItem(
            icon: CupertinoIcons.person,
            title: 'Edit Profile',
            onTap: () {},
            width: width,
          ),

          _buildSettingsItem(
            icon: CupertinoIcons.bell,
            title: 'Notifications',
            onTap: () {},
            width: width,
          ),

          _buildSettingsItem(
            icon: CupertinoIcons.settings,
            title: 'Settings',
            onTap: () {},
            width: width,
          ),

          _buildSettingsItem(
            icon: CupertinoIcons.question_circle,
            title: 'Help & Support',
            onTap: () {},
            width: width,
          ),

          const Spacer(),

          // Logout button
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              await ref.read(userNotifierProvider.notifier).signOut();
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: width * 0.04,
              ), // ~16 on normal screens
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.destructiveRed),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: CupertinoColors.destructiveRed,
                    fontWeight: FontWeight.w600,
                    fontSize: subtitleFontSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnauthenticatedContent(BuildContext context, double width) {
    final titleFontSize = width * 0.065; // ~26 on normal screens
    final subtitleFontSize = width * 0.045; // ~18 on normal screens
    final buttonFontSize = width * 0.04; // ~16 on normal screens
    final iconSize = width * 0.16; // ~64 on normal screens

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.person_fill,
            color: Pallate.profileGradient1,
            size: iconSize,
          ),
          SizedBox(height: width * 0.06), // ~24 on normal screens
          Text(
            'Profile',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: width * 0.03), // ~12 on normal screens
          Text(
            'Sign in to access your profile',
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(height: width * 0.08), // ~32 on normal screens
          CupertinoButton(
            color: Pallate.accentGreen,
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: Text(
              'Sign In or Create Account',
              style: TextStyle(fontSize: buttonFontSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double width,
  }) {
    final fontSize = width * 0.04; // ~16 on normal screens
    final iconSize = width * 0.045; // ~18 on normal screens

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: width * 0.04), // ~16 on normal screens
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, // ~16 on normal screens
          vertical: width * 0.04, // ~16 on normal screens
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: width * 0.05,
            ), // ~20 on normal screens
            SizedBox(width: width * 0.04), // ~16 on normal screens
            Text(
              title,
              style: TextStyle(fontSize: fontSize, color: Colors.white),
            ),
            const Spacer(),
            Icon(
              CupertinoIcons.chevron_right,
              color: Colors.white,
              size: iconSize,
            ),
          ],
        ),
      ),
    );
  }
}
