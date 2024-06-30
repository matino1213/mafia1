import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafia1/constants.dart';
import 'package:mafia1/controllers/select_role_controller.dart';
import 'package:mafia1/screens/distribute_roles_screen.dart';
import 'package:mafia1/screens/select_name_screen.dart';

class SelectRoleScreen extends StatelessWidget {
  const SelectRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RoleController roleController = Get.put(RoleController());
    Box userBox = Hive.box('Users');
    int activeUsersCount = userBox.values.where((user) => user.isActive).length;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Get.off(() => const SelectNameScreen());
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: kYellowColor,
          title: Text('انتخاب نقش ها', style: kTextStyle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            textDirection: TextDirection.rtl,
            children: [
              // بخش جدید برای نمایش تعداد نقش‌ها
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kYellowColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Obx(() {
                  int selectedRolesCount = roleController.roleCounts.values.fold(0, (sum, item) => sum + item);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'تعداد بازیکنان فعال: $activeUsersCount',
                        style: kTextStyle.copyWith(color: Colors.black),
                      ),
                      Text(
                        'نقش‌های انتخاب شده: $selectedRolesCount',
                        style: kTextStyle.copyWith(color: Colors.black),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  return GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: roleController.roleCounts.keys.map((roleName) {
                      return roleContainer(roleName, roleController);
                    }).toList(),
                  );
                }),
              ),
              const SizedBox(height: 20),
              InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                onTap: () {
                  int selectedRolesCount = roleController.roleCounts.values.fold(0, (sum, item) => sum + item);
                  if (selectedRolesCount == activeUsersCount) {
                    Get.to(const DistributeRolesScreen());
                  } else {
                    Get.snackbar(
                      'تعداد نقش‌ها و بازیکنان مطابقت ندارد!',
                      'تعداد نقش‌های انتخاب شده باید با تعداد بازیکنان فعال برابر باشد.',
                    );
                  }
                },
                child: Container(
                  height: 70,
                  width: Get.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    border: Border.fromBorderSide(BorderSide(color: kYellowColor, width: 5)),
                  ),
                  child: Center(
                    child: Text(
                      'تقسیم نقش ها',
                      style: kTextStyle.copyWith(color: kYellowColor, fontSize: 25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddRoleDialog(roleController);
          },
          backgroundColor: kYellowColor,
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }

  void _showAddRoleDialog(RoleController roleController) {
    String newRoleName = '';
    Get.defaultDialog(
      title: 'اضافه کردن نقش جدید',
      titleStyle: kTextStyle.copyWith(color: kYellowColor),
      backgroundColor: Colors.black,
      content: Column(
        children: [
          TextField(
            onChanged: (value) {
              newRoleName = value;
            },
            style: kTextStyle.copyWith(color: kYellowColor),
            decoration: InputDecoration(
              labelText: 'نام نقش',
              labelStyle: kTextStyle.copyWith(color: kYellowColor),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kYellowColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kYellowColor),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (newRoleName.isNotEmpty) {
                await roleController.addRole(newRoleName);
                Get.back();
              } else {
                Get.snackbar('خطا', 'نام نقش نباید خالی باشد', backgroundColor: Colors.red);
              }
            },
            child: Text('اضافه کردن', style: kTextStyle),
          ),
        ],
      ),
    );
  }

  Widget roleContainer(String text, RoleController roleController) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        border: Border.fromBorderSide(BorderSide(color: kYellowColor, width: 3)),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/$text.jpg',
            height: 50,
            width: 50,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/none.jpg',
                height: 50,
                width: 50,
              );
            },
          ),
          const SizedBox(height: 5),
          Text(text, style: kTextStyle.copyWith(color: kYellowColor)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  await roleController.addRole(text);
                },
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(BorderSide(color: kYellowColor, width: 3)),
                  ),
                  child: Center(
                    child: Text('+', style: TextStyle(color: kYellowColor)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Obx(() {
                return Text(
                  '${roleController.roleCounts[text] ?? 0}',
                  style: TextStyle(color: kYellowColor),
                );
              }),
              const SizedBox(width: 10),
              InkWell(
                onTap: () async {
                  await roleController.deleteRole(text);
                },
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(BorderSide(color: kYellowColor, width: 3)),
                  ),
                  child: Center(
                    child: Text('-', style: TextStyle(color: kYellowColor)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
