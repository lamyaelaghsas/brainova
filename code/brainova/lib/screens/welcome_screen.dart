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
  // ========================================
  // CONTRÔLEURS & ÉTAT
  // ========================================
  
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // ========================================
  // LIFECYCLE
  // ========================================
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ========================================
  // MÉTHODES - NAVIGATION
  // ========================================
  
  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: kAnimationDurationShort),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      3,
      duration: const Duration(milliseconds: kAnimationDurationMedium),
      curve: Curves.easeInOut,
    );
  }

  // ========================================
  // BUILD - UI PRINCIPALE
  // ========================================
  
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
              // ========================================
              // SECTION PAGES ONBOARDING
              // ========================================
              
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
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
              // SECTION INDICATEURS
              // ========================================
              
              _buildPageIndicators(),
              const SizedBox(height: kSpacingLargeExtra),

              // ========================================
              // SECTION BOUTONS
              // ========================================
              
              _buildBottomButtons(),
              const SizedBox(height: kPaddingVerticalL),
            ],
          ),
        ),
      ),
    );
  }

  // ========================================
  // WIDGETS - PAGE ONBOARDING
  // ========================================
  
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
          const Spacer(flex: 2),
          
          // Icône avec effet glow
          Container(
            width: kOnboardingIconSize,
            height: kOnboardingIconSize,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: glowColor.withOpacity(kOpacityVeryLow),
                  blurRadius: kGlowBlurRadius,
                  spreadRadius: 0,
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
          
          // Titre
          Text(
            title,
            style: kTitleMedium.copyWith(
              color: glowColor,
              letterSpacing: kLetterSpacingNarrow,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kPaddingVertical),
          
          // Sous-titre
          Text(
            subtitle,
            style: kBodyMedium.copyWith(
              color: kTextSecondary,
              height: kLineHeightNormal,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  // ========================================
  // WIDGETS - INDICATEURS
  // ========================================
  
  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: kPaddingVerticalXS),
          width: _currentPage == index ? kIndicatorWidth : kIndicatorSize,
          height: kIndicatorSize,
          decoration: BoxDecoration(
            color: _currentPage == index ? kAccentColor : kTextMuted,
            borderRadius: BorderRadius.circular(kPaddingVerticalXS),
          ),
        );
      }),
    );
  }

  // ========================================
  // WIDGETS - BOUTONS
  // ========================================
  
  Widget _buildBottomButtons() {
    if (_currentPage < 3) {
      return _buildNavigationButtons();
    } else {
      return _buildAuthButtons();
    }
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontalL),
      child: Column(
        children: [
          // Bouton Suivant
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
                elevation: 0,
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
                  const Icon(Icons.arrow_forward, size: kIconSizeMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: kMediumSpace),
          
          // Bouton Passer
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
  }

  Widget _buildAuthButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontalL),
      child: Column(
        children: [
          // Bouton Connexion
          SizedBox(
            width: double.infinity,
            height: kButtonHeight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: kWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                ),
                elevation: 0,
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
          
          // Bouton Inscription
          SizedBox(
            width: double.infinity,
            height: kButtonHeight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentPink,
                foregroundColor: kWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                ),
                elevation: kButtonElevationHigh,
                shadowColor: kAccentPink.withOpacity(kOpacityLow),
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