/// API endpoints used across the app
class Endpoint {
  /// Private constructor to prevent instantiation
  Endpoint._();

  // Base paths
  static const String _auth = '/api/auth';
  static const String _user = '/api/user';

  // Auth endpoints
  static const String sendOtp = '$_auth/send-otp';
  static const String verifyOtp = '$_auth/verify-otp';
  static const String resendOtp = '$_auth/send-otp';
  static const String googleSSO = '$_auth/verify-google';
  static const String appleSSO = '$_auth/verify-apple';

  // These endpoints may also be needed if used elsewhere in the app
  static const String login = '$_auth/login';
  static const String register = '$_auth/register';
  static const String refreshToken = '$_auth/refresh';
  static const String logout = '$_auth/logout';

  // User endpoints
  static const String getUser = '$_user/';
  static const String createUser = '$_user/';
  static const String updateUser = '$_user/';
  static const String uploadProfilePicture = '$_user/profile-picture';
  static const String deleteUser = '$_user/';

  // Other endpoints
  static const String settings = '/api/settings';

  // Weight endpoints
  static const String weights = '/api/weight-data';
  static const String weightUpload = '/api/weight-data/from-image';
}
