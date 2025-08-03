import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:protector/providers/auth_provider.dart';
import 'package:protector/providers/booking_provider.dart';
import 'package:protector/services/notification_service.dart';
import 'package:protector/pages/splash_screen.dart';
import 'pages/protector_home_page.dart';
import 'pages/booking_screen.dart';
import 'pages/AccountScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService();
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        Provider.value(value: notificationService),
      ],
      child: MaterialApp(
        title: 'Protector App',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: notificationService.scaffoldMessengerKey,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.black45,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize auth state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).initAuth();
      
      // Initialize Firebase Messaging
      try {
        Provider.of<NotificationService>(context, listen: false)
            .initializeFirebaseMessaging();
      } catch (e) {
        debugPrint('Failed to initialize Firebase Messaging: $e');
      }
    });
  }

  final List<Widget> _screens = [
    const ProtectorHomePage(),
    const BookingScreen(),
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
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
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
