<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Android-Native_SMS-3DDC84?style=for-the-badge&logo=android&logoColor=white" />
  <img src="https://img.shields.io/badge/GetX-State_Management-8B5CF6?style=for-the-badge" />
</p>

<h1 align="center">📱 SMS Gateway App</h1>

<p align="center">
  تطبيق Flutter/Android يحوّل هاتفك إلى بوابة SMS حقيقية تُرسل الرسائل عبر شريحة SIM.
  <br/>
  A Flutter/Android app that turns your phone into a real SMS gateway, sending messages through the device's SIM card.
</p>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [How It Works](#-how-it-works)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Features](#-features)
- [Getting Started](#-getting-started)
- [Permissions](#-permissions)
- [Configuration](#-configuration)
- [Related Repositories](#-related-repositories)

---

## 🔍 Overview

هذا التطبيق هو **بوابة SMS** تعمل على أجهزة Android. يتصل بالسيرفر الخلفي (Laravel Backend) ويقوم بـ:

1. **التسجيل** في السيرفر والحصول على Token
2. **سحب الرسائل** المعلقة (Polling)
3. **إرسال SMS** فعلياً عبر شريحة SIM في الجهاز
4. **تقرير النتائج** للسيرفر (sent/failed)
5. **إرسال Heartbeat** دوري (battery + signal)

> 💡 الفكرة: بدلاً من الاعتماد على مزودي SMS خارجيين مثل Twilio، يُستخدم هاتف Android حقيقي كبوابة إرسال.

---

## ⚙️ How It Works

```
┌──────────────────────────────────────────────────────┐
│                   SMS Gateway App                     │
│                                                      │
│  ┌──────────┐     ┌──────────┐     ┌──────────────┐ │
│  │ Register │────▶│  Poll    │────▶│ Send SMS     │ │
│  │ Device   │     │  Jobs    │     │ via SIM Card │ │
│  └──────────┘     └────┬─────┘     └──────┬───────┘ │
│                        │                   │         │
│                   ┌────┴─────┐     ┌──────┴───────┐ │
│                   │Heartbeat │     │Report Result │ │
│                   │(periodic)│     │(sent/failed) │ │
│                   └──────────┘     └──────────────┘ │
└──────────────────────────────────────────────────────┘
                         │
                    ┌────┴────┐
                    │ Backend │
                    │ Server  │
                    └─────────┘
```

### Lifecycle

1. **Registration** — عند أول تشغيل، يُسجّل الجهاز في السيرفر ويحصل على Token يُخزّن بشكل آمن
2. **Authentication** — يتحقق من صلاحية التوكن عند كل تشغيل
3. **Dashboard** — يعرض حالة البوابة ويبدأ الـ Polling
4. **Polling Loop** — يسحب الرسائل المعلقة من `/gateway/jobs/next`
5. **Native SMS** — يُرسل عبر Android `SmsManager` API من خلال `MethodChannel`
6. **Result Reporting** — يُبلّغ السيرفر بنتيجة الإرسال
7. **Heartbeat** — يُرسل نبضات حياة دورية (مستوى البطارية + قوة الإشارة)

---

## 🛠 Tech Stack

| Technology | Version | Purpose |
|---|---|---|
| **Flutter** | 3.x | UI Framework |
| **Dart** | 3.x | Language |
| **GetX** | 4.6.6 | State management, DI & routing |
| **Dio** | 5.4.0 | HTTP client |
| **Flutter Secure Storage** | 9.0.0 | Encrypted token storage |
| **Device Info Plus** | 10.1.0 | Device identification |
| **Battery Plus** | 6.0.0 | Battery level monitoring |
| **Permission Handler** | 11.3.0 | Runtime permission requests |
| **MethodChannel** | Native | Bridge to Android SMS API |

---

## 📁 Project Structure

```
Flutter-SMS-Gateway/
├── lib/
│   ├── main.dart                              # App entry point + routing
│   ├── core/
│   │   ├── services/
│   │   │   ├── network_service.dart           # Dio HTTP client setup
│   │   │   ├── storage_service.dart           # Secure token storage
│   │   │   └── sms_native_service.dart        # Native SMS via MethodChannel
│   │   └── constants/                         # API URLs, config values
│   ├── data/
│   │   ├── models/                            # Data models
│   │   └── repositories/                      # API repositories
│   ├── modules/
│   │   ├── auth/                              # Gateway registration screen
│   │   │   ├── controllers/
│   │   │   └── views/
│   │   └── dashboard/                         # Main dashboard + status
│   │       ├── controllers/
│   │       └── views/
│   └── routes/                                # GetX route definitions
│
├── android/
│   └── app/src/main/
│       ├── kotlin/.../MainActivity.kt         # MethodChannel SMS handler
│       └── AndroidManifest.xml                # SMS permissions
│
└── pubspec.yaml
```

---

## ✨ Features

| Feature | Description |
|---|---|
| 🔐 **Secure Token Storage** | التوكن يُخزّن مُشفّراً عبر `flutter_secure_storage` |
| 📡 **Auto Registration** | تسجيل تلقائي للجهاز عند أول تشغيل |
| 🔄 **Job Polling** | سحب مستمر للرسائل المعلقة من السيرفر |
| 📲 **Native SMS Sending** | إرسال SMS فعلي عبر `MethodChannel` → Android `SmsManager` |
| 💓 **Heartbeat** | نبضات حياة دورية (battery + signal) |
| 📊 **Dashboard** | شاشة مراقبة حالة البوابة |
| 🔁 **Auto Reconnect** | إعادة الاتصال عند فقدان التوكن |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.x
- Android device with **SIM card** (⚠️ لا يعمل على Emulator)
- الـ [Backend Server](https://github.com/alzoodiali/smsGatewaybackend) شغّال

### Installation

```bash
# Clone the repository
git clone https://github.com/alzoodiali/Flutter-SMS-Gateway.git
cd Flutter-SMS-Gateway

# Install dependencies
flutter pub get

# Update the server URL
# Edit: lib/core/constants/

# Run on a physical Android device
flutter run
```

> ⚠️ **مهم**: يجب تشغيل التطبيق على جهاز Android **حقيقي** يحتوي شريحة SIM. لن يعمل إرسال SMS على المحاكي (Emulator).

---

## 📋 Permissions

التطبيق يحتاج الصلاحيات التالية:

```xml
<!-- إرسال رسائل SMS -->
<uses-permission android:name="android.permission.SEND_SMS" />

<!-- قراءة معلومات الجهاز -->
<uses-permission android:name="android.permission.READ_PHONE_STATE" />

<!-- الاتصال بالسيرفر -->
<uses-permission android:name="android.permission.INTERNET" />
```

يطلب التطبيق هذه الصلاحيات تلقائياً عند التشغيل عبر `permission_handler`.

---

## ⚙️ Configuration

### Server URL

عدّل عنوان السيرفر في ملف الثوابت:

```
lib/core/constants/
```

### SIM Slot

يمكن تحديد شريحة SIM المُستخدمة للإرسال (Slot 1 أو 2) من خلال إعدادات البوابة في لوحة تحكم السيرفر.

---

## 🔗 Related Repositories

| Repository | Description |
|---|---|
| [**smsGatewaybackend**](https://github.com/alzoodiali/smsGatewaybackend) | سيرفر Laravel — يدير الرسائل والبوابات وأكواد OTP مع لوحة تحكم Filament |

---

## 📄 License

This project is open-sourced software licensed under the [MIT License](https://opensource.org/licenses/MIT).
