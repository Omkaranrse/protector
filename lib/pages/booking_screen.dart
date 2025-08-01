import 'package:flutter/material.dart';
import 'dress_code_screen.dart'; // ✅ Make sure this import path is correct based on your folder structure

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _protectees = 1;
  int _protectors = 1;

  String get protecteeLabel => _protectees == 1 ? "Just Me" : "$_protectees Protectees";
  String get protectorLabel => _protectors == 1 ? "1 Protector" : "$_protectors Protectors";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How many Protectees?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Let us know how many people need protection,\nwhether you’re solo or in a group.",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            _buildCounterRow(
              label: protecteeLabel,
              value: _protectees,
              onDecrement: () {
                if (_protectees > 1) {
                  setState(() {
                    _protectees--;
                  });
                }
              },
              onIncrement: () {
                setState(() {
                  _protectees++;
                });
              },
            ),
            const SizedBox(height: 32),
            const Text(
              "How many Protectors?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: "Based on the number of Protectees, we recommend assigning ",
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                children: [
                  TextSpan(
                    text: "1 Protector ",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: "to oversee your detail.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCounterRow(
              label: protectorLabel,
              value: _protectors,
              onDecrement: () {
                if (_protectors > 1) {
                  setState(() {
                    _protectors--;
                  });
                }
              },
              onIncrement: () {
                setState(() {
                  _protectors++;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // ✅ Navigate to DressCodeScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DressCodeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text("Next"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterRow({
    required String label,
    required int value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRoundButton(icon: Icons.remove, onPressed: onDecrement),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          _buildRoundButton(icon: Icons.add, onPressed: onIncrement),
        ],
      ),
    );
  }

  Widget _buildRoundButton({required IconData icon, required VoidCallback onPressed}) {
    return SizedBox(
      width: 36,
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.black,
          shape: const CircleBorder(),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
