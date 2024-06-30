import 'package:mafia1/models/role.dart';
import 'package:mafia1/models/user.dart';

class UserRole {
  final User user;
  final Role role;
  bool isViewed;

  UserRole({required this.user, required this.role, this.isViewed = false});
}
