import 'package:dto/models/groupe.dart';
import 'package:push_data_firestore/data/users.dart';

String generateId() {
  final now = DateTime.now().microsecondsSinceEpoch;
  final random = DateTime.now().millisecondsSinceEpoch.remainder(1000000);
  return '${now.toRadixString(36)}${random.toRadixString(36)}';
}

final List<Groupe> groupes = [
  Groupe(
    id: generateId(),
    nom: "Groupe Flutter",
    description: "Projets et exercices Flutter",
    code: "FL7K2X",
    couleur: "#FFD700",
    creatorId: users[0].id,
    memberIds: [users[0].id],  
    createdAt: DateTime.now(),
  ),
  Groupe(
    id: generateId(),
    nom: "Révisions Maths",
    description: "Physique quantique et thermodynamique",
    code: "MA9P4L",
    couleur: "#9B59B6",
    creatorId: users[1].id,
    memberIds: [users[1].id],  
    createdAt: DateTime.now(),
  ),
  Groupe(
    id: generateId(),
    nom: "Projet Web",
    description: "HTML, CSS, JavaScript avancé",
    code: "WB5H8N",
    couleur: "#E91E63",
    creatorId: users[2].id,
    memberIds: [users[2].id],  
    createdAt: DateTime.now(),
  ),
];