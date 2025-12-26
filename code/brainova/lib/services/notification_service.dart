import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service pour gérer les notifications dans l'app
class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Notifier tous les membres d'un groupe qu'une nouvelle session a été créée
  static Future<void> notifyNewSession({
    required String groupeId,
    required String sessionId,
    required String sujet,
    required String creatorId,
  }) async {
    try {
      // Récupérer les infos du groupe
      final groupeDoc = await _firestore.collection('groupes').doc(groupeId).get();
      if (!groupeDoc.exists) return;

      final groupeData = groupeDoc.data()!;
      final groupeName = groupeData['nom'] ?? 'un groupe';
      final memberIds = List<String>.from(groupeData['memberIds'] ?? []);

      // Récupérer les infos du créateur
      final creatorDoc = await _firestore.collection('users').doc(creatorId).get();
      final creatorData = creatorDoc.data();
      final creatorName = creatorData != null
          ? '${creatorData['prenom']} ${creatorData['nom']}'
          : 'Un membre';

      // Créer une notification pour chaque membre (sauf le créateur)
      for (final memberId in memberIds) {
        if (memberId == creatorId) continue; // Pas de notif pour soi-même

        await _firestore.collection('notifications').add({
          'userId': memberId,
          'type': 'nouvelle_session',
          'title': 'Nouvelle session "$sujet" créée',
          'message': '$creatorName a créé une session dans $groupeName',
          'groupeId': groupeId,
          'sessionId': sessionId,
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      }
    } catch (e) {
      print('Erreur lors de la création des notifications: $e');
    }
  }

  /// Notifier tous les membres d'un groupe qu'une session est en cours
  static Future<void> notifySessionEnCours({
    required String groupeId,
    required String sessionId,
    required String sujet,
    required String userId,
  }) async {
    try {
      // Récupérer les infos du groupe
      final groupeDoc = await _firestore.collection('groupes').doc(groupeId).get();
      if (!groupeDoc.exists) return;

      final groupeData = groupeDoc.data()!;
      final groupeName = groupeData['nom'] ?? 'un groupe';
      final memberIds = List<String>.from(groupeData['memberIds'] ?? []);

      // Récupérer les infos de l'utilisateur qui lance la session
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();
      final userName = userData != null
          ? '${userData['prenom']} ${userData['nom']}'
          : 'Un membre';

      // Créer une notification pour chaque membre (sauf celui qui lance)
      for (final memberId in memberIds) {
        if (memberId == userId) continue; // Pas de notif pour soi-même

        await _firestore.collection('notifications').add({
          'userId': memberId,
          'type': 'session_en_cours',
          'title': 'Session "$sujet" en cours',
          'message': '$userName a démarré une session dans $groupeName',
          'groupeId': groupeId,
          'sessionId': sessionId,
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      }
    } catch (e) {
      print('Erreur lors de la création des notifications: $e');
    }
  }

  /// Notifier tous les membres d'un groupe qu'un nouveau membre a rejoint
  static Future<void> notifyMembreRejoint({
    required String groupeId,
    required String newMemberId,
  }) async {
    try {
      // Récupérer les infos du groupe
      final groupeDoc = await _firestore.collection('groupes').doc(groupeId).get();
      if (!groupeDoc.exists) return;

      final groupeData = groupeDoc.data()!;
      final groupeName = groupeData['nom'] ?? 'un groupe';
      final memberIds = List<String>.from(groupeData['memberIds'] ?? []);

      // Récupérer les infos du nouveau membre
      final newMemberDoc = await _firestore.collection('users').doc(newMemberId).get();
      final newMemberData = newMemberDoc.data();
      final newMemberName = newMemberData != null
          ? '${newMemberData['prenom']} ${newMemberData['nom']}'
          : 'Un nouveau membre';

      // Créer une notification pour chaque membre (sauf le nouveau)
      for (final memberId in memberIds) {
        if (memberId == newMemberId) continue; // Pas de notif pour le nouveau membre

        await _firestore.collection('notifications').add({
          'userId': memberId,
          'type': 'membre_rejoint',
          'title': '$newMemberName a rejoint $groupeName',
          'message': 'Votre groupe compte maintenant ${memberIds.length} membres',
          'groupeId': groupeId,
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      }
    } catch (e) {
      print('Erreur lors de la création des notifications: $e');
    }
  }

  /// Marquer toutes les notifications comme lues pour l'utilisateur actuel
  static Future<void> markAllAsRead() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final unreadNotifs = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      for (final doc in unreadNotifs.docs) {
        await doc.reference.update({'isRead': true});
      }
    } catch (e) {
      print('Erreur lors du marquage des notifications: $e');
    }
  }

  /// Supprimer toutes les notifications pour l'utilisateur actuel
  static Future<void> deleteAll() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final notifs = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in notifs.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Erreur lors de la suppression des notifications: $e');
    }
  }
}