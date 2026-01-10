import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';
import 'package:brainova/styles/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;   
  bool _isHistoriqueTab = true;

  Color _getGroupColor() {
    final hexColor = widget.couleur.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ kSecondsPerHour;
    final minutes = (totalSeconds % kSecondsPerHour) ~/ kSecondsPerMinute;
    final seconds = totalSeconds % kSecondsPerMinute;

    if (hours > kDefaultCount) {
      if (minutes > kDefaultCount && seconds > kDefaultCount) {
        return '${hours}h ${minutes}min ${seconds}s';
      } else if (minutes > kDefaultCount) {
        return '${hours}h ${minutes}min';
      } else if (seconds > kDefaultCount) {
        return '${hours}h ${seconds}s';
      } else {
        return '${hours}h';
      }
    } else if (minutes > kDefaultCount) {
      if (seconds > kDefaultCount) {
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

    if (difference.inDays == kDefaultCount) {
      return 'Aujourd\'hui';
    } else if (difference.inDays == kFirstRank) {
      return 'Hier';
    } else if (difference.inDays < kDaysInWeek) {
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
          const Spacer(), 
          IconButton(
            onPressed: () => _showLeaveGroupDialog(),
            icon: const Icon(Icons.exit_to_app, color: kErrorColor),
            tooltip: 'Quitter le groupe',
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
            int totalSeconds = kDefaultCount;
            int sessionCount = kDefaultCount;

            if (sessionsSnapshot.hasData) {
              sessionCount = sessionsSnapshot.data!.docs.length;
              for (final doc in sessionsSnapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                final dureeSecondes = data['dureeSecondes'] ?? (data['dureeMinutes'] ?? kDefaultCount) * kSecondsPerMinute;
                totalSeconds += dureeSecondes as int;
              }
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: kScreenPadding),
              padding: const EdgeInsets.all(kLargeSpace),
              decoration: BoxDecoration(
                color: kSurfaceColor.withOpacity(kOpacityMediumHigh),
                borderRadius: BorderRadius.circular(kCardRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,   
                        color: kAccentColor,
                        size: kIconSizeMedium,
                      ),
                      const SizedBox(width: kSmallSpace),
                      Expanded(
                        child: Text(
                          widget.nom,   
                          style: kTitleMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showEditGroupNameDialog(),
                        icon: const Icon(Icons.edit, color: kAccentColor, size: kIconSizeMedium),
                        tooltip: 'Modifier le nom',
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
                  elevation: kElevationNone,
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
                  elevation: kElevationNone,
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

            final dureeSecondes = data['dureeSecondes'] ?? (data['dureeMinutes'] ?? kDefaultCount) * kSecondsPerMinute;

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
          color: kSurfaceColor.withOpacity(kOpacityMediumLow),
          borderRadius: BorderRadius.circular(kInputRadius),
          border: Border.all(
            color: kPrimaryColor,
            width: kBorderWidthThin,
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
              size: kIconSizeXL * kIconMultiplierDouble,
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

        final Map<String, int> userSeconds = {};

        if (sessionsSnapshot.hasData) {
          for (final sessionDoc in sessionsSnapshot.data!.docs) {
            final sessionData = sessionDoc.data() as Map<String, dynamic>;
            final participants = List<String>.from(sessionData['participantIds'] ?? []);
            final duree = sessionData['dureeSecondes'] ?? (sessionData['dureeMinutes'] ?? kDefaultCount) * kSecondsPerMinute;

            for (final userId in participants) {
              userSeconds[userId] = (userSeconds[userId] ?? kDefaultCount) + (duree as int);
            }
          }
        }

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

        Color rankColor = kTextSecondary;
        if (rank == kFirstRank) rankColor = kAccentColor;
        if (rank == kSecondRank) rankColor = kAccentPurple;
        if (rank == kThirdRank) rankColor = kAccentPink;

        return Container(
          margin: const EdgeInsets.only(bottom: kMediumSpace),
          padding: const EdgeInsets.all(kMediumSpace),
          decoration: BoxDecoration(
            color: kSurfaceColor.withOpacity(kOpacityMediumLow),
            borderRadius: BorderRadius.circular(kInputRadius),
            border: Border.all(
              color: rank <= kTopThreeRanks ? rankColor : kPrimaryColor,
              width: rank <= kTopThreeRanks ? kBorderWidth : kBorderWidthThin,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: kAvatarSizeSmall,
                height: kAvatarSizeSmall,
                decoration: BoxDecoration(
                  color: rankColor.withOpacity(kOpacityMinimal),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: rankColor,
                  size: kIconSizeMedium,
                ),
              ),
              const SizedBox(width: kMediumSpace),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kSmallSpace,
                  vertical: kPaddingVerticalXS,
                ),
                decoration: BoxDecoration(
                  color: rankColor.withOpacity(kOpacityMinimal),
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
              size: kIconSizeXL * kIconMultiplierDouble,
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

  // METHODES POUR QUITTER LE GROUPE (DANS LA CLASSE STATE)
  Future<void> _showLeaveGroupDialog() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kSurfaceColor,
        title: const Text('Quitter le groupe ?', style: kTitleMedium),
        content: Text(
          'Voulez-vous vraiment quitter "${widget.nom}" ?',
          style: kBodyMedium.copyWith(color: kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler', style: TextStyle(color: kTextSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Quitter', style: TextStyle(color: kErrorColor)),
          ),
        ],
      ),
    );

    if (shouldLeave == true && mounted) {
      await _leaveGroup();
    }
  }

  Future<void> _leaveGroup() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final groupeDoc = await _firestore
          .collection('groupes')
          .doc(widget.groupeId)
          .get();
      
      final memberIds = List<String>.from(
        (groupeDoc.data()?['memberIds'] ?? []) as List
      );

      memberIds.remove(userId);

      await _firestore.collection('groupes').doc(widget.groupeId).update({
        'memberIds': memberIds,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vous avez quitté le groupe'),
            backgroundColor: kSuccessColor,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: kErrorColor,
          ),
        );
      }
    }
  }

// METHODES POUR MODIFIER LE NOM DU GROUPE (DANS LA CLASSE STATE)
Future<void> _showEditGroupNameDialog() async {
  final TextEditingController nameController = TextEditingController(text: widget.nom);
  
  final newName = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: kSurfaceColor,
      title: const Text('Modifier le nom du groupe', style: kTitleMedium),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            autofocus: true,
            maxLength: kGroupNameMaxLength, // 30
            style: kBodyMedium,
            decoration: InputDecoration(
              hintText: 'Nouveau nom',
              hintStyle: kBodyMedium.copyWith(
                color: kTextSecondary.withOpacity(kOpacityLow),
              ),
              filled: true,
              fillColor: kBackgroundColor.withOpacity(kOpacityLow),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kInputRadius),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: kPaddingHorizontal,
                vertical: kPaddingVerticalS,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Annuler', style: TextStyle(color: kTextSecondary)),
        ),
        TextButton(
          onPressed: () {
            final trimmed = nameController.text.trim();
            if (trimmed.isNotEmpty && trimmed.length >= kGroupNameMinLength) {
              Navigator.pop(context, trimmed);
            }
          },
          child: const Text('Modifier', style: TextStyle(color: kAccentColor)),
        ),
      ],
    ),
  );

  if (newName != null && newName != widget.nom && mounted) {
    await _updateGroupName(newName);
  }
}

Future<void> _updateGroupName(String newName) async {
  try {
    await _firestore.collection('groupes').doc(widget.groupeId).update({
      'nom': newName,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nom du groupe modifié !'),
          backgroundColor: kSuccessColor,
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: kErrorColor,
        ),
      );
    }
  }
}

} 