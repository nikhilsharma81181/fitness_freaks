import 'package:fitness_freaks/core/constant/colors/pallate.dart';
import 'package:fitness_freaks/core/di/providers.dart';
import 'package:fitness_freaks/features/user/presentation/providers/auth_provider.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/background_gradient.dart';
import 'package:fitness_freaks/features/user/presentation/providers/google_auth_provider.dart';
import 'package:fitness_freaks/features/user/presentation/providers/user_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  bool _isSignUp = false;
  final _nameController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _createNewUser() async {
    try {
      // Check if the user exists in your backend
      // If not, create a new user record
      // This will depend on your user repository implementation
      final userRepository = await ref.read(userRepositoryProvider.future);
      await userRepository.createOrUpdateUser();
    } catch (e) {
      print('Error creating new user: $e');
      throw e;
    }
  }

  Future<void> _handleSuccessfulLogin() async {
    // Navigate to the appropriate screen after successful login
    // For example, you might want to navigate to the home screen
    Navigator.of(context).pushReplacementNamed('/home');
  }

  Future<void> _signInWithGoogle() async {
    try {
      print('Login page: Starting Google Sign-In');
      // Set loading state
      setState(() => _isButtonPressed = true);

      // Use the googleAuthNotifierProvider to sign in
      final result =
          await ref
              .read(googleAuthNotifierProvider.notifier)
              .signInWithGoogle();

      // Handle the result
      result.fold(
        (failure) {
          // Handle failure
          print('Login page: Google Sign-In failed: ${failure.props}');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Google Sign-In failed: ${failure.props}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (token) async {
          // Success - token is the JWT from your backend
          print('Login page: Google Sign-In succeeded with token');

          // Update Dio with the token
          ref.read(dioProvider.notifier).updateToken(token);

          // Update auth state
          ref.read(authProvider.notifier).saveToken(token);

          // Get user data if needed
          try {
            await ref.read(userNotifierProvider.notifier).getCurrentUser();
            print('Login page: User data fetched successfully');
          } catch (e) {
            print('Login page: Error fetching user data: $e');
          }

          // Create user if needed
          try {
            await _createNewUser();
            print('Login page: User created successfully');
          } catch (e) {
            print('Login page: Error creating user: $e');
          }

          // Navigate to appropriate screen
          if (mounted) {
            await _handleSuccessfulLogin();
          }
        },
      );
    } catch (e) {
      print('Login page: Google Sign-In threw exception: ${e.toString()}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google Sign-In failed: ${e.toString()}'),
          ),
        );
      }
    } finally {
      // Reset button state
      if (mounted) {
        setState(() => _isButtonPressed = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userNotifierProvider);
    final isLoading = userState.status == UserStatus.loading;

    // Disable interaction during loading
    if (isLoading) {
      return Center(child: CupertinoActivityIndicator());
    }

    return _buildContent(userState, isLoading);
  }

  Widget _buildContent(UserState userState, bool isLoading) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          // Background
          const Positioned.fill(
            child: BackgroundGradient(tabType: TabType.profile),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 7),

                  // Animated content
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // App tagline
                          Text(
                            'TRAIN. TRACK. TRANSFORM.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                              color: Pallate.accentGreen,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Main heading
                          const Text(
                            'Welcome to',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          ShaderMask(
                            shaderCallback:
                                (bounds) => const LinearGradient(
                                  colors: [
                                    Pallate.accentGreen,
                                    Color(0xFF8BE9FD),
                                  ],
                                ).createShader(bounds),
                            child: const Text(
                              'Fitness Freaks',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Subtitle
                          const SizedBox(height: 24),
                          Text(
                            'Your personal fitness companion powered by advanced tracking. Transform your workout experience with intelligent guidance.',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Login buttons
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          // Error message if any
                          if (userState.status == UserStatus.error &&
                              userState.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.destructiveRed
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: CupertinoColors.destructiveRed
                                        .withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons
                                          .exclamationmark_triangle_fill,
                                      color: CupertinoColors.destructiveRed,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        userState.errorMessage!,
                                        style: const TextStyle(
                                          color: CupertinoColors.destructiveRed,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Loading indicator
                          if (isLoading)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: Center(
                                child: CupertinoActivityIndicator(
                                  radius: 16,
                                  color: CupertinoColors.activeBlue,
                                ),
                              ),
                            ),

                          // Google sign in button
                          _buildAuthButton(
                            'Continue with Google',
                            FontAwesomeIcons.google,
                            _signInWithGoogle,
                            isLoading: isLoading,
                            isPrimary: true,
                          ),
                          const SizedBox(height: 16),

                          // Apple sign in button
                          _buildAuthButton(
                            'Continue with Apple',
                            FontAwesomeIcons.apple,
                            () {
                              // Apple Sign In not implemented yet
                            },
                            isLoading: isLoading,
                            isPrimary: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthButton(
    String text,
    IconData icon,
    VoidCallback onTap, {
    required bool isLoading,
    bool isPrimary = true,
  }) {
    final buttonColor = isPrimary ? Colors.white : Colors.white;
    final textColor =
        isPrimary ? const Color.fromARGB(255, 3, 71, 63) : Colors.white;

    return RawMaterialButton(
      padding: EdgeInsets.zero,
      onPressed:
          isLoading
              ? null
              : () {
                setState(() => _isButtonPressed = true);
                onTap();
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted) setState(() => _isButtonPressed = false);
                });
              },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration:
            isPrimary
                ? BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Pallate.accentGreen, Color(0xFF8BE9FD)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Pallate.accentGreen.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                )
                : BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
        child:
            isLoading || _isButtonPressed
                ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoActivityIndicator(
                        color:
                            isPrimary
                                ? const Color.fromARGB(255, 3, 71, 63)
                                : Colors.white,
                        radius: 10,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Signing in...",
                        style: TextStyle(
                          color:
                              isPrimary
                                  ? const Color.fromARGB(255, 3, 71, 63)
                                  : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      icon,
                      color: isPrimary ? Colors.black87 : Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
