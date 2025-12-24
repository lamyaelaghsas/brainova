import 'package:firestore_odm/firestore_odm.dart';
import 'package:dto/converters/firestore_timestamp_converter.dart';
import 'package:dto/models/user.dart';
import 'package:dto/models/groupe.dart';
import 'package:dto/models/session.dart';

part 'schema.odm.dart';

@Schema()
@Collection<User>('users')
@Collection<Groupe>('groupes')
@Collection<Session>('groupes/*/sessions')
final appSchema = _$AppSchema;