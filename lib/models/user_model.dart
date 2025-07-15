class User {
  final String fullName;
  final String mobileNumber;
  final String aadharOrPan;
  final String upiId;
  final String bankSmsSenderId;

  User({
    required this.fullName,
    required this.mobileNumber,
    required this.aadharOrPan,
    required this.upiId,
    required this.bankSmsSenderId,
  });

  // Converts a User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'aadharOrPan': aadharOrPan,
      'upiId': upiId,
      'bankSmsSenderId': bankSmsSenderId,
    };
  }

  // Creates a User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'],
      mobileNumber: json['mobileNumber'],
      aadharOrPan: json['aadharOrPan'],
      upiId: json['upiId'],
      bankSmsSenderId: json['bankSmsSenderId'],
    );
  }
}