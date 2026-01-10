# ✨ BRAINOVA 

**Application mobile de gestion de groupes d'étude collaborative**

Une application Flutter permettant aux étudiants de créer des groupes d'étude, chronométrer leurs sessions de travail et comparer leurs performances dans une ambiance motivante et gamifiée.

---

## 📱 Aperçu du Projet

BRAINOVA est une application mobile développée en Flutter qui facilite l'apprentissage collaboratif en permettant aux étudiants de :
- 📚 Créer et rejoindre des groupes d'étude
- ⏱️ Chronométrer leurs sessions d'étude en temps réel
- 🏆 Comparer leurs statistiques et se motiver mutuellement
- 🔔 Recevoir des notifications sur les activités du groupe
- 🎯 Débloquer des badges de réussite

---

## ✨ Fonctionnalités Principales

### 👥 Gestion des Groupes
- **Création de groupe** avec code d'accès unique (6 caractères alphanumériques)
- **Rejoindre un groupe** via un code partagé
- **Visualisation des membres** et statistiques du groupe
- **Quitter un groupe** en un clic avec confirmation
- **Modifier le nom du groupe** directement depuis l'écran de détail
- **Code couleur** pour identifier visuellement chaque groupe

### ⏱️ Sessions d'Étude
- **Création de sessions** avec sujet et durée prévue
- **Chronomètre en temps réel** avec pause/reprise
- **Persistance en arrière-plan** - la session continue même si vous quittez l'écran
- **Historique complet** des sessions passées avec filtres
- **Rejoindre une session en cours** pour collaborer

### 📊 Statistiques & Classement
- **Classement des membres** par temps d'étude total
- **Badges de réussite** (Nova Brillante, Studieux, Marathon, Social)
- **Profil utilisateur** avec statistiques personnelles détaillées
- **Temps total d'étude** par groupe et par utilisateur
- **Progression en temps réel** - mise à jour automatique

### 🔔 Système de Notifications

- **Nouvelle session créée** - Alertes tous les membres du groupe
- **Session en cours** - Notification quand un membre démarre une session
- **Nouveau membre** - Annonce l'arrivée d'un nouveau participant
- **Badge non-lu** - Indicateur visuel sur les notifications non consultées
- **Marquage automatique comme "lu"** au clic

**Notifications Push Locales**
- **Rappel motivationnel** - Message encourageant après 30 minutes d'étude (pour les tests : 5 secondes)
- **Planification automatique** au démarrage d'une session

### 🌐 Gestion de la Connectivité
- **Détection automatique** du statut de connexion
- **Banner d'alerte** en mode hors-ligne (rose avec icône WiFi)
- **Synchronisation automatique** au retour de la connexion

---

## 🛠️ Technologies Utilisées

### Frontend
- **Flutter** 3.x - Framework UI cross-platform
- **Dart** - Langage de programmation

### Backend & Database
- **Firebase Authentication** - Gestion des utilisateurs
- **Cloud Firestore** - Base de données NoSQL temps réel
- **Firebase Cloud Storage** - Stockage des assets

### Architecture & Patterns
- **Freezed** - Classes immuables et unions de types
- **Firestore ODM** - Object-Document Mapping pour Firestore
- **StreamBuilder** - Gestion des flux de données réactifs
- **Provider Pattern** - Gestion d'état (via services)

### Packages Principaux
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^3.10.0
  firebase_auth: ^5.3.4
  cloud_firestore: ^5.5.2
  
  # Notifications
  flutter_local_notifications: ^18.0.1
  
  # Connectivity
  connectivity_plus: ^6.1.2
  
  # Code Generation
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

dev_dependencies:
  build_runner: ^2.4.15
  freezed: ^2.5.7
  json_serializable: ^6.9.2
  cloud_firestore_odm: ^1.0.0-dev.99
