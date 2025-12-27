import 'package:dto/converters/firestore_timestamp_converter.dart';
import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    @DocumentIdField() required String id,
    required String userId,
    required String type,
    required String title,
    required String message,
    required String groupeId,
    String? sessionId,  
    required bool isRead,
    @FirestoreTimestampConverter() required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => 
      _$NotificationModelFromJson(json);
}


//FICHIER PAS UTILISÉ ACTUELLEMENT CAR MARCHE PAS DONC JE FAIS LES NOTIFS SANS DTO