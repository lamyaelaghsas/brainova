# 🚀 Configuration Package DTO pour Brainova

## ÉTAPE 1: Copier les fichiers

Copie TOUT le contenu du dossier `dto/` dans `code/dto/`

Ta structure finale doit être:
```
code/
├── brainova/
└── dto/          ← Tous les fichiers sont ici
    ├── lib/
    │   ├── dto.dart
    │   ├── schema.dart
    │   ├── converters/
    │   │   └── firestore_timestamp_converter.dart
    │   └── models/
    │       ├── user.dart
    │       ├── groupe.dart
    │       └── session.dart
    ├── pubspec.yaml
    ├── build.yaml
    ├── .gitignore
    ├── .metadata
    └── analysis_options.yaml
```

## ÉTAPE 2: Installer les dépendances

Ouvre un terminal dans `code/dto/` et lance:

```bash
cd code/dto
flutter pub get
```

## ÉTAPE 3: Générer le code ODM

Dans le même terminal (`code/dto/`), lance:

```bash
dart run build_runner build --delete-conflicting-outputs
```

✅ Cette commande va créer:
- `user.freezed.dart` et `user.g.dart`
- `groupe.freezed.dart` et `groupe.g.dart`
- `session.freezed.dart` et `session.g.dart`
- `schema.odm.dart` (LE PLUS IMPORTANT)

⏳ Ça prend 1-2 minutes.

## ÉTAPE 4: Vérifier le brainova/pubspec.yaml

Dans `code/brainova/pubspec.yaml`, vérifie que tu as:

```yaml
dependencies:
  flutter:
    sdk: flutter
  dto:
    path: ../dto    ← IMPORTANT: chemin relatif vers dto
  firestore_odm: ^3.0.2
  # ... tes autres dépendances
```

## ÉTAPE 5: Installer dans brainova

```bash
cd code/brainova
flutter pub get
```

## ÉTAPE 6: Tester l'import

Dans n'importe quel fichier Dart de brainova, teste:

```dart
import 'package:dto/dto.dart';
```

✅ Si pas d'erreur = C'EST BON !

---

## 📊 Collections Firestore créées

- **users** → Collection principale
- **groupes** → Collection principale  
- **groupes/*/sessions** → Sous-collection dans chaque groupe

---

## 🔥 Prochaine étape

Une fois que tout compile, tu pourras créer ton seeder !

Je te guiderai pour:
1. Créer les données de test
2. Créer l'écran seeder
3. Remplir Firestore

---

## ⚠️ Erreurs fréquentes

**"Package dto not found"**
→ Vérifie le chemin dans brainova/pubspec.yaml

**"Part files not generated"**
→ Relance `dart run build_runner build --delete-conflicting-outputs`

**"Build runner failed"**
→ Vérifie que tu es bien dans `code/dto/` quand tu lances la commande