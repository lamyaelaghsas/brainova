import 'package:flutter/material.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/texts.dart';


class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  // ========================================
  // MÉTHODES - NAVIGATION
  // ========================================
  
  void _onItemTapped(BuildContext context, int index) {
    if (currentIndex == index) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/notifications');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/groupes');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profil');
        break;
    }
  }

  // ========================================
  // BUILD - UI PRINCIPALE
  // ========================================
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSurfaceColor,
        boxShadow: [
          BoxShadow(
            color: kBlack.withOpacity(kOpacityVeryLow),
            blurRadius: kBlurRadiusMedium,
            offset: kShadowOffsetTop,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: kAccentColor,
        unselectedItemColor: kTextSecondary,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: kFontSizeSmall,
        unselectedFontSize: kFontSizeSmall,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            activeIcon: Icon(Icons.notifications, size: kIconSizeMedium),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home, size: kIconSizeMedium),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person, size: kIconSizeMedium),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}