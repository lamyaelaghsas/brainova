// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
      id: json['id'] as String,
      titre: json['titre'] as String,
      date:
          const FirestoreTimestampConverter().fromJson(json['date'] as Object),
      dureeMinutes: (json['dureeMinutes'] as num).toInt(),
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      statut: json['statut'] as String,
      createdAt: const FirestoreTimestampConverter()
          .fromJson(json['createdAt'] as Object),
    );

const _$SessionFieldMap = <String, String>{
  'id': 'id',
  'titre': 'titre',
  'date': 'date',
  'dureeMinutes': 'dureeMinutes',
  'participantIds': 'participantIds',
  'statut': 'statut',
  'createdAt': 'createdAt',
};

// ignore: unused_element
abstract class _$SessionPerFieldToJson {
  // ignore: unused_element
  static Object? id(String instance) => instance;
  // ignore: unused_element
  static Object? titre(String instance) => instance;
  // ignore: unused_element
  static Object? date(DateTime instance) =>
      const FirestoreTimestampConverter().toJson(instance);
  // ignore: unused_element
  static Object? dureeMinutes(int instance) => instance;
  // ignore: unused_element
  static Object? participantIds(List<String> instance) => instance;
  // ignore: unused_element
  static Object? statut(String instance) => instance;
  // ignore: unused_element
  static Object? createdAt(DateTime instance) =>
      const FirestoreTimestampConverter().toJson(instance);
}

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
      'date': const FirestoreTimestampConverter().toJson(instance.date),
      'dureeMinutes': instance.dureeMinutes,
      'participantIds': instance.participantIds,
      'statut': instance.statut,
      'createdAt':
          const FirestoreTimestampConverter().toJson(instance.createdAt),
    };
