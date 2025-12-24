import 'package:dto/converters/firestore_timestamp_converter.dart';
import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    @DocumentIdField() required String id,
    required String email,
    required String nom,
    required String prenom,
    @FirestoreTimestampConverter() required DateTime createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
