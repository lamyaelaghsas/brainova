import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';
import 'package:brainova/services/notification_service.dart'; 
import 'package:brainova/styles/constants.dart';


class NouvelleSessionScreen extends StatefulWidget {
  final String groupeId;
  final String groupeNom;

  const NouvelleSessionScreen({
    super.key,
    required this.groupeId,
    required this.groupeNom,
  });

  static const String routeName = '/nouvelle-session';

  @override
  State<NouvelleSessionScreen> createState() => _NouvelleSessionScreenState();
}

class _NouvelleSessionScreenState extends State<NouvelleSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sujetController = TextEditingController();
  final _dureeController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _sujetController.dispose();
    _dureeController.dispose();
    super.dispose();
  }

  Future<void> _demarrerSession() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Créer la session EN COURS (isTermine = false)
      final sessionDoc = await _firestore
          .collection('groupes')
          .doc(widget.groupeId)
          .collection('sessions')
          .add({
        'sujet': _sujetController.text.trim(),
        'dureeSecondes': kDefaultCount,
        'dureeMinutes': kDefaultCount,
        'dureePrevueMinutes': int.parse(_dureeController.text),
        'date': DateTime.now(),
        'participantIds': [userId],
        'isTermine': false,
        'createdBy': userId,
      });

      //  ENVOYER LA NOTIFICATION À TOUS LES MEMBRES
      await NotificationService.notifyNewSession(
        groupeId: widget.groupeId,
        sessionId: sessionDoc.id,
        sujet: _sujetController.text.trim(),
        creatorId: userId,
      );

      if (mounted) {
        // Navigation vers l'écran de session active avec chronomètre
        Navigator.pushReplacementNamed(
          context,
          '/session-active',
          arguments: {
            'groupeId': widget.groupeId,
            'sessionId': sessionDoc.id,
            'groupeNom': widget.groupeNom,
            'sujet': _sujetController.text.trim(),
            'dureePrevueMinutes': int.parse(_dureeController.text),
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(kScreenPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header avec bouton retour
                    Row(
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

                    const SizedBox(height: kLargeSpace),

                    // Titre avec émoji
                    Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome,  
                          size: kIconSizeLarge,
                          color: kAccentColor,
                        ),
                        const SizedBox(width: kSmallSpace),
                        const Text(
                          'Nouvelle Session',
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

                    const SizedBox(height: kPaddingVerticalL),

                    // Formulaire
                    Container(
                      padding: const EdgeInsets.all(kLargeSpace),
                      decoration: BoxDecoration(
                        color: kSurfaceColor.withOpacity(kOpacityLow),
                        borderRadius: BorderRadius.circular(kCardRadius),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Champ Sujet
                          Row(
                            children: [
                              const Icon(
                                Icons.book,
                                color: kAccentColor,
                                size: kIconSizeMedium,
                              ),
                              const SizedBox(width: kPaddingHorizontalXS),
                              Text(
                                'Sujet de la session',
                                style: kBodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: kSmallSpace),
                          TextFormField(
                            controller: _sujetController,
                            style: kBodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Ex: Mathématiques - Calcul intégral',
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
                                vertical: kPaddingVerticalS + kIndicatorSize,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Entrez un sujet';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: kLargeSpace),

                          // Champ Durée
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: kAccentColor,
                                size: kIconSizeMedium,
                              ),
                              const SizedBox(width: kPaddingHorizontalXS),
                              Text(
                                'Durée prévue (minutes)',
                                style: kBodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: kSmallSpace),
                          TextFormField(
                            controller: _dureeController,
                            keyboardType: TextInputType.number,
                            style: kBodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Ex: 60',
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
                                vertical: kPaddingVerticalS + kIndicatorSize,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Entrez une durée';
                              }
                              final number = int.tryParse(value);
                              if (number == null || number <= kDefaultCount) {
                                return 'Entrez un nombre valide';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: kLargeSpace + kPaddingVertical),

                          // Bouton Démarrer
                          SizedBox(
                            width: double.infinity,
                            height: kButtonHeight,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _demarrerSession,
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: kIconSizeMedium,
                                      height: kIconSizeMedium,
                                      child: CircularProgressIndicator(
                                        strokeWidth: kLoadingStrokeWidth,
                                        color: kBackgroundColor,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.play_arrow,
                                      color: kBackgroundColor,
                                      size: kIconSizeLarge,
                                    ),
                              label: Text(
                                'Démarrer la session',
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
                                elevation: kElevationNone,
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
          ),
        ),
      ),
    );
  }
}