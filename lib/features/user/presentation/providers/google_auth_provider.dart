import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_freaks/core/di/providers.dart';
import 'package:fitness_freaks/core/error/failures.dart';
import 'package:fitness_freaks/features/user/data/datasources/auth_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// GoogleSignIn provider
final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

// State notifier provider for Google Auth
final googleAuthNotifierProvider =
    StateNotifierProvider<GoogleAuthNotifier, AsyncValue<String>>((ref) {
      final firebaseAuth = ref.watch(firebaseAuthProvider);
      final dio = ref.watch(dioProvider);
      final authService = ref.watch(authServiceProvider.future);

      return GoogleAuthNotifier(
        firebaseAuth: firebaseAuth,
        googleSignIn: GoogleSignIn(),
        dio: dio,
        authServiceFuture: authService,
      );
    });

class GoogleAuthNotifier extends StateNotifier<AsyncValue<String>> {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final Dio dio;
  final Future<AuthService> authServiceFuture;

  GoogleAuthNotifier({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.dio,
    required this.authServiceFuture,
  }) : super(const AsyncValue.data(""));

  Future<Either<Failure, String>> signInWithGoogle() async {
    try {
      state = const AsyncValue.loading();

      // Get Google sign-in account
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        state = const AsyncValue.data("");
       return left(ServerFailure(message: 'Google sign in was cancelled'));
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        state = const AsyncValue.data("");
        return left(
          ServerFailure(message: 'Failed to get ID token from Google'),
        );
      }

      // Create credential and sign in to Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user == null) {
        state = const AsyncValue.data("");
        return left(
          ServerFailure(message: 'Failed to get user data from Firebase'),
        );
      }

      // Get Firebase token
      final firebaseToken = await userCredential.user!.getIdToken();

      if (firebaseToken == null) {
        state = const AsyncValue.data("");
        return left(ServerFailure(message: 'Failed to get Firebase token'));
      }

      // Exchange Firebase token for JWT
      try {
        final authService = await authServiceFuture;
        final jwtToken = await authService.exchangeFirebaseTokenForJWT(
          firebaseToken,
        );

        // Save token
        await authService.saveToken(jwtToken);

        // Update state
        state = AsyncValue.data(jwtToken);

        return right(jwtToken);
      } catch (e) {
        state = const AsyncValue.data("");
        return left(ServerFailure(message: 'Failed to exchange token: $e'));
      }
    } catch (e) {
      state = const AsyncValue.data("");
      return left(ServerFailure(message: 'Google sign-in failed: $e'));
    }
  }
}
