import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:push_data_firestore/data/users.dart' as data;
import 'package:push_data_firestore/data/groupes.dart' as data;
import 'package:push_data_firestore/data/sessions.dart' as data;
import 'package:push_data_firestore/styles/spacings.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _logs = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Clé = email du user, Valeur = UID Firebase
  final Map<String, String> _userIdMapping = {};

  void _addLog(String message) {
    setState(() {
      _logs.insert(0, "${DateTime.now().toString().substring(11, 19)} - $message");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Seeder Brainova",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                "Génère ou supprime les données de test",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _logs.isEmpty
                      ? const Center(
                    child: Text(
                      "Logs d'opérations...",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                      : ListView.builder(
                    itemCount: _logs.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        _logs[index],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: "delete",
              onPressed: deleteCollections,
              backgroundColor: Colors.red,
              label: const Row(
                children: [
                  Icon(Icons.delete_forever),
                  SizedBox(width: kHorizontalPaddingS),
                  Text("Supprimer les données"),
                ],
              ),
            ),
            FloatingActionButton.extended(
              heroTag: "generate",
              onPressed: () async {
                // ORDRE IMPORTANT : d'abord users, puis groupes, puis sessions
                await addUsers();  
                await addGroupes();  // Utilise _userIdMapping
                await addSessions(); // Utilise _userIdMapping
              },
              label: const Row(
                children: [
                  Icon(Icons.published_with_changes),
                  SizedBox(width: kHorizontalPaddingS),
                  Text("Générer les données"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> deleteCollections() async {
    _addLog("Début de la suppression...");

    try {
      // Supprimer les sessions de chaque groupe
      final groupesSnapshot = await _firestore.collection('groupes').get();
      for (final groupeDoc in groupesSnapshot.docs) {
        final sessionsSnapshot = await groupeDoc.reference.collection('sessions').get();
        for (final sessionDoc in sessionsSnapshot.docs) {
          await sessionDoc.reference.delete();
          _addLog("Session supprimée");
        }
        await groupeDoc.reference.delete();
        _addLog("Groupe supprimé");
      }

      // Supprimer les users dans Firestore
      final usersSnapshot = await _firestore.collection('users').get();
      for (final userDoc in usersSnapshot.docs) {
        await userDoc.reference.delete();
        _addLog("User supprimé dans Firestore");
      }


      _addLog(" N'oublie pas de supprimer les users dans Firebase Auth (console)");

      _addLog("Toutes les données Firestore ont été supprimées");
    } catch (e) {
      _addLog("Erreur: $e");
    }
  }

  Future<void> addUsers() async {
    _addLog("Ajout des utilisateurs...");
    _userIdMapping.clear(); // Vider la map au début

    for (final user in data.users) {
      try {
        // 1. Créer ou récupérer l'utilisateur dans Firebase Auth
        UserCredential userCredential;
        try {
          userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: user.email,
            password: "123456789",
          );
          _addLog("User créé dans Auth: ${user.email}");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: user.email,
              password: "123456789",
            );
            _addLog("User existe déjà dans Auth: ${user.email}");
          } else {
            throw e;
          }
        }

        // 2. Récupérer l'UID Firebase
        final uid = userCredential.user!.uid;
        
        _userIdMapping[user.email] = uid;

        // 3. Créer le document Firestore avec l'UID comme ID
        await _firestore.collection('users').doc(uid).set({
          'email': user.email,
          'nom': user.nom,
          'prenom': user.prenom,
          'createdAt': user.createdAt,
        });
        
        _addLog("User dans Firestore: ${user.prenom} ${user.nom}");
        
      } catch (e) {
        _addLog("Erreur user: $e");
      }
    }
    
    // Se déconnecter après avoir créé tous les users
    await FirebaseAuth.instance.signOut();
    _addLog("${_userIdMapping.length} users créés");
  }

  Future<void> addGroupes() async {
    _addLog("Ajout des groupes...");

    for (int i = 0; i < data.groupes.length; i++) {
      final groupe = data.groupes[i];
      
      try {
        final creatorEmail = data.users[i].email; // Chaque groupe créé par un user différent
        final creatorUid = _userIdMapping[creatorEmail];
        
        if (creatorUid == null) {
          _addLog("Erreur: UID introuvable pour $creatorEmail");
          continue;
        }

        // Créer le groupe avec le bon UID
        await _firestore.collection('groupes').add({
          'nom': groupe.nom,
          'description': groupe.description,
          'code': groupe.code,
          'couleur': groupe.couleur,
          'creatorId': creatorUid,
          'memberIds': [creatorUid],  
          'createdAt': groupe.createdAt,
        });
        
        _addLog("Groupe créé: ${groupe.nom} (créateur: ${data.users[i].prenom})");
        
      } catch (e) {
        _addLog("Erreur groupe: $e");
      }
    }
  }

  Future<void> addSessions() async {
    _addLog("Ajout des sessions...");

    // Récupérer les groupes créés
    final groupesSnapshot = await _firestore.collection('groupes').get();

    if (groupesSnapshot.docs.length < 3) {
      _addLog("Erreur: pas assez de groupes créés");
      return;
    }

    // Associer 2 sessions à chaque groupe
    for (int i = 0; i < groupesSnapshot.docs.length; i++) {
      final groupeDoc = groupesSnapshot.docs[i];
      final groupeId = groupeDoc.id;

      // Prendre 2 sessions pour ce groupe
      final sessionsForGroupe = data.sessions.skip(i * 2).take(2);

      for (final session in sessionsForGroupe) {
        try {
          final groupeData = groupeDoc.data() as Map<String, dynamic>;
          final creatorUid = groupeData['creatorId'] as String;

          await _firestore
              .collection('groupes')
              .doc(groupeId)
              .collection('sessions')
              .add({
            'titre': session.titre,
            'date': session.date,
            'dureeMinutes': session.dureeMinutes,
            'dureePrevueMinutes': session.dureeMinutes, 
            'dureeSecondes': 0,
            'participantIds': [creatorUid], //  Seulement le créateur
            'statut': session.statut,
            'createdAt': session.createdAt,
            'isTermine': false,
          });
          
          _addLog("Session ajoutée: ${session.titre}");
          
        } catch (e) {
          _addLog("Erreur session: $e");
        }
      }
    }

    _addLog("🎉 Toutes les données ont été créées !");
  }
}