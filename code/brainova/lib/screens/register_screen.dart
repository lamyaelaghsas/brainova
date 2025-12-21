// Importations nécessaires
import 'package:flutter/material.dart'; // Framework Flutter
import 'package:brainova/styles/colors.dart'; // Nos couleurs personnalisées
import 'package:brainova/styles/spacings.dart'; // Nos espacements

// Classe principale du RegisterScreen (StatefulWidget car l'écran change d'état)
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key}); // Constructeur

  static const String routeName = '/register'; // Nom de la route pour la navigation

  @override
  State<RegisterScreen> createState() => _RegisterScreenState(); // Crée l'état du widget
}

// État privé du RegisterScreen (c'est ici que la logique se trouve)
class _RegisterScreenState extends State<RegisterScreen> {
  // Clé pour identifier et valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour récupérer le texte saisi dans chaque champ
  final _prenomController = TextEditingController(); // Contrôle le champ prénom
  final _emailController = TextEditingController(); // Contrôle le champ email
  final _passwordController = TextEditingController(); // Contrôle le champ password

  // Variable pour savoir si le mot de passe est masqué ou visible
  bool _obscurePassword = true; // true = masqué (par défaut)

  @override
  void dispose() {
    // Méthode appelée quand le widget est détruit
    // Important : libérer la mémoire des contrôleurs
    _prenomController.dispose(); // Détruit le contrôleur prénom
    _emailController.dispose(); // Détruit le contrôleur email
    _passwordController.dispose(); // Détruit le contrôleur password
    super.dispose(); // Appelle la méthode dispose du parent
  }

