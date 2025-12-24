// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Session {
  @DocumentIdField()
  String get id;
  String get titre;
  @FirestoreTimestampConverter()
  DateTime get date;
  int get dureeMinutes;
  List<String> get participantIds;
  String get statut;
  @FirestoreTimestampConverter()
  DateTime get createdAt;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionCopyWith<Session> get copyWith =>
      _$SessionCopyWithImpl<Session>(this as Session, _$identity);

  /// Serializes this Session to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Session &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.titre, titre) || other.titre == titre) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dureeMinutes, dureeMinutes) ||
                other.dureeMinutes == dureeMinutes) &&
            const DeepCollectionEquality()
                .equals(other.participantIds, participantIds) &&
            (identical(other.statut, statut) || other.statut == statut) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, titre, date, dureeMinutes,
      const DeepCollectionEquality().hash(participantIds), statut, createdAt);

  @override
  String toString() {
    return 'Session(id: $id, titre: $titre, date: $date, dureeMinutes: $dureeMinutes, participantIds: $participantIds, statut: $statut, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $SessionCopyWith<$Res> {
  factory $SessionCopyWith(Session value, $Res Function(Session) _then) =
      _$SessionCopyWithImpl;
  @useResult
  $Res call(
      {@DocumentIdField() String id,
      String titre,
      @FirestoreTimestampConverter() DateTime date,
      int dureeMinutes,
      List<String> participantIds,
      String statut,
      @FirestoreTimestampConverter() DateTime createdAt});
}

/// @nodoc
class _$SessionCopyWithImpl<$Res> implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._self, this._then);

  final Session _self;
  final $Res Function(Session) _then;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titre = null,
    Object? date = null,
    Object? dureeMinutes = null,
    Object? participantIds = null,
    Object? statut = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      titre: null == titre
          ? _self.titre
          : titre // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dureeMinutes: null == dureeMinutes
          ? _self.dureeMinutes
          : dureeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      participantIds: null == participantIds
          ? _self.participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      statut: null == statut
          ? _self.statut
          : statut // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [Session].
extension SessionPatterns on Session {
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
    TResult Function(_Session value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Session() when $default != null:
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
    TResult Function(_Session value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Session():
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
    TResult? Function(_Session value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Session() when $default != null:
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
            String titre,
            @FirestoreTimestampConverter() DateTime date,
            int dureeMinutes,
            List<String> participantIds,
            String statut,
            @FirestoreTimestampConverter() DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Session() when $default != null:
        return $default(_that.id, _that.titre, _that.date, _that.dureeMinutes,
            _that.participantIds, _that.statut, _that.createdAt);
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
            String titre,
            @FirestoreTimestampConverter() DateTime date,
            int dureeMinutes,
            List<String> participantIds,
            String statut,
            @FirestoreTimestampConverter() DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Session():
        return $default(_that.id, _that.titre, _that.date, _that.dureeMinutes,
            _that.participantIds, _that.statut, _that.createdAt);
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
            String titre,
            @FirestoreTimestampConverter() DateTime date,
            int dureeMinutes,
            List<String> participantIds,
            String statut,
            @FirestoreTimestampConverter() DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Session() when $default != null:
        return $default(_that.id, _that.titre, _that.date, _that.dureeMinutes,
            _that.participantIds, _that.statut, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Session implements Session {
  const _Session(
      {@DocumentIdField() required this.id,
      required this.titre,
      @FirestoreTimestampConverter() required this.date,
      required this.dureeMinutes,
      required final List<String> participantIds,
      required this.statut,
      @FirestoreTimestampConverter() required this.createdAt})
      : _participantIds = participantIds;
  factory _Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  @override
  @DocumentIdField()
  final String id;
  @override
  final String titre;
  @override
  @FirestoreTimestampConverter()
  final DateTime date;
  @override
  final int dureeMinutes;
  final List<String> _participantIds;
  @override
  List<String> get participantIds {
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantIds);
  }

  @override
  final String statut;
  @override
  @FirestoreTimestampConverter()
  final DateTime createdAt;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SessionCopyWith<_Session> get copyWith =>
      __$SessionCopyWithImpl<_Session>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SessionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Session &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.titre, titre) || other.titre == titre) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dureeMinutes, dureeMinutes) ||
                other.dureeMinutes == dureeMinutes) &&
            const DeepCollectionEquality()
                .equals(other._participantIds, _participantIds) &&
            (identical(other.statut, statut) || other.statut == statut) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, titre, date, dureeMinutes,
      const DeepCollectionEquality().hash(_participantIds), statut, createdAt);

  @override
  String toString() {
    return 'Session(id: $id, titre: $titre, date: $date, dureeMinutes: $dureeMinutes, participantIds: $participantIds, statut: $statut, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$SessionCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$SessionCopyWith(_Session value, $Res Function(_Session) _then) =
      __$SessionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@DocumentIdField() String id,
      String titre,
      @FirestoreTimestampConverter() DateTime date,
      int dureeMinutes,
      List<String> participantIds,
      String statut,
      @FirestoreTimestampConverter() DateTime createdAt});
}

/// @nodoc
class __$SessionCopyWithImpl<$Res> implements _$SessionCopyWith<$Res> {
  __$SessionCopyWithImpl(this._self, this._then);

  final _Session _self;
  final $Res Function(_Session) _then;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? titre = null,
    Object? date = null,
    Object? dureeMinutes = null,
    Object? participantIds = null,
    Object? statut = null,
    Object? createdAt = null,
  }) {
    return _then(_Session(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      titre: null == titre
          ? _self.titre
          : titre // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dureeMinutes: null == dureeMinutes
          ? _self.dureeMinutes
          : dureeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      participantIds: null == participantIds
          ? _self._participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      statut: null == statut
          ? _self.statut
          : statut // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
