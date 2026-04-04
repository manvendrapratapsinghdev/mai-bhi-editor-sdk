import 'package:equatable/equatable.dart';

/// Base failure class for domain-layer error handling.
///
/// Use [Failure] subclasses inside `Either<Failure, T>` return types so that
/// presentation-layer code never has to catch exceptions directly.
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Failure originating from a server/API error.
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

/// Failure due to absence of internet connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

/// Failure when expected cached data is missing.
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache miss'});
}

/// Failure when authentication is invalid or expired.
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication failed'});
}

/// Failure when the client is rate-limited (HTTP 429).
class RateLimitFailure extends Failure {
  final int? retryAfterSeconds;

  const RateLimitFailure({
    super.message = 'Rate limit exceeded',
    this.retryAfterSeconds,
  });

  @override
  List<Object?> get props => [message, retryAfterSeconds];
}
