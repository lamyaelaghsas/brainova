import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prenomController = TextEditingController();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Créer le compte Firebase Auth
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Créer le document utilisateur dans Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text.trim(),
        'nom': _nomController.text.trim(),
        'prenom': _prenomController.text.trim(),
        'createdAt': DateTime.now(),
      });

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/groupes');
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Une erreur est survenue';
      
      if (e.code == 'weak-password') {
        message = 'Le mot de passe est trop faible';
      } else if (e.code == 'email-already-in-use') {
        message = 'Cet email est déjà utilisé';
      } else if (e.code == 'invalid-email') {
        message = 'Email invalide';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back-accueil.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontalL),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: kPaddingVertical),

                    // === LOGO CERVEAU ===
                    const SizedBox(
                      width: kLogoSize,
                      height: kLogoSize,
                      child: Image(
                        image: AssetImage('assets/icons/cerveau.png'),
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: kPaddingVertical),

                    // === TITRE BRAINOVA ===
                    Text(
                      'BRAINOVA',
                      style: kTitleLarge.copyWith(
                        fontSize: kFontSizeXXLarge,
                      ),
                    ),

                    const SizedBox(height: kIndicatorSize),

                    // === SOUS-TITRE ===
                    Text(
                      'Créez votre compte et commencez à briller',
                      style: kBodyMedium.copyWith(
                        fontSize: kFontSizeSmall,
                        color: kTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: kLargeSpace + kPaddingHorizontalXS),

                    // === CARTE FORMULAIRE ===
                    Container(
                      padding: const EdgeInsets.all(kLargeSpace),
                      decoration: BoxDecoration(
                        color: kSurfaceColor.withOpacity(kFormFieldOpacity),
                        borderRadius: BorderRadius.circular(kCardRadius),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titre "Inscription"
                          const Text(
                            'Inscription',
                            style: kTitleMedium,
                          ),

                          const SizedBox(height: kLargeSpace),

                          // === LIGNE PRÉNOM + NOM ===
                          Row(
                            children: [
                              // Champ Prénom
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Prénom',
                                      style: kBodyMedium.copyWith(
                                        fontSize: kFontSizeSmall,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: kIndicatorSize),
                                    TextFormField(
                                      controller: _prenomController,
                                      style: kBodyMedium,
                                      decoration: InputDecoration(
                                        hintText: 'Jean',
                                        hintStyle: kBodyMedium.copyWith(
                                          color: kTextSecondary.withOpacity(kFormFieldOpacity),
                                        ),
                                        filled: true,
                                        fillColor: kBackgroundColor.withOpacity(kFormFieldOpacity),
                                        prefixIcon: const Icon(
                                          Icons.person_outline,
                                          color: kAccentPink,
                                          size: kPaddingVertical,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(kInputRadius),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: kMediumSpace,
                                          vertical: kMediumSpace,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Entrez votre prénom';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: kSmallSpace),
                              // Champ Nom
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nom',
                                      style: kBodyMedium.copyWith(
                                        fontSize: kFontSizeSmall,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: kIndicatorSize),
                                    TextFormField(
                                      controller: _nomController,
                                      style: kBodyMedium,
                                      decoration: InputDecoration(
                                        hintText: 'Dupont',
                                        hintStyle: kBodyMedium.copyWith(
                                          color: kTextSecondary.withOpacity(kFormFieldOpacity),
                                        ),
                                        filled: true,
                                        fillColor: kBackgroundColor.withOpacity(kFormFieldOpacity),
                                        prefixIcon: const Icon(
                                          Icons.person,
                                          color: kAccentPink,
                                          size: kPaddingVertical,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(kInputRadius),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: kMediumSpace,
                                          vertical: kMediumSpace,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Entrez votre nom';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: kPaddingVertical),

                          // === CHAMP EMAIL ===
                          Text(
                            'Email',
                            style: kBodyMedium.copyWith(
                              fontSize: kFontSizeSmall,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: kIndicatorSize),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: kBodyMedium,
                            decoration: InputDecoration(
                              hintText: 'jean.dupont@email.com',
                              hintStyle: kBodyMedium.copyWith(
                                color: kTextSecondary.withOpacity(kFormFieldOpacity),
                              ),
                              filled: true,
                              fillColor: kBackgroundColor.withOpacity(kFormFieldOpacity),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: kAccentColor,
                              ),
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
                                return 'Entrez votre email';
                              }
                              if (!value.contains('@')) {
                                return 'Email invalide';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: kPaddingVertical),

                          // === CHAMP MOT DE PASSE ===
                          Text(
                            'Mot de passe',
                            style: kBodyMedium.copyWith(
                              fontSize: kFontSizeSmall,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: kIndicatorSize),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: kBodyMedium,
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              hintStyle: kBodyMedium.copyWith(
                                color: kTextSecondary.withOpacity(kFormFieldOpacity),
                              ),
                              filled: true,
                              fillColor: kBackgroundColor.withOpacity(kFormFieldOpacity),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: kAccentPurple,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: kTextSecondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
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
                                return 'Entrez un mot de passe';
                              }
                              if (value.length < kPasswordMinLength) { // 6 caracteres minimum
                                return 'Minimum 6 caractères';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: kPaddingVertical),

                          // === CHAMP CONFIRMER MOT DE PASSE ===
                          Text(
                            'Confirmer le mot de passe',
                            style: kBodyMedium.copyWith(
                              fontSize: kFontSizeSmall,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: kIndicatorSize),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            style: kBodyMedium,
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              hintStyle: kBodyMedium.copyWith(
                                color: kTextSecondary.withOpacity(kFormFieldOpacity),
                              ),
                              filled: true,
                              fillColor: kBackgroundColor.withOpacity(kFormFieldOpacity),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: kAccentPurple,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: kTextSecondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
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
                                return 'Confirmez votre mot de passe';
                              }
                              if (value != _passwordController.text) {
                                return 'Les mots de passe ne correspondent pas';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: kLargeSpace),

                          // === BOUTON CRÉER MON COMPTE ===
                          SizedBox(
                            width: double.infinity,
                            height: kButtonHeight,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [kAccentPink, kAccentPurple],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                              ),
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: kIconSizeMedium,
                                        width: kIconSizeMedium,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: kWhiteColor,
                                        ),
                                      )
                                    : Text(
                                        'Créer mon compte',
                                        style: kButtonText.copyWith(
                                          fontSize: kFontSizeLarge,
                                          color: kWhiteColor,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: kLargeSpace),

                    // === LIEN VERS CONNEXION ===
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/login');
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Déjà un compte ? ',
                          style: kBodyMedium.copyWith(
                            fontSize: kFontSizeMedium,
                          ),
                          children: const [
                            TextSpan(
                              text: 'Se connecter',
                              style: TextStyle(
                                color: kAccentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: kPaddingVerticalL),
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