// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
      id: json['id'] as String,
      email: json['email'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      createdAt:
          const FirestoreTimestampConverter().fromJson(json['createdAt']),
    );

const _$UserFieldMap = <String, String>{
  'id': 'id',
  'email': 'email',
  'nom': 'nom',
  'prenom': 'prenom',
  'createdAt': 'createdAt',
};

// ignore: unused_element
abstract class _$UserPerFieldToJson {
  // ignore: unused_element
  static Object? id(String instance) => instance;
  // ignore: unused_element
  static Object? email(String instance) => instance;
  // ignore: unused_element
  static Object? nom(String instance) => instance;
  // ignore: unused_element
  static Object? prenom(String instance) => instance;
  // ignore: unused_element
  static Object? createdAt(DateTime instance) =>
      const FirestoreTimestampConverter().toJson(instance);
}

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'createdAt':
          const FirestoreTimestampConverter().toJson(instance.createdAt),
    };
