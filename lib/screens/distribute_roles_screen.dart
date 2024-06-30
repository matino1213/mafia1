import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafia1/constants.dart';
import 'package:mafia1/models/user_role.dart';
import 'package:mafia1/screens/narrator_screen.dart';

class DistributeRolesScreen extends StatefulWidget {
  const DistributeRolesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DistributeRolesScreenState createState() => _DistributeRolesScreenState();
}

class _DistributeRolesScreenState extends State<DistributeRolesScreen> {
  final List<UserRole> userRoles = [];
  int viewedRolesCount = 0;

  @override
  void initState() {
    super.initState();
    _distributeRoles();
  }

  void _distributeRoles() {
    final userBox = Hive.box('Users');
    final roleBox = Hive.box('Roles');
    final activeUsers = userBox.values.where((user) => user.isActive).toList();
    final roles = roleBox.values.toList();

    roles.shuffle();

    userRoles.clear();
    for (int i = 0; i < activeUsers.length; i++) {
      userRoles.add(UserRole(user: activeUsers[i], role: roles[i]));
    }

    setState(() {
      viewedRolesCount = 0;
    });
  }

  void _showFinalDialog() {
    Get.defaultDialog(
      backgroundColor: kYellowColor,
      title: 'تمام نقش‌ها نمایش داده شد',
      titleStyle: kTextStyle,
      middleText: 'چه کاری می‌خواهید انجام دهید؟',
      middleTextStyle: kTextStyle,
      actions: [
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          onTap: () {
            Get.back();
            _distributeRoles();
          },
          child: Container(
            height: 50,
            width: 200,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              border: Border.fromBorderSide(BorderSide(color: Colors.black, width: 2)),
            ),
            child: Center(
              child: Text(
                'تقسیم دوباره نقش ها',
                style: kTextStyle.copyWith(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10), // Space between buttons
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          onTap: () {
            Get.off(() => NarratorScreen(userRoles: userRoles));
          },
          child: Container(
            height: 50,
            width: 200,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              border: Border.fromBorderSide(BorderSide(color: Colors.black, width: 2)),
            ),
            child: Center(
              child: Text(
                'رفتن به صفحه راوی',
                style: kTextStyle.copyWith(color: Colors.black, fontSize: 18)),
            ),
          ),
        ),
      ],
    );
  }

  void _onRoleViewed(UserRole userRole) {
    setState(() {
      userRole.isViewed = true;
      viewedRolesCount++;
      if (viewedRolesCount == userRoles.length) {
        _showFinalDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: kYellowColor,
        title: Text('توزیع نقش‌ها', style: kTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: userRoles.length,
          itemBuilder: (context, index) {
            final userRole = userRoles[index];
            if (userRole.isViewed) return Container();
            return InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.black,
                      title: Text(
                        'نقش ${userRole.user.name}',
                        style: kTextStyle.copyWith(color: kYellowColor),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/${userRole.role.roleName}.jpg',
                            height: 100,
                            width: 100,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/none.jpg',
                                height: 100,
                                width: 100,
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            userRole.role.roleName,
                            style: kTextStyle.copyWith(color: kYellowColor, fontSize: 25),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('بستن', style: kTextStyle.copyWith(color: kYellowColor)),
                        ),
                      ],
                    );
                  },
                ).then((_) {
                  // Ensure that the role is marked as viewed if the dialog is dismissed
                  _onRoleViewed(userRole);
                });
              },
              child: Card(
                shape: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: kYellowColor,
                child: Center(
                  child: Text(
                    userRole.user.name,
                    style: kTextStyle.copyWith(color: Colors.black),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
