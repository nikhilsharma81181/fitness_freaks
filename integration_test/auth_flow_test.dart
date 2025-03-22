import 'package:fitness_freaks/core/error/exceptions.dart';
import 'package:fitness_freaks/features/user/data/datasources/auth_service.dart';
import 'package:fitness_freaks/features/user/data/datasources/user_remote_data_source.dart';
import 'package:fitness_freaks/features/user/data/models/user_model.dart';
import 'package:fitness_freaks/features/user/presentation/providers/user_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

class MockAuthService extends Mock implements AuthService {}

class MockDio extends Mock implements Dio {}

class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late UserRemoteDataSource userRemoteDataSource;
  late MockAuthService mockAuthService;
  late MockDio mockDio;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;

  setUp(() {
    mockAuthService = MockAuthService();
    mockDio = MockDio();
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();

    userRemoteDataSource = UserRemoteDataSourceImpl(
      dio: mockDio,
      authService: mockAuthService,
      firebaseAuth: mockFirebaseAuth,
      googleSignIn: mockGoogleSignIn,
    );
  });

  group('Authentication Flow Tests', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testName = 'Test User';

    final mockUserModel = UserModel(
      id: '123',
      name: testName,
      email: testEmail,
      profileImageUrl: '',
      fitnessLevel: 1,
      goals: [],
    );

    test('Sign In - Success Flow', () async {
      // Setup Firebase auth success
      when(
        () => mockAuthService.signInWithEmailPassword(testEmail, testPassword),
      ).thenAnswer((_) async => mockUserModel);

      when(
        () => mockAuthService.getToken(),
      ).thenAnswer((_) async => 'mock_token');

      // Setup API success
      when(
        () => mockDio.post('/api/auth/login', data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response(
          data: {'token': 'new_token', 'user': mockUserModel.toJson()},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Execute sign in
      final result = await userRemoteDataSource.signInWithEmailAndPassword(
        testEmail,
        testPassword,
      );

      // Verify flow
      expect(result, isA<UserModel>());
      expect(result.email, testEmail);
      expect(result.name, testName);

      // Verify API calls
      verify(
        () => mockAuthService.signInWithEmailPassword(testEmail, testPassword),
      ).called(1);
      verify(() => mockAuthService.getToken()).called(1);
      verify(
        () => mockDio.post('/api/auth/login', data: any(named: 'data')),
      ).called(1);
    });

    test('Sign In - API Failure Flow', () async {
      // Setup Firebase auth success
      when(
        () => mockAuthService.signInWithEmailPassword(testEmail, testPassword),
      ).thenAnswer((_) async => mockUserModel);

      when(
        () => mockAuthService.getToken(),
      ).thenAnswer((_) async => 'mock_token');

      // Setup API failure
      when(
        () => mockDio.post('/api/auth/login', data: any(named: 'data')),
      ).thenThrow(
        DioError(requestOptions: RequestOptions(path: ''), error: 'API Error'),
      );

      // Setup sign out success
      when(() => mockAuthService.signOut()).thenAnswer((_) async => {});

      // Execute and expect error
      expect(
        () => userRemoteDataSource.signInWithEmailAndPassword(
          testEmail,
          testPassword,
        ),
        throwsA(isA<ServerException>()),
      );

      // Verify cleanup
      verify(() => mockAuthService.signOut()).called(1);
    });

    test('Sign Up - Success Flow', () async {
      // Setup Firebase auth success
      when(
        () => mockAuthService.signUpWithEmailPassword(
          testEmail,
          testPassword,
          testName,
        ),
      ).thenAnswer((_) async => mockUserModel);

      when(
        () => mockAuthService.getToken(),
      ).thenAnswer((_) async => 'mock_token');

      // Setup API success
      when(
        () => mockDio.post('/api/auth/register', data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response(
          data: {'token': 'new_token', 'user': mockUserModel.toJson()},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Execute sign up
      final result = await userRemoteDataSource.signUpWithEmailAndPassword(
        testEmail,
        testPassword,
        testName,
      );

      // Verify flow
      expect(result, isA<UserModel>());
      expect(result.email, testEmail);
      expect(result.name, testName);

      // Verify API calls
      verify(
        () => mockAuthService.signUpWithEmailPassword(
          testEmail,
          testPassword,
          testName,
        ),
      ).called(1);
      verify(() => mockAuthService.getToken()).called(1);
      verify(
        () => mockDio.post('/api/auth/register', data: any(named: 'data')),
      ).called(1);
    });

    test('Google Sign In - Success Flow', () async {
      // Mock required objects
      final mockGoogleUser = MockGoogleSignInAccount();
      final mockGoogleAuth = MockGoogleSignInAuthentication();
      final mockFirebaseUser = MockFirebaseUser();
      final mockUserCredential = MockUserCredential();

      // Mock Google sign in
      when(
        () => mockGoogleSignIn.signIn(),
      ).thenAnswer((_) async => mockGoogleUser);

      when(
        () => mockGoogleUser.authentication,
      ).thenAnswer((_) async => mockGoogleAuth);

      when(() => mockGoogleAuth.accessToken).thenReturn('mock_access_token');

      when(() => mockGoogleAuth.idToken).thenReturn('mock_id_token');

      // Mock Firebase credential
      final mockCredential = MockAuthCredential();
      when(
        () => firebase_auth.GoogleAuthProvider.credential(
          accessToken: any(named: 'accessToken'),
          idToken: any(named: 'idToken'),
        ),
      ).thenReturn(mockCredential as firebase_auth.OAuthCredential);

      // Mock Firebase sign in
      when(
        () => mockFirebaseAuth.signInWithCredential(any()),
      ).thenAnswer((_) async => mockUserCredential);

      when(() => mockUserCredential.user).thenReturn(mockFirebaseUser);

      // Mock user properties
      when(() => mockFirebaseUser.uid).thenReturn('google_user_123');

      when(() => mockFirebaseUser.displayName).thenReturn('Google User');

      when(() => mockFirebaseUser.email).thenReturn('google@example.com');

      when(
        () => mockFirebaseUser.photoURL,
      ).thenReturn('https://example.com/photo.jpg');

      when(
        () => mockFirebaseUser.getIdToken(),
      ).thenAnswer((_) async => 'firebase_token');

      // Mock token storage
      when(() => mockAuthService.saveToken(any())).thenAnswer((_) async => {});

      // Mock backend API call
      when(
        () => mockDio.post('/api/auth/google', data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response(
          data: {'token': 'backend_token', 'user': mockUserModel.toJson()},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Execute Google sign in
      final result = await userRemoteDataSource.signInWithGoogle();

      // Verify result
      expect(result, isA<UserModel>());

      // Verify API calls
      verify(() => mockGoogleSignIn.signIn()).called(1);
      verify(() => mockFirebaseAuth.signInWithCredential(any())).called(1);
      verify(
        () => mockDio.post('/api/auth/google', data: any(named: 'data')),
      ).called(1);
    });
  });
}

// Additional mock classes needed for Google Sign In test
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockFirebaseUser extends Mock implements firebase_auth.User {}

class MockUserCredential extends Mock implements firebase_auth.UserCredential {}

class MockAuthCredential extends Mock implements firebase_auth.AuthCredential {}
