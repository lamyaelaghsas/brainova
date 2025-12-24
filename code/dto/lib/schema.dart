import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_odm/firestore_odm.dart';
import 'package:dto/models/user.dart';
import 'package:dto/models/groupe.dart';
import 'package:dto/models/session.dart';

part 'schema.odm.dart';

@Schema()
@Collection<User>('users')
@Collection<Groupe>('groupes')
@Collection<Session>('sessions')
final appSchema = _$AppSchema;