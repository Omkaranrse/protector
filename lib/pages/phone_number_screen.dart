import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:protector/pages/otp_verify_screen.dart';
import 'package:protector/providers/auth_provider.dart';
import 'package:protector/services/notification_service.dart';
import 'package:protector/utils/page_transitions.dart';
import 'package:protector/utils/validators.dart';
import 'package:protector/widgets/loading_indicator.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _countryCode = '+91';
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final notificationService = Provider.of<NotificationService>(context, listen: false);
      
      final phoneNumber = '$_countryCode${_phoneController.text.trim()}';
      final success = await authProvider.sendOtp(phoneNumber);

      if (success) {
        if (!mounted) return;
        
        notificationService.showInAppNotification(
          'OTP Sent',
          'A verification code has been sent to your phone',
        );

        final result = await Navigator.push(
          context,
          PageTransitions.slideRightTransition(
            OtpVerifyScreen(phoneNumber: phoneNumber),
          ),
        );

        if (result == true) {
          Navigator.pop(context, true);
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to send OTP. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Enter Phone Number', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        loadingMessage: 'Sending OTP...',
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter your phone number',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null) ...[  
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '+91',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Phone number',
                            hintStyle: TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.grey[900],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            errorStyle: const TextStyle(color: Colors.red),
                          ),
                          validator: Validators.validatePhoneNumber,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _sendOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Next'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildPolicyText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPolicyText() {
    return const Text.rich(
      TextSpan(
        text: 'By continuing you acknowledge and agree to\n',
        style: TextStyle(color: Colors.white54, fontSize: 12),
        children: [
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline),
          ),
          TextSpan(text: ' and '),
          TextSpan(
            text: 'Terms of Use',
            style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline),
          ),
        ],
      ),
    );
  }

  // This method is not used and is redundant with the button in the build method
  // Removing it would be better, but keeping it commented for reference
  /*
  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _sendOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text('Next'),
      ),
    );
  }
  */
}
