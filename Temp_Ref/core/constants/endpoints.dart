// /// API endpoints used in the application
// class Endpoint {
//   // Base URLs
//   static const String baseUrl = 'https://api.fitnessfreaks.com/v1';
//   static const String authBaseUrl = 'https://auth.fitnessfreaks.com';
  
//   // Authentication endpoints
//   static const String login = '/auth/login';
//   static const String register = '/auth/register';
//   static const String refreshToken = '/auth/refresh';
//   static const String resetPassword = '/auth/reset-password';
  
//   // User endpoints
//   static const String me = '/users/me';
//   static const String updateProfile = '/users/me';
  
//   // Workout endpoints
//   static const String workouts = '/workouts';
//   static const String workout = '/workouts/{id}';
  
//   // Weight endpoints
//   static const String weights = '/weights';
//   static const String weight = '/weights/{id}';
//   static const String weightUpload = '/weights/upload';
  
//   // Utility method to replace URL parameters
//   static String path(String endpoint, Map<String, String> params) {
//     String result = endpoint;
//     params.forEach((key, value) {
//       result = result.replaceAll('{$key}', value);
//     });
//     return result;
//   }
// }
