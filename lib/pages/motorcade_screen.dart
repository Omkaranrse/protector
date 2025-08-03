import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'pickup_details_screen.dart';

class MotorcadeScreen extends StatefulWidget {
  final int protectees;
  final int protectors;
  final String dressCode;
  final String pickupLocation;

  const MotorcadeScreen({
    super.key,
    required this.protectees,
    required this.protectors,
    required this.dressCode,
    required this.pickupLocation,
  });

  @override
  State<MotorcadeScreen> createState() => _MotorcadeScreenState();
}

class _MotorcadeScreenState extends State<MotorcadeScreen> {
  int _carCount = 1;
  final String _pickupLocation = '';
  // No video controller needed for GIF

  @override
  void initState() {
    super.initState();
    // No initialization needed for GIF
  }

  @override
  void dispose() {
    super.dispose();
  }
  void _incrementCar() {
    setState(() {
      _carCount++;
    });
  }

  void _decrementCar() {
    if (_carCount > 1) {
      setState(() {
        _carCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            const SizedBox(height: 10),

            // Car GIF
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/videos/Car_Video_With_Rotating_Wheels.gif',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Info Text
            const Text(
              'Escalade or Similar Vehicle • Fits 5 Protectees',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'How many cars do you want in your motorcade?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Each car comes with a dedicated driver for the duration of your protection. Based on your booking detail, you will require 1 car.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Counter
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
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: _decrementCar,
                  ),
                  Text(
                    '$_carCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _incrementCar,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Next Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle "Next"
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PickupDetailsScreen(
                        protectees: widget.protectees,
                        protectors: widget.protectors,
                        dressCode: widget.dressCode,
                        cars: _carCount,
                        pickupLocation: _pickupLocation,
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
