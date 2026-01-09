import 'dart:async';
import 'package:flutter/foundation.dart';

/// A utility class that debounces function calls.
///
/// This is useful for preventing excessive function calls when handling
/// rapid user input like search queries.
///
/// Example:
/// ```dart
/// final debouncer = Debouncer(milliseconds: 300);
///
/// debouncer.run(() {
///   // This code will only run after 300ms of inactivity
///   performSearch(query);
/// });
/// ```
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  /// Creates a Debouncer with the specified delay in milliseconds.
  ///
  /// [milliseconds] - The delay duration before executing the debounced action.
  Debouncer({required this.milliseconds});

  /// Runs the given action after the specified delay.
  ///
  /// If this method is called again before the delay expires,
  /// the previous timer is cancelled and a new one is created.
  void run(VoidCallback action) {
    // Cancel any existing timer
    _timer?.cancel();

    // Create a new timer
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancels any pending debounced action.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Disposes of the debouncer and cancels any pending action.
  ///
  /// Should be called when the debouncer is no longer needed,
  /// typically in a widget's dispose method.
  void dispose() {
    cancel();
  }
}

