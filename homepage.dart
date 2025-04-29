import 'package:flutter/material.dart';
import 'result_screen.dart';
import 'aqua_sense_logo.dart'; // Import the new logo widget

void main() {
  runApp(const AquaSenseApp());
}

class AquaSenseApp extends StatelessWidget {
  const AquaSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0; // Default to "Home" tab
  bool _isDeviceConnected = false; // Tracks device connection status
  bool _showNotification = false; // Controls notification visibility
  late AnimationController _notificationController; // For notification flashing
  late Animation<double> _notificationOpacity;

  @override
  void initState() {
    super.initState();
    // Notification animation controller
    _notificationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _notificationOpacity = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(
        parent: _notificationController,
        curve: Curves.easeInOut,
      ),
    );

    // Repeat notification flash
    _notificationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _notificationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _notificationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _notificationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleDeviceConnection(bool value) {
    setState(() {
      _isDeviceConnected = value;
      _showNotification = true;
      _notificationController.forward();
    });

    // Hide notification after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showNotification = false;
          _notificationController.reset();
        });
      }
    });
  }

  void _startAnalysis() {
    // Use current date and time
    final currentTime = DateTime.now();
    // Mock result with current date/time
    final mockResult = WaterAnalysisResult(
      dateTime: currentTime,
      pH: 7.2,
      turbidity: 1.3,
      status: 'Safe',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(result: mockResult),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                children: [
                  // Logo
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: AquaSenseLogo(), // Use the reusable logo widget
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'Control Panel',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                  // Start Analysis Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ElevatedButton(
                      onPressed: _isDeviceConnected ? _startAnalysis : null,
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
                        'Start Analysis',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Toggle Button for Device Connection
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Device Connected: ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        Switch(
                          value: _isDeviceConnected,
                          onChanged: _toggleDeviceConnection,
                          activeColor: Colors.blue[600],
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Flashing Notification
          if (_showNotification)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _notificationOpacity,
                builder: (context, child) {
                  return Opacity(
                    opacity: _notificationOpacity.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      color: _isDeviceConnected ? Colors.green[700] : Colors.red[700],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isDeviceConnected ? Icons.check_circle : Icons.error,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isDeviceConnected
                                ? 'Device Connected ✅'
                                : 'Device Not Connected ❌',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
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