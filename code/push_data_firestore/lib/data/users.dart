import 'package:dto/models/user.dart';

String generateId() {
  final now = DateTime.now().microsecondsSinceEpoch;
  final random = DateTime.now().millisecondsSinceEpoch.remainder(1000000);
  return '${now.toRadixString(36)}${random.toRadixString(36)}';
}

final List<User> users = [
  User(
    id: generateId(),
    email: "marie.dupont@student.be",
    nom: "Dupont",
    prenom: "Marie",
    createdAt: DateTime.now(),
  ),
  User(
    id: generateId(),
    email: "lucas.bernard@student.be",
    nom: "Bernard",
    prenom: "Lucas",
    createdAt: DateTime.now(),
  ),
  User(
    id: generateId(),
    email: "sophie.martin@student.be",
    nom: "Martin",
    prenom: "Sophie",
    createdAt: DateTime.now(),
  ),
  User(
    id: generateId(),
    email: "thomas.petit@student.be",
    nom: "Petit",
    prenom: "Thomas",
    createdAt: DateTime.now(),
  ),
];
