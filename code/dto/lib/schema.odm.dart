// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// FirestoreGenerator
// **************************************************************************

/// Identifiers for all Firestore collections in the schema
/// Used to map collection paths to their respective collection classes
/// By combining collection classes (e.g., as tuple types),
/// we can use extension methods with record types to reduce boilerplate
/// Example: (_$UsersCollection, _$PostsCollection)
final class _$UsersCollection {}

final class _$GroupesCollection {}

final class _$SessionsCollection {}

/// Generated schema class - dummy class that only serves as type marker
class AppSchema extends FirestoreSchema {
  const AppSchema();
}

/// Generated schema instance
const AppSchema _$AppSchema = AppSchema();

/// Generated FilterSelector for `User`
extension AppSchemaUserFilterSelectorExtension on FilterSelector<User> {
  /// Filter by document ID (id field)
  @pragma('vm:prefer-inline')
  DocumentIdFieldFilter get id => DocumentIdFieldFilter(
        name: 'id',
        parent: this,
      );

  /// Filter by email
  StringFieldFilter get email => StringFieldFilter(
        name: 'email',
        parent: this,
      );

  /// Filter by nom
  StringFieldFilter get nom => StringFieldFilter(
        name: 'nom',
        parent: this,
      );

  /// Filter by prenom
  StringFieldFilter get prenom => StringFieldFilter(
        name: 'prenom',
        parent: this,
      );

  /// Filter by createdAt
  DateTimeFieldFilter get createdAt => DateTimeFieldFilter(
        name: 'createdAt',
        parent: this,
      );
}

/// Generated OrderByFieldSelector for `User`
extension AppSchemaUserOrderByFieldSelectorExtension
    on OrderByFieldSelector<User> {
  /// Order by document ID (id field)
  OrderByField<String> get id => OrderByField(
        name: 'id',
        parent: this,
        type: FieldPathType.documentId,
      );

  /// Order by email
  OrderByField<String> get email => OrderByField(
        name: 'email',
        parent: this,
      );

  /// Order by nom
  OrderByField<String> get nom => OrderByField(
        name: 'nom',
        parent: this,
      );

  /// Order by prenom
  OrderByField<String> get prenom => OrderByField(
        name: 'prenom',
        parent: this,
      );

  /// Order by createdAt
  OrderByField<DateTime> get createdAt => OrderByField(
        name: 'createdAt',
        parent: this,
      );
}

/// Generated AggregateFieldSelector for User
extension AppSchemaUserAggregateFieldSelectorExtension
    on AggregateFieldSelector<User> {}

extension AppSchemaUserPatchBuilder on PatchBuilder<User> {
  /// Update id field `String`
  @pragma('vm:prefer-inline')
  PatchBuilder<String> get id => PatchBuilder(
        name: 'id',
        parent: this,
        converter: const PrimitiveConverter(),
      );

  /// Update email field `String`
  @pragma('vm:prefer-inline')
  PatchBuilder<String> get email => PatchBuilder(
        name: 'email',
        parent: this,
        converter: const PrimitiveConverter(),
      );

  /// Update nom field `String`
  @pragma('vm:prefer-inline')
  PatchBuilder<String> get nom => PatchBuilder(
        name: 'nom',
        parent: this,
        converter: const PrimitiveConverter(),
      );

  /// Update prenom field `String`
  @pragma('vm:prefer-inline')
  PatchBuilder<String> get prenom => PatchBuilder(
        name: 'prenom',
        parent: this,
        converter: const PrimitiveConverter(),
      );

  /// Update createdAt field `DateTime`
  @pragma('vm:prefer-inline')
  DateTimeFieldUpdate<DateTime> get createdAt => DateTimeFieldUpdate(
        name: 'createdAt',
        parent: this,
      );
}

/// Generated FilterSelector for `Groupe`
extension AppSchemaGroupeFilterSelectorExtension on FilterSelector<Groupe> {
  /// Filter by document ID (id field)
  @pragma('vm:prefer-inline')
  DocumentIdFieldFilter get id => DocumentIdFieldFilter(
        name: 'id',
        parent: this,
      );

  /// Filter by nom
  StringFieldFilter get nom => StringFieldFilter(
        name: 'nom',
        parent: this,
      );

  /// Filter by description
  StringFieldFilter get description => StringFieldFilter(
        name: 'description',
        parent: this,
      );

  /// Filter by code
  StringFieldFilter get code => StringFieldFilter(
        name: 'code',
        parent: this,
      );

  /// Filter by couleur
  StringFieldFilter get couleur => StringFieldFilter(
        name: 'couleur',
        parent: this,
      );

  /// Filter by creatorId
  StringFieldFilter get creatorId => StringFieldFilter(
        name: 'creatorId',
        parent: this,
      );

