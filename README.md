# Tenaye
# 📱 Tenaye – AI-Powered Personal Health & Emergency Assistant

**Project:** Tenaye MVP  
**Platform:** Android (APK)  
**Backend:** Node.js, Express, Prisma, MySQL (Deployed on VPS)  
**AI Integration:** Google Gemini API  
**Frontend:** Flutter (Dart)

---

## 🚀 Overview

Tenaye is a personal health assistant designed to combine daily wellness tracking with emergency response support.

The app enables users to:
- Track moods and health context
- Receive AI-powered health suggestions
- Manage medication reminders
- Access an emergency SOS medical profile instantly

The system connects a Flutter mobile app with a secure backend API hosted on a VPS.

---

## 📥 Installation Guide (Android APK)

⚠️ **Notes for Evaluators**

- Ensure the device has internet access to reach the backend server  
- If installation fails, enable **Install unknown apps** in Android settings  
- This is a development build intended for demonstration purposes only  
- Please use an **Android device for testing**, as iOS is not supported in this release  

---

Since this is a prototype build not published on the Play Store, please follow the steps below to install the app manually.

### 1. Download the APK

-click the following link  on your Android device  
[http://173.212.213.249/tenaye.apk](http://173.212.213.249/tenaye.apk)

- The APK file will begin downloading automatically  

---

### 2. Install the App

After download:

If Android blocks installation:

- Go to **Settings**
- Open **Security** (or **Privacy & Security**, depending on device)
- Tap **Install unknown apps** (or **Special app access**)
- Select your browser (e.g. Chrome)
- Enable **“Allow from this source”**
- Go back and open the APK file
- Tap **Install**

> ⚠️ Note: Some devices may show “Play Protect blocked this app” since it is not from the Play Store. This is expected for test builds.

---

## 🔐 Required Permissions

To fully evaluate the application, please allow the following permissions:

- **Display over other apps** → Required for SOS emergency screen overlay  
- **Notifications** → For medication reminders and alerts  
- **Alarm permissions** → For scheduled health notifications  

---

## 🧪 Key Features for Evaluation

### 1. AI Health Assistant (Context-Aware)

- Log your mood from the home screen (e.g., stressed, tired, happy)
- Open the AI chat feature
- The assistant uses your stored mood data to generate personalized responses

---

### 2. Emergency SOS System 🚨

- Tap the **SOS button** on the dashboard
- The app immediately displays a high-priority emergency medical profile

Includes:
- Blood type  
- Allergies  
- Medical conditions  
- Emergency contacts  

---

### 3. Medication Reminder System

- Add medication details in the profile section  
- The app schedules local notifications  
- Alerts are triggered even when the app is closed  

---

## 🛠 System Architecture

- **Frontend:** Flutter (Dart)  
- **Backend API:** Node.js + Express  
- **Database:** MySQL with Prisma ORM  
- **Hosting:** Linux VPS (PM2 process manager)  
- **AI Service:** Google Gemini API (server-secured keys)  

---

## 📱 Platform Compatibility

⚠️ **Important Notice for Evaluators**

- This application is currently **Android-only**
- The iOS version is **not available yet**
- iOS does not allow the same level of background alarm and persistent notification handling required for the medication reminder system
- Therefore, **all testing must be done on an Android device**

The full feature set (especially medication reminders and SOS alerts) is only guaranteed to work on Android.

---

