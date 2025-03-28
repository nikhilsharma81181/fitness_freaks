import 'package:fitness_freaks/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fitness_freaks/features/user/presentation/providers/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/auth_providers.dart';
import '../../../user/presentation/providers/user_providers.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final userNotifier = ref.watch(userNotifierProvider.notifier);
    
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black, Color(0xFF111827), Colors.black],
              ),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                // Animated content would go here
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tagline
                    Text(
                      'TRAIN. TRACK. TRANSFORM.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color: Colors.blue[400],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Main heading
                    const Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF3B82F6),
                          Color(0xFFA78BFA),
                          Color(0xFFEC4899),
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        'Fitness AI',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Subtitle
                    const SizedBox(height: 24),
                    Text(
                      'Your personal AI-powered fitness companion. '
                      'Transform your workout experience with intelligent guidance.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.grey[300],
                      ),
                    ),

                    // Login buttons
                    const SizedBox(height: 48),
                    _buildLoginButton(
                      context,
                      'Continue with Google',
                      FontAwesomeIcons.google,
                      () => _handleGoogleSignIn(
                        context,
                        authNotifier,
                        userNotifier,
                      ),
                      isPrimary: true,
                    ),
                    const SizedBox(height: 16),
                    _buildLoginButton(
                      context,
                      'Continue with Apple',
                      FontAwesomeIcons.apple,
                      () {
                        // Show coming soon message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Apple Sign-In will be available soon'),
                          ),
                        );
                      },
                      isPrimary: false,
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onTap, {
    bool isPrimary = true,
  }) {
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
      },
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: isPrimary
            ? BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF3B82F6),
                    Color(0xFF8B5CF6),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              )
            : BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn(
    BuildContext context,
    AuthNotifier authNotifier,
    UserNotifier userNotifier,
  ) async {
    try {
      final token = await authNotifier.signInWithGoogle();
      
      if (token != null) {
        // After successful login, try to get the user
        await userNotifier.getUser();
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in failed: $e')),
        );
      }
    }
  }
}