  /// Filter by memberIds
  ArrayFieldFilter get memberIds => ArrayFieldFilter(
        name: 'memberIds',
        parent: this,
      );

  /// Filter by createdAt
  DateTimeFieldFilter get createdAt => DateTimeFieldFilter(
        name: 'createdAt',
        parent: this,
      );
}

/// Generated OrderByFieldSelector for `Groupe`
extension AppSchemaGroupeOrderByFieldSelectorExtension
    on OrderByFieldSelector<Groupe> {
  /// Order by document ID (id field)
  OrderByField<String> get id => OrderByField(
        name: 'id',
        parent: this,
        type: FieldPathType.documentId,
      );

  /// Order by nom
  OrderByField<String> get nom => OrderByField(
        name: 'nom',
        parent: this,
      );

  /// Order by description
  OrderByField<String> get description => OrderByField(
        name: 'description',
        parent: this,
      );

  /// Order by code
  OrderByField<String> get code => OrderByField(
        name: 'code',
        parent: this,
      );

  /// Order by couleur
  OrderByField<String> get couleur => OrderByField(
        name: 'couleur',
        parent: this,
      );

  /// Order by creatorId
  OrderByField<String> get creatorId => OrderByField(
        name: 'creatorId',
        parent: this,
      );

  /// Order by memberIds
  OrderByField<List<String>> get memberIds => OrderByField(
        name: 'memberIds',
        parent: this,
      );

  /// Order by createdAt
  OrderByField<DateTime> get createdAt => OrderByField(
        name: 'createdAt',
        parent: this,
      );
}

/// Generated AggregateFieldSelector for Groupe
extension AppSchemaGroupeAggregateFieldSelectorExtension
    on AggregateFieldSelector<Groupe> {}

extension AppSchemaGroupePatchBuilder on PatchBuilder<Groupe> {
  /// Update id field `String`
  @pragma('vm:prefer-inline')
  PatchBuilder<String> get id => PatchBuilder(
        name: 'id',
        parent: this,
        converter: const PrimitiveConverter(),
      );

  /// Update nom field `String`
  @pragma('vm:prefer-inline')
  PatchBuilder<String> get nom => PatchBuilder(
        name: 'nom',
        parent: this,
        converter: const PrimitiveConverter(),
      );

  /// Update description field `String`
  @pragma('vm:prefer-inline')
  PatchBuilder<String> get description => PatchBuilder(
        name: 'description',
        parent: this,
        converter: const PrimitiveConverter(),
      );

  /// Update code field `String`
  @pragma('vm:prefer-inline')
  PatchBuilder<String> get code => PatchBuilder(
        name: 'code',
        parent: this,
        converter: const PrimitiveConverter(),
      );

  /// Update couleur field `String`
  @pragma('vm:prefer-inline')
  PatchBuilder<String> get couleur => PatchBuilder(
        name: 'couleur',
        parent: this,
        converter: const PrimitiveConverter(),
      );

  /// Update creatorId field `String`
  @pragma('vm:prefer-inline')
  PatchBuilder<String> get creatorId => PatchBuilder(
        name: 'creatorId',
        parent: this,
        converter: const PrimitiveConverter(),
      );

  /// Update memberIds field `List<String>`
  @pragma('vm:prefer-inline')
  ListFieldUpdate<List<String>, String> get memberIds => ListFieldUpdate(
        name: 'memberIds',
        parent: this,
        converter: /* {} */ ListConverter<String>(const PrimitiveConverter()),
        elementConverter: const PrimitiveConverter(),
      );

  /// Update createdAt field `DateTime`
  @pragma('vm:prefer-inline')
  DateTimeFieldUpdate<DateTime> get createdAt => DateTimeFieldUpdate(
        name: 'createdAt',
        parent: this,
      );
}

/// Generated FilterSelector for `List<E>`
extension AppSchemaListFilterSelectorExtension<E> on FilterSelector<List<E>> {}

/// Generated OrderByFieldSelector for `List<E>`
extension AppSchemaListOrderByFieldSelectorExtension<E>
    on OrderByFieldSelector<List<E>> {}

/// Generated FilterSelector for `Session`
extension AppSchemaSessionFilterSelectorExtension on FilterSelector<Session> {
  /// Filter by document ID (id field)
  @pragma('vm:prefer-inline')
  DocumentIdFieldFilter get id => DocumentIdFieldFilter(
        name: 'id',
        parent: this,
      );

  /// Filter by titre
  StringFieldFilter get titre => StringFieldFilter(
        name: 'titre',
        parent: this,
      );

  /// Filter by date
  DateTimeFieldFilter get date => DateTimeFieldFilter(
        name: 'date',
        parent: this,
      );

