import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';

class SessionDetailScreen extends StatefulWidget {
  final String groupeId;
  final String sessionId;
  final String groupeNom;

  const SessionDetailScreen({
    super.key,
    required this.groupeId,
    required this.sessionId,
    required this.groupeNom,
  });

  static const String routeName = '/session-detail';

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  // ========================================
  // SERVICES FIREBASE
  // ========================================
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ========================================
  // MÉTHODES - FORMATAGE
  // ========================================
  
  String _formatDate(DateTime date) {
    const months = [
      '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    
    final day = date.day;
    final month = months[date.month];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day $month $year à $hour:$minute';
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

  String _formatJoinTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return 'Rejoint à $hour:$minute';
  }

  // ========================================
  // MÉTHODES - GESTION SESSION
  // ========================================
  
  Future<void> _rejoindreSession(Map<String, dynamic> sessionData) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Vérification : La session est-elle terminée ?
      final isTermine = sessionData['isTermine'] ?? false;

      if (isTermine) {
        // Session terminée → Ne pas ajouter l'utilisateur
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cette session est déjà terminée. Consultez les résultats dans l\'historique.'),
              backgroundColor: kErrorColor,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return; 
      }

      // Session en cours → Ajouter l'utilisateur
      final participantIds = List<String>.from(sessionData['participantIds'] ?? []);

      if (!participantIds.contains(userId)) {
        participantIds.add(userId);
        await _firestore
            .collection('groupes')
            .doc(widget.groupeId)
            .collection('sessions')
            .doc(widget.sessionId)
            .update({
          'participantIds': participantIds,
        });
      }

      // Navigation vers l'écran actif
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/session-active',
          arguments: {
            'groupeId': widget.groupeId,
            'sessionId': widget.sessionId,
            'groupeNom': widget.groupeNom,
            'sujet': sessionData['sujet'] ?? 'Session',
            'dureePrevueMinutes': sessionData['dureePrevueMinutes'] ?? 60,
          },
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

