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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> _rejoindreSession(Map<String, dynamic> sessionData) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      final participantIds = List<String>.from(sessionData['participantIds'] ?? []);

      // Ajouter l'utilisateur s'il n'est pas déjà participant
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

      // Si la session n'est pas terminée, naviguer vers l'écran actif
      final isTermine = sessionData['isTermine'] ?? false;
      if (!isTermine) {
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            '/session-active',
            arguments: {
              'groupeId': widget.groupeId,
              'sessionId': widget.sessionId,
              'groupeNom': widget.groupeNom,
              'sujet': sessionData['sujet'] ?? 'Session',
              'dureePrevueMinutes': sessionData['dureeMinutes'] ?? 60,
            },
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cette session est déjà terminée'),
              backgroundColor: kErrorColor,
            ),
          );
        }
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
              // Lire dureeSecondes si disponible, sinon convertir dureeMinutes
              final dureeSecondes = sessionData['dureeSecondes'] ?? (sessionData['dureeMinutes'] ?? 0) * 60;
              final participantIds = List<String>.from(sessionData['participantIds'] ?? []);
              final isTermine = sessionData['isTermine'] ?? false;
              final enCours = !isTermine;

              return Column(
                children: [
                  // Header
                  Padding(
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
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Titre
                            Row(
                              children: [
                                const Text('✨', style: TextStyle(fontSize: kFontSizeXLarge)),
                                const SizedBox(width: kSmallSpace),
                                const Text(
                                  'Détails de la session',
                                  style: kTitleLarge,
                                ),
                              ],
                            ),

                            const SizedBox(height: kSmallSpace),

                            // Nom du groupe
                            Text(
                              widget.groupeNom,
                              style: kBodyMedium.copyWith(
                                fontSize: kFontSizeMedium,
                                color: kTextSecondary,
                              ),
                            ),

                            const SizedBox(height: kLargeSpace),

                            // Card session
                            Container(
                              padding: const EdgeInsets.all(kLargeSpace),
                              decoration: BoxDecoration(
                                color: kSurfaceColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(kCardRadius),
                                border: Border.all(
                                  color: enCours ? kAccentColor : kPrimaryColor,
                                  width: enCours ? kBorderWidth : 1,
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
                                      if (enCours)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: kMediumSpace,
                                            vertical: kPaddingVerticalXS,
                                          ),
                                          decoration: BoxDecoration(
                                            color: kAccentColor.withOpacity(0.2),
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
                                        ),
                                    ],
                                  ),

                                  const SizedBox(height: kMediumSpace),

                                  // Date
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: kIconSizeSmall,
                                        color: kTextSecondary,
                                      ),
                                      const SizedBox(width: kPaddingHorizontalXS),
                                      Text(
                                        _formatDate(date),
                                        style: kBodyMedium.copyWith(
                                          fontSize: kFontSizeMedium,
                                          color: kTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: kSmallSpace),

                                  // Durée
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: kIconSizeSmall,
                                        color: kTextSecondary,
                                      ),
                                      const SizedBox(width: kPaddingHorizontalXS),
                                      Text(
                                        _formatDuration(dureeSecondes),
                                        style: kBodyMedium.copyWith(
                                          fontSize: kFontSizeMedium,
                                          color: kTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: kSmallSpace),

                                  // Participants count
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.people,
                                        size: kIconSizeSmall,
                                        color: kTextSecondary,
                                      ),
                                      const SizedBox(width: kPaddingHorizontalXS),
                                      Text(
                                        '${participantIds.length} participants',
                                        style: kBodyMedium.copyWith(
                                          fontSize: kFontSizeMedium,
                                          color: kTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: kLargeSpace),

                            // Section Participants
                            Row(
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
                            ),

                            const SizedBox(height: kMediumSpace),

                            // Liste participants
                            ...participantIds.map((userId) {
                              return _buildParticipantCard(userId, date);
                            }).toList(),

                            const SizedBox(height: kLargeSpace + kPaddingVertical),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bouton rejoindre
                  Padding(
                    padding: const EdgeInsets.all(kScreenPadding),
                    child: SizedBox(
                      width: double.infinity,
                      height: kButtonHeight,
                      child: ElevatedButton.icon(
                        onPressed: () => _rejoindreSession(sessionData),
                        icon: const Icon(
                          Icons.group_add,
                          color: kBackgroundColor,
                          size: kIconSizeMedium,
                        ),
                        label: Text(
                          'Rejoindre la session',
                          style: kButtonText.copyWith(
                            fontSize: kFontSizeLarge,
                            color: kBackgroundColor,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kAccentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kInputRadius),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
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
            color: kSurfaceColor.withOpacity(0.6),
            borderRadius: BorderRadius.circular(kInputRadius),
            border: Border.all(
              color: kPrimaryColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: kAvatarSizeMedium,
                height: kAvatarSizeMedium,
                decoration: BoxDecoration(
                  color: kAccentPurple.withOpacity(0.2),
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
}