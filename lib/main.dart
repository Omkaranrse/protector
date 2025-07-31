import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Protector App',
      theme: ThemeData(
        brightness: Brightness.dark, // Dark theme
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProtectorHomePage(),
    );
  }
}

class ProtectorHomePage extends StatefulWidget {
  const ProtectorHomePage({super.key});

  @override
  State<ProtectorHomePage> createState() => _ProtectorHomePageState();
}

class _ProtectorHomePageState extends State<ProtectorHomePage> {
  late VideoPlayerController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the video player
    // Replace 'assets/background_video.mp4' with your video path
    // For network video: VideoPlayerController.network('YOUR_VIDEO_URL')
    // For asset video: VideoPlayerController.asset('assets/background_video.mp4')
    _controller = VideoPlayerController.asset('assets/background.mp4') // Example: from assets
    // _controller = VideoPlayerController.networkUrl(Uri.parse('https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4')) // Example: from network
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true); // Loop the video
        _controller.setVolume(0.0); // Mute the video
        setState(() {}); // Ensure the first frame is shown
      });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Video
          _controller.value.isInitialized
              ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          )
              : Container(color: Colors.black), // Show black while video loads

          // Gradient Overlay to make text more readable
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(1.0),
                  ],
                  stops: const [0.0, 0.5, 0.7, 1.0],
                ),
              ),
            ),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Book Armed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Protectors in New York',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'City',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle "Book a Protector" button press
                          print('Book a Protector pressed!');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Book a Protector'),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              // Feature Cards
              _buildFeatureCard(
                icon: Icons.security, // Placeholder for the shield icon
                text: 'Armed Protectors will be right by your side, ensuring your safety.',
              ),
              _buildFeatureCard(
                icon: Icons.star, // Placeholder for the badge icon
                text: 'Our Protectors are only Active duty or Retired Law Enforcement and Military.',
              ),
              _buildFeatureCard(
                icon: Icons.car_rental, // Placeholder for the car icon
                text: 'Black car transportation is included for safe and effortless city travel.',
              ),
              const SizedBox(height: 20), // Spacing before bottom navigation bar
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // Dark background for the bar
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Protector',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        type: BottomNavigationBarType.fixed, // Ensures all items are visible
      ),
    );
  }

  Widget _buildFeatureCard({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[900], // Dark background for the cards
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}