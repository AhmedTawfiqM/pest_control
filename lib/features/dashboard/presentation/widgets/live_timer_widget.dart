import 'package:flutter/material.dart';
import '../../../../core/utils/app_datetime.dart';

class LiveTimerWidget extends StatelessWidget {
  final DateTime startTimeUtc;

  const LiveTimerWidget({
    super.key,
    required this.startTimeUtc,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final duration = AppDateTime.durationFromNowUtc(startTimeUtc);
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_time,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                AppDateTime.formatDuration(duration),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

