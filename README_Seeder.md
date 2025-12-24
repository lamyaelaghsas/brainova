# 🚀 STRUCTURE DTO - EXACTEMENT COMME LE PROF

## ✅ CE QUI A ÉTÉ FAIT

J'ai créé la structure **EXACTE** du prof :

```
code/
├── brainova/           (ton projet principal)
└── dto/                (package séparé - COMME LE PROF)
    ├── lib/
    │   ├── models/
    │   │   ├── user.dart          (avec @freezed)
    │   │   ├── groupe.dart        (avec @freezed)
    │   │   └── session.dart       (avec @freezed)
    │   ├── schema.dart            (avec @Schema et @Collection)
    │   └── dto.dart               (exporte tout)
    ├── pubspec.yaml               (avec freezed + firestore_odm)
    └── build.yaml
```

## 📋 ÉTAPES À SUIVRE MAINTENANT

### 1️⃣ Copier le dossier `dto` dans ton projet

```bash
# Depuis /mnt/user-data/outputs/
# Copie le dossier dto/ à côté de brainova/
```

**Structure finale :**
```
code/
├── brainova/
└── dto/         ← DOIT ÊTRE ICI
```

### 2️⃣ Générer le code dans le package dto

```bash

flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**Cela va générer :**
- `user.freezed.dart` + `user.g.dart`
- `groupe.freezed.dart` + `groupe.g.dart`
- `session.freezed.dart` + `session.g.dart`
- `schema.odm.dart`

### 3️⃣ Dans ton projet brainova

```bash
cd ../brainova
flutter pub get
```

**Le `pubspec.yaml` de brainova contient déjà :**
```yaml
dependencies:
  dto:
    path: ../dto          ← RÉFÉRENCE AU PACKAGE LOCAL
  firestore_odm: ^3.0.2
```

### 4️⃣ Utiliser le seeder

Le `seeder_screen.dart` est déjà configuré pour utiliser le package dto :

```dart
import 'package:dto/dto.dart';

// Instance ODM (comme le prof)
final db = FirestoreODM(appSchema, firestore: FirebaseFirestore.instance);

// Ajouter des données
await db.users.insert(user);
await db.groupes.insert(groupe);
await db.sessions.insert(session);
```

---

## 🔥 FICHIERS CRÉÉS

### dto/lib/models/user.dart
```dart
@freezed
class User with _$User {
  const factory User({
    @DocumentIdField() String? id,
    required String email,
    required String nom,
    required String prenom,
    @Default([]) List<String> groupes,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### dto/lib/models/groupe.dart
```dart
@freezed
class Groupe with _$Groupe {
  const factory Groupe({
    @DocumentIdField() String? id,
    required String nom,
    required String code,
    @Default([]) List<String> membres,
    required DateTime createdAt,
  }) = _Groupe;

  factory Groupe.fromJson(Map<String, dynamic> json) => _$GroupeFromJson(json);
}
```

### dto/lib/models/session.dart
```dart
@freezed
class Session with _$Session {
  const factory Session({
    @DocumentIdField() String? id,
    required String groupeId,
    required String userId,
    required String userNom,
    required String matiere,
    required int dureeMinutes,
    required DateTime date,
    String? note,
    required DateTime createdAt,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
}
```

### dto/lib/schema.dart
```dart
@Schema()
@Collection<User>('users')
@Collection<Groupe>('groupes')
@Collection<Session>('sessions')
final appSchema = _$AppSchema;
```

---

## 🎯 DIFFÉRENCES AVEC TON CODE INITIAL

| Avant | Maintenant (PROF) |
|-------|------------------|
| `json_annotation` | `@freezed` + `freezed_annotation` |
| Modèles dans `brainova/lib/models/` | Package `dto` séparé |
| `toMap()` / `fromMap()` manuels | Généré automatiquement |
| `FirebaseFirestore.instance.collection()` | `db.users.insert()` via ODM |

---

## ⚡ COMMANDES RAPIDES

```bash
# Dans dto/ - Régénérer le code après modification
cd code/dto
dart run build_runner build --delete-conflicting-outputs

# Dans brainova/ - Lancer l'app
cd code/brainova
flutter run -d chrome
```

---

## 🧪 TESTER LE SEEDER

1. Lance l'app : `flutter run -d chrome`
2. Va sur `/seeder` (tu dois l'ajouter dans les routes)
3. Clique sur "GÉNÉRER LES DONNÉES"
4. Vérifie dans Firebase Console que les données apparaissent

---

## 📦 STRUCTURE COMPLÈTE FINALE

```
code/
├── brainova/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── data/
│   │   │   ├── users.dart       (données de test)
│   │   │   ├── groupes.dart     (données de test)
│   │   │   └── sessions.dart    (données de test)
│   │   └── screens/
│   │       └── seeder_screen.dart
│   └── pubspec.yaml             (avec dto: path: ../dto)
│
└── dto/                         (PACKAGE SÉPARÉ)
    ├── lib/
    │   ├── models/
    │   │   ├── user.dart
    │   │   ├── user.freezed.dart    (généré)
    │   │   ├── user.g.dart          (généré)
    │   │   ├── groupe.dart
    │   │   ├── groupe.freezed.dart  (généré)
    │   │   ├── groupe.g.dart        (généré)
    │   │   ├── session.dart
    │   │   ├── session.freezed.dart (généré)
    │   │   └── session.g.dart       (généré)
    │   ├── schema.dart
    │   ├── schema.odm.dart          (généré)
    │   └── dto.dart
    ├── pubspec.yaml
    └── build.yaml
```

---

## ❓ SI ÇA NE FONCTIONNE PAS

### Erreur : "Target of URI hasn't been generated"
```bash
cd code/dto
dart run build_runner build --delete-conflicting-outputs
```

### Erreur : "Package not found"
Vérifie que `dto/` est bien au même niveau que `brainova/` :
```
code/
├── brainova/
└── dto/      ← DOIT ÊTRE ICI, pas dans brainova/
```

### Erreur de dépendances
```bash
cd code/dto
flutter pub get

cd ../brainova
flutter pub get
```

---

## 🎓 C'EST EXACTEMENT COMME LE PROF !

Cette structure est **IDENTIQUE** à celle du prof :
- ✅ Package `dto` séparé
- ✅ `@freezed` pour les modèles
- ✅ `firestore_odm` version 3.0.2
- ✅ `schema.dart` avec `@Schema()` et `@Collection()`
- ✅ Référence `path: ../dto` dans le projet principal

**À toi de jouer ! 🚀**