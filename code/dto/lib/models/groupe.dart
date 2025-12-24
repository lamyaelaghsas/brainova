import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'groupe.freezed.dart';
part 'groupe.g.dart';

@freezed
class Groupe with _$Groupe {
  const factory Groupe({
    @DocumentIdField() String? id,
    required String nom,
    required String code,
    @Default([]) List<String> membres,
    required DateTime createdAt,
  }) = _Groupe;

  factory Groupe.fromJson(Map<String, dynamic> json) => _$GroupeFromJson(json);
}