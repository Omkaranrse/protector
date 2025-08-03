import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:protector/pages/admin/admin_login_screen.dart';
import 'package:protector/pages/booking_history_screen.dart';
import 'package:protector/pages/phone_number_screen.dart';
import 'package:protector/pages/admin/admin_dashboard_screen.dart';
import 'package:protector/pages/user_profile_screen.dart';
import 'package:protector/providers/auth_provider.dart';
import 'package:protector/services/notification_service.dart';
import 'package:protector/utils/page_transitions.dart';

class AccountScreen extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  const AccountScreen({Key? key, this.onLoginSuccess}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final isLoggedIn = authProvider.isAuthenticated;
        final user = authProvider.user;

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
              child: isLoggedIn && user != null
                  ? _buildLoggedInView(authProvider, user.isAdmin)
                  : _buildLoginView(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoggedInView(AuthProvider authProvider, bool isAdmin) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (isAdmin)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 32),
        _buildAccountOption(
          'My Profile',
          Icons.person,
          () => Navigator.push(
            context,
            PageTransitions.slideRightTransition(const UserProfileScreen()),
          ),
        ),
        const SizedBox(height: 16),
        _buildAccountOption(
          'My Bookings',
          Icons.calendar_today,
          () => Navigator.push(
            context,
            PageTransitions.slideRightTransition(const BookingHistoryScreen()),
          ),
        ),
        if (isAdmin) ...[  
          const SizedBox(height: 16),
          _buildAccountOption(
            'Admin Dashboard',
            Icons.admin_panel_settings,
            () => Navigator.push(
              context,
              PageTransitions.slideRightTransition(const AdminDashboardScreen()),
            ),
          ),
        ],
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () => _logout(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[850],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Members Login',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Easily book a Protector within minutes.\nGain peace of mind and ensure your safety.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => _navigateToLogin(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[850],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.security),
                  label: const Text('Members Login'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Not a Member yet?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'You can gain member access when you book\nyour first armed Protector.',
          style: TextStyle(color: Colors.white70),
        ),
        const Spacer(),
        Center(
          child: TextButton(
            onPressed: () => _navigateToAdminLogin(),
            child: const Text(
              'Admin Login',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountOption(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToLogin() async {
    final result = await Navigator.push(
      context,
      PageTransitions.slideRightTransition(const PhoneNumberScreen()),
    );
    
    if (result == true && widget.onLoginSuccess != null) {
      widget.onLoginSuccess!();
    }
  }

  void _navigateToAdminLogin() {
    Navigator.push(
      context,
      PageTransitions.slideRightTransition(const AdminLoginScreen()),
    );
  }

  Future<void> _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final notificationService = Provider.of<NotificationService>(context, listen: false);
    
    await authProvider.logout();
    notificationService.showNotification('You have been logged out successfully', NotificationType.success);
  }
}
