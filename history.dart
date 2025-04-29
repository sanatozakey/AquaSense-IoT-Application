import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const AquaSenseApp());
}

class AquaSenseApp extends StatelessWidget {
  const AquaSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HistoryPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class WaterTestRecord {
  final String dateTime;
  final double pH;
  final double turbidity;
  final String status;

  WaterTestRecord({
    required this.dateTime,
    required this.pH,
    required this.turbidity,
    required this.status,
  });
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _waveAnimation;
  late Animation<double> _rotateAnimation;
  int _selectedIndex = 1; // Default to "History" tab

  // Sample data for the history table
  final List<WaterTestRecord> _records = [
    WaterTestRecord(
      dateTime: "3/29/25 10:25 AM",
      pH: 7.2,
      turbidity: 1.3,
      status: "Safe",
    ),
    WaterTestRecord(
      dateTime: "3/28/25 10:40 AM",
      pH: 8.0,
      turbidity: 380.0,
      status: "Unsafe",
    ),
    WaterTestRecord(
      dateTime: "3/27/25 12:30 PM",
      pH: 5.5,
      turbidity: 5.0,
      status: "Unsafe",
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize logo animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation logic here if needed
    // For now, we're only showing the History page
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
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(120, 120),
                      painter: AquaSenseLogoPainter(
                        waveProgress: _waveAnimation.value,
                        rotateProgress: _rotateAnimation.value,
                      ),
                      child: Container(
                        width: 120,
                        height: 120,
                        alignment: Alignment.center,
                        child: const Text(
                          'AquaSense',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 4.0,
                                color: Colors.black87,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'HISTORY',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ),
              // History Table
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue[600]!, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DataTable(
                        columnSpacing: 10,
                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue[50]!),
                        dataRowColor: MaterialStateColor.resolveWith((states) {
                          return states.contains(MaterialState.selected)
                              ? Colors.blue[100]!
                              : Colors.white;
                        }),
                        columns: [
                          DataColumn(
                            label: Text(
                              'Date/Time',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'pH/Turbidity',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                        ],
                        rows: List.generate(
                          _records.length,
                          (index) {
                            final record = _records[index];
                            return DataRow(
                              color: MaterialStateColor.resolveWith((states) {
                                return index % 2 == 0 ? Colors.white : Colors.blue[50]!;
                              }),
                              cells: [
                                DataCell(
                                  Text(
                                    record.dateTime,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    'pH: ${record.pH.toStringAsFixed(1)} / Turbidity: ${record.turbidity.toStringAsFixed(1)}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    record.status,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: record.status == "Safe" ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Help',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 5,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AquaSenseLogoPainter extends CustomPainter {
  final double waveProgress;
  final double rotateProgress;

  AquaSenseLogoPainter({
    required this.waveProgress,
    required this.rotateProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final innerRadius = radius - 6;

    // Draw white background
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, bgPaint);

    // Draw dark blue ocean waves with longer wavelengths
    final wavePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.blue[800]!.withOpacity(0.9),
          Colors.blue[900]!,
          Colors.blue[700]!.withOpacity(0.85),
          Colors.white.withOpacity(0.7),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 4; i++) {
      final path = Path();
      final waveHeight = 12.0 + i * 3.0;
      final waveSpeed = 1.2 + i * 0.3;
      for (double x = 0; x <= size.width; x += 1) {
        final y = center.dy +
            math.sin((x / size.width * math.pi) + waveProgress * waveSpeed + i) *
                waveHeight +
            math.cos((x / size.width * math.pi / 2) + waveProgress * 0.7) * 4;
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      final clipPath = Path()
        ..addOval(Rect.fromCircle(center: center, radius: innerRadius));
      canvas.save();
      canvas.clipPath(clipPath);
      canvas.drawPath(path, wavePaint);
      canvas.restore();
    }

    // Draw rotating circle outline with gap
    final outlinePaint = Paint()
      ..color = Colors.blue[600]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    final arcRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      arcRect,
      rotateProgress,
      2 * math.pi * 0.85,
      false,
      outlinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}