import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_freaks/core/di/providers.dart';

// Define the state for auth provider
class AuthState {
  final bool isAuthenticated;
  final String? token;

  AuthState({
    this.isAuthenticated = false,
    this.token,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
    );
  }
}

// Auth notifier class
class AuthNotifier extends StateNotifier<AuthState> {
  final SharedPreferences _prefs;

  AuthNotifier({required SharedPreferences prefs})
      : _prefs = prefs,
        super(AuthState()) {
    _initialize();
  }

  void _initialize() async {
    final token = _prefs.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      state = state.copyWith(isAuthenticated: true, token: token);
    }
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString('auth_token', token);
    state = state.copyWith(isAuthenticated: true, token: token);
  }

  Future<void> clearToken() async {
    await _prefs.remove('auth_token');
    state = AuthState();
  }

  bool get isAuthenticated => state.isAuthenticated;
  String? get token => state.token;
}

// Provider for auth state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthNotifier(prefs: prefs.asData!.value);
});
