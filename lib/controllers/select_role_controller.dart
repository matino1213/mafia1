import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafia1/models/role.dart';

class RoleController extends GetxController {
  var roleCounts = <String, int>{}.obs;
  final List<String> defaultRoles = [
    'شهروند',
    'پزشک',
    'کاراگاه',
    'اسنایپر',
    'رویین تن',
    'زره پوش',
    'کشیش',
    'تفنگدار',
    'خبرنگار',
    'مافیا',
    'گادفادر',
    'سایلنسر',
    'مذاکره کننده',
    'دکتر لکتر',
    'کیلر',
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeDefaultRoles();
    _loadRoleCounts();
  }

  void _initializeDefaultRoles() {
    for (var role in defaultRoles) {
      roleCounts[role] = 0;
    }
  }

  Future<void> _loadRoleCounts() async {
    Box roleBox = Hive.box('Roles');
    for (var item in roleBox.values) {
      Role role = item;
      roleCounts[role.roleName] = (roleCounts[role.roleName] ?? 0) + 1;
    }
  }

  Future<void> addRole(String text) async {
    Box roleBox = Hive.box('Roles');
    Role newRole = Role(text);
    await roleBox.add(newRole);
    roleCounts[text] = (roleCounts[text] ?? 0) + 1;
  }

  Future<void> deleteRole(String text) async {
    Box roleBox = Hive.box('Roles');
    final roles =
        roleBox.values.where((role) => role.roleName == text).toList();
    if (roles.isNotEmpty) {
      await roles.first.delete();
      roleCounts[text] = (roleCounts[text] ?? 1) - 1;
    }
  }
}
