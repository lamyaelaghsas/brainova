import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';
import 'package:brainova/widgets/custom_bottom_nav_bar.dart';
import 'package:brainova/styles/constants.dart';

class GroupeListScreen extends StatefulWidget {
  const GroupeListScreen({super.key});

  static const String routeName = '/groupes';

  @override
  State<GroupeListScreen> createState() => _GroupeListScreenState();
}

// Écran affichant la liste des groupes de l'utilisateur
class _GroupeListScreenState extends State<GroupeListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Charge les données de l'utilisateur connecté
  Future<void> _loadUserData() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        setState(() {
          final prenom = data['prenom'] ?? '';
          final nom = data['nom'] ?? '';
          _userName = '$prenom $nom';
        });
      }
    }
  }

  // Convertit le code couleur hexadécimal en Color
  Color _getGroupColor(String couleur) {
    final hexColor = couleur.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: kHexadecimalRadix));
  }

  // Formate la durée totale en heures
  String _formatDuration(int minutes) {
    final hours = minutes ~/ kMinutesPerHour;
    return '${hours}h';
  }

  // Formate la date de la dernière session
  String _formatLastSession(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

     if (difference.inDays == kDefaultCount) {
      return 'Aujourd\'hui, ${date.hour}h${date.minute.toString().padLeft(kTimePadLength, kTimePadCharacter)}';
    } else if (difference.inDays == kOneDayAgo) {
      return 'Hier, ${date.hour}h${date.minute.toString().padLeft(kTimePadLength, kTimePadCharacter)}';
    } else if (difference.inDays < kDaysInWeek) { // Moins d'une semaine (7 jours)
      return 'Il y a ${difference.inDays} jours, ${date.hour}h${date.minute.toString().padLeft(kTimePadLength, kTimePadCharacter)}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // ===========================
  // Build Method 
  // ===========================
  @override
  Widget build(BuildContext context) {
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
              _buildHeader(),
              Expanded(
                child: _buildGroupsList(),
              ),
              // Boutons créer/rejoindre groupe
              Padding(
                padding: const EdgeInsets.all(kScreenPadding),
                child: Row(
                  children: [
                    // Bouton "Créer un groupe"
                    Expanded(
                      child: SizedBox(
                        height: kButtonHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/creer-groupe');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentColor,
                            foregroundColor: kBackgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(kInputRadius),
                            ),
                            elevation: kElevationNone,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, size: kIconSizeMedium),
                              const SizedBox(width: kPaddingHorizontalXS),
                              Text(
                                'Créer un groupe',
                                style: kButtonText.copyWith(
                                  color: kBackgroundColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: kMediumSpace),
                    // Bouton "Rejoindre un groupe"
                    Expanded(
                      child: SizedBox(
                        height: kButtonHeight,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/rejoindre-groupe');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kTextPrimary,
                            side: const BorderSide(color: kAccentColor, width: kBorderWidth),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(kInputRadius),
                            ),
                          ),
                          child: Text(
                            'Rejoindre un groupe',
                            style: kButtonText.copyWith(
                              color: kTextPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: kNavIndexGroups),
    );
  }

  // =============================================
  // Header avec nom utilisateur et déconnexion
  // =============================================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(kScreenPadding),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom de l'utilisateur
                Text(_userName, style: kTitleMedium),
                const SizedBox(height: kPaddingVerticalXS),
                // Nombre de groupes
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('groupes')
                      .where('memberIds', arrayContains: _auth.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final count = snapshot.hasData ? snapshot.data!.docs.length : kDefaultCount;
                    return Text(
                      '$count groupes',
                      style: kBodyMedium.copyWith(color: kTextSecondary),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================
  // Liste des groupes
  // ===========================
  Widget _buildGroupsList() {
    final userId = _auth.currentUser?.uid;
    
    if (userId == null) {
      return const Center(
        child: Text('Utilisateur non connecté', style: kBodyMedium),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('groupes')
          .where('memberIds', arrayContains: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: kAccentColor),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kScreenPadding,
                vertical: kMediumSpace,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mes Groupes d'Étude",
                    style: kTitleLarge,
                  ),
                  const SizedBox(height: kSmallSpace),
                  Text(
                    "Étudiez ensemble, brillez ensemble !",
                    style: kBodyMedium.copyWith(
                      color: kTextSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final groupeDoc = snapshot.data!.docs[index];
                  final groupeData = groupeDoc.data() as Map<String, dynamic>;
                  
                  return _buildGroupCard(
                    groupeId: groupeDoc.id,
                    nom: groupeData['nom'] ?? '',
                    code: groupeData['code'] ?? '',
                    couleur: groupeData['couleur'] ?? kDefaultGroupColorHex,
                    memberIds: List<String>.from(groupeData['memberIds'] ?? []),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGroupCard({
    required String groupeId,
    required String nom,
    required String code,
    required String couleur,
    required List<String> memberIds,
  }) {
    final groupColor = _getGroupColor(couleur);

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('groupes')
          .doc(groupeId)
          .collection('sessions')
          .snapshots(),
      builder: (context, sessionsSnapshot) {
        int totalMinutes = 0;
        DateTime? lastSessionDate;

        if (sessionsSnapshot.hasData) {
          for (final sessionDoc in sessionsSnapshot.data!.docs) {
            final sessionData = sessionDoc.data() as Map<String, dynamic>;
            totalMinutes += (sessionData['dureeMinutes'] ?? kDefaultCount) as int;
            
            final sessionDate = (sessionData['date'] as Timestamp).toDate();
            if (lastSessionDate == null || sessionDate.isAfter(lastSessionDate)) {
              lastSessionDate = sessionDate;
            }
          }
        }

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/groupe-detail',
              arguments: {
                'groupeId': groupeId,
                'nom': nom,
                'code': code,
                'couleur': couleur,
                'description': null,
              },
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: kMediumSpace),
            padding: const EdgeInsets.all(kLargeSpace),
            decoration: BoxDecoration(
              color: kSurfaceColor.withOpacity(kOpacityHigh),
              borderRadius: BorderRadius.circular(kCardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header avec nom
                Row(
                  children: [
                    // Pastille de couleur
                    Container(
                      width: kGroupColorBadge,
                      height: kGroupColorBadge,
                      decoration: BoxDecoration(
                        color: groupColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: kSmallSpace),
                    Expanded(
                      child: Text(
                        nom,
                        style: kTitleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSmallSpace),
                // Code
                Text(
                  'Code: $code',
                  style: kAccentText,
                ),
                const SizedBox(height: kMediumSpace),
                // Stats: Membres et Total
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(kCardPadding),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(kInputRadius),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.people,
                                  size: kIconSizeSmall,
                                  color: kTextSecondary,
                                ),
                                const SizedBox(width: kPaddingHorizontalXS),
                                Text(
                                  'Membres',
                                  style: kBodyMedium.copyWith(
                                    fontSize: kFontSizeXSmall,
                                    color: kTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: kPaddingVerticalXS),
                            Text(
                              '${memberIds.length}',
                              style: kTitleLarge.copyWith(fontSize: kFontSizeXXLarge),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: kMediumSpace),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(kCardPadding),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(kInputRadius),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.trending_up,
                                  size: kIconSizeSmall,
                                  color: kTextSecondary,
                                ),
                                const SizedBox(width: kPaddingHorizontalXS),
                                Text(
                                  'Total',
                                  style: kBodyMedium.copyWith(
                                    fontSize: kFontSizeXSmall,
                                    color: kTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: kPaddingVerticalXS),
                            Text(
                              _formatDuration(totalMinutes),
                              style: kTitleLarge.copyWith(fontSize: kFontSizeXXLarge),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Dernière session
                if (lastSessionDate != null) ...[
                  const SizedBox(height: kMediumSpace),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: kIconSizeSmall,
                        color: kAccentColor,
                      ),
                      const SizedBox(width: kPaddingHorizontalXS),
                      Text(
                        'Dernière session: ${_formatLastSession(lastSessionDate)}',
                        style: kBodyMedium.copyWith(
                          fontSize: kFontSizeXSmall,
                          color: kAccentColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kPaddingHorizontalL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.groups,
              size: kIconSizeXL * kIconMultiplierDouble,
              color: kTextSecondary,
            ),
            const SizedBox(height: kLargeSpace),
            const Text(
              'Aucun groupe',
              style: kTitleMedium,
            ),
            const SizedBox(height: kSmallSpace),
            Text(
              'Créez votre premier groupe d\'étude !',
              style: kBodyMedium.copyWith(color: kTextSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}