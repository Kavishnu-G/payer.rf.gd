import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import '../services/local_storage_service.dart';

class GenerateLinkScreen extends StatefulWidget {
  const GenerateLinkScreen({super.key});

  @override
  State<GenerateLinkScreen> createState() => _GenerateLinkScreenState();
}

class _GenerateLinkScreenState extends State<GenerateLinkScreen> {
  final _amountController = TextEditingController();
  final _localStorageService = LocalStorageService();

  String? _upiId;
  String? _generatedToken;

  @override
  void initState() {
    super.initState();
    _loadUpiId();
  }

  Future<void> _loadUpiId() async {
    final user = await _localStorageService.getUser();
    if (user != null) {
      setState(() {
        _upiId = user.upiId;
      });
    }
  }

  void _generateToken() {
    if (_upiId == null || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount.')),
      );
      return;
    }

    final payload = {
      "upi_id": _upiId,
      "amount": _amountController.text,
    };

    final jsonString = jsonEncode(payload);
    final bytes = utf8.encode(jsonString);
    final base64String = base64Encode(bytes);

    setState(() {
      _generatedToken = base64String;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate Payment Link')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: TextEditingController(text: _upiId ?? 'Loading...'),
              decoration: const InputDecoration(
                labelText: 'Your UPI ID',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder()),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _generateToken,
              child: const Text('Generate Token'),
            ),
            const SizedBox(height: 30),
            if (_generatedToken != null)
              _buildTokenDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Generated Token:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Text(_generatedToken!, style: const TextStyle(fontFamily: 'monospace')),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copy'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _generatedToken!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Token copied to clipboard!')),
                );
              },
            ),
            const SizedBox(width: 20),
            TextButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Share'),
              onPressed: () => Share.share(_generatedToken!),
            ),
          ],
        )
      ],
    );
  }
}