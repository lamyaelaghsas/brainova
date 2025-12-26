// === IMPORTATIONS ===
import 'package:brainova/screens/groupelist_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:brainova/screens/welcome_screen.dart';
import 'package:brainova/screens/register_screen.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/screens/login_screen.dart';
import 'package:brainova/screens/groupe_detail_screen.dart';
import 'package:brainova/screens/nouvelle_session_screen.dart';
import 'package:brainova/screens/creer_groupe_screen.dart';
import 'package:brainova/screens/rejoindre_groupe_screen.dart';
import 'package:brainova/screens/session_detail_screen.dart';
import 'package:brainova/screens/session_active_screen.dart';
import 'package:brainova/screens/profil_screen.dart';
import 'package:brainova/screens/notifications_screen.dart';
import 'package:brainova/widgets/connectivity_wrapper.dart'; 



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
    return ConnectivityWrapper( //  WRAPPER POUR DÉTECTER LA CONNEXION
      child: MaterialApp( // Widget racine de toute app Flutter Material Design
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

          '/groupes': (context) => const GroupeListScreen(), 

          '/profil': (context) => const ProfilScreen(),
          '/notifications': (context) => const NotificationsScreen(),

          '/groupe-detail': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return GroupeDetailScreen(
              groupeId: args['groupeId'],
              nom: args['nom'],
              code: args['code'],
              couleur: args['couleur'],
              description: args['description'],
            );
          },
          '/nouvelle-session': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return NouvelleSessionScreen(
              groupeId: args['groupeId'],
              groupeNom: args['groupeNom'],
            );
          },

          CreerGroupeScreen.routeName: (context) => const CreerGroupeScreen(),
          RejoindreGroupeScreen.routeName: (context) => const RejoindreGroupeScreen(),
          '/session-detail': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return SessionDetailScreen(
              groupeId: args['groupeId'],
              sessionId: args['sessionId'],
              groupeNom: args['groupeNom'],
            );
          },

          '/session-active': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return SessionActiveScreen(
            groupeId: args['groupeId'],
            sessionId: args['sessionId'],
            groupeNom: args['groupeNom'],
            sujet: args['sujet'],
            dureePrevueMinutes: args['dureePrevueMinutes'],
          );
        },
          
        },

        // Route initiale
        initialRoute: '/', // On démarre sur le WelcomeScreen
      ),
    );
  }
}