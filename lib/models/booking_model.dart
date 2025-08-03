import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled
}

class Booking {
  final String id;
  final String userId;
  final int protectees;
  final int protectors;
  final String dressCode;
  final int cars;
  final String pickupLocation;
  final DateTime pickupDateTime;
  final int durationHours;
  final double price;
  final BookingStatus status;
  final DateTime createdAt;

  Booking({
    String? id,
    required this.userId,
    required this.protectees,
    required this.protectors,
    required this.dressCode,
    required this.cars,
    required this.pickupLocation,
    required this.pickupDateTime,
    required this.durationHours,
    required this.price,
    this.status = BookingStatus.pending,
    DateTime? createdAt,
  }) : 
    this.id = id ?? const Uuid().v4(),
    this.createdAt = createdAt ?? DateTime.now();

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['userId'],
      protectees: json['protectees'],
      protectors: json['protectors'],
      dressCode: json['dressCode'],
      cars: json['cars'],
      pickupLocation: json['pickupLocation'],
      pickupDateTime: DateTime.parse(json['pickupDateTime']),
      durationHours: json['durationHours'],
      price: json['price'].toDouble(),
      status: BookingStatus.values.byName(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'protectees': protectees,
      'protectors': protectors,
      'dressCode': dressCode,
      'cars': cars,
      'pickupLocation': pickupLocation,
      'pickupDateTime': pickupDateTime.toIso8601String(),
      'durationHours': durationHours,
      'price': price,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get formattedDate {
    return DateFormat('dd MMM yyyy').format(pickupDateTime);
  }

  String get formattedTime {
    return DateFormat('hh:mm a').format(pickupDateTime);
  }

  String get formattedPrice {
    return '₹${price.toStringAsFixed(2)}';
  }

  String get statusText {
    return status.name[0].toUpperCase() + status.name.substring(1);
  }

  Booking copyWith({
    String? id,
    String? userId,
    int? protectees,
    int? protectors,
    String? dressCode,
    int? cars,
    String? pickupLocation,
    DateTime? pickupDateTime,
    int? durationHours,
    double? price,
    BookingStatus? status,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      protectees: protectees ?? this.protectees,
      protectors: protectors ?? this.protectors,
      dressCode: dressCode ?? this.dressCode,
      cars: cars ?? this.cars,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      pickupDateTime: pickupDateTime ?? this.pickupDateTime,
      durationHours: durationHours ?? this.durationHours,
      price: price ?? this.price,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}