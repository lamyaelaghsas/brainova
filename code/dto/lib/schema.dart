import 'package:firestore_odm/firestore_odm.dart';
import 'models/user.dart';
import 'models/groupe.dart';
import 'models/session.dart';

part 'schema.odm.dart';

@Schema()
@Collection<User>('users')
@Collection<Groupe>('groupes')
@Collection<Session>('groupes/*/sessions')
final appSchema = _$AppSchema;
