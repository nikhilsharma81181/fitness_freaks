/// Interface for mapping API responses to specific types
///
/// This allows for consistent handling of API responses across the application
/// and easy mocking for tests.
abstract class ApiResponseMapper<T> {
  /// Maps a raw API response to a specific type
  ///
  /// [data] is the raw response data, typically a Map<String, dynamic>
  /// Returns an instance of type T
  T map(dynamic data);

  /// Maps a list of raw API responses to a list of specific types
  ///
  /// [dataList] is a list of raw response data
  /// Returns a List<T>
  List<T> mapList(List<dynamic> dataList) {
    return dataList.map((item) => map(item)).toList();
  }
}
