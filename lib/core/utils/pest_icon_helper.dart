import 'package:flutter/material.dart';

/// Helper class to provide rich, context-specific icons for different pest types
class PestIconHelper {
  /// Returns an appropriate icon for the given pest name
  static IconData getPestIcon(String pestName) {
    final normalizedName = pestName.toLowerCase().trim();

    switch (normalizedName) {
      case 'ants':
        return Icons.pets; // Represents small crawling insects

      case 'cockroaches':
        return Icons.bug_report; // Classic bug icon

      case 'flies':
        return Icons.air; // Represents flying pests

      case 'rodents':
        return Icons.cruelty_free; // Mouse/rat icon

      case 'termites':
        return Icons.home_repair_service; // Represents structural damage

      case 'bedbugs':
        return Icons.bed; // Bed-related pest

      case 'mosquitoes':
        return Icons.wind_power; // Flying, biting insects

      case 'spiders':
        return Icons.hub; // Web-like pattern

      case 'fleas':
        return Icons.scatter_plot; // Small jumping insects

      case 'ticks':
        return Icons.bubble_chart; // Small parasitic insects

      default:
        return Icons.bug_report; // Default pest icon
    }
  }

  /// Returns an icon widget with the appropriate icon for the pest
  static Icon getPestIconWidget(
    String pestName, {
    Color color = Colors.orange,
    double? size,
  }) {
    return Icon(
      getPestIcon(pestName),
      color: color,
      size: size,
    );
  }

  /// Returns a colored icon based on pest severity/type
  static Icon getPestIconWithSeverityColor(String pestName, {double? size}) {
    final normalizedName = pestName.toLowerCase().trim();
    Color color;

    switch (normalizedName) {
      case 'rodents':
      case 'termites':
        color = Colors.red; // High severity
        break;

      case 'cockroaches':
      case 'bedbugs':
        color = Colors.deepOrange; // Medium-high severity
        break;

      case 'mosquitoes':
      case 'fleas':
      case 'ticks':
        color = Colors.orange; // Medium severity
        break;

      case 'ants':
      case 'flies':
      case 'spiders':
        color = Colors.amber; // Lower severity
        break;

      default:
        color = Colors.orange; // Default
    }

    return Icon(
      getPestIcon(pestName),
      color: color,
      size: size,
    );
  }
}

