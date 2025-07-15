import 'package:telephony/telephony.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'local_storage_service.dart';
import '../models/utr_model.dart';

// This function must be a top-level function to be used as a background callback
void onBackgroundMessage(SmsMessage message) {
  print("Background SMS received: ${message.body}");
  // For a robust solution, you would use a background service to handle this
}

class SmsService {
  final Telephony telephony = Telephony.instance;
  final ApiService _apiService = ApiService();
  final LocalStorageService _localStorageService = LocalStorageService();

  // Starts the SMS listener
  void startListening() async {
    final user = await _localStorageService.getUser();
    if (user == null || user.bankSmsSenderId.isEmpty) {
      print("User or Sender ID not configured. SMS listening stopped.");
      return;
    }

    print("Starting SMS listener for sender: ${user.bankSmsSenderId}");
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) async {
        // Filter messages by the configured sender ID
        if (message.address?.toUpperCase() == user.bankSmsSenderId.toUpperCase()) {
          print("SMS received from configured sender: ${message.address}");
          await _processSms(message.body ?? "", user.upiId);
        }
      },
      onBackgroundMessage: onBackgroundMessage,
    );
  }

  // Extracts data from SMS and sends it to the API
  Future<void> _processSms(String messageBody, String userId) async {
    final utrRegex = RegExp(r'UPI ref No\.?\s*(\d{12,})');
    final amountRegex = RegExp(r'Rs\.?\s*(\d+\.?\d{0,2})');

    final utrMatch = utrRegex.firstMatch(messageBody);
    final amountMatch = amountRegex.firstMatch(messageBody);

    if (utrMatch != null && amountMatch != null) {
      final utr = utrMatch.group(1);
      final amount = amountMatch.group(1);
      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      if (utr != null && amount != null) {
        print("Extracted UTR: $utr, Amount: $amount");
        final utrData = UtrData(
          userId: userId,
          utr: utr,
          amount: amount,
          date: currentDate,
        );
        await _apiService.submitUtr(utrData);
      }
    }
  }
}