  // ========================================
  // BUILD - UI PRINCIPALE
  // ========================================
  
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
          child: StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection('groupes')
                .doc(widget.groupeId)
                .collection('sessions')
                .doc(widget.sessionId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: kAccentColor),
                );
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(
                  child: Text(
                    'Session introuvable',
                    style: kTitleMedium,
                  ),
                );
              }

              final sessionData = snapshot.data!.data() as Map<String, dynamic>;
              final sujet = sessionData['sujet'] ?? 'Session';
              final date = (sessionData['date'] as Timestamp).toDate();
              final dureeSecondes = sessionData['dureeSecondes'] ?? (sessionData['dureeMinutes'] ?? 0) * 60;
              final participantIds = List<String>.from(sessionData['participantIds'] ?? []);
              final isTermine = sessionData['isTermine'] ?? false;
              final enCours = !isTermine;

              return Column(
                children: [
                  // ========================================
                  // SECTION HEADER
                  // ========================================
                  
                  _buildHeader(),

                  // ========================================
                  // SECTION CONTENU
                  // ========================================
                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle(),
                            const SizedBox(height: kSmallSpace),
                            _buildGroupeName(),
                            const SizedBox(height: kLargeSpace),
                            _buildSessionCard(
                              sujet: sujet,
                              date: date,
                              dureeSecondes: dureeSecondes,
                              participantIds: participantIds,
                              enCours: enCours,
                            ),
                            const SizedBox(height: kLargeSpace),
                            _buildParticipantsSection(),
                            const SizedBox(height: kMediumSpace),
                            _buildParticipantsList(participantIds, date),
                            const SizedBox(height: kPaddingVerticalXL),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ========================================
                  // SECTION BOUTON
                  // ========================================
                  
                  _buildJoinButton(isTermine, sessionData),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ========================================
  // WIDGETS - HEADER
  // ========================================
  
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
          const Text('Retour', style: kBodyMedium),
        ],
      ),
    );
  }

  // ========================================
  // WIDGETS - TITRE
  // ========================================
  
  Widget _buildTitle() {
    return Row(
      children: [
        const Icon(
          Icons.auto_awesome,
          size: kIconSizeLarge,
          color: kAccentColor,
        ),
        const SizedBox(width: kSmallSpace),
        const Text(
          'Détails de la session',
          style: kTitleLarge,
        ),
      ],
    );
  }

  Widget _buildGroupeName() {
    return Text(
      widget.groupeNom,
      style: kBodyMedium.copyWith(
        fontSize: kFontSizeMedium,
        color: kTextSecondary,
      ),
    );
  }

  // ========================================
  // WIDGETS - CARTE SESSION
  // ========================================
  
  Widget _buildSessionCard({
    required String sujet,
    required DateTime date,
    required int dureeSecondes,
    required List<String> participantIds,
    required bool enCours,
  }) {
    return Container(
      padding: const EdgeInsets.all(kLargeSpace),
      decoration: BoxDecoration(
        color: kSurfaceColor.withOpacity(kOpacityMediumHigh),
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(
          color: enCours ? kAccentColor : kPrimaryColor,
          width: enCours ? kBorderWidth : kBorderWidthThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sujet + Badge
          Row(
            children: [
              Expanded(
                child: Text(
                  sujet,
                  style: kTitleMedium.copyWith(
                    fontSize: kFontSizeLarge,
                  ),
                ),
              ),
              if (enCours) _buildBadgeEnCours(),
              if (!enCours) _buildBadgeTerminee(),
            ],
          ),
          const SizedBox(height: kMediumSpace),
          
          // Date
          _buildInfoRow(Icons.calendar_today, _formatDate(date)),
          const SizedBox(height: kSmallSpace),
          
          // Durée
          _buildInfoRow(Icons.access_time, _formatDuration(dureeSecondes)),
          const SizedBox(height: kSmallSpace),
          
          // Participants count
          _buildInfoRow(Icons.people, '${participantIds.length} participants'),
        ],
      ),
    );
  }

  Widget _buildBadgeEnCours() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kMediumSpace,
        vertical: kPaddingVerticalXS,
      ),
      decoration: BoxDecoration(
        color: kAccentColor.withOpacity(kOpacityMinimal),
        borderRadius: BorderRadius.circular(kPaddingHorizontalXS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: kIndicatorSize,
            height: kIndicatorSize,
            decoration: const BoxDecoration(
              color: kAccentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: kPaddingHorizontalXS),
          Text(
            'En cours',
            style: kBodyMedium.copyWith(
              fontSize: kFontSizeSmall,
              color: kAccentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeTerminee() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kMediumSpace,
        vertical: kPaddingVerticalXS,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(kOpacityMinimal),
        borderRadius: BorderRadius.circular(kPaddingHorizontalXS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            size: kIconSizeSmall,
            color: kPrimaryColor,
          ),
          const SizedBox(width: kPaddingHorizontalXS),
          Text(
            'Terminée',
            style: kBodyMedium.copyWith(
              fontSize: kFontSizeSmall,
              color: kPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: kIconSizeSmall,
          color: kTextSecondary,
        ),
        const SizedBox(width: kPaddingHorizontalXS),
        Text(
          text,
          style: kBodyMedium.copyWith(
            fontSize: kFontSizeMedium,
            color: kTextSecondary,
          ),
        ),
      ],
    );
  }

  // ========================================
  // WIDGETS - PARTICIPANTS
  // ========================================
  
  Widget _buildParticipantsSection() {
    return Row(
      children: [
        const Icon(
          Icons.people,
          color: kAccentPurple,
          size: kIconSizeMedium,
        ),
        const SizedBox(width: kPaddingHorizontalXS),
        Text(
          'Participants',
          style: kTitleMedium.copyWith(fontSize: kFontSizeLarge),
        ),
      ],
    );
  }

  Widget _buildParticipantsList(List<String> participantIds, DateTime sessionDate) {
    return Column(
      children: participantIds.map((userId) {
        return _buildParticipantCard(userId, sessionDate);
      }).toList(),
    );
  }

  Widget _buildParticipantCard(String userId, DateTime sessionDate) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(userId).snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const SizedBox.shrink();
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
        final prenom = userData?['prenom'] ?? '';
        final nom = userData?['nom'] ?? '';
        final fullName = '$prenom $nom';

        return Container(
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
          child: Row(
            children: [
              // Avatar
              Container(
                width: kAvatarSizeMedium,
                height: kAvatarSizeMedium,
                decoration: BoxDecoration(
                  color: kAccentPurple.withOpacity(kOpacityMinimal),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: kAccentPurple,
                  size: kIconSizeMedium,
                ),
              ),
              const SizedBox(width: kMediumSpace),
              
              // Nom + heure
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
                      _formatJoinTime(sessionDate),
                      style: kBodyMedium.copyWith(
                        fontSize: kFontSizeSmall,
                        color: kTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ========================================
  // WIDGETS - BOUTONS
  // ========================================
  
  Widget _buildJoinButton(bool isTermine, Map<String, dynamic> sessionData) {
    return Padding(
      padding: const EdgeInsets.all(kScreenPadding),
      child: SizedBox(
        width: double.infinity,
        height: kButtonHeight,
        child: ElevatedButton.icon(
          onPressed: isTermine ? null : () => _rejoindreSession(sessionData),
          icon: Icon(
            isTermine ? Icons.check_circle : Icons.group_add,
            color: isTermine ? kTextSecondary : kBackgroundColor,
            size: kIconSizeMedium,
          ),
          label: Text(
            isTermine ? 'Session terminée' : 'Rejoindre la session',
            style: kButtonText.copyWith(
              fontSize: kFontSizeLarge,
              color: isTermine ? kTextSecondary : kBackgroundColor,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isTermine ? kSurfaceColor : kAccentColor,
            disabledBackgroundColor: kSurfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kInputRadius),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}