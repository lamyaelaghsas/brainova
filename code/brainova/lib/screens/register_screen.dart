// Importations nécessaires
import 'package:flutter/material.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/spacings.dart';

// Classe principale du RegisterScreen (StatefulWidget car l'écran change d'état)
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

// État privé du RegisterScreen
class _RegisterScreenState extends State<RegisterScreen> {
  // Clé pour identifier et valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour récupérer le texte saisi dans chaque champ
  final _prenomController = TextEditingController();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Variables pour savoir si les mots de passe sont masqués
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Fonction appelée quand on clique sur le bouton "Créer mon compte"
  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      print('Prénom: ${_prenomController.text}');
      print('Nom: ${_nomController.text}');
      print('Email: ${_emailController.text}');
      print('Mot de passe: ${_passwordController.text}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inscription réussie ! (Firebase à venir)'),
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
                    const SizedBox(height: 20),

                    

                    // === LOGO CERVEAU ===
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
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: kWhiteColor,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // === SOUS-TITRE ===
                    const Text(
                      'Créez votre compte et commencez à briller',
                      style: TextStyle(
                        fontSize: 14,
                        color: kTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

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
                          // Titre "Inscription"
                          const Text(
                            'Inscription',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: kWhiteColor,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // === LIGNE PRÉNOM + NOM ===
                          Row(
                            children: [
                              // Champ Prénom
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Prénom',
                                      style: TextStyle(
                                        color: kWhiteColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _prenomController,
                                      style: const TextStyle(
                                        color: kWhiteColor,
                                        fontSize: 16,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Jean',
                                        hintStyle: TextStyle(
                                          color: kTextSecondary.withOpacity(0.5),
                                          fontSize: 16,
                                        ),
                                        filled: true,
                                        fillColor: kBackgroundColor.withOpacity(0.5),
                                        prefixIcon: const Icon(
                                          Icons.person_outline,
                                          color: kAccentPink,
                                          size: 20,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Requis';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Champ Nom
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Nom',
                                      style: TextStyle(
                                        color: kWhiteColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _nomController,
                                      style: const TextStyle(
                                        color: kWhiteColor,
                                        fontSize: 16,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Dupont',
                                        hintStyle: TextStyle(
                                          color: kTextSecondary.withOpacity(0.5),
                                          fontSize: 16,
                                        ),
                                        filled: true,
                                        fillColor: kBackgroundColor.withOpacity(0.5),
                                        prefixIcon: const Icon(
                                          Icons.person_outline,
                                          color: kAccentPink,
                                          size: 20,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Requis';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

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
                                return 'Entrez un mot de passe';
                              }
                              if (value.length < 6) {
                                return 'Minimum 6 caractères';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // === CHAMP CONFIRMER MOT DE PASSE ===
                          const Text(
                            'Confirmer le mot de passe',
                            style: TextStyle(
                              color: kWhiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
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
                                return 'Confirmez votre mot de passe';
                              }
                              if (value != _passwordController.text) {
                                return 'Les mots de passe ne correspondent pas';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // === BOUTON CRÉER MON COMPTE ===
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [kAccentPink, kAccentPurple],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: ElevatedButton(
                                onPressed: _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Créer mon compte',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // === LIEN VERS CONNEXION ===
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/login');
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: 'Déjà un compte ? ',
                          style: TextStyle(
                            color: kWhiteColor,
                            fontSize: 15,
                          ),
                          children: [
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