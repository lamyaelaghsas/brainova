import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dto/models/groupe.dart';
import 'package:dto/models/user.dart' as dto;

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

      print('GroupeDoc data: ${groupeDoc.data()}');

      // Utiliser le DTO
      final groupe = Groupe.fromJson({
        'id': groupeDoc.id,
        ...groupeDoc.data()!,
      });

      // Récupérer les infos du créateur
      final creatorDoc = await _firestore.collection('users').doc(creatorId).get();
      
      print('CreatorDoc data: ${creatorDoc.data()}');
      
      final creator = creatorDoc.exists 
          ? dto.User.fromJson({
              'id': creatorDoc.id,
              ...creatorDoc.data()!,
            })
          : null;
      
      final creatorName = creator != null
          ? '${creator.prenom} ${creator.nom}'
          : 'Un membre';

      // Créer une notification pour chaque membre (sauf le créateur)
      for (final memberId in groupe.memberIds) {
        if (memberId == creatorId) continue;

        await _firestore.collection('notifications').add({
          'userId': memberId,
          'type': 'nouvelle_session',
          'title': 'Nouvelle session "$sujet" créée',
          'message': '$creatorName a créé une session dans ${groupe.nom}',
          'groupeId': groupeId,
          'sessionId': sessionId,
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      }
    } catch (e, stackTrace) {
      print('Erreur lors de la création des notifications: $e');
      print('StackTrace: $stackTrace');
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
      final groupeDoc = await _firestore.collection('groupes').doc(groupeId).get();
      if (!groupeDoc.exists) return;

      // Utiliser le DTO
      final groupe = Groupe.fromJson({
        'id': groupeDoc.id,
        ...groupeDoc.data()!,
      });

      // Récupérer les infos de l'utilisateur qui lance la session
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final user = userDoc.exists 
          ? dto.User.fromJson({
              'id': userDoc.id,
              ...userDoc.data()!,
            })
          : null;
      
      final userName = user != null
          ? '${user.prenom} ${user.nom}'
          : 'Un membre';

      // Créer une notification pour chaque membre (sauf celui qui lance)
      for (final memberId in groupe.memberIds) {
        if (memberId == userId) continue;

        await _firestore.collection('notifications').add({
          'userId': memberId,
          'type': 'session_en_cours',
          'title': 'Session "$sujet" en cours',
          'message': '$userName a démarré une session dans ${groupe.nom}',
          'groupeId': groupeId,
          'sessionId': sessionId,
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      }
    } catch (e, stackTrace) {
      print('Erreur lors de la création des notifications: $e');
      print('StackTrace: $stackTrace');
    }
  }

  /// Notifier tous les membres d'un groupe qu'un nouveau membre a rejoint
  static Future<void> notifyMembreRejoint({
    required String groupeId,
    required String newMemberId,
  }) async {
    try {
      final groupeDoc = await _firestore.collection('groupes').doc(groupeId).get();
      if (!groupeDoc.exists) return;

      // Utiliser le DTO
      final groupe = Groupe.fromJson({
        'id': groupeDoc.id,
        ...groupeDoc.data()!,
      });

      // Récupérer les infos du nouveau membre
      final newMemberDoc = await _firestore.collection('users').doc(newMemberId).get();
      final newMember = newMemberDoc.exists
          ? dto.User.fromJson({
              'id': newMemberDoc.id,
              ...newMemberDoc.data()!,
            })
          : null;
      
      final newMemberName = newMember != null
          ? '${newMember.prenom} ${newMember.nom}'
          : 'Un nouveau membre';

      // Créer une notification pour chaque membre (sauf le nouveau)
      for (final memberId in groupe.memberIds) {
        if (memberId == newMemberId) continue;

        await _firestore.collection('notifications').add({
          'userId': memberId,
          'type': 'membre_rejoint',
          'title': '$newMemberName a rejoint ${groupe.nom}',
          'message': 'Votre groupe compte maintenant ${groupe.memberIds.length} membres',
          'groupeId': groupeId,
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      }
    } catch (e, stackTrace) {
      print('Erreur lors de la création des notifications: $e');
      print('StackTrace: $stackTrace');
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