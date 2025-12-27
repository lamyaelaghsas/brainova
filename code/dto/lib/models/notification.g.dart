// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      groupeId: json['groupeId'] as String,
      sessionId: json['sessionId'] as String?,
      isRead: json['isRead'] as bool,
      createdAt: const FirestoreTimestampConverter()
          .fromJson(json['createdAt'] as Object),
    );

const _$NotificationModelFieldMap = <String, String>{
  'id': 'id',
  'userId': 'userId',
  'type': 'type',
  'title': 'title',
  'message': 'message',
  'groupeId': 'groupeId',
  'sessionId': 'sessionId',
  'isRead': 'isRead',
  'createdAt': 'createdAt',
};

// ignore: unused_element
abstract class _$NotificationModelPerFieldToJson {
  // ignore: unused_element
  static Object? id(String instance) => instance;
  // ignore: unused_element
  static Object? userId(String instance) => instance;
  // ignore: unused_element
  static Object? type(String instance) => instance;
  // ignore: unused_element
  static Object? title(String instance) => instance;
  // ignore: unused_element
  static Object? message(String instance) => instance;
  // ignore: unused_element
  static Object? groupeId(String instance) => instance;
  // ignore: unused_element
  static Object? sessionId(String? instance) => instance;
  // ignore: unused_element
  static Object? isRead(bool instance) => instance;
  // ignore: unused_element
  static Object? createdAt(DateTime instance) =>
      const FirestoreTimestampConverter().toJson(instance);
}

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'groupeId': instance.groupeId,
      'sessionId': instance.sessionId,
      'isRead': instance.isRead,
      'createdAt':
          const FirestoreTimestampConverter().toJson(instance.createdAt),
    };
