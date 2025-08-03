// lib/pages/dress_code_screen.dart

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'motorcade_screen.dart';


class DressCodeScreen extends StatefulWidget {
  final int protectees;
  final int protectors;

  const DressCodeScreen({
    Key? key,
    required this.protectees,
    required this.protectors,
  }) : super(key: key);

  @override
  State<DressCodeScreen> createState() => _DressCodeScreenState();
}

class _DressCodeScreenState extends State<DressCodeScreen> {
  final List<String> dressCodes = [
    'Business Casual',
    'Business Formal',
    'Operator',
    'Tactical Casual',
  ];

  final List<String> videoPaths = [
    'assets/videos/business_casual.mp4',
    'assets/videos/business_formal.mp4',
    'assets/videos/operator.mp4',
    'assets/videos/tactical_casual.mp4',
  ];

  int selectedIndex = 0;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.asset(videoPaths[selectedIndex])
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0.0);
        _controller.play();
        setState(() {});
      });
  }

  void _switchVideo(int newIndex) {
    _controller.pause();
    _controller.dispose();
    setState(() {
      selectedIndex = newIndex;
    });
    _initializeVideo();
  }

  void _nextDressCode() {
    int newIndex = (selectedIndex + 1) % dressCodes.length;
    _switchVideo(newIndex);
  }

  void _previousDressCode() {
    int newIndex = (selectedIndex - 1 + dressCodes.length) % dressCodes.length;
    _switchVideo(newIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 10),

            // Video Player
            Expanded(
              child: Center(
                child: _controller.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                    : const CircularProgressIndicator(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Pick Dress Code',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Protectors tailor their uniform for any occasion.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left, color: Colors.white),
                    onPressed: _previousDressCode,
                  ),
                  Text(
                    dressCodes[selectedIndex],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right, color: Colors.white),
                    onPressed: _nextDressCode,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Replace dummy data with actual booking details from previous screens
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MotorcadeScreen(
                        protectees: widget.protectees,
                        protectors: widget.protectors,
                        dressCode: dressCodes[selectedIndex],
                        pickupLocation: '',
                      ),
                    ),
                  );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Next'),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
