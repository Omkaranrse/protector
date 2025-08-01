import 'package:flutter/material.dart';
import 'dart:math';

class BookingSummaryScreen extends StatelessWidget {
  final int protectees;
  final int protectors;
  final String dressCode;
  final int cars;
  final String pickupLocation;
  final DateTime pickupDate;
  final TimeOfDay pickupTime;
  final Duration protectionDuration;
  final bool isMember;

  const BookingSummaryScreen({
    super.key,
    required this.protectees,
    required this.protectors,
    required this.dressCode,
    required this.cars,
    required this.pickupLocation,
    required this.pickupDate,
    required this.pickupTime,
    required this.protectionDuration,
    required this.isMember,
  });

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '$hour:$minute $period';
  }

  String _formattedDate(DateTime date) {
    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final endHour = pickupTime.hour + protectionDuration.inHours;
    final endTime = TimeOfDay(hour: endHour % 24, minute: pickupTime.minute);
    final int price = 5000 + Random().nextInt(5000); // ₹5000 to ₹9999

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Booking Details', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.white),
              title: Text(pickupLocation, style: const TextStyle(color: Colors.white)),
              subtitle: Text(
                '${_formattedDate(pickupDate)} · ${_formatTime(pickupTime)}',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.white),
              title: Text('Duration: ${protectionDuration.inHours} hours', style: const TextStyle(color: Colors.white)),
              subtitle: Text('${_formatTime(pickupTime)} — ${_formatTime(endTime)}', style: const TextStyle(color: Colors.white70)),
            ),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.white),
              title: Text('$protectors Armed Protector(s)', style: const TextStyle(color: Colors.white)),
              subtitle: Text('$protectees Protectee(s)', style: const TextStyle(color: Colors.white70)),
            ),
            ListTile(
              leading: const Icon(Icons.checkroom, color: Colors.white),
              title: Text('Dress Code: $dressCode', style: const TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: const Icon(Icons.directions_car, color: Colors.white),
              title: Text('Cars: $cars', style: const TextStyle(color: Colors.white)),
              subtitle: const Text('Cadillac Escalade or similar', style: TextStyle(color: Colors.white70)),
            ),
            ListTile(
              leading: const Icon(Icons.card_membership, color: Colors.white),
              title: Text(isMember ? 'Member' : 'Not a Member', style: const TextStyle(color: Colors.white)),
              subtitle: isMember
                  ? const Text('Annual Fee: ₹129', style: TextStyle(color: Colors.white70))
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              'Total Price: ₹$price',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Confirm booking logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
