import 'package:dto/converters/firestore_timestamp_converter.dart';
import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'groupe.freezed.dart';
part 'groupe.g.dart';

@freezed
abstract class Groupe with _$Groupe {
  const factory Groupe({
    @DocumentIdField() required String id,
    required String nom,
    required String description,
    required String code,
    required String couleur,
    required String creatorId,
    required List<String> memberIds,
    @FirestoreTimestampConverter() required DateTime createdAt,
  }) = _Groupe;

  factory Groupe.fromJson(Map<String, dynamic> json) => _$GroupeFromJson(json);
}
