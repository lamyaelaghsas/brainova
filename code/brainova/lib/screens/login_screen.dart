// Importations nécessaires
import 'package:flutter/material.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/spacings.dart';

// Classe principale du LoginScreen (StatefulWidget car l'écran change d'état)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// État privé du LoginScreen
class _LoginScreenState extends State<LoginScreen> {
  // Clé pour identifier et valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour récupérer le texte saisi dans chaque champ
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variable pour savoir si le mot de passe est masqué ou visible
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fonction appelée quand on clique sur le bouton "Se connecter"
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connexion réussie ! (Firebase à venir)'),
          backgroundColor: kSuccessColor,
        ),
      );
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
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    // === LOGO ===
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Image.asset(
                        'assets/icons/cerveau.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // === TITRE BRAINOVA ===
                    const Text(
                      'BRAINOVA',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: kWhiteColor,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // === SOUS-TITRE ===
                    const Text(
                      'Étudiez ensemble, brillez ensemble',
                      style: TextStyle(
                        fontSize: 14,
                        color: kTextSecondary,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // === CARTE FORMULAIRE ===
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: kSurfaceColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titre "Connexion"
                          const Text(
                            'Connexion',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: kWhiteColor,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // === CHAMP EMAIL ===
                          const Text(
                            'Adresse email',
                            style: TextStyle(
                              color: kWhiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              color: kWhiteColor,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: 'votre@email.com',
                              hintStyle: TextStyle(
                                color: kTextSecondary.withOpacity(0.5),
                                fontSize: 16,
                              ),
                              filled: true,
                              fillColor: kBackgroundColor.withOpacity(0.5),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: kAccentPurple,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
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

                          const SizedBox(height: 20),

                          // === CHAMP MOT DE PASSE ===
                          const Text(
                            'Mot de passe',
                            style: TextStyle(
                              color: kWhiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(
                              color: kWhiteColor,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              hintStyle: TextStyle(
                                color: kTextSecondary.withOpacity(0.5),
                                fontSize: 16,
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
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Entrez votre mot de passe';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // === BOUTON SE CONNECTER ===
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [kAccentColor, kAccentPurple],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Se connecter',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: kBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // === LIEN VERS INSCRIPTION ===
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/register');
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: 'Pas encore de compte ? ',
                          style: TextStyle(
                            color: kWhiteColor,
                            fontSize: 15,
                          ),
                          children: [
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

                    const SizedBox(height: 40),
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