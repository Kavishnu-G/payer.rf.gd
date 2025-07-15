# 💸 Payer.rf.gd Collector – UTR-Based Instant Payment Verification System

Payer.rf.gd Collector is a dual-module solution designed for **small-scale payment collectors**, **event organizers**, and **Google Forms users** who need to collect UPI payments **without a merchant account**, payment gateway, or tedious manual verification.

This project consists of:

- 📱 **Android App Module** (Flutter) – For users to collect and verify UPI payments via UTR from SMS.
- 🌐 **Web Module** – A sharable static payment page for customers to make payments and submit UTR numbers.

🔗 **Live Project Link (Built using Firebase Studio):** [https://idx.google.com/payerrfgd-35255344](https://idx.google.com/payerrfgd-35255344)

---

## 📦 Project Modules

```
/app           # Android Flutter App to collect and manage payments
/web           # Static Web Module for payment submission by users
README.md
session_expired.html
```

---

## 🎯 Project Description

**Payer.rf.gd Collector** is born out of a real-world pain point:  
🔹 Many institutions and companies use **Google Forms** to collect registrations and payments, but:

- They often just paste a **static UPI QR image**
- Ask users to upload **UTR numbers** or **screenshots**
- Then spend hours **manually verifying** payments
- And worst — Google Form creators usually **don’t have merchant accounts** to automate payment tracking.

⚡ This project **fixes that**:

> Users who want to collect payment via Google Forms can now install the **Payer.rf.gd Android App**, configure it once with UPI + SMS sender ID, and generate sharable payment links.

📥 The payer (filling the Google Form) can click the link, make payment via QR, enter UTR, and the system automatically matches it with the UTR received from the SMS on the collector's phone.

💥 **Result?**
- ✅ Instant payment verification
- ✅ No third-party gateway needed
- ✅ No screenshots or manual checks
- ✅ Funds go directly to your bank via UPI
- ✅ Payers can still use Google Forms — seamlessly!

---

## 🛠️ Stack & Technologies

### Android App:
- Flutter 3.x
- Dart
- Telephony (for SMS reading)
- SharedPreferences (for local storage)
- REST API (for UTR matching, optional)

### Web Module:
- HTML, TailwindCSS
- JavaScript
- QRious.js (QR generation)
- Base64 token encoding for secure link sharing

### Build Platform:
- ✅ Built using [Firebase Studio](https://idx.google.com/payerrfgd-35255344) (Google IDX)

---
## 🎬 Live Demo

[![Watch the Demo](https://img.youtube.com/vi/2LV6_80hC3g/0.jpg)](https://www.youtube.com/watch?v=2LV6_80hC3g)

---
## 🔧 Features

### ✅ Android App (Flutter)
- KYC-style onboarding (Name, UPI ID, Sender ID)
- Reads UPI credit messages only from user-defined sender (e.g., `BOIIND-S`)
- Extracts UTR number and amount automatically
- Pushes UTR details to backend
- Generate sharable **payment token links**
- Dashboard with daily amount, UTRs, and link generator

### ✅ Web Module
- Accepts **Base64 encoded token** via URL
- Displays UPI ID and amount
- QR generation for payment
- 2-minute countdown for session + QR
- Manual UTR entry field
- Submits UTR to backend for verification
- Redirects to session timeout screen after expiry

---

## 🔗 Real Use Case Flow

1. **Form Creator Installs App**
   - Completes basic KYC
   - Sets UPI ID (e.g., `kavimobiled@okicici`)
   - Adds bank SMS sender ID (e.g., `BOIIND-S`)

2. **Generates Token Link**
   - `upi_id` + `amount` are embedded in a Base64 token
   - Link: `https://payer.io/web/index.html?token=...`

3. **Adds Link to Google Form**
   - Pasted as "Make Payment" button or clickable hyperlink

4. **Form Filler (Payer)**
   - Opens link → Sees QR + UPI ID
   - Pays via UPI app
   - Enters UTR manually
   - UTR is cross-verified with one received in merchant's SMS

---

## 📁 App Module Structure (`/app`)

```
lib/
├── main.dart
├── models/
│   ├── user_model.dart
│   └── utr_model.dart
├── screens/
│   ├── onboarding_screen.dart
│   ├── dashboard_screen.dart
│   ├── generate_link_screen.dart
│   └── settings_screen.dart
├── services/
│   ├── api_service.dart
│   ├── local_storage_service.dart
│   └── sms_service.dart
└── utils/
    └── app_permissions.dart
```

---

## 📁 Web Module Structure (`/web`)

- `index.html` / `index2.html` → Accepts token from Google Form and creates QR
- `session_expired.html` → Informs session expired, prevents going back
- TailwindCSS used for minimal design
- QRious.js used to render UPI QR codes
- Token format:  
```json
{
  "upi_id": "kavimobiled@okicici",
  "amount": "10"
}
```

Base64 Encoded & passed as:
```
index.html?token=BASE64_STRING
```

---

## 🔐 Security Practices

- No sensitive SMS messages read — only from configured sender
- UPI payments happen directly via user’s app (Google Pay, PhonePe, etc.)
- No third-party payment gateway involved
- Payments go directly to collector’s UPI-linked bank
- Easy to validate and track without storing payment credentials

---

## 🙌 Author & Credits

**Project Lead:**  
👨‍💻 Kavishnu G  
📍 Student | Developer | Technopreneur  
🎓 Sri Krishna Arts and Science College  
🌐 GitHub: [github.com/kavishnu-g](https://github.com/kavishnu-g)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

> 🚀 If you’re a college club, freelancer, or small business owner — this tool can save you **hours of manual work** while keeping you **fully in control** of your payment flow.
