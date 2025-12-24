import 'package:brainova/models/groupe.dart';
import 'package:brainova/data/users.dart';

// Liste des groupes de test
List<Groupe> groupes = [
  Groupe(
    id: generateId(),
    nom: 'Physique Avancée 2024',
    code: 'PHYS2024',
    membres: [
      users[0].id, // Sophie
      users[1].id, // Lucas
      users[2].id, // Emma
      users[3].id, // Thomas
      users[4].id, // Léa
    ],
    createdAt: DateTime(2024, 9, 1),
  ),
  Groupe(
    id: generateId(),
    nom: 'Mathématiques - Calcul intégral',
    code: 'MATH2024',
    membres: [
      users[0].id, // Sophie
      users[1].id, // Lucas
      users[2].id, // Emma
      users[3].id, // Thomas
    ],
    createdAt: DateTime(2024, 9, 5),
  ),
  Groupe(
    id: generateId(),
    nom: 'Révision Chimie',
    code: 'CHEM2024',
    membres: [
      users[1].id, // Lucas
      users[2].id, // Emma
      users[4].id, // Léa
    ],
    createdAt: DateTime(2024, 10, 1),
  ),
];