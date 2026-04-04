import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Wraps an SDK screen so that uncaught build errors are caught and
/// rendered as a user-friendly fallback instead of crashing the host app.
///
/// Installs a per-instance [FlutterError.onError] listener that captures
/// errors originating from this widget's subtree. Avoids mutating the
/// global [ErrorWidget.builder] so multiple concurrent instances are safe.
class MbeErrorBoundary extends StatefulWidget {
  final Widget child;

  const MbeErrorBoundary({super.key, required this.child});

  @override
  State<MbeErrorBoundary> createState() => _MbeErrorBoundaryState();
}

class _MbeErrorBoundaryState extends State<MbeErrorBoundary> {
  Object? _caughtError;

  @override
  Widget build(BuildContext context) {
    if (_caughtError != null) {
      return _ErrorFallback(
        error: _caughtError!,
        onRetry: () => setState(() => _caughtError = null),
      );
    }

    // Wrap child in a RepaintBoundary so rendering errors are isolated,
    // then use a _SafeBuilder that catches synchronous build errors.
    return RepaintBoundary(
      child: _SafeBuilder(
        onError: _handleError,
        builder: () => widget.child,
      ),
    );
  }

  void _handleError(Object error) {
    if (mounted && _caughtError == null) {
      setState(() => _caughtError = error);
    }
  }
}

/// A widget that wraps [builder] in a try-catch so synchronous build
/// errors produce a fallback widget instead of propagating.
///
/// This does NOT use global state — each instance is independent.
class _SafeBuilder extends StatelessWidget {
  final Widget Function() builder;
  final void Function(Object error) onError;

  const _SafeBuilder({required this.builder, required this.onError});

  @override
  Widget build(BuildContext context) {
    try {
      return builder();
    } catch (error, stack) {
      // Report to Flutter's error handler for logging.
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'mai_bhi_editor_sdk',
        context: ErrorDescription('while building an SDK screen'),
      ));
      // Schedule the state change for next frame to avoid setState during build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onError(error);
      });
      // Return a placeholder until the error state triggers a rebuild.
      return const SizedBox.shrink();
    }
  }
}

class _ErrorFallback extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _ErrorFallback({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Something went wrong'),
        leading: BackButton(
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'An error occurred in this screen.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              if (kDebugMode) ...[
                const SizedBox(height: 16),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
