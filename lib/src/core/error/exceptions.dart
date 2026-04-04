/// Exception thrown when the server returns an error response.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Exception thrown when there is no internet connection.
class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'No internet connection'});

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when cached data is not found.
class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'No cached data found'});

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when authentication fails or token expires.
class AuthException implements Exception {
  final String message;

  const AuthException({this.message = 'Authentication failed'});

  @override
  String toString() => 'AuthException: $message';
}

/// Exception thrown when the API returns a rate-limit 429 response.
class RateLimitException implements Exception {
  final String message;
  final int? retryAfterSeconds;

  const RateLimitException({
    this.message = 'Rate limit exceeded',
    this.retryAfterSeconds,
  });

  @override
  String toString() =>
      'RateLimitException: $message (retry after ${retryAfterSeconds}s)';
}