  /// Filter by dureeMinutes
  NumericFieldFilter get dureeMinutes => NumericFieldFilter(
        name: 'dureeMinutes',
        parent: this,
      );

  /// Filter by participantIds
  ArrayFieldFilter get participantIds => ArrayFieldFilter(
        name: 'participantIds',
        parent: this,
      );

  /// Filter by statut
  StringFieldFilter get statut => StringFieldFilter(
        name: 'statut',
        parent: this,
      );

  /// Filter by createdAt
  DateTimeFieldFilter get createdAt => DateTimeFieldFilter(
        name: 'createdAt',
        parent: this,
      );
}

/// Generated OrderByFieldSelector for `Session`
extension AppSchemaSessionOrderByFieldSelectorExtension
    on OrderByFieldSelector<Session> {
  /// Order by document ID (id field)
  OrderByField<String> get id => OrderByField(
        name: 'id',
        parent: this,
        type: FieldPathType.documentId,
      );

  /// Order by titre
  OrderByField<String> get titre => OrderByField(
        name: 'titre',
        parent: this,
      );

  /// Order by date
  OrderByField<DateTime> get date => OrderByField(
        name: 'date',
        parent: this,
      );

  /// Order by dureeMinutes
  OrderByField<int> get dureeMinutes => OrderByField(
        name: 'dureeMinutes',
        parent: this,
      );

  /// Order by participantIds
  OrderByField<List<String>> get participantIds => OrderByField(
        name: 'participantIds',
        parent: this,
      );

  /// Order by statut
  OrderByField<String> get statut => OrderByField(
        name: 'statut',
        parent: this,
      );

  /// Order by createdAt
  OrderByField<DateTime> get createdAt => OrderByField(
        name: 'createdAt',
        parent: this,
      );
}

/// Generated AggregateFieldSelector for Session
extension AppSchemaSessionAggregateFieldSelectorExtension
    on AggregateFieldSelector<Session> {
  /// dureeMinutes field for aggregation
  AggregateField<int> get dureeMinutes => AggregateField(
        name: 'dureeMinutes',
        parent: this,
      );
}

extension AppSchemaSessionPatchBuilder on PatchBuilder<Session> {
  /// Update id field `String`
  @pragma('vm:prefer-inline')
  PatchBuilder<String> get id => PatchBuilder(
        name: 'id',
        parent: this,
        converter: const PrimitiveConverter(),
      );

  /// Update titre field `String`
  @pragma('vm:prefer-inline')
  PatchBuilder<String> get titre => PatchBuilder(
        name: 'titre',
        parent: this,
        converter: const PrimitiveConverter(),
      );

  /// Update date field `DateTime`
  @pragma('vm:prefer-inline')
  DateTimeFieldUpdate<DateTime> get date => DateTimeFieldUpdate(
        name: 'date',
        parent: this,
      );

  /// Update dureeMinutes field `int`
  @pragma('vm:prefer-inline')
  NumericFieldUpdate<int> get dureeMinutes => NumericFieldUpdate(
        name: 'dureeMinutes',
        parent: this,
        converter: const PrimitiveConverter(),
      );

  /// Update participantIds field `List<String>`
  @pragma('vm:prefer-inline')
  ListFieldUpdate<List<String>, String> get participantIds => ListFieldUpdate(
        name: 'participantIds',
        parent: this,
        converter: /* {} */ ListConverter<String>(const PrimitiveConverter()),
        elementConverter: const PrimitiveConverter(),
      );

  /// Update statut field `String`
  @pragma('vm:prefer-inline')
  PatchBuilder<String> get statut => PatchBuilder(
        name: 'statut',
        parent: this,
        converter: const PrimitiveConverter(),
      );

  /// Update createdAt field `DateTime`
  @pragma('vm:prefer-inline')
  DateTimeFieldUpdate<DateTime> get createdAt => DateTimeFieldUpdate(
        name: 'createdAt',
        parent: this,
      );
}

/// Class to add collections to `FirestoreODM<AppSchema>`
extension AppSchemaODM on FirestoreODM<AppSchema> {
  /// Access users collection
  @pragma('vm:prefer-inline')
  FirestoreCollection<AppSchema, User, (_$UsersCollection,)> get users =>
      FirestoreCollection<AppSchema, User, (_$UsersCollection,)>(
        query: firestore.collection('users'),
        converter: const _$UserJsonConverter(),
        documentIdField: 'id',
      );

  /// Access groupes collection
  @pragma('vm:prefer-inline')
  FirestoreCollection<AppSchema, Groupe, (_$GroupesCollection,)> get groupes =>
      FirestoreCollection<AppSchema, Groupe, (_$GroupesCollection,)>(
        query: firestore.collection('groupes'),
        converter: const _$GroupeJsonConverter(),
        documentIdField: 'id',
      );
}

