# Protector

Protector is a Flutter mobile app for booking and managing personal protection services. It guides users through selecting protection details, dress code, pickup information, and booking confirmation.

## Features

- User phone number and OTP verification flow
- Booking flow for protectees, protectors, dress code, and pickup details
- Motorcade and vehicle selection experience
- Booking history and booking confirmation screens
- Admin dashboard for overseeing bookings

## Prerequisites

- Flutter SDK 3.8.1 or newer
- An iOS or Android emulator/device
- Xcode for iOS development on macOS

## Getting started

1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Run the app:
   ```bash
   flutter run
   ```
3. For a specific platform:
   ```bash
   flutter run -d ios
   flutter run -d android
   ```

## Project structure

- lib/pages: app screens and flows
- lib/services: API and service layer helpers
- lib/models: booking and user data models
- lib/providers: state management for booking and user data

## Notes

- The app currently uses mock service responses for booking and authentication flows.
- Assets are bundled from the assets directory and referenced in the Flutter project configuration.
