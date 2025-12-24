import 'package:brainova/models/session.dart';
import 'package:brainova/data/users.dart';
import 'package:brainova/data/groupes.dart';

// Liste des sessions de test
List<Session> sessions = [
  // Sessions pour Physique Avancée (groupe 0)
  Session(
    id: generateId(),
    groupeId: groupes[0].id,
    userId: users[0].id,
    userNom: '${users[0].prenom} ${users[0].nom}',
    matiere: 'Physique quantique',
    dureeMinutes: 420, // 7h
    date: DateTime(2024, 12, 20),
    note: 'Révision des équations de Schrödinger',
    createdAt: DateTime(2024, 12, 20),
  ),
  Session(
    id: generateId(),
    groupeId: groupes[0].id,
    userId: users[1].id,
    userNom: '${users[1].prenom} ${users[1].nom}',
    matiere: 'Thermodynamique',
    dureeMinutes: 360, // 6h
    date: DateTime(2024, 12, 21),
    note: 'Étude des lois de la thermodynamique',
    createdAt: DateTime(2024, 12, 21),
  ),
  Session(
    id: generateId(),
    groupeId: groupes[0].id,
    userId: users[2].id,
    userNom: '${users[2].prenom} ${users[2].nom}',
    matiere: 'Mécanique quantique',
    dureeMinutes: 300, // 5h
    date: DateTime(2024, 12, 22),
    createdAt: DateTime(2024, 12, 22),
  ),
  Session(
    id: generateId(),
    groupeId: groupes[0].id,
    userId: users[3].id,
    userNom: '${users[3].prenom} ${users[3].nom}',
    matiere: 'Physique nucléaire',
    dureeMinutes: 240, // 4h
    date: DateTime(2024, 12, 22),
    createdAt: DateTime(2024, 12, 22),
  ),
  Session(
    id: generateId(),
    groupeId: groupes[0].id,
    userId: users[0].id,
    userNom: '${users[0].prenom} ${users[0].nom}',
    matiere: 'Révision - Examen final de physique',
    dureeMinutes: 45,
    date: DateTime(2024, 12, 23),
    note: 'Préparation intensive examen',
    createdAt: DateTime(2024, 12, 23),
  ),

  // Sessions pour Mathématiques (groupe 1)
  Session(
    id: generateId(),
    groupeId: groupes[1].id,
    userId: users[0].id,
    userNom: '${users[0].prenom} ${users[0].nom}',
    matiere: 'Calcul intégral',
    dureeMinutes: 180, // 3h
    date: DateTime(2024, 12, 20),
    note: 'Intégrales définies et indéfinies',
    createdAt: DateTime(2024, 12, 20),
  ),
  Session(
    id: generateId(),
    groupeId: groupes[1].id,
    userId: users[1].id,
    userNom: '${users[1].prenom} ${users[1].nom}',
    matiere: 'Calcul intégral',
    dureeMinutes: 120, // 2h
    date: DateTime(2024, 12, 20),
    createdAt: DateTime(2024, 12, 20),
  ),
  Session(
    id: generateId(),
    groupeId: groupes[1].id,
    userId: users[2].id,
    userNom: '${users[2].prenom} ${users[2].nom}',
    matiere: 'Analyse mathématique',
    dureeMinutes: 150, // 2h30
    date: DateTime(2024, 12, 21),
    createdAt: DateTime(2024, 12, 21),
  ),

  // Sessions pour Chimie (groupe 2)
  Session(
    id: generateId(),
    groupeId: groupes[2].id,
    userId: users[1].id,
    userNom: '${users[1].prenom} ${users[1].nom}',
    matiere: 'Chimie organique',
    dureeMinutes: 90,
    date: DateTime(2024, 12, 18),
    note: 'Révision nomenclature',
    createdAt: DateTime(2024, 12, 18),
  ),
  Session(
    id: generateId(),
    groupeId: groupes[2].id,
    userId: users[2].id,
    userNom: '${users[2].prenom} ${users[2].nom}',
    matiere: 'Réactions chimiques',
    dureeMinutes: 75,
    date: DateTime(2024, 12, 19),
    createdAt: DateTime(2024, 12, 19),
  ),
];