import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:push_data_firestore/data/users.dart';
import 'package:push_data_firestore/data/groupes.dart';
import 'package:push_data_firestore/data/sessions.dart';
import 'package:push_data_firestore/styles/spacings.dart';
import 'package:dto/dto.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _logs = [];
  late final FirestoreODM odm;

  @override
  void initState() {
    super.initState();
    odm = FirestoreODM(appSchema, firestore: FirebaseFirestore.instance);
  }

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
                "🚀 Seeder Brainova",
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
                await authenticate();
                await addUsers();
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
    _addLog("🗑️ Début de la suppression...");

    try {
      final allUsers = await odm.users.get();
      final allGroupes = await odm.groupes.get();

      for (final groupe in allGroupes) {
        final sessions = await odm.groupes(groupe.id).sessions.get();
        for (final session in sessions) {
          await odm.groupes(groupe.id).sessions(session.id).delete();
          _addLog("❌ Session supprimée: ${session.titre}");
        }
        await odm.groupes(groupe.id).delete();
        _addLog("❌ Groupe supprimé: ${groupe.nom}");
      }

      for (final user in allUsers) {
        await odm.users(user.id).delete();
        _addLog("❌ User supprimé: ${user.prenom} ${user.nom}");
      }

      _addLog("✅ Toutes les données ont été supprimées");
    } catch (e) {
      _addLog("❌ Erreur: $e");
    }
  }

  Future<void> authenticate() async {
    _addLog("🔐 Authentification des utilisateurs...");
    
    for (final user in users) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email,
          password: "123456789",
        );
        _addLog("✅ User créé: ${user.email}");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          _addLog("ℹ️ User existe déjà: ${user.email}");
        } else {
          _addLog("❌ Erreur auth: ${e.message}");
        }
      }
    }
  }

  Future<void> addUsers() async {
    _addLog("👤 Ajout des utilisateurs...");

    for (final user in users) {
      try {
        await odm.users.insert(user);
        _addLog("✅ User ajouté: ${user.prenom} ${user.nom}");
      } catch (e) {
        _addLog("❌ Erreur user: $e");
      }
    }
  }

  Future<void> addGroupes() async {
    _addLog("👥 Ajout des groupes...");

    for (final groupe in groupes) {
      try {
        await odm.groupes.insert(groupe);
        _addLog("✅ Groupe ajouté: ${groupe.nom}");
      } catch (e) {
        _addLog("❌ Erreur groupe: $e");
      }
    }
  }

  Future<void> addSessions() async {
    _addLog("📅 Ajout des sessions...");

    final sessionsByGroupe = getSessionsByGroupe();

    for (final entry in sessionsByGroupe.entries) {
      final groupeId = entry.key;
      final groupeSessions = entry.value;

      for (final session in groupeSessions) {
        try {
          await odm.groupes(groupeId).sessions.insert(session);
          _addLog("✅ Session ajoutée: ${session.titre}");
        } catch (e) {
          _addLog("❌ Erreur session: $e");
        }
      }
    }

    _addLog("🎉 Toutes les données ont été créées !");
  }
}
