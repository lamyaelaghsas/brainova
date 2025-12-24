import 'package:dto/converters/firestore_timestamp_converter.dart';
import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    @DocumentIdField() required String id,
    required String titre,
    @FirestoreTimestampConverter() required DateTime date,
    required int dureeMinutes,
    required List<String> participantIds,
    required String statut,
    @FirestoreTimestampConverter() required DateTime createdAt,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
}
