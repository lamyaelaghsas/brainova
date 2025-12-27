import 'package:flutter/material.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static const String routeName = '/';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      3,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }


  // ======================================================================
  // Widget de la page d'accueil avec les écrans d'onboarding (1ere visite)
  // ======================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Container( // Plein écran avec image de fond
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration( 
          image: DecorationImage(
            image: AssetImage('assets/images/back-accueil.png'),
            fit: BoxFit.cover, // Image de fond qui couvre tout l'écran
          ),
        ),
        child: SafeArea( 
          child: Column(
            children: [ // Contenu principal en colonne
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  // ========================================
                  // Quatre pages d'onboarding 
                  // ========================================
                  children: [ 
                    _buildOnboardingPage(
                      icon: 'assets/icons/trophee.png',
                      glowColor: kAccentPink,
                      title: 'Motivez-vous mutuellement',
                      subtitle: 'Comparez vos scores, défiez vos camarades\net célébrez vos réussites ensemble',
                    ),
                    _buildOnboardingPage(
                      icon: 'assets/icons/temps.png',
                      glowColor: kAccentColor,
                      title: 'Suivez votre progression',
                      subtitle: 'Chronomètrez vos sessions d\'étude et\nvisualisez votre temps d\'apprentissage en\ntemps réel',
                    ),
                    _buildOnboardingPage(
                      icon: 'assets/icons/groupe.png',
                      glowColor: kAccentPurple,
                      title: 'Créez vos groupes d\'étude',
                      subtitle: 'Formez des équipes avec vos amis ou\nrejoignez des groupes existants pour\napprendre ensemble',
                    ),
                    _buildOnboardingPage(
                      icon: 'assets/icons/cerveau.png',
                      glowColor: kAccentColor,
                      title: 'Étudiez ensemble, brillez ensemble',
                      subtitle: 'Rejoignez une communauté d\'étudiants\nmotivés et atteignez vos objectifs\nacadémiques en groupe',
                    ),
                  ],
                ),
              ),
              // ========================================
              // Indicateurs de page
              // ========================================
              _buildPageIndicators(),
              const SizedBox(height: kSpacingLargeExtra),

              // ========================================
              // Boutons en bas 
              // ========================================
              _buildBottomButtons(),
              const SizedBox(height: kPaddingVerticalL),
            ],
          ),
        ),
      ),
    );
  }

// ========================================================
// Widgets pour les pages d'onboarding  
// ========================================================
  Widget _buildOnboardingPage({
    required String icon,
    required Color glowColor,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontalL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: kSpacerFlexSmall), // Pousse le contenu vers le centre (ratio 2:3)
          
          // Icône avec effet de glow (lueur colorée)
          Container(
            width: kOnboardingIconSize,
            height: kOnboardingIconSize,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: glowColor.withOpacity(kOpacityVeryLow), // Lueur semi-transparente
                  blurRadius: kGlowBlurRadius, // Intensité du flou
                  spreadRadius: kShadowSpreadNone, // Pas d'expansion au-delà du flou
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(kPaddingVerticalL),
              child: Image.asset(
                icon,
                fit: BoxFit.contain,
              ),
            ),
          ),
          
          const SizedBox(height: kSpacingXXLarge),
          
          // Titre coloré de la page
          Text(
            title,
            style: kTitleMedium.copyWith(
              color: glowColor,
              letterSpacing: kLetterSpacingNormal,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: kPaddingVertical),
          
          // Sous-titre explicatif
          Text(
            subtitle,
            style: kBodyMedium.copyWith(
              color: kTextSecondary,
              height: kLineHeightRelaxed, // Espacement entre les lignes
            ),
            textAlign: TextAlign.center,
          ),
          
          const Spacer(flex: kSpacerFlexLarge), // Pousse le contenu vers le centre (ratio 2:3)
        ],
      ),
    );
  }

  // ========================================================
  // Construit les 4 indicateurs de page (points)
  // ========================================================
  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(kOnboardingPageCount, (index) {
        // Pour chaque page, crée un indicateur
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: kPaddingVerticalXS),
          // L'indicateur actif est plus large que les autres
          width: _currentPage == index ? kIndicatorWidth : kIndicatorSize,
          height: kIndicatorSize,
          decoration: BoxDecoration(
            // L'indicateur actif est jaune, les autres gris
            color: _currentPage == index ? kAccentColor : kTextMuted,
            borderRadius: BorderRadius.circular(kPaddingVerticalXS),
          ),
        );
      }),
    );
  }

  // ========================================================
  // Construit les boutons du bas selon la page actuelle
  // ========================================================
  Widget _buildBottomButtons() {
    // Si on n'est PAS sur la dernière page (pages 0, 1, 2)
    if (_currentPage < kOnboardingLastPageIndex) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontalL),
        child: Column(
          children: [
            // =================================================
            // Bouton "Suivant" pour passer à la page suivante
            // =================================================
            SizedBox(
              width: double.infinity,
              height: kButtonHeight,
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentColor,
                  foregroundColor: kBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                  ),
                  elevation: kElevationNone,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Suivant',
                      style: kButtonText.copyWith(
                        fontSize: kFontSizeLarge,
                      ),
                    ),
                    const SizedBox(width: kIndicatorSize),
                    const Icon(Icons.arrow_forward, size: kPaddingVertical),
                  ],
                ),
              ),
            ),
            const SizedBox(height: kMediumSpace),
            // Bouton "Passer" pour sauter directement à la fin
            TextButton(
              onPressed: _skipToEnd,
              child: Text(
                'Passer',
                style: kBodyMedium.copyWith(color: kTextSecondary),
              ),
            ),
          ],
        ),
      );
    } else {
      // =======================================================
      // Si on EST sur la dernière page (page 3)
      // Affiche les boutons de connexion et d'inscription
      // =======================================================
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontalL),
        child: Column(
          children: [
            // ========================================
            // Bouton "Je me connecte"
            // ========================================
            SizedBox(
              width: double.infinity,
              height: kButtonHeight,
              child: ElevatedButton(
                onPressed: () {
                  // Navigation vers l'écran de connexion
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: kWhiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                  ),
                  elevation: kElevationNone,
                ),
                child: Text(
                  'Je me connecte',
                  style: kButtonText.copyWith(
                    fontSize: kFontSizeLarge,
                    color: kWhiteColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: kMediumSpace),
            // ===================================================
            // Bouton "Créer mon compte" avec effet d'élévation
            // ===================================================
            SizedBox(
              width: double.infinity,
              height: kButtonHeight,
              child: ElevatedButton(
                onPressed: () {
                  // Navigation vers l'écran d'inscription
                  Navigator.pushNamed(context, '/register');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentPink,
                  foregroundColor: kWhiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                  ),
                  elevation: kButtonElevationHigh, // Ombre plus prononcée
                  shadowColor: kAccentPink.withOpacity(kOpacityLow), // Ombre colorée
                ),
                child: Text(
                  'Créer mon compte',
                  style: kButtonText.copyWith(
                    fontSize: kFontSizeLarge,
                    color: kWhiteColor,
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