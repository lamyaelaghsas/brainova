import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service pour gérer les notifications dans l'app
class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> notifyNewSession({
    required String groupeId,
    required String sessionId,
    required String sujet,
    required String creatorId,
  }) async {
    try {
      final groupeDoc = await _firestore.collection('groupes').doc(groupeId).get();
      if (!groupeDoc.exists) return;

      final groupeData = groupeDoc.data()!;
      final groupeName = groupeData['nom'] ?? 'un groupe';
      final memberIds = List<String>.from(groupeData['memberIds'] ?? []);

      final creatorDoc = await _firestore.collection('users').doc(creatorId).get();
      final creatorData = creatorDoc.data();
      final creatorName = creatorData != null
          ? '${creatorData['prenom']} ${creatorData['nom']}'
          : 'Un membre';

      for (final memberId in memberIds) {
        if (memberId == creatorId) continue;

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
      print('Erreur: $e');
    }
  }

  static Future<void> notifySessionEnCours({
    required String groupeId,
    required String sessionId,
    required String sujet,
    required String userId,
  }) async {
    try {
      final groupeDoc = await _firestore.collection('groupes').doc(groupeId).get();
      if (!groupeDoc.exists) return;

      final groupeData = groupeDoc.data()!;
      final groupeName = groupeData['nom'] ?? 'un groupe';
      final memberIds = List<String>.from(groupeData['memberIds'] ?? []);

      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();
      final userName = userData != null
          ? '${userData['prenom']} ${userData['nom']}'
          : 'Un membre';

      for (final memberId in memberIds) {
        if (memberId == userId) continue;

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
      print('Erreur: $e');
    }
  }

  static Future<void> notifyMembreRejoint({
    required String groupeId,
    required String newMemberId,
  }) async {
    try {
      final groupeDoc = await _firestore.collection('groupes').doc(groupeId).get();
      if (!groupeDoc.exists) return;

      final groupeData = groupeDoc.data()!;
      final groupeName = groupeData['nom'] ?? 'un groupe';
      final memberIds = List<String>.from(groupeData['memberIds'] ?? []);

      final newMemberDoc = await _firestore.collection('users').doc(newMemberId).get();
      final newMemberData = newMemberDoc.data();
      final newMemberName = newMemberData != null
          ? '${newMemberData['prenom']} ${newMemberData['nom']}'
          : 'Un nouveau membre';

      for (final memberId in memberIds) {
        if (memberId == newMemberId) continue;

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
      print('Erreur: $e');
    }
  }

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
      print('Erreur: $e');
    }
  }

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
      print('Erreur: $e');
    }
  }
}