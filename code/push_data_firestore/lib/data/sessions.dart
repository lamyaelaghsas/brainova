import 'package:dto/models/session.dart';
import 'package:push_data_firestore/data/groupes.dart';
import 'package:push_data_firestore/data/users.dart';

String generateId() {
  final now = DateTime.now().microsecondsSinceEpoch;
  final random = DateTime.now().millisecondsSinceEpoch.remainder(1000000);
  return '${now.toRadixString(36)}${random.toRadixString(36)}';
}

final List<Session> sessions = [
  Session(
    id: generateId(),
    titre: "Widgets Flutter - Bases",
    date: DateTime(2024, 12, 20, 14, 30),
    dureeMinutes: 120,
    participantIds: [users[0].id, users[1].id, users[2].id],
    statut: "terminee",
    createdAt: DateTime.now(),
  ),
  Session(
    id: generateId(),
    titre: "State Management avec Provider",
    date: DateTime(2024, 12, 23, 10, 0),
    dureeMinutes: 180,
    participantIds: [users[0].id, users[1].id, users[3].id],
    statut: "terminee",
    createdAt: DateTime.now(),
  ),
  Session(
    id: generateId(),
    titre: "Mathématiques - Calcul intégral",
    date: DateTime(2024, 12, 20, 14, 0),
    dureeMinutes: 120,
    participantIds: [users[1].id, users[2].id],
    statut: "terminee",
    createdAt: DateTime.now(),
  ),
  Session(
    id: generateId(),
    titre: "Physique - Mécanique quantique",
    date: DateTime(2024, 12, 18, 13, 0),
    dureeMinutes: 90,
    participantIds: [users[1].id],
    statut: "terminee",
    createdAt: DateTime.now(),
  ),
  Session(
    id: generateId(),
    titre: "HTML & CSS Avancé",
    date: DateTime(2024, 12, 22, 16, 0),
    dureeMinutes: 150,
    participantIds: [users[2].id, users[3].id, users[0].id],
    statut: "terminee",
    createdAt: DateTime.now(),
  ),
  Session(
    id: generateId(),
    titre: "JavaScript - Async/Await",
    date: DateTime(2024, 12, 25, 10, 30),
    dureeMinutes: 120,
    participantIds: [users[2].id, users[0].id],
    statut: "en_cours",
    createdAt: DateTime.now(),
  ),
];

Map<String, List<Session>> getSessionsByGroupe() {
  return {
    groupes[0].id: [sessions[0], sessions[1]],
    groupes[1].id: [sessions[2], sessions[3]],
    groupes[2].id: [sessions[4], sessions[5]],
  };
}
