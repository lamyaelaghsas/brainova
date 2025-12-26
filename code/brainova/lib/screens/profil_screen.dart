import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';
import 'package:brainova/widgets/custom_bottom_nav_bar.dart';

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
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h\n${minutes}min';
    } else if (hours > 0) {
      return '${hours}h\n0min';
    } else if (minutes > 0) {
      return '0h\n${minutes}min';
    } else {
      return '0h\n0min';
    }
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
    if (nbSessions >= 10) {
      badges.add({
        'icon': '⭐',
        'name': 'Nova Brillante',
        'description': '10 sessions terminées',
        'unlocked': true,
      });
    }

    // Badge Studieux : 5+ sessions
    if (nbSessions >= 5) {
      badges.add({
        'icon': '🏆',
        'name': 'Studieux',
        'description': '5 sessions terminées',
        'unlocked': true,
      });
    }

    // Badge Marathon : 2h+ d'étude total
    if (totalSeconds >= 7200) {
      badges.add({
        'icon': '⏰',
        'name': 'Marathon',
        'description': '2h+ d\'étude',
        'unlocked': true,
      });
    }

    // Badge Social : 3+ groupes
    if (nbGroupes >= 3) {
      badges.add({
        'icon': '👥',
        'name': 'Social',
        'description': 'Membre de 3+ groupes',
        'unlocked': true,
      });
    }

    // Badges verrouillés (à débloquer)
    if (nbSessions < 10) {
      badges.add({
        'icon': '🔒',
        'name': 'Nova Brillante',
        'description': 'Terminez 10 sessions',
        'unlocked': false,
      });
    }

    if (nbSessions < 5) {
      badges.add({
        'icon': '🔒',
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
                              // Avatar + Nom + Email
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(kLargeSpace + kMediumSpace),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFFD700), Color(0xFFDB7BDB)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(kCardRadius),
                                ),
                                child: Column(
                                  children: [
                                    // Avatar
                                    Container(
                                      width: kAvatarSizeLarge * 1.5,
                                      height: kAvatarSizeLarge * 1.5,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFFFFD700), Color(0xFFDB7BDB)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: kBackgroundColor,
                                          width: 4,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        size: kIconSizeXL,
                                        color: kBackgroundColor,
                                      ),
                                    ),
                                    const SizedBox(height: kMediumSpace),
                                    // Nom
                                    Text(
                                      '$prenom $nom',
                                      style: kTitleLarge.copyWith(
                                        color: kBackgroundColor,
                                        fontSize: kFontSizeXXLarge,
                                      ),
                                    ),
                                    const SizedBox(height: kPaddingVerticalXS),
                                    // Email
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.email,
                                          size: kIconSizeSmall,
                                          color: kBackgroundColor,
                                        ),
                                        const SizedBox(width: kPaddingHorizontalXS),
                                        Text(
                                          email,
                                          style: kBodyMedium.copyWith(
                                            color: kBackgroundColor,
                                            fontSize: kFontSizeMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: kMediumSpace),
                                    // Badge principal si débloqué
                                    if (badges.any((b) => b['unlocked'] && b['name'] == 'Nova Brillante'))
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: kLargeSpace,
                                          vertical: kPaddingVerticalS,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFFFFD700), Color(0xFFFF69B4)],
                                          ),
                                          borderRadius: BorderRadius.circular(kInputRadius),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              '⭐',
                                              style: TextStyle(fontSize: kFontSizeLarge),
                                            ),
                                            const SizedBox(width: kPaddingHorizontalXS),
                                            Text(
                                              'Nova Brillante ⭐',
                                              style: kTitleMedium.copyWith(
                                                color: kBackgroundColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
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
                                      color: const Color(0xFF9B59B6),
                                    ),
                                  ),
                                  const SizedBox(width: kMediumSpace),
                                  Expanded(
                                    child: _buildStatCard(
                                      icon: Icons.star,
                                      label: 'Sessions',
                                      value: '$nbSessions',
                                      color: const Color(0xFFFFD700),
                                    ),
                                  ),
                                  const SizedBox(width: kMediumSpace),
                                  Expanded(
                                    child: _buildStatCard(
                                      icon: Icons.people,
                                      label: 'Groupes',
                                      value: '$nbGroupes',
                                      color: const Color(0xFFDB7BDB),
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
                                  color: kSurfaceColor.withOpacity(0.8),
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
                                  color: kSurfaceColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(kCardRadius),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '🏆 Badges',
                                      style: kTitleMedium.copyWith(
                                        fontSize: kFontSizeLarge,
                                      ),
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
        color: kSurfaceColor.withOpacity(0.8),
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
              fontSize: kFontSizeXLarge,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem({
    required String icon,
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
            : kPrimaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(kInputRadius),
        border: Border.all(
          color: unlocked ? kAccentColor : kTextSecondary.withOpacity(0.3),
          width: unlocked ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            icon,
            style: TextStyle(
              fontSize: kFontSizeXXLarge,
              color: unlocked ? null : kTextSecondary.withOpacity(0.5),
            ),
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
          .where('participantIds', arrayContains: userId) // ⭐ Seulement les sessions où l'user a participé
          .where('isTermine', isEqualTo: true) // ⭐ Seulement les sessions terminées
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