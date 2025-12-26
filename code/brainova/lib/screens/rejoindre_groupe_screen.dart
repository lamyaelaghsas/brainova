import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';
import 'package:brainova/services/notification_service.dart';

class RejoindreGroupeScreen extends StatefulWidget {
  const RejoindreGroupeScreen({super.key});

  static const String routeName = '/rejoindre-groupe';

  @override
  State<RejoindreGroupeScreen> createState() => _RejoindreGroupeScreenState();
}

class _RejoindreGroupeScreenState extends State<RejoindreGroupeScreen> {
  // ========================================
  // CONTRÔLEURS & SERVICES
  // ========================================
  
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // ========================================
  // LIFECYCLE
  // ========================================
  
  @override
  void initState() {
    super.initState();
    _codeController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // ========================================
  // MÉTHODES - GESTION GROUPE
  // ========================================
  
  Future<void> _rejoindreGroupe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      final code = _codeController.text.trim().toUpperCase();

      // Chercher le groupe avec ce code
      final groupeQuery = await _firestore
          .collection('groupes')
          .where('code', isEqualTo: code)
          .get();

      if (groupeQuery.docs.isEmpty) {
        throw Exception('Aucun groupe trouvé avec ce code');
      }

      final groupeDoc = groupeQuery.docs.first;
      final groupeData = groupeDoc.data();
      final memberIds = List<String>.from(groupeData['memberIds'] ?? []);

      // Vérifier si l'utilisateur est déjà membre
      if (memberIds.contains(userId)) {
        throw Exception('Vous êtes déjà membre de ce groupe');
      }

      // Ajouter l'utilisateur au groupe
      memberIds.add(userId);
      await _firestore.collection('groupes').doc(groupeDoc.id).update({
        'memberIds': memberIds,
      });

      // Envoyer la notification à tous les membres
      await NotificationService.notifyMembreRejoint(
        groupeId: groupeDoc.id,
        newMemberId: userId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vous avez rejoint "${groupeData['nom']}" !'),
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _utiliserCodeTest(String code) {
    _codeController.text = code;
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
                    // SECTION ICÔNE & TITRE
                    // ========================================
                    
                    _buildIcon(),
                    const SizedBox(height: kLargeSpace),
                    _buildTitle(),
                    const SizedBox(height: kSmallSpace),
                    _buildSubtitle(),
                    const SizedBox(height: kPaddingVerticalL),

                    // ========================================
                    // SECTION CODE D'ACCÈS
                    // ========================================
                    
                    _buildCodeField(),
                    const SizedBox(height: kLargeSpace),

                    // ========================================
                    // SECTION COMMENT ÇA MARCHE
                    // ========================================
                    
                    _buildHowItWorks(),
                    const SizedBox(height: kLargeSpace),

                    // ========================================
                    // SECTION CODES DE TEST
                    // ========================================
                    
                    _buildTestCodes(),
                    const SizedBox(height: kPaddingVerticalXL),

                    // ========================================
                    // SECTION BOUTON
                    // ========================================
                    
                    _buildSubmitButton(),
                    const SizedBox(height: kSmallSpace),
                    _buildNote(),
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
        const Text('Retour', style: kBodyMedium),
      ],
    );
  }

  // ========================================
  // WIDGETS - ICÔNE & TITRE
  // ========================================
  
