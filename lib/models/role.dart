import 'package:hive_flutter/hive_flutter.dart';

part 'role.g.dart';

@HiveType(typeId: 1)
class Role extends HiveObject {
  @HiveField(0)
  final String roleName;

  Role(this.roleName);
}
