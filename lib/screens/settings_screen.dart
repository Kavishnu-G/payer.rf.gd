import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import 'onboarding_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _localStorageService = LocalStorageService();
  final _apiService = ApiService();

  final _upiIdController = TextEditingController();
  final _senderIdController = TextEditingController();
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    _currentUser = await _localStorageService.getUser();
    if (_currentUser != null) {
      _upiIdController.text = _currentUser!.upiId;
      _senderIdController.text = _currentUser!.bankSmsSenderId;
    }
    setState(() => _isLoading = false);
  }

  Future<void> _updateSettings() async {
    if (_currentUser != null) {
      final updatedUser = User(
        fullName: _currentUser!.fullName,
        mobileNumber: _currentUser!.mobileNumber,
        aadharOrPan: _currentUser!.aadharOrPan,
        upiId: _upiIdController.text,
        bankSmsSenderId: _senderIdController.text.toUpperCase(),
      );

      // Save to API and then locally
      bool success = await _apiService.registerUser(updatedUser);
      if (success) {
        await _localStorageService.saveUser(updatedUser);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings updated successfully!')),
          );
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update settings.')),
          );
        }
      }
    }
  }

  Future<void> _logout() async {
    await _localStorageService.clearUser();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        (route) => false, // This predicate removes all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentUser == null
              ? const Center(child: Text('Could not load user data.'))
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    TextFormField(
                      controller: _upiIdController,
                      decoration: const InputDecoration(labelText: 'UPI ID', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _senderIdController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(labelText: 'Bank SMS Sender ID', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _updateSettings,
                      child: const Text('Save Changes'),
                    ),
                    const Divider(height: 40),
                    ListTile(
                      title: const Text('Full Name'),
                      subtitle: Text(_currentUser!.fullName),
                    ),
                    ListTile(
                      title: const Text('Mobile Number'),
                      subtitle: Text(_currentUser!.mobileNumber),
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: _logout,
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
    );
  }
}