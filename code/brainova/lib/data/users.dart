import 'package:brainova/models/user.dart';

// Fonction pour générer un ID unique (comme le prof)
String generateId() {
  final now = DateTime.now().microsecondsSinceEpoch;
  final random = DateTime.now().millisecondsSinceEpoch.remainder(1000000);
  return '${now.toRadixString(36)}${random.toRadixString(36)}';
}

// Liste des utilisateurs de test
List<User> users = [
  User(
    id: generateId(),
    email: 'sophie.martin@email.com',
    nom: 'Martin',
    prenom: 'Sophie',
    groupes: [], // Sera rempli après création des groupes
  ),
  User(
    id: generateId(),
    email: 'lucas.bernard@email.com',
    nom: 'Bernard',
    prenom: 'Lucas',
    groupes: [],
  ),
  User(
    id: generateId(),
    email: 'emma.dubois@email.com',
    nom: 'Dubois',
    prenom: 'Emma',
    groupes: [],
  ),
  User(
    id: generateId(),
    email: 'thomas.petit@email.com',
    nom: 'Petit',
    prenom: 'Thomas',
    groupes: [],
  ),
  User(
    id: generateId(),
    email: 'lea.moreau@email.com',
    nom: 'Moreau',
    prenom: 'Léa',
    groupes: [],
  ),
];