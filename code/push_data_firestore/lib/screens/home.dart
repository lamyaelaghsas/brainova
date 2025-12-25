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
                await addUsers();  // Auth + Firestore en même temps
                await addGroupes();
                await addSessions();
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

      // Supprimer les users
      final usersSnapshot = await _firestore.collection('users').get();
      for (final userDoc in usersSnapshot.docs) {
        await userDoc.reference.delete();
        _addLog("User supprimé");
      }

      _addLog("Toutes les données ont été supprimées");
    } catch (e) {
      _addLog("Erreur: $e");
    }
  }

  Future<void> addUsers() async {
    _addLog("Ajout des utilisateurs...");

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
            // Si l'user existe déjà, se connecter pour récupérer l'UID
            userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: user.email,
              password: "123456789",
            );
            _addLog("User existe déjà dans Auth: ${user.email}");
          } else {
            throw e;
          }
        }

        // 2. Utiliser l'UID Firebase comme ID du document Firestore
        final uid = userCredential.user!.uid;
        await _firestore.collection('users').doc(uid).set(user.toJson());
        _addLog("User ajouté dans Firestore: ${user.prenom} ${user.nom} (UID: ${uid.substring(0, 8)}...)");
        
      } catch (e) {
        _addLog("Erreur user: $e");
      }
    }
    
    // Se déconnecter après avoir créé tous les users
    await FirebaseAuth.instance.signOut();
  }

  Future<void> addGroupes() async {
    _addLog("Ajout des groupes...");

    for (final groupe in data.groupes) {
      try {
        await _firestore.collection('groupes').add(groupe.toJson());
        _addLog("Groupe ajouté: ${groupe.nom}");
      } catch (e) {
        _addLog("Erreur groupe: $e");
      }
    }
  }

  Future<void> addSessions() async {
    _addLog("Ajout des sessions...");

    // On doit d'abord récupérer les IDs des groupes créés
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
          await _firestore
              .collection('groupes')
              .doc(groupeId)
              .collection('sessions')
              .add(session.toJson());
          _addLog("Session ajoutée: ${session.titre}");
        } catch (e) {
          _addLog("Erreur session: $e");
        }
      }
    }

    _addLog("🎉 Toutes les données ont été créées !");
  }
}