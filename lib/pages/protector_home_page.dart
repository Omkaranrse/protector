// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../widgets/feature_card.dart';
import '../widgets/protector_card.dart';
import '../widgets/learn_more_card.dart';
import 'booking_screen.dart';


class ProtectorHomePage extends StatefulWidget {
  const ProtectorHomePage({super.key});

  @override
  State<ProtectorHomePage> createState() => _ProtectorHomePageState();
}

class _ProtectorHomePageState extends State<ProtectorHomePage>
    with WidgetsBindingObserver {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = VideoPlayerController.asset(
      'assets/background.mp4', // replace with your video file if needed
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0.0);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller.value.isInitialized) {
      if (state == AppLifecycleState.resumed) {
        _controller.play(); // Resume on app resume
      } else if (state == AppLifecycleState.paused) {
        // Optional: pause when app is backgrounded
        //_controller.pause();
      }
    }
  }

  // Simulate login state (replace with real auth logic)


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.value.isInitialized
          ? CustomScrollView(
              slivers: [
                // Collapsing video section
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 300,
                  backgroundColor: Colors.black,
                  floating: false,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _controller.value.size.width,
                              height: _controller.value.size.height,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.6),
                                  Colors.black,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 24,
                          bottom: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Book Armed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Protectors in India',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Body content
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BookingScreen(),
                            ),
                          );
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
                  ),
                ),

                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      FeatureCard(
                        icon: Icons.security,
                        text:
                            'Armed Protectors will be right by your side, ensuring your safety.',
                      ),
                      FeatureCard(
                        icon: Icons.verified_user,
                        text:
                            'Our Protectors are only Active duty or Retired Law Enforcement and Military.',
                      ),
                      FeatureCard(
                        icon: Icons.directions_car,
                        text:
                            'Black car transportation is included for safe and effortless city travel.',
                      ),

                      const SizedBox(height: 20),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Meet the Protectors',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return ProtectorCard(
                              name: 'Protector ${index + 1}',
                              role: 'Former NYPD & Army',
                              imagePath: index % 2 == 0
                                  ? 'assets/images/body_gaurd.jpg'
                                  : 'assets/images/Bodyguard.jpg',
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Learn More',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const LearnMoreCard(
                        title: 'Emergency Medical',
                        description:
                            'Protectors have experience dealing with emergency medical such as TCCC.',
                      ),
                      const LearnMoreCard(
                        title: 'License',
                        description:
                            'Our Protectors are either credentialed Active Duty or Retired Law Enforcement officers who hold a valid HR-218 credential.',
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
