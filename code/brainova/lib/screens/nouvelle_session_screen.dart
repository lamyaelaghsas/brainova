import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';
import 'package:brainova/services/notification_service.dart'; 

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
  // ========================================
  // CONTRÔLEURS & SERVICES
  // ========================================
  
  final _formKey = GlobalKey<FormState>();
  final _sujetController = TextEditingController();
  final _dureeController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // ========================================
  // LIFECYCLE
  // ========================================
  
  @override
  void dispose() {
    _sujetController.dispose();
    _dureeController.dispose();
    super.dispose();
  }

  // ========================================
  // MÉTHODES - GESTION SESSION
  // ========================================
  
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
        'dureeSecondes': 0,
        'dureeMinutes': 0,
        'dureePrevueMinutes': int.parse(_dureeController.text),
        'date': DateTime.now(),
        'participantIds': [userId],
        'isTermine': false,
        'createdBy': userId,
      });

      // Envoyer la notification à tous les membres
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(kScreenPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ========================================
                    // SECTION HEADER
                    // ========================================
                    
                    _buildHeader(),
                    const SizedBox(height: kLargeSpace),

                    // ========================================
                    // SECTION TITRE
                    // ========================================
                    
                    _buildTitle(),
                    const SizedBox(height: kSmallSpace),
                    _buildGroupeName(),
                    const SizedBox(height: kPaddingVerticalL),

                    // ========================================
                    // SECTION FORMULAIRE
                    // ========================================
                    
                    _buildForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ========================================
  // WIDGETS - HEADER
  // ========================================
  
  Widget _buildHeader() {
    return Row(
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
          'Nouvelle Session',
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
  // WIDGETS - FORMULAIRE
  // ========================================
  
  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(kLargeSpace),
      decoration: BoxDecoration(
        color: kSurfaceColor.withOpacity(kOpacityLow),
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Champ Sujet
          _buildSujetField(),
          const SizedBox(height: kLargeSpace),

          // Champ Durée
          _buildDureeField(),
          const SizedBox(height: kPaddingVerticalXL),

          // Bouton Démarrer
          _buildSubmitButton(),
        ],
      ),
    );
  }

  // ========================================
  // WIDGETS - CHAMPS DE SAISIE
  // ========================================
  
  Widget _buildSujetField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
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
        
        // Champ
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
      ],
    );
  }

  Widget _buildDureeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
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
        
        // Champ
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
            if (number == null || number <= 0) {
              return 'Entrez un nombre valide';
            }
            return null;
          },
        ),
      ],
    );
  }

  // ========================================
  // WIDGETS - BOUTONS
  // ========================================
  
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: kButtonHeight,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _demarrerSession,
        icon: _isLoading
            ? const SizedBox(
                width: kIconSizeMedium,
                height: kIconSizeMedium,
                child: CircularProgressIndicator(
                  strokeWidth: kStrokeWidthThin,
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
          elevation: 0,
        ),
      ),
    );
  }
}