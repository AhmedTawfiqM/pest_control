import 'package:flutter/material.dart';
import '../../../../core/utils/pest_icon_helper.dart';

/// Demo page to showcase all pest icons
/// This is useful for testing and documentation purposes
class PestIconDemoPage extends StatelessWidget {
  const PestIconDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pests = [
      'Ants',
      'Cockroaches',
      'Flies',
      'Rodents',
      'Termites',
      'Bedbugs',
      'Mosquitoes',
      'Spiders',
      'Fleas',
      'Ticks',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pest Icons Reference'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Pest-Specific Icons',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Each pest type has a unique icon with severity-based coloring',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ...pests.map((pest) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: PestIconHelper.getPestIconWithSeverityColor(
                    pest,
                    size: 32,
                  ),
                  title: Text(
                    pest,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    'Icon: ${PestIconHelper.getPestIcon(pest).toString()}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Default color
                      PestIconHelper.getPestIconWidget(
                        pest,
                        color: Colors.orange,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      // Severity color
                      PestIconHelper.getPestIconWithSeverityColor(
                        pest,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 24),
          const Card(
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Severity Color Guide',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.red, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'High Severity (Rodents, Termites)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.deepOrange, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Medium-High (Cockroaches, Bedbugs)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.orange, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Medium (Mosquitoes, Fleas, Ticks)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.amber, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Lower (Ants, Flies, Spiders)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

