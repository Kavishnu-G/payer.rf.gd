import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/utr_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../services/sms_service.dart';
import 'generate_link_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _apiService = ApiService();
  final _localStorageService = LocalStorageService();
  final _smsService = SmsService();

  bool _isLoading = true;
  List<UtrData> _paymentHistory = [];
  double _todayTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
  }

  Future<void> _initializeDashboard() async {
    // Start listening for SMS in the background
    _smsService.startListening();

    // Fetch initial data
    await _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final user = await _localStorageService.getUser();
    if (user != null) {
      final history = await _apiService.getPaymentHistory(user.upiId);
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      double todaySum = 0.0;
      
      for (var payment in history) {
        if (payment.date == today) {
          todaySum += double.tryParse(payment.amount) ?? 0.0;
        }
      }

      setState(() {
        _paymentHistory = history.reversed.toList(); // Show newest first
        _todayTotal = todaySum;
      });
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const SettingsScreen()))
                .then((_) => _fetchData()), // Refresh data when returning
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchData,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Cards
                    Row(
                      children: [
                        Expanded(child: _buildSummaryCard('Collected Today', '₹${_todayTotal.toStringAsFixed(2)}')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildSummaryCard('Total UTRs', _paymentHistory.length.toString())),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Last 5 Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    // Recent Transactions List
                    Expanded(
                      child: _paymentHistory.isEmpty
                          ? const Center(child: Text('No transactions yet.'))
                          : ListView.builder(
                              itemCount: _paymentHistory.length > 5 ? 5 : _paymentHistory.length,
                              itemBuilder: (context, index) {
                                final payment = _paymentHistory[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  child: ListTile(
                                    leading: const Icon(Icons.check_circle, color: Colors.green),
                                    title: Text('UTR: ${payment.utr}'),
                                    subtitle: Text('Date: ${payment.date}'),
                                    trailing: Text('₹${payment.amount}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GenerateLinkScreen())),
        label: const Text('Generate Link'),
        icon: const Icon(Icons.add_link),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}