  Widget _buildIcon() {
    return Center(
      child: Container(
        width: kIconSizeXXXL,
        height: kIconSizeXXXL,
        decoration: const BoxDecoration(
          color: kAccentPurple,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.group_add,
          color: kWhiteColor,
          size: kIconSizeXL,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Center(
      child: Text(
        'Rejoindre un Groupe',
        style: kTitleLarge,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Center(
      child: Text(
        'Entrez le code partagé par vos amis',
        style: kBodyMedium.copyWith(
          fontSize: kFontSizeMedium,
          color: kTextSecondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ========================================
  // WIDGETS - CODE D'ACCÈS
  // ========================================
  
  Widget _buildCodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.key,
              color: kAccentPurple,
              size: kIconSizeMedium,
            ),
            const SizedBox(width: kPaddingHorizontalXS),
            Text(
              'Code d\'accès',
              style: kBodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: kSmallSpace),
        TextFormField(
          controller: _codeController,
          maxLength: kCodeLength,
          textCapitalization: TextCapitalization.characters,
          style: kTitleMedium.copyWith(
            letterSpacing: kLetterSpacingWide,
            color: kAccentPurple,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'ABC123',
            hintStyle: kTitleMedium.copyWith(
              color: kTextSecondary.withOpacity(kOpacityVeryLow),
              letterSpacing: kLetterSpacingWide,
            ),
            filled: true,
            fillColor: kSurfaceColor.withOpacity(kOpacityLow),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kInputRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: kPaddingHorizontal,
              vertical: kLargeSpace,
            ),
            counterText: '${_codeController.text.length}/$kCodeLength caractères',
            counterStyle: kBodyMedium.copyWith(
              fontSize: kFontSizeXSmall,
              color: kTextSecondary,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Entrez un code';
            }
            if (value.length != kCodeLength) {
              return 'Le code doit contenir $kCodeLength caractères';
            }
            return null;
          },
        ),
      ],
    );
  }

  // ========================================
  // WIDGETS - COMMENT ÇA MARCHE
  // ========================================
  
  Widget _buildHowItWorks() {
    return Container(
      padding: const EdgeInsets.all(kLargeSpace),
      decoration: BoxDecoration(
        color: kSurfaceColor.withOpacity(kOpacityLow),
        borderRadius: BorderRadius.circular(kInputRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb,
                color: kAccentColor,
                size: kIconSizeMedium,
              ),
              const SizedBox(width: kSmallSpace),
              Text(
                'Comment ça marche ?',
                style: kTitleMedium.copyWith(fontSize: kFontSizeLarge),
              ),
            ],
          ),
          const SizedBox(height: kMediumSpace),
          _buildStep(
            Icons.menu_book,
            'Demandez le code du groupe à un membre',
          ),
          const SizedBox(height: kSmallSpace),
          _buildStep(
            Icons.key,
            'Entrez le code de $kCodeLength caractères ci-dessus',
          ),
          const SizedBox(height: kSmallSpace),
          _buildStep(
            Icons.groups,
            'Commencez à étudier ensemble !',
          ),
        ],
      ),
    );
  }

  Widget _buildStep(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: kIconSizeMedium,
          color: kAccentPurple,
        ),
        const SizedBox(width: kMediumSpace),
        Expanded(
          child: Text(
            text,
            style: kBodyMedium.copyWith(
              fontSize: kFontSizeSmall,
              color: kTextSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ========================================
  // WIDGETS - CODES DE TEST
  // ========================================
  
  Widget _buildTestCodes() {
    return Container(
      padding: const EdgeInsets.all(kMediumSpace),
      decoration: BoxDecoration(
        border: Border.all(
          color: kAccentPurple.withOpacity(kOpacityVeryLow),
          width: kBorderWidthThin,
        ),
        borderRadius: BorderRadius.circular(kInputRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.code,
                size: kIconSizeSmall,
                color: kAccentPurple,
              ),
              const SizedBox(width: kPaddingHorizontalXS),
              Text(
                'Codes de test disponibles :',
                style: kBodyMedium.copyWith(
                  fontSize: kFontSizeSmall,
                  color: kAccentPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: kSmallSpace),
          Wrap(
            spacing: kSmallSpace,
            children: [
              _buildCodeChip('FL7K2X'),
              _buildCodeChip('MA9P4L'),
              _buildCodeChip('WB5H8N'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCodeChip(String code) {
    return GestureDetector(
      onTap: () => _utiliserCodeTest(code),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kMediumSpace,
          vertical: kPaddingVerticalXS,
        ),
        decoration: BoxDecoration(
          color: kAccentPurple.withOpacity(kOpacityMinimal),
          borderRadius: BorderRadius.circular(kPaddingHorizontalXS),
          border: Border.all(
            color: kAccentPurple.withOpacity(kOpacityLow),
            width: kBorderWidthThin,
          ),
        ),
        child: Text(
          code,
          style: kAccentText.copyWith(
            color: kAccentPurple,
            fontWeight: FontWeight.bold,
            letterSpacing: kLetterSpacingNormal,
          ),
        ),
      ),
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
        onPressed: _isLoading ? null : _rejoindreGroupe,
        icon: _isLoading
            ? const SizedBox(
                width: kIconSizeMedium,
                height: kIconSizeMedium,
                child: CircularProgressIndicator(
                  strokeWidth: kStrokeWidthThin,
                  color: kWhiteColor,
                ),
              )
            : const Icon(
                Icons.group_add,
                color: kWhiteColor,
                size: kIconSizeMedium,
              ),
        label: Text(
          'Rejoindre le groupe',
          style: kButtonText.copyWith(
            fontSize: kFontSizeLarge,
            color: kWhiteColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccentPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kInputRadius),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildNote() {
    return Center(
      child: Text(
        'Entrez les $kCodeLength caractères du code',
        style: kBodyMedium.copyWith(
          fontSize: kFontSizeXSmall,
          color: kTextSecondary,
        ),
      ),
    );
  }
}