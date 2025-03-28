/// Interface defining caching strategies
abstract class CachePolicy {
  /// Returns true if the cached data is valid, false otherwise
  ///
  /// [lastUpdated] is the timestamp when the data was last updated
  bool isValid(DateTime lastUpdated);
  
  /// Returns the time-to-live in milliseconds
  int get ttlMilliseconds;
}

/// Cache policy that never expires
class NoExpirationCachePolicy implements CachePolicy {
  @override
  bool isValid(DateTime lastUpdated) => true;
  
  @override
  int get ttlMilliseconds => -1; // Indicates no expiration
}

/// Cache policy with a fixed time-to-live
class TimedCachePolicy implements CachePolicy {
  final Duration ttl;
  
  /// Create a timed cache policy with the specified time-to-live
  ///
  /// [ttl] is the time-to-live for cached data
  const TimedCachePolicy({required this.ttl});
  
  @override
  bool isValid(DateTime lastUpdated) {
    final now = DateTime.now();
    final expirationTime = lastUpdated.add(ttl);
    return now.isBefore(expirationTime);
  }
  
  @override
  int get ttlMilliseconds => ttl.inMilliseconds;
}

/// Cache policy that expires at a specific time of day
class DailyExpirationCachePolicy implements CachePolicy {
  final int hour;
  final int minute;
  final int second;
  
  /// Create a cache policy that expires at a specific time each day
  ///
  /// [hour] is the hour of the day (0-23)
  /// [minute] is the minute (0-59)
  /// [second] is the second (0-59)
  const DailyExpirationCachePolicy({
    required this.hour,
    this.minute = 0,
    this.second = 0,
  });
  
  @override
  bool isValid(DateTime lastUpdated) {
    final now = DateTime.now();
    final lastRefreshDay = DateTime(
      lastUpdated.year,
      lastUpdated.month,
      lastUpdated.day,
      hour,
      minute,
      second,
    );
    
    // If last update was before today's expiration time and now is after expiration time
    if (lastUpdated.isBefore(lastRefreshDay) && now.isAfter(lastRefreshDay)) {
      return false;
    }
    
    // If last update was yesterday or earlier, check against yesterday's expiration time
    if (lastUpdated.day != now.day || lastUpdated.month != now.month || lastUpdated.year != now.year) {
      return false;
    }
    
    return true;
  }
  
  @override
  int get ttlMilliseconds {
    // Calculate time until next expiration
    final now = DateTime.now();
    final todayExpiration = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      second,
    );
    
    if (now.isAfter(todayExpiration)) {
      // If we've passed today's expiration, calculate time until tomorrow's expiration
      final tomorrowExpiration = todayExpiration.add(const Duration(days: 1));
      return tomorrowExpiration.difference(now).inMilliseconds;
    } else {
      return todayExpiration.difference(now).inMilliseconds;
    }
  }
}
