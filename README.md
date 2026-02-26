# ফ্রেশ কর্নার — Fresh Corner

তাজা শাকসবজি, ফল ও মুদিখানা পণ্যের অনলাইন ডেলিভারি প্ল্যাটফর্ম।

---

## প্রজেক্ট স্ট্রাকচার

```
fresh-corner/
├── web-user/     # Next.js 14 — User Website
├── web-admin/    # React + Vite — Admin Panel
├── backend/      # Node.js Express — API Server
├── mobile/       # Flutter — Android APK
├── desktop/      # Flutter — Ubuntu Desktop Admin
└── shared/       # Common TypeScript types & constants
```

---

## টেক স্ট্যাক

| প্ল্যাটফর্ম | ভাষা | Framework | Hosting |
|---|---|---|---|
| User Web | TypeScript | Next.js 14 | Firebase Hosting |
| Admin Web | TypeScript | React + Vite | Firebase Hosting |
| Backend API | TypeScript | Express.js | Render.com |
| User APK | Dart | Flutter | GitHub Releases |
| Admin Desktop | Dart | Flutter Desktop | GitHub Releases |
| Database | — | Firestore | Firebase |
| Images | — | Cloudinary | Cloudinary CDN |

---

## Setup করুন

### 1. Firebase Project
- Firebase console থেকে নতুন project তৈরি করুন
- Authentication → Phone sign-in enable করুন
- Firestore Database তৈরি করুন
- Firebase Admin SDK credentials নিন

### 2. Cloudinary Account
- cloudinary.com এ account তৈরি করুন
- `fresh-corner/products` এবং `fresh-corner/categories` folder তৈরি করুন

### 3. Backend Setup
```bash
cd backend
cp .env.example .env
# .env ফাইলে credentials দিন
npm install
npm run dev
```

### 4. Admin Web Panel
```bash
cd web-admin
cp .env.example .env
# .env ফাইলে Firebase credentials দিন
npm install
npm run dev
# http://localhost:5173
```

### 5. User Web App
```bash
cd web-user
cp .env.local.example .env.local
# .env.local ফাইলে Firebase credentials দিন
npm install
npm run dev
# http://localhost:3000
```

### 6. Flutter Mobile (APK)
```bash
cd mobile
# android/app/google-services.json ফাইল দিন
flutter pub get
flutter run
```

### 7. Flutter Desktop (Ubuntu)
```bash
cd desktop
flutter config --enable-linux-desktop
flutter pub get
flutter run -d linux
```

---

## GitHub Secrets

GitHub repository settings → Secrets এ এগুলো দিন:

```
FIREBASE_SERVICE_ACCOUNT       # Firebase service account JSON
FIREBASE_PROJECT_ID            # Firebase project ID
RENDER_DEPLOY_HOOK_URL         # Render.com deploy hook

# Backend
FIREBASE_PRIVATE_KEY
FIREBASE_CLIENT_EMAIL
CLOUDINARY_CLOUD_NAME
CLOUDINARY_API_KEY
CLOUDINARY_API_SECRET

# Web Admin
VITE_FIREBASE_API_KEY
VITE_FIREBASE_AUTH_DOMAIN
...

# Web User
NEXT_PUBLIC_FIREBASE_API_KEY
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN
...

# Flutter
GOOGLE_SERVICES_JSON           # google-services.json content
API_URL                        # https://your-api.onrender.com
```

---

## Firestore Security Rules (example)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth.token.role == 'admin';
    }
    match /categories/{catId} {
      allow read: if true;
      allow write: if request.auth.token.role == 'admin';
    }
    match /orders/{orderId} {
      allow read: if request.auth.uid == resource.data.userId
                  || request.auth.token.role == 'admin';
      allow create: if request.auth != null;
      allow update: if request.auth.token.role == 'admin';
    }
    match /deliveries/{orderId} {
      allow read, write: if request.auth.token.role == 'admin';
    }
    match /settings/{doc} {
      allow read: if true;
      allow write: if request.auth.token.role == 'admin';
    }
  }
}
```

---

## Deploy Flow

```
GitHub Push
├── backend/   → Render.com auto deploy
├── web-admin/ → GitHub Actions → Firebase Hosting (admin target)
├── web-user/  → GitHub Actions → Firebase Hosting (user target)
├── mobile/    → GitHub Actions → APK build → Artifacts/Releases
└── desktop/   → GitHub Actions → Linux build → Artifacts/Releases
```

---

## Admin User তৈরি

Backend deploy হওয়ার পরে Firebase console থেকে:
1. Authentication → Users → একটি user এর UID নিন
2. Firestore → `users/{uid}` document এ `role: "admin"` সেট করুন
3. অথবা Firebase Admin SDK দিয়ে custom claim সেট করুন:

```javascript
admin.auth().setCustomUserClaims(uid, { role: 'admin' });
```

---

**Made with ❤️ — ফ্রেশ কর্নার**
