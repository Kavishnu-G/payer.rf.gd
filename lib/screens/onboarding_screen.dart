import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../utils/app_permissions.dart';
import 'dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  final _localStorageService = LocalStorageService();

  // Controllers for form fields
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _panController = TextEditingController();
  final _upiIdController = TextEditingController();
  final _senderIdController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _panController.dispose();
    _upiIdController.dispose();
    _senderIdController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // 1. Request SMS Permission
      bool smsPermissionGranted = await AppPermissions.requestSmsPermission();
      if (!smsPermissionGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SMS permission is required to collect payments.')),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      // 2. Create User object
      final user = User(
        fullName: _fullNameController.text,
        mobileNumber: _mobileController.text,
        aadharOrPan: _panController.text,
        upiId: _upiIdController.text,
        bankSmsSenderId: _senderIdController.text.toUpperCase(),
      );

      // 3. Register user with API and save locally
      bool registered = await _apiService.registerUser(user);
      if (registered) {
        await _localStorageService.saveUser(user);
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration failed. Please try again.')),
          );
        }
      }

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Collector')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Enter Your Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                validator: (value) => (value?.isEmpty ?? true) ? 'Please enter your full name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(labelText: 'Mobile Number', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) => (value?.isEmpty ?? true) ? 'Please enter your mobile number' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _panController,
                decoration: const InputDecoration(labelText: 'Aadhaar/PAN', border: OutlineInputBorder()),
                validator: (value) => (value?.isEmpty ?? true) ? 'Please enter your Aadhaar or PAN' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _upiIdController,
                decoration: const InputDecoration(labelText: 'UPI ID (e.g., user@okicici)', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your UPI ID';
                  if (!value.contains('@')) return 'Please enter a valid UPI ID';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senderIdController,
                decoration: const InputDecoration(labelText: 'Bank SMS Sender ID (e.g., BOIIND-S)', border: OutlineInputBorder()),
                textCapitalization: TextCapitalization.characters,
                validator: (value) => (value?.isEmpty ?? true) ? 'Please enter the bank sender ID' : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Register & Proceed'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}