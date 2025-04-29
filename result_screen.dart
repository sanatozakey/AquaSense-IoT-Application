import 'package:flutter/material.dart';
import 'aqua_sense_logo.dart'; // Import the logo widget

class WaterAnalysisResult {
  final DateTime dateTime;
  final double pH;
  final double turbidity;
  final String status;

  WaterAnalysisResult({
    required this.dateTime,
    required this.pH,
    required this.turbidity,
    required this.status,
  });
}

class ResultScreen extends StatelessWidget {
  final WaterAnalysisResult result;

  const ResultScreen({super.key, required this.result});

  String _formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '${dateTime.month}/${dateTime.day}/${dateTime.year % 100} $hour:$minute $period';
  }

  void _showExplanationDialog(BuildContext context, String title, String explanation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(explanation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _startTestingAgain(BuildContext context) {
    // Pop back to HomePage and trigger a new analysis
    Navigator.pop(context);
    // Since we can't directly call _startAnalysis from here, we assume the user will press "Start Analysis" again.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[50]!,
              Colors.blue[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: AquaSenseLogo(),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Water Analysis Result',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ),
              // Result Card
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date/Time
                      Text(
                        _formatDateTime(result.dateTime),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // pH with Info Icon
                      Row(
                        children: [
                          Text(
                            'pH: ${result.pH.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.info_outline,
                              size: 20,
                              color: Colors.blue[600],
                            ),
                            onPressed: () => _showExplanationDialog(
                              context,
                              'pH Level',
                              'The pH level measures the acidity or alkalinity of water. A pH between 6.5 and 8.5 is generally considered safe for drinking water. Your result of ${result.pH.toStringAsFixed(1)} is ${result.pH >= 6.5 && result.pH <= 8.5 ? "within the safe range." : "outside the safe range, which may affect water quality."}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // Turbidity with Info Icon
                      Row(
                        children: [
                          Text(
                            'Turbidity: ${result.turbidity.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.info_outline,
                              size: 20,
                              color: Colors.blue[600],
                            ),
                            onPressed: () => _showExplanationDialog(
                              context,
                              'Turbidity',
                              'Turbidity measures the clarity of water, indicating the presence of suspended particles. Values below 5 NTU (Nephelometric Turbidity Units) are typically safe for drinking. Your result of ${result.turbidity.toStringAsFixed(1)} NTU is ${result.turbidity <= 5 ? "within the safe range." : "above the safe limit, indicating potential contamination."}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // Status with Info Icon
                      Row(
                        children: [
                          Text(
                            'Status: ${result.status}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: result.status == 'Safe' ? Colors.green[700] : Colors.red[700],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.info_outline,
                              size: 20,
                              color: Colors.blue[600],
                            ),
                            onPressed: () => _showExplanationDialog(
                              context,
                              'Status',
                              'The status indicates overall water safety based on pH and turbidity. "Safe" means both pH (6.5-8.5) and turbidity (<5 NTU) are within acceptable ranges. "Unsafe" means one or both values are outside these ranges, suggesting the water may not be suitable for drinking without treatment.',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Start Testing Again Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () => _startTestingAgain(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Start Testing Again',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}