/// Extension to add collections to `TransactionContext<AppSchema>`
extension $AppSchemaTransactionContext on TransactionContext<AppSchema> {
  /// Access users collection
  @pragma('vm:prefer-inline')
  TransactionCollection<AppSchema, User, (_$UsersCollection,)> get users =>
      TransactionCollection<AppSchema, User, (_$UsersCollection,)>(
        query: ref.collection('users'),
        context: this,
        converter: const _$UserJsonConverter(),
        documentIdField: 'id',
      );

  /// Access groupes collection
  @pragma('vm:prefer-inline')
  TransactionCollection<AppSchema, Groupe, (_$GroupesCollection,)>
      get groupes =>
          TransactionCollection<AppSchema, Groupe, (_$GroupesCollection,)>(
            query: ref.collection('groupes'),
            context: this,
            converter: const _$GroupeJsonConverter(),
            documentIdField: 'id',
          );
}

/// Transaction document class for groupes collection
extension $AppSchemaGroupesTransactionDocument
    on TransactionDocument<AppSchema, Groupe, (_$GroupesCollection,)> {
  /// Access sessions subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<AppSchema, Session,
          (_$GroupesCollection, _$SessionsCollection)>
      get sessions => TransactionCollection<AppSchema, Session,
              (_$GroupesCollection, _$SessionsCollection)>(
            query: ref.collection('sessions'),
            context: context,
            converter: const _$SessionJsonConverter(),
            documentIdField: 'id',
          );
}

/// Document class for groupes collection
extension $AppSchemaGroupesDocument
    on FirestoreDocument<AppSchema, Groupe, (_$GroupesCollection,)> {
  /// Access sessions subcollection
  FirestoreCollection<AppSchema, Session,
          (_$GroupesCollection, _$SessionsCollection)>
      get sessions => FirestoreCollection<AppSchema, Session,
              (_$GroupesCollection, _$SessionsCollection)>(
            query: ref.collection('sessions'),
            converter: const _$SessionJsonConverter(),
            documentIdField: 'id',
          );
}

/// Extension to add collections to BatchContext<AppSchema>
extension AppSchemaBatchContextExtensions on BatchContext<AppSchema> {
  /// Access users collection
  BatchCollection<AppSchema, User, (_$UsersCollection,)> get users =>
      BatchCollection(
        collection: firestoreInstance.collection('users'),
        converter: const _$UserJsonConverter(),
        documentIdField: 'id',
        context: this,
      );

  /// Access groupes collection
  BatchCollection<AppSchema, Groupe, (_$GroupesCollection,)> get groupes =>
      BatchCollection(
        collection: firestoreInstance.collection('groupes'),
        converter: const _$GroupeJsonConverter(),
        documentIdField: 'id',
        context: this,
      );
}

/// Batch document class for groupes collection
extension $AppSchemaGroupesBatchDocument
    on BatchDocument<AppSchema, Groupe, (_$GroupesCollection,)> {
  /// Access sessions subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<AppSchema, Session,
          (_$GroupesCollection, _$SessionsCollection)>
      get sessions => getBatchCollection(
            parent: this,
            name: 'sessions',
            converter: const _$SessionJsonConverter(),
            documentIdField: 'id',
          );
}

//Generated converter for `FirestoreTimestampConverter`
class _$FirestoreTimestampConverterAnnotationConverter
    implements FirestoreConverter<DateTime, Object?> {
  const _$FirestoreTimestampConverterAnnotationConverter();

  @override
  DateTime fromJson(Object? data) =>
      FirestoreTimestampConverter().fromJson(data);

  @override
  Object? toJson(DateTime value) => FirestoreTimestampConverter().toJson(value);
}

//Generated converter for `User`
class _$UserJsonConverter
    implements FirestoreConverter<User, Map<String, dynamic>> {
  const _$UserJsonConverter();

  @override
  User fromJson(Map<String, dynamic> data) => User.fromJson(data);

  @override
  Map<String, dynamic> toJson(User value) => value.toJson();
}

//Generated converter for `Groupe`
class _$GroupeJsonConverter
    implements FirestoreConverter<Groupe, Map<String, dynamic>> {
  const _$GroupeJsonConverter();

  @override
  Groupe fromJson(Map<String, dynamic> data) => Groupe.fromJson(data);

  @override
  Map<String, dynamic> toJson(Groupe value) => value.toJson();
}

//Generated converter for `Session`
class _$SessionJsonConverter
    implements FirestoreConverter<Session, Map<String, dynamic>> {
  const _$SessionJsonConverter();

  @override
  Session fromJson(Map<String, dynamic> data) => Session.fromJson(data);

  @override
  Map<String, dynamic> toJson(Session value) => value.toJson();
}