```

---

## 📂 Structure du Projet

```
code/
├── brainova/                      # Application principale
│   ├── lib/
│   │   ├── models/                # Modèles locaux (optionnel)
│   │   ├── screens/               # Écrans de l'application (12 écrans)
│   │   │   ├── welcome_screen.dart          # Onboarding (4 pages)
│   │   │   ├── login_screen.dart            # Connexion
│   │   │   ├── register_screen.dart         # Inscription
│   │   │   ├── groupelist_screen.dart       # Liste des groupes
│   │   │   ├── groupe_detail_screen.dart    # Détail groupe + tabs
│   │   │   ├── creer_groupe_screen.dart     # Création de groupe
│   │   │   ├── rejoindre_groupe_screen.dart # Rejoindre via code
│   │   │   ├── nouvelle_session_screen.dart # Formulaire session
│   │   │   ├── session_active_screen.dart   # Chronomètre actif
│   │   │   ├── session_detail_screen.dart   # Détails session
│   │   │   ├── notifications_screen.dart    # Centre de notifications
│   │   │   └── profil_screen.dart           # Profil + stats
│   │   ├── services/              # Services métier
│   │   │   ├── notification_service.dart         # Notifications Firestore
│   │   │   └── local_notification_service.dart   # Notifications locales
│   │   ├── styles/                # Système de design
│   │   │   ├── colors.dart        # Palette de couleurs (20+ couleurs)
│   │   │   ├── sizes.dart         # Tailles et dimensions
│   │   │   ├── spacings.dart      # Espacements standardisés
│   │   │   ├── texts.dart         # Styles de texte typographiques
│   │   │   └── constants.dart     # Constantes métier (badges, durées, etc.)
│   │   ├── widgets/               # Composants réutilisables
│   │   │   ├── custom_bottom_nav_bar.dart    # Barre de navigation
│   │   │   └── connectivity_wrapper.dart     # Wrapper de connectivité
│   │   └── main.dart              # Point d'entrée + init Firebase
│   ├── android/
│   │   └── app/
│   │       ├── src/main/AndroidManifest.xml  # Permissions notifications
│   │       └── build.gradle.kts              # Config Gradle + desugaring
│   └── assets/
│       ├── icons/                 # Icônes personnalisées (cerveau, trophée, etc.)
│       └── images/                # Images de fond (back-accueil.png)
│
├── dto/                           # Data Transfer Objects (Freezed)
│   ├── lib/
│   │   ├── converters/
│   │   │   └── firestore_timestamp_converter.dart
│   │   └── models/                # Modèles Firestore avec Freezed
│   │       ├── groupe.dart
│   │       ├── session.dart
│   │       ├── user.dart
│   │       └── notification.dart
│   └── pubspec.yaml
│
└── push_data_firestore/           # Scripts de seed data
```

---

## 🎨 Architecture & Design Patterns

### Séparation DTO / Application
Le projet utilise une **architecture modulaire** avec séparation claire entre :

**📦 Package `dto/`** : 
- Modèles de données Firestore avec **Freezed** (immutabilité)
- Conversions JSON automatiques avec `json_serializable`
- Firestore ODM pour le mapping objet-document
- Converter personnalisé pour Timestamp → DateTime
- **Indépendant** de l'application Flutter

**📱 Package `brainova/`** :
- Application Flutter principale
- Écrans et widgets UI
- Services métier et logique applicative

### Système de Design - Élimination des Magic Numbers

Organisation stricte des styles pour garantir la **maintenabilité** :

**`colors.dart`** - Palette complète
- Couleurs principales (primaires, secondaires)
- Couleurs d'accent (doré, violet, rose)
- Couleurs d'état (succès, erreur, warning)
- Couleurs de texte (primaire, secondaire, muted)

**`sizes.dart`** - Tailles des composants
- Boutons (hauteur standard, hauteur petite)
- Icônes (5 tailles : small → XXL)
- Cartes (radius, elevation)
- Avatars (3 tailles)

**`spacings.dart`** - Espacements standardisés
- Padding (horizontal, vertical, XS → L)
- Marges (small, medium, large)
- Espaces spécifiques (screen padding, card padding)

**`texts.dart`** - Styles typographiques
- Titres (large, medium)
- Corps de texte (body medium)
- Texte de bouton
- Texte d'accent

**`constants.dart`** - Constantes métier
- Durées (secondes/minute, minutes/heure, jours/semaine)
- Badges (seuils de déblocage)
- Limites (longueur nom groupe, nombre notifications)
- Indices navigation (0=Notifs, 1=Groupes, 2=Profil)

**Exemple d'utilisation :**
```dart
// ❌ AVANT (magic numbers)
padding: const EdgeInsets.all(20.0),
fontSize: 16,

