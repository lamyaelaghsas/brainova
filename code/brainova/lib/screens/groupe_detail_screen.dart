import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';

class GroupeDetailScreen extends StatefulWidget {
  final String groupeId;
  final String nom;
  final String code;
  final String couleur;
  final String? description;

  const GroupeDetailScreen({
    super.key,
    required this.groupeId,
    required this.nom,
    required this.code,
    required this.couleur,
    this.description,
  });

  static const String routeName = '/groupe-detail';

  @override
  State<GroupeDetailScreen> createState() => _GroupeDetailScreenState();
}

class _GroupeDetailScreenState extends State<GroupeDetailScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isHistoriqueTab = true; // true = Historique, false = Classement

  Color _getGroupColor() {
    final hexColor = widget.couleur.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      if (minutes > 0 && seconds > 0) {
        return '${hours}h ${minutes}min ${seconds}s';
      } else if (minutes > 0) {
        return '${hours}h ${minutes}min';
      } else if (seconds > 0) {
        return '${hours}h ${seconds}s';
      } else {
        return '${hours}h';
      }
    } else if (minutes > 0) {
      if (seconds > 0) {
        return '${minutes}min ${seconds}s';
      } else {
        return '${minutes}min';
      }
    } else {
      return '${seconds}s';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Aujourd\'hui';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return months[month];
  }

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
              _buildGroupeCard(),
              _buildTabButtons(),
              Expanded(
                child: _isHistoriqueTab ? _buildHistorique() : _buildClassement(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _isHistoriqueTab
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/nouvelle-session',
                  arguments: {
                    'groupeId': widget.groupeId,
                    'groupeNom': widget.nom,
                  },
                );
              },
              backgroundColor: kAccentColor,
              icon: const Icon(Icons.add, color: kBackgroundColor),
              label: Text(
                'Ajouter une session',
                style: kButtonText.copyWith(
                  color: kBackgroundColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(kScreenPadding),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: kTextPrimary),
          ),
          const SizedBox(width: kPaddingHorizontalXS),
          const Text(
            'Retour',
            style: kBodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupeCard() {
    final groupColor = _getGroupColor();

    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('groupes').doc(widget.groupeId).snapshots(),
      builder: (context, groupSnapshot) {
        if (!groupSnapshot.hasData) {
          return const SizedBox.shrink();
        }

        final groupData = groupSnapshot.data!.data() as Map<String, dynamic>?;
        final memberIds = List<String>.from(groupData?['memberIds'] ?? []);

        return StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('groupes')
              .doc(widget.groupeId)
              .collection('sessions')
              .snapshots(),
          builder: (context, sessionsSnapshot) {
            int totalSeconds = 0;
            int sessionCount = 0;

            if (sessionsSnapshot.hasData) {
              sessionCount = sessionsSnapshot.data!.docs.length;
              for (final doc in sessionsSnapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                // Même code que session_detail_screen qui marche
                final dureeSecondes = data['dureeSecondes'] ?? (data['dureeMinutes'] ?? 0) * 60;
                totalSeconds += dureeSecondes as int;
              }
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: kScreenPadding),
              padding: const EdgeInsets.all(kLargeSpace),
              decoration: BoxDecoration(
                color: kSurfaceColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(kCardRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom du groupe avec émoji
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${widget.nom} ✨',
                          style: kTitleMedium,
                        ),
                      ),
                    ],
                  ),
                  if (widget.description != null) ...[
                    const SizedBox(height: kPaddingHorizontalXS),
                    Text(
                      widget.description!,
                      style: kBodyMedium.copyWith(
                        fontSize: kFontSizeSmall,
                        color: kTextSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: kSmallSpace),
                  // Code
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kMediumSpace,
                      vertical: kPaddingVerticalXS,
                    ),
                    decoration: BoxDecoration(
                      color: groupColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(kPaddingHorizontalXS),
                    ),
                    child: Text(
                      'Code: ${widget.code}',
                      style: kAccentText.copyWith(
                        color: groupColor,
                        fontSize: kFontSizeSmall,
                      ),
                    ),
                  ),
                  const SizedBox(height: kMediumSpace),
                  // Stats
                  Row(
                    children: [
                      _buildStatItem(
                        Icons.people,
                        memberIds.length.toString(),
                        'Membres',
                        kAccentPurple,
                      ),
                      const SizedBox(width: kLargeSpace),
                      _buildStatItem(
                        Icons.event_note,
                        sessionCount.toString(),
                        'Sessions',
                        kAccentPink,
                      ),
                      const SizedBox(width: kLargeSpace),
                      _buildStatItem(
                        Icons.access_time,
                        _formatDuration(totalSeconds),
                        'Temps total',
                        kAccentColor,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: kIconSizeMedium),
        const SizedBox(height: kPaddingVerticalXS),
        Text(
          value,
          style: kTitleMedium.copyWith(
            fontSize: kFontSizeLarge,
            color: color,
          ),
        ),
        Text(
          label,
          style: kBodyMedium.copyWith(
            fontSize: kFontSizeXSmall,
            color: kTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTabButtons() {
    return Padding(
      padding: const EdgeInsets.all(kScreenPadding),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: kButtonHeightSmall,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => _isHistoriqueTab = true);
                },
                icon: Icon(
                  Icons.history,
                  size: kIconSizeMedium,
                  color: _isHistoriqueTab ? kBackgroundColor : kTextPrimary,
                ),
                label: Text(
                  'Historique',
                  style: kButtonText.copyWith(
                    color: _isHistoriqueTab ? kBackgroundColor : kTextPrimary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isHistoriqueTab ? kAccentColor : kSurfaceColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kInputRadius),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
          const SizedBox(width: kMediumSpace),
          Expanded(
            child: SizedBox(
              height: kButtonHeightSmall,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => _isHistoriqueTab = false);
                },
                icon: Icon(
                  Icons.emoji_events,
                  size: kIconSizeMedium,
                  color: !_isHistoriqueTab ? kBackgroundColor : kTextPrimary,
                ),
                label: Text(
                  'Classement',
                  style: kButtonText.copyWith(
                    color: !_isHistoriqueTab ? kBackgroundColor : kTextPrimary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !_isHistoriqueTab ? kAccentColor : kSurfaceColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kInputRadius),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorique() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('groupes')
          .doc(widget.groupeId)
          .collection('sessions')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: kAccentColor),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyHistorique();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;

            // Même code que session_detail_screen qui marche
            final dureeSecondes = data['dureeSecondes'] ?? (data['dureeMinutes'] ?? 0) * 60;

            return _buildSessionCard(
              sessionId: doc.id,
              sujet: data['sujet'] ?? 'Session',
              date: (data['date'] as Timestamp).toDate(),
              duree: dureeSecondes as int,
              participants: List<String>.from(data['participantIds'] ?? []),
              isTermine: data['isTermine'] ?? false,
            );
          },
        );
      },
    );
  }

  Widget _buildSessionCard({
    required String sessionId,
    required String sujet,
    required DateTime date,
    required int duree,
    required List<String> participants,
    required bool isTermine,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/session-detail',
          arguments: {
            'groupeId': widget.groupeId,
            'sessionId': sessionId,
            'groupeNom': widget.nom,
          },
        );
      },
      child: Container(
      margin: const EdgeInsets.only(bottom: kMediumSpace),
      padding: const EdgeInsets.all(kMediumSpace),
      decoration: BoxDecoration(
        color: kSurfaceColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(kInputRadius),
        border: Border.all(
          color: kPrimaryColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  sujet,
                  style: kTitleMedium.copyWith(fontSize: kFontSizeLarge),
                ),
              ),
              if (isTermine)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kSmallSpace,
                    vertical: kPaddingVerticalXS,
                  ),
                  decoration: BoxDecoration(
                    color: kAccentPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(kPaddingHorizontalXS),
                  ),
                  child: Text(
                    'Terminé',
                    style: kBodyMedium.copyWith(
                      fontSize: kFontSizeXSmall,
                      color: kAccentPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: kSmallSpace),
          Row(
            children: [
              Icon(Icons.calendar_today, size: kIconSizeSmall, color: kTextSecondary),
              const SizedBox(width: kPaddingHorizontalXS),
              Text(
                _formatDate(date),
                style: kBodyMedium.copyWith(
                  fontSize: kFontSizeSmall,
                  color: kTextSecondary,
                ),
              ),
              const SizedBox(width: kMediumSpace),
              Icon(Icons.access_time, size: kIconSizeSmall, color: kTextSecondary),
              const SizedBox(width: kPaddingHorizontalXS),
              Text(
                _formatDuration(duree),
                style: kBodyMedium.copyWith(
                  fontSize: kFontSizeSmall,
                  color: kTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: kPaddingVerticalXS),
          Row(
            children: [
              Icon(Icons.people, size: kIconSizeSmall, color: kTextSecondary),
              const SizedBox(width: kPaddingHorizontalXS),
              Text(
                '${participants.length} participants',
                style: kBodyMedium.copyWith(
                  fontSize: kFontSizeSmall,
                  color: kTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildEmptyHistorique() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kPaddingHorizontalL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event_note,
              size: kIconSizeXL * 2,
              color: kTextSecondary,
            ),
            const SizedBox(height: kLargeSpace),
            const Text(
              'Aucune session',
              style: kTitleMedium,
            ),
            const SizedBox(height: kSmallSpace),
            Text(
              'Commencez par ajouter votre première session d\'étude !',
              style: kBodyMedium.copyWith(color: kTextSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassement() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('groupes')
          .doc(widget.groupeId)
          .collection('sessions')
          .snapshots(),
      builder: (context, sessionsSnapshot) {
        if (sessionsSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: kAccentColor),
          );
        }

        // Calculer le temps total par utilisateur
        final Map<String, int> userSeconds = {};

        if (sessionsSnapshot.hasData) {
          for (final sessionDoc in sessionsSnapshot.data!.docs) {
            final sessionData = sessionDoc.data() as Map<String, dynamic>;
            final participants = List<String>.from(sessionData['participantIds'] ?? []);
            // Même code que session_detail_screen qui marche
            final duree = sessionData['dureeSecondes'] ?? (sessionData['dureeMinutes'] ?? 0) * 60;

            for (final userId in participants) {
              userSeconds[userId] = (userSeconds[userId] ?? 0) + (duree as int);
            }
          }
        }

        // Trier par temps décroissant
        final sortedUsers = userSeconds.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        if (sortedUsers.isEmpty) {
          return _buildEmptyClassement();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
          itemCount: sortedUsers.length,
          itemBuilder: (context, index) {
            final userId = sortedUsers[index].key;
            final seconds = sortedUsers[index].value;
            final rank = index + 1;

            return _buildClassementCard(
              userId: userId,
              seconds: seconds,
              rank: rank,
            );
          },
        );
      },
    );
  }

  Widget _buildClassementCard({
    required String userId,
    required int seconds,
    required int rank,
  }) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(userId).snapshots(),
      builder: (context, userSnapshot) {
        // ⭐ CORRECTION: État de chargement
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.only(bottom: kMediumSpace),
            padding: const EdgeInsets.all(kMediumSpace),
            decoration: BoxDecoration(
              color: kSurfaceColor.withOpacity(0.6),
              borderRadius: BorderRadius.circular(kInputRadius),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: kAccentColor,
                strokeWidth: 2,
              ),
            ),
          );
        }

        // ⭐ CORRECTION: Données par défaut
        String fullName = 'Utilisateur inconnu';
        
        if (userSnapshot.hasData && userSnapshot.data!.exists) {
          final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
          final prenom = userData?['prenom'] ?? '';
          final nom = userData?['nom'] ?? '';
          
          if (prenom.isNotEmpty || nom.isNotEmpty) {
            fullName = '$prenom $nom'.trim();
          } else {
            fullName = 'Utilisateur';
          }
        }

        // Couleur selon le rang
        Color rankColor = kTextSecondary;
        if (rank == 1) rankColor = kAccentColor;
        if (rank == 2) rankColor = kAccentPurple;
        if (rank == 3) rankColor = kAccentPink;

        return Container(
          margin: const EdgeInsets.only(bottom: kMediumSpace),
          padding: const EdgeInsets.all(kMediumSpace),
          decoration: BoxDecoration(
            color: kSurfaceColor.withOpacity(0.6),
            borderRadius: BorderRadius.circular(kInputRadius),
            border: Border.all(
              color: rank <= 3 ? rankColor : kPrimaryColor,
              width: rank <= 3 ? kBorderWidth : 1,
            ),
          ),
          child: Row(
            children: [
              // Avatar avec icône
              Container(
                width: kAvatarSizeSmall,
                height: kAvatarSizeSmall,
                decoration: BoxDecoration(
                  color: rankColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: rankColor,
                  size: kIconSizeMedium,
                ),
              ),
              const SizedBox(width: kMediumSpace),
              // Nom
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: kTitleMedium.copyWith(fontSize: kFontSizeMedium),
                    ),
                    const SizedBox(height: kPaddingVerticalXS),
                    Text(
                      '${_formatDuration(seconds)} d\'étude',
                      style: kBodyMedium.copyWith(
                        fontSize: kFontSizeSmall,
                        color: kTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Badge rang
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kSmallSpace,
                  vertical: kPaddingVerticalXS,
                ),
                decoration: BoxDecoration(
                  color: rankColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(kPaddingHorizontalXS),
                ),
                child: Text(
                  '#$rank',
                  style: kAccentText.copyWith(
                    color: rankColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyClassement() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kPaddingHorizontalL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events,
              size: kIconSizeXL * 2,
              color: kTextSecondary,
            ),
            const SizedBox(height: kLargeSpace),
            const Text(
              'Pas encore de classement',
              style: kTitleMedium,
            ),
            const SizedBox(height: kSmallSpace),
            Text(
              'Ajoutez des sessions pour voir le classement !',
              style: kBodyMedium.copyWith(color: kTextSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}