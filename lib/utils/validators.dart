class Validators {
  // Validate phone number (Indian format)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove any non-digit characters
    final cleanedNumber = value.replaceAll(RegExp(r'\D'), '');
    
    // Check if it's a valid Indian phone number (10 digits)
    if (cleanedNumber.length != 10) {
      return 'Please enter a valid 10-digit phone number';
    }
    
    return null; // Valid
  }

  // Validate OTP
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }
    
    return null; // Valid
  }

  // Validate name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    return null; // Valid
  }

  // Validate email (optional)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email is optional
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null; // Valid
  }

  // Validate number of protectees
  static String? validateProtectees(int? value) {
    if (value == null) {
      return 'Number of protectees is required';
    }
    
    if (value < 1) {
      return 'At least 1 protectee is required';
    }
    
    if (value > 10) {
      return 'Maximum 10 protectees allowed';
    }
    
    return null; // Valid
  }

  // Validate number of protectors
  static String? validateProtectors(int? value) {
    if (value == null) {
      return 'Number of protectors is required';
    }
    
    if (value < 1) {
      return 'At least 1 protector is required';
    }
    
    if (value > 5) {
      return 'Maximum 5 protectors allowed';
    }
    
    return null; // Valid
  }

  // Validate number of cars
  static String? validateCars(int? value) {
    if (value == null) {
      return 'Number of cars is required';
    }
    
    if (value < 1) {
      return 'At least 1 car is required';
    }
    
    if (value > 3) {
      return 'Maximum 3 cars allowed';
    }
    
    return null; // Valid
  }

  // Validate pickup location
  static String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pickup location is required';
    }
    
    if (value.length < 5) {
      return 'Please enter a more specific location';
    }
    
    return null; // Valid
  }

  // Validate pickup date
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Pickup date is required';
    }
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(value.year, value.month, value.day);
    
    if (selectedDate.isBefore(today)) {
      return 'Pickup date cannot be in the past';
    }
    
    // Limit bookings to 30 days in advance
    final maxDate = today.add(const Duration(days: 30));
    if (selectedDate.isAfter(maxDate)) {
      return 'Pickup date cannot be more than 30 days in advance';
    }
    
    return null; // Valid
  }

  // Validate pickup time
  static String? validateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Pickup time is required';
    }
    
    final now = DateTime.now();
    
    // If it's today, ensure the time is at least 2 hours from now
    if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
      final minimumTime = now.add(const Duration(hours: 2));
      if (dateTime.isBefore(minimumTime)) {
        return 'Pickup time must be at least 2 hours from now';
      }
    }
    
    return null; // Valid
  }

  // Validate duration
  static String? validateDuration(int? value) {
    if (value == null) {
      return 'Duration is required';
    }
    
    if (value < 2) {
      return 'Minimum duration is 2 hours';
    }
    
    if (value > 12) {
      return 'Maximum duration is 12 hours';
    }
    
    return null; // Valid
  }

  // Validate admin username
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    
    if (value.length < 4) {
      return 'Username must be at least 4 characters';
    }
    
    return null; // Valid
  }

  // Validate admin password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null; // Valid
  }
}