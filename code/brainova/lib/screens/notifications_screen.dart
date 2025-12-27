import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';
import 'package:brainova/widgets/custom_bottom_nav_bar.dart';
import 'package:brainova/styles/constants.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  static const String routeName = '/notifications';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < kMinutesPerHour) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < kHoursPerDay) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays == kOneDay) {
      return 'Hier';
    } else if (difference.inDays < kDaysInWeek) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'session_en_cours':
        return kGreen; // Vert
      case 'nouvelle_session':
        return kYellow; // Jaune
      case 'membre_rejoint':
        return kPink; // rose
      default:
        return kAccentColor;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'session_en_cours':
        return Icons.play_circle_filled;
      case 'nouvelle_session':
        return Icons.add_circle;
      case 'membre_rejoint':
        return Icons.person_add;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser?.uid;
    
    //DEBUG AUTH
    print('=== AUTH DEBUG ===');
    print('Utilisateur connecté: ${_auth.currentUser?.email}');
    print('UID actuel: $userId');
    print('UID attendu: svEShIWd6eWArtf5t3M4szPBzgr2');
    print('Match: ${userId == "svEShIWd6eWArtf5t3M4szPBzgr2"}');

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Utilisateur non connecté')),
      );
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back-accueil.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(kScreenPadding),
                child: Column(
                  children: [
                    // Icône + Titre
                    Container(
                      width: kIconSizeXL * kIconMultiplierUnEtDemi,
                      height: kIconSizeXL * kIconMultiplierUnEtDemi,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [kPink, kYellow],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: kBackgroundColor,
                        size: kIconSizeLarge,
                      ),
                    ),
                    const SizedBox(height: kMediumSpace),
                    const Text(
                      'Notifications',
                      style: kTitleLarge,
                    ),
                    const SizedBox(height: kPaddingVerticalXS),
                    Text(
                      'Restez à jour avec vos groupes',
                      style: kBodyMedium.copyWith(
                        color: kTextSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              // Liste des notifications
              // Liste des notifications
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('notifications')
                      .where('userId', isEqualTo: userId)
                      .orderBy('createdAt', descending: true)
                      .limit(50)
                      .snapshots(),
                  builder: (context, snapshot) {
                    // === DEBUG COMPLET ===
                    print('=== NOTIFICATIONS DEBUG ===');
                    print('État: ${snapshot.connectionState}');
                    print('Erreur: ${snapshot.error}');
                    print('HasData: ${snapshot.hasData}');
                    print('Nombre de docs: ${snapshot.data?.docs.length ?? 0}');
                    print('userId recherché: $userId');
                    
                    // SI ERREUR → AFFICHER À L'ÉCRAN
                    if (snapshot.hasError) {
                      print('ERREUR FIRESTORE: ${snapshot.error}');
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(kScreenPadding),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: kIconSizeError,
                                color: kErrorColor,
                              ),
                              const SizedBox(height: kLargeSpace),
                              const Text(
                                'Erreur Firestore',
                                style: kTitleMedium,
                              ),
                              const SizedBox(height: kSmallSpace),
                              Container(
                                padding: const EdgeInsets.all(kMediumSpace),
                                decoration: BoxDecoration(
                                  color: kSurfaceColor,
                                  borderRadius: BorderRadius.circular(kCardRadius),
                                ),
                                child: SelectableText(
                                  '${snapshot.error}',
                                  style: kBodyMedium.copyWith(
                                    fontSize: kFontSizeSmall,
                                    color: kErrorColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: kLargeSpace),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {}); // Force rebuild
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('Réessayer'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kAccentColor,
                                  foregroundColor: kBackgroundColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: kAccentColor),
                      );
                    }

                    //DEBUG: Afficher les données reçues
                    if (snapshot.hasData) {
                      print('Documents reçus:');
                      for (var doc in snapshot.data!.docs) {
                        final data = doc.data() as Map<String, dynamic>;
                        print('  - Doc ID: ${doc.id}');
                        print('    userId: ${data['userId']}');
                        print('    type: ${data['type']}');
                        print('    title: ${data['title']}');
                        print('    createdAt: ${data['createdAt']}');
                      }
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      print('Aucune donnée ou liste vide');
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final notifDoc = snapshot.data!.docs[index];
                        final notifData = notifDoc.data() as Map<String, dynamic>;

                        final type = notifData['type'] ?? '';
                        final title = notifData['title'] ?? 'Notification';
                        final message = notifData['message'] ?? '';
                        final createdAt = notifData['createdAt'] != null
                            ? (notifData['createdAt'] as Timestamp).toDate()
                            : DateTime.now();
                        final isRead = notifData['isRead'] ?? false;

                        return _buildNotificationCard(
                          type: type,
                          title: title,
                          message: message,
                          time: _formatTime(createdAt),
                          isRead: isRead,
                          onTap: () async {
                            if (!isRead) {
                              await _firestore
                                  .collection('notifications')
                                  .doc(notifDoc.id)
                                  .update({'isRead': true});
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildNotificationCard({
    required String type,
    required String title,
    required String message,
    required String time,
    required bool isRead,
    required VoidCallback onTap,
  }) {
    final color = _getNotificationColor(type);
    final icon = _getNotificationIcon(type);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: kMediumSpace),
        padding: const EdgeInsets.all(kMediumSpace),
        decoration: BoxDecoration(
          color: isRead
              ? kSurfaceColor.withOpacity(kOpacityLow)
              : kSurfaceColor.withOpacity(kOpacityHigh),
          borderRadius: BorderRadius.circular(kCardRadius),
          border: Border.all(
            color: isRead ? Colors.transparent : color.withOpacity(kOpacityVeryLow),
            width: isRead ? 0 : kBorderWidth,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicateur de couleur + icône
            Container(
              width: kAvatarSizeMedium,
              height: kAvatarSizeMedium,
              decoration: BoxDecoration(
                color: color.withOpacity(kOpacityMinimal),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: kIconSizeMedium,
              ),
            ),
            const SizedBox(width: kMediumSpace),
            // Contenu
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: kTitleMedium.copyWith(
                            fontSize: kFontSizeMedium,
                            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: kIndicatorSize,
                          height: kIndicatorSize,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: kPaddingVerticalXS),
                  Text(
                    message,
                    style: kBodyMedium.copyWith(
                      fontSize: kFontSizeSmall,
                      color: kTextSecondary,
                    ),
                  ),
                  const SizedBox(height: kPaddingVerticalXS),
                  Text(
                    time,
                    style: kBodyMedium.copyWith(
                      fontSize: kFontSizeXSmall,
                      color: kTextSecondary.withOpacity(kOpacityMedium),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kPaddingHorizontalL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: kIconSizeXL * kIconMultiplierDouble,
              height: kIconSizeXL * kIconMultiplierDouble,
              decoration: BoxDecoration(
                color: kSurfaceColor.withOpacity(kOpacityLow),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_off,
                size: kIconSizeXL,
                color: kTextSecondary,
              ),
            ),
            const SizedBox(height: kLargeSpace),
            const Text(
              'Aucune notification',
              style: kTitleMedium,
            ),
            const SizedBox(height: kSmallSpace),
            Text(
              'Vous serez notifié des activités de vos groupes',
              style: kBodyMedium.copyWith(color: kTextSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}