import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/groupes');
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Une erreur est survenue';
      
      if (e.code == 'user-not-found') {
        message = 'Aucun utilisateur trouvé avec cet email';
      } else if (e.code == 'wrong-password') {
        message = 'Mot de passe incorrect';
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
                    const SizedBox(height: kLargeSpace * 2.5),

                    // === LOGO ===
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
                    const Text(
                      'BRAINOVA',
                      style: kTitleLarge,
                    ),

                    const SizedBox(height: kIndicatorSize),

                    // === SOUS-TITRE ===
                    Text(
                      'Étudiez ensemble, brillez ensemble',
                      style: kBodyMedium.copyWith(
                        fontSize: kFontSizeSmall,
                        color: kTextSecondary,
                      ),
                    ),

                    const SizedBox(height: kPaddingVerticalL),

                    // === CARTE FORMULAIRE ===
                    Container(
                      padding: const EdgeInsets.all(kLargeSpace),
                      decoration: BoxDecoration(
                        color: kSurfaceColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(kCardRadius),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titre "Connexion"
                          const Text(
                            'Connexion',
                            style: kTitleMedium,
                          ),

                          const SizedBox(height: kLargeSpace),

                          // === CHAMP EMAIL ===
                          Text(
                            'Adresse email',
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
                              hintText: 'votre@email.com',
                              hintStyle: kBodyMedium.copyWith(
                                color: kTextSecondary.withOpacity(0.5),
                              ),
                              filled: true,
                              fillColor: kBackgroundColor.withOpacity(0.5),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: kAccentPurple,
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
                                color: kTextSecondary.withOpacity(0.5),
                              ),
                              filled: true,
                              fillColor: kBackgroundColor.withOpacity(0.5),
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
                                return 'Entrez votre mot de passe';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: kLargeSpace),

                          // === BOUTON SE CONNECTER ===
                          SizedBox(
                            width: double.infinity,
                            height: kButtonHeight,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [kAccentColor, kAccentPurple],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                              ),
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
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
                                          color: kBackgroundColor,
                                        ),
                                      )
                                    : Text(
                                        'Se connecter',
                                        style: kButtonText.copyWith(
                                          fontSize: kFontSizeLarge,
                                          color: kBackgroundColor,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: kLargeSpace),

                    // === LIEN VERS INSCRIPTION ===
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/register');
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Pas encore de compte ? ',
                          style: kBodyMedium.copyWith(
                            fontSize: kFontSizeMedium,
                          ),
                          children: const [
                            TextSpan(
                              text: 'S\'inscrire',
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