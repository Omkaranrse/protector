import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:protector/models/user_model.dart';
import 'package:protector/providers/auth_provider.dart';
import 'package:protector/services/notification_service.dart';
import 'package:protector/utils/validators.dart';
import 'package:protector/widgets/loading_indicator.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initUserData();
  }

  void _initUserData() {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final notificationService = Provider.of<NotificationService>(context, listen: false);

      final success = await authProvider.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : null,
      );

      if (success) {
        notificationService.showInAppNotification(
          'Profile Updated',
          'Your profile has been updated successfully.',
        );
        setState(() => _isEditing = false);
      } else {
        notificationService.showInAppNotification(
          'Update Failed',
          'Failed to update your profile. Please try again.',
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.user;

          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return LoadingOverlay(
            isLoading: _isLoading,
            loadingMessage: 'Updating profile...',
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(user),
                    const SizedBox(height: 24),
                    _buildProfileForm(),
                    if (_isEditing) ...[  
                      const SizedBox(height: 24),
                      _buildActionButtons(),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[800],
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
              style: const TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            user.phoneNumber,
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
          if (user.isAdmin) ...[  
            const SizedBox(height: 8),
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
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person),
          ),
          enabled: _isEditing,
          validator: Validators.validateName,
        ),
        const SizedBox(height: 16),
        Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return TextFormField(
              enabled: false,
              initialValue: authProvider.user?.phoneNumber ?? '',
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email (Optional)',
            prefixIcon: Icon(Icons.email),
          ),
          enabled: _isEditing,
          validator: Validators.validateEmail,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() => _isEditing = false);
              _initUserData(); // Reset form
            },
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveProfile,
            child: const Text('Save Changes'),
          ),
        ),
      ],
    );
  }
}