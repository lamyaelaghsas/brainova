import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  const factory Session({
    @DocumentIdField() String? id,
    required String groupeId,
    required String userId,
    required String userNom,
    required String matiere,
    required int dureeMinutes,
    required DateTime date,
    String? note,
    required DateTime createdAt,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
}