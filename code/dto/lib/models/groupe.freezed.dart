// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'groupe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Groupe {
  @DocumentIdField()
  String get id;
  String get nom;
  String? get description; // ✅ Optionnel maintenant
  String get code;
  String get couleur;
  String get creatorId;
  List<String> get memberIds;
  @FirestoreTimestampConverter()
  DateTime get createdAt;

  /// Create a copy of Groupe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupeCopyWith<Groupe> get copyWith =>
      _$GroupeCopyWithImpl<Groupe>(this as Groupe, _$identity);

  /// Serializes this Groupe to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Groupe &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.couleur, couleur) || other.couleur == couleur) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            const DeepCollectionEquality().equals(other.memberIds, memberIds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nom,
      description,
      code,
      couleur,
      creatorId,
      const DeepCollectionEquality().hash(memberIds),
      createdAt);

  @override
  String toString() {
    return 'Groupe(id: $id, nom: $nom, description: $description, code: $code, couleur: $couleur, creatorId: $creatorId, memberIds: $memberIds, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $GroupeCopyWith<$Res> {
  factory $GroupeCopyWith(Groupe value, $Res Function(Groupe) _then) =
      _$GroupeCopyWithImpl;
  @useResult
  $Res call(
      {@DocumentIdField() String id,
      String nom,
      String? description,
      String code,
      String couleur,
      String creatorId,
      List<String> memberIds,
      @FirestoreTimestampConverter() DateTime createdAt});
}

/// @nodoc
class _$GroupeCopyWithImpl<$Res> implements $GroupeCopyWith<$Res> {
  _$GroupeCopyWithImpl(this._self, this._then);

  final Groupe _self;
  final $Res Function(Groupe) _then;

  /// Create a copy of Groupe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? description = freezed,
    Object? code = null,
    Object? couleur = null,
    Object? creatorId = null,
    Object? memberIds = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nom: null == nom
          ? _self.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      couleur: null == couleur
          ? _self.couleur
          : couleur // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _self.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      memberIds: null == memberIds
          ? _self.memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [Groupe].
extension GroupePatterns on Groupe {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Groupe value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Groupe() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Groupe value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Groupe():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Groupe value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Groupe() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @DocumentIdField() String id,
            String nom,
            String? description,
            String code,
            String couleur,
            String creatorId,
            List<String> memberIds,
            @FirestoreTimestampConverter() DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Groupe() when $default != null:
        return $default(_that.id, _that.nom, _that.description, _that.code,
            _that.couleur, _that.creatorId, _that.memberIds, _that.createdAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @DocumentIdField() String id,
            String nom,
            String? description,
            String code,
            String couleur,
            String creatorId,
            List<String> memberIds,
            @FirestoreTimestampConverter() DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Groupe():
        return $default(_that.id, _that.nom, _that.description, _that.code,
            _that.couleur, _that.creatorId, _that.memberIds, _that.createdAt);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @DocumentIdField() String id,
            String nom,
            String? description,
            String code,
            String couleur,
            String creatorId,
            List<String> memberIds,
            @FirestoreTimestampConverter() DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Groupe() when $default != null:
        return $default(_that.id, _that.nom, _that.description, _that.code,
            _that.couleur, _that.creatorId, _that.memberIds, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Groupe implements Groupe {
  const _Groupe(
      {@DocumentIdField() required this.id,
      required this.nom,
      this.description,
      required this.code,
      required this.couleur,
      required this.creatorId,
      required final List<String> memberIds,
      @FirestoreTimestampConverter() required this.createdAt})
      : _memberIds = memberIds;
  factory _Groupe.fromJson(Map<String, dynamic> json) => _$GroupeFromJson(json);

  @override
  @DocumentIdField()
  final String id;
  @override
  final String nom;
  @override
  final String? description;
// ✅ Optionnel maintenant
  @override
  final String code;
  @override
  final String couleur;
  @override
  final String creatorId;
  final List<String> _memberIds;
  @override
  List<String> get memberIds {
    if (_memberIds is EqualUnmodifiableListView) return _memberIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberIds);
  }

  @override
  @FirestoreTimestampConverter()
  final DateTime createdAt;

  /// Create a copy of Groupe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GroupeCopyWith<_Groupe> get copyWith =>
      __$GroupeCopyWithImpl<_Groupe>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GroupeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Groupe &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.couleur, couleur) || other.couleur == couleur) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            const DeepCollectionEquality()
                .equals(other._memberIds, _memberIds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nom,
      description,
      code,
      couleur,
      creatorId,
      const DeepCollectionEquality().hash(_memberIds),
      createdAt);

  @override
  String toString() {
    return 'Groupe(id: $id, nom: $nom, description: $description, code: $code, couleur: $couleur, creatorId: $creatorId, memberIds: $memberIds, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$GroupeCopyWith<$Res> implements $GroupeCopyWith<$Res> {
  factory _$GroupeCopyWith(_Groupe value, $Res Function(_Groupe) _then) =
      __$GroupeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@DocumentIdField() String id,
      String nom,
      String? description,
      String code,
      String couleur,
      String creatorId,
      List<String> memberIds,
      @FirestoreTimestampConverter() DateTime createdAt});
}

/// @nodoc
class __$GroupeCopyWithImpl<$Res> implements _$GroupeCopyWith<$Res> {
  __$GroupeCopyWithImpl(this._self, this._then);

  final _Groupe _self;
  final $Res Function(_Groupe) _then;

  /// Create a copy of Groupe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? description = freezed,
    Object? code = null,
    Object? couleur = null,
    Object? creatorId = null,
    Object? memberIds = null,
    Object? createdAt = null,
  }) {
    return _then(_Groupe(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nom: null == nom
          ? _self.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      couleur: null == couleur
          ? _self.couleur
          : couleur // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _self.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      memberIds: null == memberIds
          ? _self._memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
