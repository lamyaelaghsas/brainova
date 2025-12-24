// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Groupe _$GroupeFromJson(Map<String, dynamic> json) => _Groupe(
      id: json['id'] as String,
      nom: json['nom'] as String,
      description: json['description'] as String,
      code: json['code'] as String,
      couleur: json['couleur'] as String,
      creatorId: json['creatorId'] as String,
      memberIds:
          (json['memberIds'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt:
          const FirestoreTimestampConverter().fromJson(json['createdAt']),
    );

const _$GroupeFieldMap = <String, String>{
  'id': 'id',
  'nom': 'nom',
  'description': 'description',
  'code': 'code',
  'couleur': 'couleur',
  'creatorId': 'creatorId',
  'memberIds': 'memberIds',
  'createdAt': 'createdAt',
};

// ignore: unused_element
abstract class _$GroupePerFieldToJson {
  // ignore: unused_element
  static Object? id(String instance) => instance;
  // ignore: unused_element
  static Object? nom(String instance) => instance;
  // ignore: unused_element
  static Object? description(String instance) => instance;
  // ignore: unused_element
  static Object? code(String instance) => instance;
  // ignore: unused_element
  static Object? couleur(String instance) => instance;
  // ignore: unused_element
  static Object? creatorId(String instance) => instance;
  // ignore: unused_element
  static Object? memberIds(List<String> instance) => instance;
  // ignore: unused_element
  static Object? createdAt(DateTime instance) =>
      const FirestoreTimestampConverter().toJson(instance);
}

Map<String, dynamic> _$GroupeToJson(_Groupe instance) => <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'description': instance.description,
      'code': instance.code,
      'couleur': instance.couleur,
      'creatorId': instance.creatorId,
      'memberIds': instance.memberIds,
      'createdAt':
          const FirestoreTimestampConverter().toJson(instance.createdAt),
    };
