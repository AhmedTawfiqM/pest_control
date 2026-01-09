import 'package:intl/intl.dart';

/// Date and time format types
enum AppDateTimeFormat {
  /// Format: Jan 09, 2026
  shortDate,

  /// Format: January 09, 2026
  longDate,

  /// Format: 02:30 PM
  time12Hour,

  /// Format: 14:30
  time24Hour,

  /// Format: Jan 09, 2026 02:30 PM
  shortDateTime,

  /// Format: January 09, 2026 at 02:30 PM
  longDateTime,

  /// Format: 08:20:35 (HH:MM:SS)
  duration,

  /// Format: 2026-01-09
  isoDate,

  /// Format: 2026-01-09T14:30:00.000Z
  isoDateTime,
}

/// Centralized DateTime utility for the app
class AppDateTime {
  AppDateTime._();

  // Date Formatters
  static final DateFormat _shortDateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _longDateFormat = DateFormat('MMMM dd, yyyy');
  static final DateFormat _time12HourFormat = DateFormat('hh:mm a');
  static final DateFormat _time24HourFormat = DateFormat('HH:mm');
  static final DateFormat _shortDateTimeFormat = DateFormat('MMM dd, yyyy hh:mm a');
  static final DateFormat _longDateTimeFormat = DateFormat('MMMM dd, yyyy \'at\' hh:mm a');
  static final DateFormat _isoDateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _isoDateTimeFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

  /// Format a DateTime according to the specified format
  static String format(DateTime dateTime, AppDateTimeFormat format) {
    switch (format) {
      case AppDateTimeFormat.shortDate:
        return _shortDateFormat.format(dateTime);
      case AppDateTimeFormat.longDate:
        return _longDateFormat.format(dateTime);
      case AppDateTimeFormat.time12Hour:
        return _time12HourFormat.format(dateTime);
      case AppDateTimeFormat.time24Hour:
        return _time24HourFormat.format(dateTime);
      case AppDateTimeFormat.shortDateTime:
        return _shortDateTimeFormat.format(dateTime);
      case AppDateTimeFormat.longDateTime:
        return _longDateTimeFormat.format(dateTime);
      case AppDateTimeFormat.duration:
        return formatDuration(Duration(
          hours: dateTime.hour,
          minutes: dateTime.minute,
          seconds: dateTime.second,
        ));
      case AppDateTimeFormat.isoDate:
        return _isoDateFormat.format(dateTime);
      case AppDateTimeFormat.isoDateTime:
        return _isoDateTimeFormat.format(dateTime.toUtc());
    }
  }

  /// Get current DateTime in UTC
  static DateTime nowUtc() => DateTime.now().toUtc();

  /// Get current DateTime in local timezone
  static DateTime nowLocal() => DateTime.now();

  /// Convert UTC to local timezone
  static DateTime utcToLocal(DateTime utcDateTime) {
    return utcDateTime.toLocal();
  }

  /// Convert local to UTC timezone
  static DateTime localToUtc(DateTime localDateTime) {
    return localDateTime.toUtc();
  }

  /// Format a Duration as HH:MM:SS
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:'
           '${minutes.toString().padLeft(2, '0')}:'
           '${seconds.toString().padLeft(2, '0')}';
  }

  /// Format a Duration as human readable with appropriate units
  /// Shows seconds for very short durations (< 1 minute)
  /// Shows minutes for short durations (< 1 hour)
  /// Shows hours and minutes for longer durations
  static String formatDurationHuman(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      if (minutes > 0) {
        return '${hours}h ${minutes}m';
      }
      return '${hours}h';
    } else if (minutes > 0) {
      if (seconds > 0) {
        return '${minutes}m ${seconds}s';
      }
      return '${minutes}m';
    } else {
      return '${seconds}s';
    }
  }

  /// Format a Duration in a compact way for display
  /// Examples: "2h 30m", "45m", "30s"
  static String formatDurationCompact(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Calculate duration between two DateTimes
  static Duration calculateDuration(DateTime start, DateTime end) {
    return end.difference(start);
  }

  /// Calculate duration from start to now
  static Duration durationFromNow(DateTime start) {
    return DateTime.now().difference(start);
  }

  /// Calculate duration from UTC start to now
  static Duration durationFromNowUtc(DateTime utcStart) {
    return nowUtc().difference(utcStart);
  }

  /// Check if a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }

  /// Check if time has crossed midnight
  static bool hasCrossedMidnight(DateTime start, DateTime end) {
    return start.day != end.day;
  }

  /// Get time difference accounting for midnight wraparound
  static Duration getDurationWithMidnightHandling(DateTime start, DateTime end) {
    if (hasCrossedMidnight(start, end)) {
      // Handle midnight wraparound
      return end.difference(start);
    }
    return end.difference(start);
  }

  /// Parse ISO date string to DateTime
  static DateTime? parseIsoString(String? isoString) {
    if (isoString == null || isoString.isEmpty) return null;
    try {
      return DateTime.parse(isoString);
    } catch (e) {
      return null;
    }
  }

  /// Format time ago (e.g., "2 hours ago", "5 minutes ago")
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }
}

