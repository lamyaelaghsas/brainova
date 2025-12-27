import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';
import 'package:brainova/widgets/custom_bottom_nav_bar.dart';
import 'package:brainova/styles/constants.dart';


class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  static const String routeName = '/profil';

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ kSecondsPerHour;
    final minutes = (totalSeconds % kSecondsPerHour) ~/ kSecondsPerMinute;
    final seconds = totalSeconds % kSecondsPerMinute;

    return '${hours}h ${minutes}min ${seconds}sec';
  }

  String _formatMemberSince(DateTime date) {
    const months = [
      '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return '${months[date.month]} ${date.year}';
  }

  // Calculer les badges en fonction des stats
  List<Map<String, dynamic>> _calculateBadges(int nbSessions, int totalSeconds, int nbGroupes) {
    final badges = <Map<String, dynamic>>[];

    // Badge Nova Brillante : 10+ sessions
    if (nbSessions >= kBadgeNovaSessionsRequired) {
      badges.add({
        'icon': Icons.star,
        'name': 'Nova Brillante',
        'description': '10 sessions terminées',
        'unlocked': true,
      });
    }

    // Badge Studieux : 5+ sessions
    if (nbSessions >= kBadgeStudieuxSessionsRequired) {
      badges.add({
        'icon': Icons.emoji_events,
        'name': 'Studieux',
        'description': '5 sessions terminées',
        'unlocked': true,
      });
    }

    // Badge Marathon : 2h+ d'étude total
    if (totalSeconds >= kBadgeMarathonSecondsRequired) {
      badges.add({
        'icon': Icons.access_time,
        'name': 'Marathon',
        'description': '2h+ d\'étude',
        'unlocked': true,
      });
    }

    // Badge Social : 3+ groupes
    if (nbGroupes >= kBadgeSocialGroupesRequired) {
      badges.add({
        'icon': Icons.people,
        'name': 'Social',
        'description': 'Membre de 3+ groupes',
        'unlocked': true,
      });
    }

    // Badges verrouillés (à débloquer)
    if (nbSessions < kBadgeNovaSessionsRequired) {
      badges.add({
        'icon': Icons.lock,
        'name': 'Nova Brillante',
        'description': 'Terminez 10 sessions',
        'unlocked': false,
      });
    }

    if (nbSessions < kBadgeStudieuxSessionsRequired) {
      badges.add({
        'icon': Icons.lock,
        'name': 'Studieux',
        'description': 'Terminez 5 sessions',
        'unlocked': false,
      });
    }

    return badges;
  }

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser?.uid;

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
          child: StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('users').doc(userId).snapshots(),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(color: kAccentColor),
                );
              }

              final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
              final prenom = userData?['prenom'] ?? 'Utilisateur';
              final nom = userData?['nom'] ?? '';
              final email = userData?['email'] ?? _auth.currentUser?.email ?? '';
              final createdAt = userData?['createdAt'] != null
                  ? (userData!['createdAt'] as Timestamp).toDate()
                  : DateTime.now();

              return StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('groupes')
                    .where('memberIds', arrayContains: userId)
                    .snapshots(),
                builder: (context, groupesSnapshot) {
                  final nbGroupes = groupesSnapshot.hasData ? groupesSnapshot.data!.docs.length : 0;

                  // Calculer stats depuis toutes les sessions de tous les groupes
                  return FutureBuilder<Map<String, int>>(
                    future: _calculateStats(userId),
                    builder: (context, statsSnapshot) {
                      final stats = statsSnapshot.data ?? {'sessions': 0, 'seconds': 0};
                      final nbSessions = stats['sessions']!;
                      final totalSeconds = stats['seconds']!;

                      final badges = _calculateBadges(nbSessions, totalSeconds, nbGroupes);

                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(kScreenPadding),
                          child: Column(
                            children: [
                              // Avatar + Nom + Email (VERSION SIMPLIFIÉE)
                              Row(
                                children: [
                                  // Avatar
                                  Container(
                                    width: kAvatarSizeLarge,
                                    height: kAvatarSizeLarge,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [kPink, kYellow],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: kAccentColor,
                                        width: kBorderWidthThick,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: kIconSizeLarge,
                                      color: kBackgroundColor,
                                    ),
                                  ),
                                  const SizedBox(width: kMediumSpace),
                                  // Nom + Email
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$prenom $nom',
                                          style: kTitleLarge.copyWith(
                                            fontSize: kFontSizeXLarge,
                                          ),
                                        ),
                                        const SizedBox(height: kPaddingVerticalXS),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.email,
                                              size: kIconSizeSmall,
                                              color: kTextSecondary,
                                            ),
                                            const SizedBox(width: kPaddingHorizontalXS),
                                            Expanded(
                                              child: Text(
                                                email,
                                                style: kBodyMedium.copyWith(
                                                  color: kTextSecondary,
                                                  fontSize: kFontSizeSmall,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: kLargeSpace),

                              // Stats : Temps d'étude, Sessions, Groupes
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      icon: Icons.access_time,
                                      label: 'Temps\nd\'étude',
                                      value: _formatDuration(totalSeconds),
                                      color: kProfileStatsVioletColor,
                                    ),
                                  ),
                                  const SizedBox(width: kMediumSpace),
                                  Expanded(
                                    child: _buildStatCard(
                                      icon: Icons.star,
                                      label: 'Sessions',
                                      value: '$nbSessions',
                                      color: kMainButtonColor,
                                    ),
                                  ),
                                  const SizedBox(width: kMediumSpace),
                                  Expanded(
                                    child: _buildStatCard(
                                      icon: Icons.people,
                                      label: 'Groupes',
                                      value: '$nbGroupes',
                                      color: kPink,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: kLargeSpace),

                              // Informations du compte
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(kLargeSpace),
                                decoration: BoxDecoration(
                                  color: kSurfaceColor.withOpacity(kOpacityMedium),
                                  borderRadius: BorderRadius.circular(kCardRadius),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Informations du compte',
                                      style: kTitleMedium.copyWith(
                                        fontSize: kFontSizeLarge,
                                      ),
                                    ),
                                    const SizedBox(height: kMediumSpace),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: kIconSizeMedium,
                                          color: kAccentPurple,
                                        ),
                                        const SizedBox(width: kSmallSpace),
                                        Text(
                                          'Membre depuis ${_formatMemberSince(createdAt)}',
                                          style: kBodyMedium.copyWith(
                                            color: kTextSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: kLargeSpace),

                              // Badges débloqués
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(kLargeSpace),
                                decoration: BoxDecoration(
                                  color: kSurfaceColor.withOpacity(kOpacityMedium),
                                  borderRadius: BorderRadius.circular(kCardRadius),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.emoji_events,  
                                          size: kIconSizeMedium,
                                          color: kAccentColor,
                                        ),
                                        const SizedBox(width: kSmallSpace),
                                        Text(
                                          'Badges',
                                          style: kTitleMedium.copyWith(
                                            fontSize: kFontSizeLarge,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: kMediumSpace),
                                    ...badges.map((badge) {
                                      return _buildBadgeItem(
                                        icon: badge['icon'],
                                        name: badge['name'],
                                        description: badge['description'],
                                        unlocked: badge['unlocked'],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),

                              const SizedBox(height: kLargeSpace),

                              // Bouton de déconnexion
                              SizedBox(
                                width: double.infinity,
                                height: kButtonHeight,
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final shouldLogout = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: kSurfaceColor,
                                        title: const Text('Se déconnecter ?', style: kTitleMedium),
                                        content: Text(
                                          'Voulez-vous vraiment vous déconnecter ?',
                                          style: kBodyMedium.copyWith(color: kTextSecondary),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Annuler', style: TextStyle(color: kTextSecondary)),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Déconnexion', style: TextStyle(color: kErrorColor)),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (shouldLogout == true && mounted) {
                                      await _auth.signOut();
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/',
                                        (route) => false,
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.logout, color: kErrorColor),
                                  label: Text(
                                    'Se déconnecter',
                                    style: kButtonText.copyWith(
                                      color: kErrorColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: kErrorColor, width: kBorderWidth),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(kInputRadius),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: kLargeSpace + kLargeSpace),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(kMediumSpace),
      decoration: BoxDecoration(
        color: kSurfaceColor.withOpacity(kOpacityMedium),
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      child: Column(
        children: [
          Icon(icon, size: kIconSizeMedium, color: color),
          const SizedBox(height: kSmallSpace),
          Text(
            label,
            style: kBodyMedium.copyWith(
              fontSize: kFontSizeSmall,
              color: kTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kPaddingVerticalXS),
          Text(
            value,
            style: kTitleLarge.copyWith(
              fontSize: kFontSizeMedium,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem({
  required IconData icon, // String → IconData
  required String name,
  required String description,
  required bool unlocked,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: kSmallSpace),
      padding: const EdgeInsets.all(kMediumSpace),
      decoration: BoxDecoration(
        color: unlocked
            ? kPrimaryColor
            : kPrimaryColor.withOpacity(kOpacityVeryLow),
        borderRadius: BorderRadius.circular(kInputRadius),
        border: Border.all(
          color: unlocked ? kAccentColor : kTextSecondary.withOpacity(kOpacityVeryLow),
          width: unlocked ? kBorderWidth : kBorderWidthThin,
        ),
      ),
      child: Row(
        children: [
          // Remplacer Text par Icon
          Icon(
            icon,
            size: kIconSizeLarge, // Taille appropriée pour les badges
            color: unlocked ? kAccentColor : kTextSecondary.withOpacity(kOpacityLow),
          ),
          const SizedBox(width: kMediumSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: kTitleMedium.copyWith(
                    fontSize: kFontSizeMedium,
                    color: unlocked ? kTextPrimary : kTextSecondary,
                  ),
                ),
                const SizedBox(height: kPaddingVerticalXS),
                Text(
                  description,
                  style: kBodyMedium.copyWith(
                    fontSize: kFontSizeSmall,
                    color: kTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (unlocked)
            const Icon(
              Icons.check_circle,
              color: kAccentColor,
              size: kIconSizeMedium,
           ),
        ],
      ),
    );
}

  // Calculer les stats depuis toutes les sessions de tous les groupes
  Future<Map<String, int>> _calculateStats(String userId) async {
    int totalSessions = 0;
    int totalSeconds = 0;

    // Récupérer tous les groupes dont l'utilisateur est membre
    final groupesSnapshot = await _firestore
        .collection('groupes')
        .where('memberIds', arrayContains: userId)
        .get();

    // Pour chaque groupe, récupérer ses sessions
    for (final groupeDoc in groupesSnapshot.docs) {
      final sessionsSnapshot = await _firestore
          .collection('groupes')
          .doc(groupeDoc.id)
          .collection('sessions')
          .where('participantIds', arrayContains: userId) 
          .where('isTermine', isEqualTo: true) 
          .get();

      totalSessions += sessionsSnapshot.docs.length;

      for (final sessionDoc in sessionsSnapshot.docs) {
        final sessionData = sessionDoc.data();
        totalSeconds += (sessionData['dureeSecondes'] ?? 0) as int;
      }
    }

    return {'sessions': totalSessions, 'seconds': totalSeconds};
  }
}