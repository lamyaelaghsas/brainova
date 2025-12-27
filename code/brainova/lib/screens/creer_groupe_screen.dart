import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';
import 'package:brainova/styles/constants.dart';


class CreerGroupeScreen extends StatefulWidget {
  const CreerGroupeScreen({super.key});

  static const String routeName = '/creer-groupe';

  @override
  State<CreerGroupeScreen> createState() => _CreerGroupeScreenState();
}

class _CreerGroupeScreenState extends State<CreerGroupeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String _code = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateCode();
    _nomController.addListener(() {
      setState(() {}); // Pour mettre à jour le compteur de caractères
    });
  }

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  String _generateCode() {
    const chars = kGroupCodeCharacters; // Lettres majuscules et chiffres
    final random = Random();
    _code = List.generate(kGroupCodeLength, (index) => chars[random.nextInt(chars.length)]).join();
    return _code;
  }

  void _regenerateCode() {
    setState(() {
      _generateCode();
    });
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copié !'),
        backgroundColor: kSuccessColor,
        duration: Duration(seconds: kSnackBarCopyDurationSeconds), //2sec
      ),
    );
  }

  /// Génère un code unique en vérifiant dans Firestore
  Future<String> _generateUniqueCode() async {
    const maxAttempts = kMaxCodeGenerationAttempts; // Maximum de tentatives
    
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      final code = _generateCode(); // Génère un code aléatoire
      
      // Vérifier si le code existe déjà dans Firestore
      final existingGroup = await _firestore
          .collection('groupes')
          .where('code', isEqualTo: code)
          .get();
      
      if (existingGroup.docs.isEmpty) {
        // Code unique trouvé !
        setState(() => _code = code);
        return code;
      }
      
      // Code existe déjà, réessayer...
      print('Code $code existe déjà, tentative ${attempt + 1}/$maxAttempts');
    }
    
    // Après 10 tentatives, échec (très rare avec 36^6 combinaisons)
    throw Exception('Impossible de générer un code unique après $maxAttempts tentatives');
  }


  Future<void> _creerGroupe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Générer un code unique (boucle automatique)
      final uniqueCode = await _generateUniqueCode();

      // Créer le groupe avec le code garanti unique
      await _firestore.collection('groupes').add({
        'nom': _nomController.text.trim(),
        'code': uniqueCode,
        'couleur': kDefaultGroupColorHex,
        'memberIds': [userId],
        'createdBy': userId,
        'createdAt': DateTime.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Groupe créé avec succès !'),
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

  //================================================
  // Widget build
  //================================================
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
                    // Header RETOUR
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: kTextPrimary),
                        ),
                        const SizedBox(width: kPaddingHorizontalXS),
                      ],
                    ),

                    const SizedBox(height: kLargeSpace),

                    // Icône jaune
                    Center(
                      child: Container(
                        width: kIconSizeXL * kIconMultiplierDouble,
                        height: kIconSizeXL * kIconMultiplierDouble,
                        decoration: const BoxDecoration(
                          color: kAccentColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: kBackgroundColor,
                          size: kIconSizeXL,
                        ),
                      ),
                    ),

                    const SizedBox(height: kLargeSpace),

                    // Titre
                    const Center(
                      child: Text(
                        'Créer un Groupe',
                        style: kTitleLarge,
                      ),
                    ),

                    const SizedBox(height: kSmallSpace),

                    // Sous-titre
                    Center(
                      child: Text(
                        'Lancez votre nova d\'étude collective',
                        style: kBodyMedium.copyWith(
                          fontSize: kFontSizeMedium,
                          color: kTextSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: kPaddingVerticalL),

                    // Nom du groupe
                    Text(
                      'Nom du groupe',
                      style: kBodyMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: kSmallSpace),
                    TextFormField(
                      controller: _nomController,
                      maxLength: kGroupNameMaxLength,
                      style: kBodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Ex: Groupe Flutter BAC 3',
                        hintStyle: kBodyMedium.copyWith(
                          color: kTextSecondary.withOpacity(kOpacityLow),
                        ),
                        filled: true,
                        fillColor: kSurfaceColor.withOpacity(kOpacityLow),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kInputRadius),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: kPaddingHorizontal,
                          vertical: kPaddingVerticalS + kIndicatorSize,
                        ),
                        counterText: '${_nomController.text.length}/30 caractères',
                        counterStyle: kBodyMedium.copyWith(
                          fontSize: kFontSizeXSmall,
                          color: kTextSecondary,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrez un nom de groupe';
                        }
                        if (value.length < kGroupNameMinLength ) { //3 caractères
                          return 'Le nom doit contenir au moins 3 caractères';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: kLargeSpace),

                    // Code d'accès unique
                    Text(
                      'Code d\'accès unique',
                      style: kBodyMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: kSmallSpace),
                    Container(
                      padding: const EdgeInsets.all(kLargeSpace),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kAccentColor.withOpacity(kOpacityVeryLow),
                          width: kBorderWidth,
                        ),
                        borderRadius: BorderRadius.circular(kInputRadius),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Partagez ce code avec vos amis',
                            style: kBodyMedium.copyWith(
                              fontSize: kFontSizeSmall,
                              color: kTextSecondary,
                            ),
                          ),
                          const SizedBox(height: kMediumSpace),
                          Text(
                            _code,
                            style: kTitleLarge.copyWith(
                              color: kAccentColor,
                              letterSpacing: kLetterSpacingWide ,
                            ),
                          ),
                          const SizedBox(height: kMediumSpace),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _copyCode,
                                  icon: const Icon(Icons.copy, size: kIconSizeMedium),
                                  label: const Text('Copier'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: kAccentColor,
                                    side: const BorderSide(color: kAccentColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(kInputRadius),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: kMediumSpace),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _regenerateCode,
                                  icon: const Icon(Icons.refresh, size: kIconSizeMedium),
                                  label: const Text('Régénérer'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: kAccentPurple,
                                    side: const BorderSide(color: kAccentPurple),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(kInputRadius),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: kSmallSpace),
                          Row(
                            children: [
                              const Icon(
                                Icons.lightbulb_outline,
                                size: kIconSizeSmall,
                                color: kAccentColor,
                              ),
                              const SizedBox(width: kPaddingHorizontalXS),
                              Expanded(
                                child: Text(
                                  'Ce code sera utilisé pour rejoindre le groupe',
                                  style: kBodyMedium.copyWith(
                                    fontSize: kFontSizeXSmall,
                                    color: kAccentColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: kLargeSpace),

                    // Ce qui vous attend
                    Container(
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
                                Icons.auto_awesome,   
                                size: kIconSizeMedium,
                                color: kAccentColor,
                              ),
                              const SizedBox(width: kSmallSpace),
                              Text(
                                'Ce qui vous attend',
                                style: kTitleMedium.copyWith(fontSize: kFontSizeLarge),
                              ),
                            ],
                          ),
                          const SizedBox(height: kMediumSpace),
                          _buildFeatureItem(
                            Icons.auto_stories,  
                            'Suivez vos sessions d\'étude en groupe',
                          ),
                          const SizedBox(height: kSmallSpace),
                          _buildFeatureItem(
                            Icons.emoji_events,  
                            'Comparez vos performances avec les autres',
                          ),
                          const SizedBox(height: kSmallSpace),
                          _buildFeatureItem(
                            Icons.whatshot,  
                            'Motivez-vous mutuellement à étudier',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: kLargeSpace + kPaddingVertical),

                    // Bouton créer
                    SizedBox(
                      width: double.infinity,
                      height: kButtonHeight,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _creerGroupe,
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
                                Icons.auto_awesome,
                                color: kBackgroundColor,
                                size: kIconSizeMedium,
                              ),
                        label: Text(
                          'Créer le groupe',
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

                    const SizedBox(height: kSmallSpace),

                    // Note
                    Center(
                      child: Text(
                        'Le nom doit contenir au moins 3 caractères',
                        style: kBodyMedium.copyWith(
                          fontSize: kFontSizeXSmall,
                          color: kTextSecondary,
                        ),
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

  //================================================
  // Widget pour afficher un élément de fonctionnalité
  //================================================
  Widget _buildFeatureItem(IconData icon, String text) {  // String emoji → IconData icon
    return Row(
      children: [
        Icon(icon, size: kIconSizeMedium, color: kAccentColor),  // Remplace le Text(emoji)
        const SizedBox(width: kMediumSpace),
        Expanded(
          child: Text(
            text,
            style: kBodyMedium.copyWith(
              fontSize: kFontSizeMedium,
              color: kTextSecondary,
            ),
          ),
        ),
      ],
    );
  }
}