  // Fonction appelée quand on clique sur le bouton "Inscription"
  void _handleRegister() {
    // Vérifie si le formulaire est valide (tous les validators retournent null)
    if (_formKey.currentState!.validate()) {
      // Affiche dans la console les valeurs saisies (pour debug)
      print('Prénom: ${_prenomController.text}'); // Affiche le prénom
      print('Email: ${_emailController.text}'); // Affiche l'email
      print('Mot de passe: ${_passwordController.text}'); // Affiche le mot de passe

      // Affiche un message de succès en bas de l'écran (SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inscription réussie ! (Firebase à venir)'), // Texte du message
          backgroundColor: kSuccessColor, // Couleur verte de succès
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Méthode qui construit l'interface graphique
    return Scaffold( // Structure de base d'un écran Flutter
      body: Container( // Container pour le fond
        width: double.infinity, // Prend toute la largeur
        height: double.infinity, // Prend toute la hauteur
        decoration: const BoxDecoration( // Décoration du container
          image: DecorationImage( // Image de fond
            image: AssetImage('assets/images/back-accueil.png'), // Chemin de l'image
            fit: BoxFit.cover, // L'image couvre tout l'écran
          ),
        ),
        child: SafeArea( // Zone sûre (évite les encoches, status bar, etc.)
          child: SingleChildScrollView( // Permet de scroller si le clavier apparaît
            child: Padding( // Ajoute du padding horizontal
              padding: const EdgeInsets.symmetric(horizontal: 40), // 40px à gauche et droite
              child: Form( // Widget formulaire pour la validation
                key: _formKey, // Associe la clé du formulaire
                child: Column( // Colonne verticale pour aligner les éléments
                  children: [
                    const SizedBox(height: 60), // Espace vide de 60px en haut

                    // === LOGO ===
                    Container( // Container pour le logo
                      width: 180, // Largeur du logo A MODIF APRES PCQ JE TESTE JUSTE SUR CHROME MM PR LOGIN
                      height: 180, // Hauteur du logo
                      /*decoration: BoxDecoration( // Décoration du container
                        shape: BoxShape.circle, // Forme circulaire
                        boxShadow: [ // Ombre autour du logo
                          BoxShadow(
                            color: kAccentColor.withOpacity(0.3), // Couleur dorée semi-transparente
                            blurRadius: 30, // Flou de l'ombre
                            spreadRadius: 5, // Étendue de l'ombre
                          ),
                        ],
                      ),*/
                      child: ClipOval( // Découpe en forme de cercle
                        child: Image.asset( // Image du logo
                          'assets/icons/icon-accueil.png', // Chemin de l'image
                          fit: BoxFit.cover, // Couvre tout le cercle
                        ),
                      ),
                    ),

                    const SizedBox(height: 60), // Espace de 60px après le logo

                    // === CHAMP PRÉNOM ===
                    Column( // Colonne pour le label + champ
                      crossAxisAlignment: CrossAxisAlignment.start, // Aligne à gauche
                      children: [
                        const Padding( // Padding pour le label
                          padding: EdgeInsets.only(left: 8, bottom: 8), // 8px à gauche et en bas
                          child: Text( // Texte "PRÉNOM"
                            'PRÉNOM',
                            style: TextStyle(
                              color: kWhiteColor, // Couleur blanche
                              fontSize: 14, // Taille du texte
                              fontWeight: FontWeight.w600, // Gras
                              letterSpacing: 1, // Espacement entre les lettres
                            ),
                          ),
                        ),
                        TextFormField( // Champ de texte avec validation
                          controller: _prenomController, // Associe le contrôleur
                          style: const TextStyle( // Style du texte saisi
                            color: Color(0xFF9CA3AF), // Couleur grise
                            fontSize: 16, // Taille du texte
                          ),
                          decoration: InputDecoration( // Décoration du champ
                            hintText: 'LAMYAE', // Texte placeholder
                            hintStyle: const TextStyle( // Style du placeholder
                              color: Color(0xFF9CA3AF), // Couleur grise
                              fontSize: 16, // Taille
                            ),
                            filled: true, // Active le fond coloré
                            fillColor: const Color(0xFFE5E7EB), // Couleur de fond gris clair
                            border: OutlineInputBorder( // Bordure du champ
                              borderRadius: BorderRadius.circular(12), // Coins arrondis
                              borderSide: BorderSide.none, // Pas de bordure visible
                            ),
                            contentPadding: const EdgeInsets.symmetric( // Padding interne
                              horizontal: 20, // 20px à gauche et droite
                              vertical: 18, // 18px en haut et bas
                            ),
                          ),
                          validator: (value) { // Fonction de validation
                            if (value == null || value.isEmpty) { // Si le champ est vide
                              return 'Entrez votre prénom'; // Message d'erreur
                            }
                            return null; // Pas d'erreur
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24), // Espace de 24px entre les champs

                    // === CHAMP EMAIL ===
                    Column( // Colonne pour le label + champ
                      crossAxisAlignment: CrossAxisAlignment.start, // Aligne à gauche
                      children: [
                        const Padding( // Padding pour le label
                          padding: EdgeInsets.only(left: 8, bottom: 8), // 8px à gauche et en bas
                          child: Text( // Texte "EMAIL"
                            'EMAIL',
                            style: TextStyle(
                              color: kWhiteColor, // Couleur blanche
                              fontSize: 14, // Taille du texte
                              fontWeight: FontWeight.w600, // Gras
                              letterSpacing: 1, // Espacement entre lettres
                            ),
                          ),
                        ),
                        TextFormField( // Champ de texte
                          controller: _emailController, // Associe le contrôleur
                          keyboardType: TextInputType.emailAddress, // Clavier email (avec @)
                          style: const TextStyle( // Style du texte
                            color: Color(0xFF9CA3AF), // Couleur grise
                            fontSize: 16, // Taille
                          ),
                          decoration: InputDecoration( // Décoration
                            hintText: 'hello@reallygreatsite.com', // Placeholder
                            hintStyle: const TextStyle( // Style du placeholder
                              color: Color(0xFF9CA3AF), // Gris
                              fontSize: 16, // Taille
                            ),
                            filled: true, // Active le fond
                            fillColor: const Color(0xFFE5E7EB), // Fond gris clair
                            border: OutlineInputBorder( // Bordure
                              borderRadius: BorderRadius.circular(12), // Coins arrondis
                              borderSide: BorderSide.none, // Pas de bordure
                            ),
                            contentPadding: const EdgeInsets.symmetric( // Padding interne
                              horizontal: 20, // Horizontal
                              vertical: 18, // Vertical
                            ),
                          ),
                          validator: (value) { // Validation
                            if (value == null || value.isEmpty) { // Si vide
                              return 'Entrez votre email'; // Erreur
                            }
                            if (!value.contains('@')) { // Si pas de @
                              return 'Email invalide'; // Erreur
                            }
                            return null; // Pas d'erreur
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24), // Espace de 24px

                    // === CHAMP PASSWORD ===
                    Column( // Colonne pour label + champ
                      crossAxisAlignment: CrossAxisAlignment.start, // Aligne à gauche
                      children: [
                        const Padding( // Padding du label
                          padding: EdgeInsets.only(left: 8, bottom: 8), // Espacement
                          child: Text( // Label "MOT DE PASSE"
                            'MOT DE PASSE',
                            style: TextStyle(
                              color: kWhiteColor, // Blanc
                              fontSize: 14, // Taille
                              fontWeight: FontWeight.w600, // Gras
                              letterSpacing: 1, // Espacement lettres
                            ),
                          ),
                        ),
                        TextFormField( // Champ password
                          controller: _passwordController, // Contrôleur
                          obscureText: _obscurePassword, // Masque le texte si true
                          style: const TextStyle( // Style du texte
                            color: Color(0xFF9CA3AF), // Gris
                            fontSize: 16, // Taille
                          ),
                          decoration: InputDecoration( // Décoration
                            hintText: '••••••••••••', // Placeholder en points
                            hintStyle: const TextStyle( // Style placeholder
                              color: Color(0xFF9CA3AF), // Gris
                              fontSize: 16, // Taille
                            ),
                            filled: true, // Fond activé
                            fillColor: const Color(0xFFE5E7EB), // Fond gris clair
                            border: OutlineInputBorder( // Bordure
                              borderRadius: BorderRadius.circular(12), // Arrondi
                              borderSide: BorderSide.none, // Pas de bordure
                            ),
                            contentPadding: const EdgeInsets.symmetric( // Padding
                              horizontal: 20, // Horizontal
                              vertical: 18, // Vertical
                            ),
                            suffixIcon: IconButton( // Icône à droite du champ
                              icon: Icon(
                                _obscurePassword // Si masqué
                                    ? Icons.visibility_off // Icône œil barré
                                    : Icons.visibility, // Icône œil ouvert
                                color: const Color(0xFF9CA3AF), // Couleur grise
                              ),
                              onPressed: () { // Quand on clique sur l'icône
                                setState(() { // Change l'état du widget
                                  _obscurePassword = !_obscurePassword; // Inverse la valeur
                                });
                              },
                            ),
                          ),
                          validator: (value) { // Validation
                            if (value == null || value.isEmpty) { // Si vide
                              return 'Entrez un mot de passe'; // Erreur
                            }
                            if (value.length < 6) { // Si moins de 6 caractères
                              return 'Minimum 6 caractères'; // Erreur
                            }
                            return null; // Pas d'erreur
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 50), // Espace de 50px avant le bouton

                    // === BOUTON INSCRIPTION ===
                    SizedBox( // Container de taille fixe pour le bouton
                      width: double.infinity, // Prend toute la largeur
                      height: 60, // Hauteur de 60px
                      child: ElevatedButton( // Bouton élevé
                        onPressed: _handleRegister, // Appelle la fonction d'inscription
                        style: ElevatedButton.styleFrom( // Style du bouton
                          backgroundColor: const Color(0xFFD946EF), // Rose/magenta
                          foregroundColor: kWhiteColor, // Texte blanc
                          shape: RoundedRectangleBorder( // Forme du bouton
                            borderRadius: BorderRadius.circular(30), // Très arrondi
                          ),
                          elevation: 0, // Pas d'ombre
                        ),
                        child: const Text( // Texte du bouton
                          'Inscription',
                          style: TextStyle(
                            fontSize: 18, // Taille
                            fontWeight: FontWeight.w600, // Semi-gras
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24), // Espace de 24px

                    // === LIEN VERS CONNEXION ===
                    TextButton( // Bouton texte (pas de fond)
                      onPressed: () { // Quand on clique
                        Navigator.pop(context); // Retour à l'écran précédent
                        Navigator.pushNamed(context, '/login'); // Va vers l'écran de connexion
                      },
                      child: RichText( // Texte avec plusieurs styles
                        text: const TextSpan( // Texte principal
                          text: 'J\'ai déjà un compte.\n', // Première ligne
                          style: TextStyle(
                            color: kWhiteColor, // Blanc
                            fontSize: 15, // Taille
                          ),
                          children: [ // Enfants (texte avec style différent)
                            TextSpan(
                              text: 'Je me connecte !', // Deuxième ligne
                              style: TextStyle(
                                decoration: TextDecoration.underline, // Souligné
                                decorationColor: kWhiteColor, // Couleur soulignement
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center, // Centré
                      ),
                    ),

                    const SizedBox(height: 40), // Espace de 40px en bas
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