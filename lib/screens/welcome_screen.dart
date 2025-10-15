import 'package:brainova/styles/spacings.dart';
import 'package:flutter/material.dart';
import 'package:brainova/screens/welcome_screen.dart';
import 'package:brainova/screens/register_screen.dart';  // ← AJOUTE CETTE LIGNE
import 'package:brainova/styles/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Image de fond
          image: DecorationImage(
            image: AssetImage('assets/images/back-accueil.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo
              _buildLogo(),

              const SizedBox(height: 40),

              // Titre BRAINOVA
              _buildTitle(),

              const SizedBox(height: 16),

              // Sous-titre
              _buildSubtitle(),

              const Spacer(flex: 3),

              // Boutons
              _buildButtons(context),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 300,
      height: 300,
      /*decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: kAccentColor.withOpacity(0.3),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),*/
      child: ClipOval(
        child: Image.asset(
          'assets/icons/icon-accueil.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'BRAINOVA',
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: kWhiteColor,
        letterSpacing: 1,
        /*shadows: [
          Shadow(
            color: kAccentColor,
            blurRadius: 20,
          ),
        ],*/
      ),
    );
  }

  Widget _buildSubtitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        'Application d\'étude collective',
        style: TextStyle(
          fontSize: 18,
          color: kTextSecondary,
          letterSpacing: 1,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontalL),
      child: Column(
        children: [
          // Bouton Connexion
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E4057),  // Bleu marine
                foregroundColor: kWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Connexion',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Bouton Inscription
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD946EF),  // Rose/magenta vif
                foregroundColor: kWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
                shadowColor: const Color(0xFFD946EF).withOpacity(0.5),
              ),
              child: const Text(
                'Inscription',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}