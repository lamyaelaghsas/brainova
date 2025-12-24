import 'package:flutter/material.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/spacings.dart';

// Classe principale du WelcomeScreen avec système d'onboarding
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static const String routeName = '/';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

// widget d'état pour le WelcomeScreen
class _WelcomeScreenState extends State<WelcomeScreen> {
  // Contrôleur pour gérer les pages
  final PageController _pageController = PageController();
  
  // Page actuelle (0 à 3)
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Passer à la page suivante
  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Passer directement à la dernière page (bouton "Passer")
  void _skipToEnd() {
    _pageController.animateToPage(
      3,
      duration: const Duration(milliseconds: 400), //durée de l'animation
      curve: Curves.easeInOut, //courbe d'animation
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back-accueil.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // PageView pour les 4 écrans
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    // Écran 1 : Trophée
                    _buildOnboardingPage(
                      icon: 'assets/icons/trophee.png',
                      glowColor: kAccentPink,
                      title: 'Motivez-vous mutuellement',
                      subtitle: 'Comparez vos scores, défiez vos camarades\net célébrez vos réussites ensemble',
                    ),
                    // Écran 2 : Temps
                    _buildOnboardingPage(
                      icon: 'assets/icons/temps.png',
                      glowColor: kAccentColor,
                      title: 'Suivez votre progression',
                      subtitle: 'Chronométrez vos sessions d\'étude et\nvisualisez votre temps d\'apprentissage en\ntemps réel',
                    ),
                    // Écran 3 : Groupe
                    _buildOnboardingPage(
                      icon: 'assets/icons/groupe.png',
                      glowColor: kAccentPurple,
                      title: 'Créez vos groupes d\'étude',
                      subtitle: 'Formez des équipes avec vos amis ou\nrejoignez des groupes existants pour\napprendre ensemble',
                    ),
                    // Écran 4 : Cerveau
                    _buildOnboardingPage(
                      icon: 'assets/icons/cerveau.png',
                      glowColor: kAccentColor,
                      title: 'Étudiez ensemble, brillez ensemble',
                      subtitle: 'Rejoignez une communauté d\'étudiants\nmotivés et atteignez vos objectifs\nacadémiques en groupe',
                    ),
                  ],
                ),
              ),

              // Indicateurs de pagination (dots)
              _buildPageIndicators(),

              const SizedBox(height: 30),

              // Boutons selon la page actuelle
              _buildBottomButtons(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour un écran d'onboarding
  Widget _buildOnboardingPage({
    required String icon,
    required Color glowColor,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),

          // Icône avec effet glow
          Container(
  width: 200,
  height: 200,
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: glowColor.withOpacity(0.3),  // Moins opaque (0.3 au lieu de 0.6)
        blurRadius: 100,                     // Plus diffus (100 au lieu de 80)
        spreadRadius: 0,                     // Pas d'expansion (0 au lieu de 20)
      ),
    ],
  ),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Image.asset(
                icon,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 60),

          // Titre
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: glowColor,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Sous-titre
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: kTextSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }

  // Indicateurs de pagination
  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? kAccentColor : kTextMuted,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  // Boutons en bas de l'écran
  Widget _buildBottomButtons() {
    // Si on est sur les 3 premières pages
    if (_currentPage < 3) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontalL),
        child: Column(
          children: [
            // Bouton "Suivant"
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentColor,
                  foregroundColor: kBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Suivant',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Lien "Passer"
            TextButton(
              onPressed: _skipToEnd,
              child: const Text(
                'Passer',
                style: TextStyle(
                  fontSize: 16,
                  color: kTextSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Page 4 : Boutons de connexion/inscription
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontalL),
        child: Column(
          children: [
            

            // Bouton "Je me connecte"
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E4057),
                  foregroundColor: kWhiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Je me connecte',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Bouton "Créer mon compte"
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD946EF),
                  foregroundColor: kWhiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFFD946EF).withOpacity(0.5),
                ),
                child: const Text(
                  'Créer mon compte',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}