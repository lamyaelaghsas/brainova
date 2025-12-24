// === IMPORTATIONS ===
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:brainova/screens/welcome_screen.dart';
import 'package:brainova/screens/register_screen.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/screens/login_screen.dart';



// === FONCTION PRINCIPALE ===
// C'est la première fonction appelée quand l'app démarre
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BrainovaApp());
}

// === CLASSE PRINCIPALE DE L'APPLICATION ===
// StatelessWidget = Widget sans état (ne change pas)
class BrainovaApp extends StatelessWidget {
  const BrainovaApp({super.key}); // Constructeur de la classe

  @override
  // Méthode build() : construit l'interface graphique de l'app
  Widget build(BuildContext context) {
    return MaterialApp( // Widget racine de toute app Flutter Material Design
      // === CONFIGURATION GÉNÉRALE ===
      title: 'Brainova', // Nom de l'app (visible dans le task manager)
      debugShowCheckedModeBanner: false, // Enlève le bandeau "DEBUG" en haut à droite

      // === THÈME DE L'APPLICATION === A MODIFFFF CAR MAJ
      theme: ThemeData( // Définit les couleurs et styles globaux de l'app
        useMaterial3: true, // Active Material Design 3 (version moderne)

        // Couleur de fond par défaut pour tous les écrans
        scaffoldBackgroundColor: kBackgroundColor, // Noir spatial (#0F1419)

        // Couleur primaire de l'app (utilisée par défaut pour les éléments importants)
        primaryColor: kAccentColor, // Doré (#FFD700)

        // Schéma de couleurs dark (mode sombre)
        colorScheme: const ColorScheme.dark(
          primary: kAccentColor,     // Couleur primaire : doré
          secondary: kAccentPurple,   // Couleur secondaire : violet
          surface: kSurfaceColor,     // Couleur des surfaces (cartes, etc.)
        ),
      ),

      // === NAVIGATION / ROUTES ===
      // Map des routes : associe un chemin (String) à un écran (Widget)
      routes: {
        // Route écran d'accueil
        '/': (context) => const WelcomeScreen(),

        // route pour inscription
        '/register': (context) => const RegisterScreen(),

        // route pour la connexion
        '/login': (context) => const LoginScreen(),
        
      },

      // Route initiale
      initialRoute: '/', // On démarre sur le WelcomeScreen
    );
  }
}