import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';
import '../models/utr_model.dart';

class ApiService {
  // IMPORTANT: Replace with your Firebase Realtime Database URL
  final String _baseUrl = "https://payerrfgd-35255344-default-rtdb.firebaseio.com";

  // Registers a new user in Firebase
  Future<bool> registerUser(User user) async {
    // We use the UPI ID as a key to store user data
    final url = Uri.parse('$_baseUrl/api/users/${Uri.encodeComponent(user.upiId)}.json');
    try {
      final response = await http.put( // PUT will create or overwrite
        url,
        body: jsonEncode(user.toJson()),
      );
      // Firebase returns 200 for successful PUT
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Submits a new UTR entry to Firebase
  Future<bool> submitUtr(UtrData utrData) async {
    final url = Uri.parse('$_baseUrl/api/utr/receive.json');
    try {
      final response = await http.post( // POST generates a unique key for each entry
        url,
        body: jsonEncode(utrData.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Fetches payment history for a specific user
  Future<List<UtrData>> getPaymentHistory(String userId) async {
    // Queries Firebase for UTRs matching the userId (UPI ID)
    final url = Uri.parse('$_baseUrl/api/utr/receive.json?orderBy="user_id"&equalTo="${Uri.encodeComponent(userId)}"');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body) ?? {};
        final List<UtrData> history = [];
        data.forEach((key, value) {
          history.add(UtrData(
            userId: value['user_id'],
            utr: value['utr'],
            amount: value['amount'].toString(),
            date: value['date'],
          ));
        });
        return history;
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}