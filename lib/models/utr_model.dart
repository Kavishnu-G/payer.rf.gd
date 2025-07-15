class UtrData {
  final String userId;
  final String utr;
  final String amount;
  final String date;

  UtrData({
    required this.userId,
    required this.utr,
    required this.amount,
    required this.date,
  });

  // Converts a UtrData object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'utr': utr,
      'amount': amount,
      'date': date,
    };
  }
}