🧠 Contexte du projet BRAINOVA
📋 Informations générales
Nom du projet : Brainova
Type : Application mobile Flutter (Web + Android)
Étudiant : Cours de Flutter en BAC 3
Objectif : Créer une application d'étude collaborative originale

🎯 Concept de l'application
Brainova est une application qui permet aux étudiants de créer des groupes d'étude collaboratifs et de suivre leurs sessions d'étude ensemble.
Tagline
"Étudiez ensemble, brillez ensemble"
Inspiration
Le projet est basé sur la structure de TicTic (app de gestion de dépenses partagées), mais adapté pour l'étude collaborative :

Au lieu de gérer des dépenses → on gère des sessions d'étude
Au lieu de "qui doit combien ?" → "qui étudie combien ?"
Au lieu de remboursements → motivation collective


✨ Fonctionnalités principales
1. Authentification

✅ Créer un compte (email + mot de passe + nom/prénom)
✅ Se connecter
❌ PAS de photos dans les profils (pour simplifier)

2. Gestion des groupes

Créer plusieurs groupes d'étude (ex: "Groupe Flutter", "Révisions Maths")
Chaque groupe a un code d'accès unique
Inviter des membres via code numérique (6 caractères)
Rejoindre un groupe existant avec le code

3. Sessions d'étude
Ajouter une session avec :

Matière étudiée
Durée (heures + minutes)
Date
Note/commentaire optionnel
❌ PAS de photos (décision de simplification)

Fonctionnalités :

Modifier/supprimer sa propre session
Voir toutes les sessions du groupe
Historique complet filtrable

4. Dashboard groupe

Total d'heures d'étude du groupe
Classement des membres (qui étudie le plus)
Graphiques de progression (optionnel)
Notifications quand un membre étudie


🎨 Design & Identité visuelle
Thème : Spatial/Futuriste
Style : Cosmos, étoiles, constellations, effet nova/supernova
Couleurs principales
dart// Fond & surfaces
kBackgroundColor: #0F1419 (noir spatial)
kPrimaryColor: #1A1F3A (bleu nuit)
kSurfaceColor: #1E2338

// Accents
kAccentColor: #FFD700 (doré lumineux - étoile/nova)
kAccentPurple: #8B5CF6 (violet spatial)
kAccentPink: #EC4899 (rose néon)

// Texte
kTextPrimary: #FFFFFF (blanc)
kTextSecondary: #B0B8D4 (gris-bleu)

Assets

Logo : assets/icons/icon-accueil.png (cerveau doré avec étoile)
Fond accueil : assets/images/back-accueil.png (starfield avec constellations)


Framework : Flutter (Dart)
Base de données : Firebase (Firestore + Auth)
State management : Provider (simple) -> je sais pas ce que c'est ca 
Plateformes : Web (Chrome pour dev) + Android


💾 Structure des données
User
dart{
  id: String,
  email: String,
  nom: String,
  prenom: String,
  groupes: List<String>  // IDs des groupes
}
Groupe
dart{
  id: String,
  nom: String,
  code: String,  // Code à 6 caractères alphanumériques
  membres: List<String>,  // IDs des users
  created_at: DateTime
}
Session
dart{
  id: String,
  groupe_id: String,
  user_id: String,
  user_nom: String,
  matiere: String,
  duree_minutes: int,
  date: DateTime,
  note: String?,  // Optionnel
  created_at: DateTime
}

📱 Écrans à créer (ordre de priorité)
Fait ✅

✅ WelcomeScreen - Écran d'accueil

À faire 🔜

LoginScreen - Connexion OK
RegisterScreen - Inscription OK
HomeScreen - Liste des groupes OK
CreateGroupScreen - Créer un groupe OK
JoinGroupScreen - Rejoindre avec code OK
GroupDetailScreen - Détail groupe + sessions OK
AddSessionScreen - Ajouter session OK
le seeder aussi !!!
(Optionnel) OnboardingScreens - 3 écrans explicatifs


🚨 Décisions importantes prises
Ce qu'on a ENLEVÉ (par rapport au concept initial)

❌ Photos dans les sessions (trop complexe)
❌ QR codes (juste code numérique)
❌ iOS (on développe sur Windows)
❌ Notifications push temps réel (peut-être en bonus)
❌ Graphiques avancés (juste stats basiques)

Ce qu'on GARDE (essentiel)

✅ Firebase pour auth + données
✅ Groupes avec codes d'accès
✅ Sessions avec durée et notes
✅ Classement et stats du groupe
✅ Design spatial/futuriste


🔧 Configuration technique
Environnement

IDE : IntelliJ IDEA
OS : Windows
Device de test : Chrome (Web)
SDK Flutter : ^3.9.2

Dépendances (pubspec.yaml)
yamldependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  firebase_core: ^3.8.1
  firebase_auth: ^5.3.4
  cloud_firestore: ^5.5.2
  provider: ^6.1.2

📝 État actuel du projet
Complété

✅ Projet créé et configuré
✅ Structure des dossiers
✅ Fichiers de styles (colors, texts, spacings, sizes)
✅ welcome_screen, login_screen, register_screen 
✅ Assets copiés (logo + fond)



💡 Notes de style à respecter

Toujours utiliser les constantes de colors.dart, spacings.dart, etc.
Pas de code dupliqué : créer des widgets réutilisables
Noms de fichiers : snake_case (welcome_screen.dart)
Noms de classes : PascalCase (WelcomeScreen)
Variables : camelCase (kAccentColor)
Commentaires : En français, concis
Formatage : Toujours flutter format .


🎓 Objectifs pédagogiques
Ce projet sert à démontrer :

✅ Maîtrise de Flutter (widgets, navigation, state)
✅ Intégration Firebase (auth + database)
✅ Architecture propre (séparation concerns)
✅ Design moderne et cohérent
✅ Gestion de projet (Git, structure)
✅ Originalité du concept
