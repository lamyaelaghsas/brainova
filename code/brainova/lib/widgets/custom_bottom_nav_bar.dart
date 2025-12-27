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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSurfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(kOpacityMinimal),
            blurRadius: kShadowBlurRadius,
            offset: const Offset(0, -2),
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
        selectedFontSize: kFontSizeXSmall,
        unselectedFontSize: kFontSizeXSmall,
        onTap: (index) {
          switch (index) {
            case 0:
              if (currentIndex != 0) {
                Navigator.pushReplacementNamed(context, '/notifications');
              }
              break;
            case 1:
              if (currentIndex != 1) {
                Navigator.pushReplacementNamed(context, '/groupes');
              }
              break;
            case 2:
              if (currentIndex != 2) {
                Navigator.pushReplacementNamed(context, '/profil');
              }
              break;
          }
        },
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