// ✅ APRÈS (constantes nommées)
padding: const EdgeInsets.all(kScreenPadding),
fontSize: kFontSizeMedium,
```

---

## 🚀 Installation

### Prérequis
- Flutter SDK 3.x ou supérieur
- Dart SDK 3.x ou supérieur
- Android Studio / VS Code avec extensions Flutter
- Compte Firebase avec projet configuré
- **Windows** : Mode développeur activé (pour symlinks)

### Étapes d'Installation

#### 1. Cloner le Repository
```bash
git clone https://github.com/votre-username/brainova.git
cd brainova
```

#### 2. Installer les Dépendances

**Package DTO :**
```bash
cd dto
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
cd ..
```

**Application Principale :**
```bash
cd brainova
flutter pub get
```

#### 3. Configuration Firebase

1. Créer un projet Firebase sur [console.firebase.google.com](https://console.firebase.google.com)

2. Activer les services suivants :
   - **Authentication** (Email/Password)
   - **Cloud Firestore**

3. Télécharger le fichier de configuration :
   - **Android** : `google-services.json` → `android/app/`


4. **Créer un index composite** pour les notifications :
   - Collection : `notifications`
   - Champs : `userId` (Ascending), `createdAt` (Descending)

#### 4. Configuration Android

**AndroidManifest.xml** (`android/app/src/main/AndroidManifest.xml`) :
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

**build.gradle.kts** (`android/app/build.gradle.kts`) :
```kotlin
android {
    compileSdk = 34
    
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
    }
    
    defaultConfig {
        minSdk = 21
        targetSdk = 34
        multiDexEnabled = true
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

#### 5. Lancer l'Application

```bash
cd brainova
flutter run
```

---

## 📖 Utilisation

### Création de Compte
1. Ouvrir l'application
2. Passer l'onboarding (4 pages) ou cliquer "Passer"
3. Cliquer sur **"Créer mon compte"**
4. Remplir : Prénom, Nom, Email, Mot de passe (min. 6 caractères)
5. Se connecter avec les identifiants

### Créer un Groupe
1. Sur l'écran d'accueil, cliquer **"Créer un groupe"**
2. Entrer un nom (min. 3 caractères, max. 30)
3. Un code unique de 6 caractères est généré automatiquement
4. Copier le code ou le régénérer si nécessaire
5. Partager le code avec ses amis

### Rejoindre un Groupe
1. Cliquer **"Rejoindre un groupe"**
2. Entrer le code à 6 caractères (insensible à la casse)
3. Confirmer l'ajout
4. Le groupe apparaît dans la liste

### Lancer une Session d'Étude
1. Ouvrir un groupe
2. Cliquer sur le bouton flottant **"Ajouter une session"**
3. Renseigner :
   - Sujet de la session (ex: "Révisions Flutter")
   - Durée prévue en minutes (ex: 60)
4. Cliquer **"Démarrer la session"**
5. Le chronomètre démarre automatiquement
6. **Notifications planifiées** :
   - Rappel motivationnel à 30 minutes
7. Utiliser **Pause/Reprendre** si nécessaire
8. Cliquer **"Terminer"** pour finaliser et enregistrer

### Consulter les Statistiques
1. Accéder à l'onglet **"Profil"** (barre du bas)
2. Voir :
   - **Temps total d'étude** (heures, minutes, secondes)
   - **Nombre de sessions** terminées
   - **Nombre de groupes** rejoints
   - **Badges débloqués** avec conditions
   - **Date d'inscription** (membre depuis...)

### Gérer un Groupe
1. Ouvrir un groupe
2. **Modifier le nom** : Cliquer sur l'icône ✏️ à côté du nom
3. **Quitter le groupe** : Cliquer sur l'icône 🚪 en haut à droite
4. Basculer entre onglets :
   - **Historique** : Liste des sessions passées
   - **Classement** : Podium des membres par temps d'étude

---

## 🗄️ Structure Firestore

### Collection `users`
```json
{
  "userId": {
    "email": "user@example.com",
    "nom": "Dupont",
    "prenom": "Jean",
    "createdAt": Timestamp
  }
}
```

### Collection `groupes`
```json
{
  "groupeId": {
    "nom": "Groupe Flutter BAC 3",
    "code": "ABC123",
    "couleur": "#FFD700",
    "memberIds": ["userId1", "userId2"],
    "createdBy": "userId1",
    "createdAt": Timestamp
  }
}
```

### Sous-collection `groupes/{groupeId}/sessions`
```json
{
  "sessionId": {
    "sujet": "Révisions Flutter - State Management",
    "date": Timestamp,
    "dureeSecondes": 3600,
    "dureeMinutes": 60,
    "dureePrevueMinutes": 60,
    "participantIds": ["userId1", "userId2"],
    "isTermine": true,
    "createdBy": "userId1",
    "endTime": Timestamp
  }
}
```

### Collection `notifications`
```json
{
  "notificationId": {
    "userId": "userId1",
    "type": "nouvelle_session | session_en_cours | membre_rejoint",
    "title": "Nouvelle session \"Flutter\" créée",
    "message": "Jean Dupont a créé une session dans Groupe Flutter",
    "groupeId": "groupeId",
    "sessionId": "sessionId",
    "createdAt": Timestamp,
    "isRead": false
  }
}
```

---

## 🎯 Fonctionnalités Techniques

### Génération de Code Unique
- Codes de **6 caractères** (A-Z, 0-9)
- Vérification d'unicité avec **retry automatique**
- **2,176,782,336** combinaisons possibles
- Génération côté client pour performance

### Gestion du Temps
- **Chronomètre en temps réel** (précision à la seconde)
- Conversion automatique **minutes ↔ secondes**
- Formatage intelligent :
  - `3665s` → `1h 1min 5s`
  - `65s` → `1min 5s`
  - `5s` → `5s`
- **Persistance** : La session continue en arrière-plan

### Notifications Temps Réel

**Firestore Notifications (Cross-User)**
- **3 types** : `nouvelle_session`, `session_en_cours`, `membre_rejoint`
- Envoyées à tous les membres sauf l'auteur
- Badge non-lu (point rouge)
- Marquage automatique "lu" au clic
- Formatage du temps relatif ("il y a 5 min")

**Local Notifications (Personal Reminders)**
```dart
// Planifiées automatiquement au démarrage de session
- ID base = sessionId.hashCode
- Notification 1 (ID+1) : 30 minutes → "💪 Bravo ! Continue..."
// Annulées automatiquement à la fin
```

### Gestion de la Connectivité
- **ConnectivityWrapper** : Wrapper global autour de l'app
- Détection via `connectivity_plus`
- **Banner rose** : "Vous êtes hors ligne" 📶
- **Cache Firestore** : Données accessibles offline
- Synchronisation auto au retour online

### Gestion d'État Réseau
- **StreamBuilder** : Flux temps réel Firestore
- **ConnectionState.waiting** → CircularProgressIndicator
- **snapshot.hasError** → Message d'erreur (rare, Firestore a un cache)
- **snapshot.data!.docs.isEmpty** → Empty state

---

## 🏆 Système de Badges

| Badge | Critère | Icône Material | Couleur |
|-------|---------|----------------|---------|
| **Nova Brillante** | 10+ sessions terminées | `Icons.star` | Doré |
| **Studieux** | 5+ sessions terminées | `Icons.emoji_events` | Violet |
| **Marathon** | 2h+ (7200s) d'étude total | `Icons.access_time` | Rose |
| **Social** | Membre de 3+ groupes | `Icons.people` | Vert |

**Affichage :**
- ✅ **Débloqué** : Fond coloré, icône colorée, checkmark vert
- 🔒 **Verrouillé** : Fond grisé, icône `Icons.lock`, texte gris

---

## 📝 Bonnes Pratiques Appliquées

### Code Quality
✅ **Zéro magic number** - Toutes les valeurs dans `constants.dart` ou fichiers de style  
✅ **Modèles typés avec Freezed** - Immutabilité garantie  
✅ **Accès typé aux données** - `.property` au lieu de `["property"]`  
✅ **Architecture modulaire** - Séparation DTO / Application  
✅ **Code commenté** - Commentaires explicatifs en français  

### UI/UX
✅ **Design system centralisé** - 5 fichiers de styles  
✅ **Feedback utilisateur** - SnackBars (succès=vert, erreur=rouge)  
✅ **Loading states** - CircularProgressIndicator pendant le chargement  
✅ **Empty states** - Messages clairs avec icônes explicatives  
✅ **Confirmations** - AlertDialog avant actions destructives (quitter, supprimer)  
✅ **Accessibilité** - Tooltips sur IconButtons  

### Performance
✅ **StreamBuilder** - Mise à jour temps réel sans polling  
✅ **ListView.builder** - Lazy loading pour grandes listes  
✅ **Optimisation Firestore** - Requêtes avec `limit()`, indexes composites  
✅ **Cache local** - Persistance offline Firestore  

### Sécurité
✅ **Règles Firestore** - Accès contrôlé par `memberIds`  
✅ **Validation côté client** - FormValidation sur tous les champs  
✅ **Auth Firebase** - Gestion sécurisée des sessions  

---

## 👥 Équipe de Développement

**Lamyae Laghsas** - Développeuse   
**Donika Ademi** - Développeuse  

**Formation :** BAC 3 - Développement d'Applications Mobiles  
**Institution :** Haute École de la Province de Liège (HEPL)  
**Année Académique :** 2025-2026  

---

## 📄 Licence

Ce projet est développé dans un cadre éducatif strictement académique.  

**Utilisation :**
- ✅ Consultation et apprentissage
- ✅ Référence pour projets étudiants
- ❌ Utilisation commerciale interdite
- ❌ Redistribution sans autorisation

© 2025 BRAINOVA - Tous droits réservés

---

## 📞 Contact & Support

Pour toute question, suggestion ou collaboration :

📧 **Email Principal :** lamyae.laghsas@student.hepl.be  
📧 **Email Secondaire :** donika.ademi@student.hepl.be  

🐛 **Signaler un bug :** Ouvrir une issue sur GitHub  
💡 **Proposer une fonctionnalité :** Pull Request bienvenue !

---

**✨ Étudiez ensemble, brillez ensemble ! ✨**