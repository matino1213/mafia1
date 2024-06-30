import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafia1/constants.dart';
import 'package:mafia1/models/user.dart';
import 'package:mafia1/screens/home_screen.dart';
import 'package:mafia1/screens/select_role_screen.dart';

class SelectNameScreen extends StatefulWidget {
  const SelectNameScreen({super.key});

  @override
  State<SelectNameScreen> createState() => _SelectNameScreenState();
}

class _SelectNameScreenState extends State<SelectNameScreen> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Get.off(() => const HomeScreen());
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.defaultDialog(
              backgroundColor: kYellowColor,
              title: 'نام بازیکن را وارد کنید',
              titleStyle: kTextStyle,
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: Get.width * 0.5,
                    child: TextField(
                      textAlign: TextAlign.right,
                      controller: nameController,
                      style: kTextStyle,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          borderRadius: const BorderRadius.all(Radius.circular(25)),
                          color: Colors.black,
                          child: InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(25)),
                            onTap: () async {
                              bool repetitious = false;
                              Box userBox = Hive.box('Users');
                              for (var item in userBox.values) {
                                User user = item;
                                if (user.name == nameController.text) {
                                  repetitious = true;
                                }
                              }
                              if (nameController.text.isEmpty) {
                                Get.snackbar('مقدار خالی', 'لطفا یک نام وارد کنید');
                              } else if (repetitious) {
                                Get.snackbar('نام تکراری', 'لطفا نام جدید وارد کنید');
                              } else {
                                await add(nameController.text);
                                nameController.clear();
                                Get.back();
                              }
                            },
                            child: SizedBox(
                              height: 50,
                              width: 100,
                              child: Center(
                                child: Text(
                                  'افزودن',
                                  style: kTextStyle.copyWith(color: kYellowColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(25)),
                          onTap: () {
                            nameController.clear();
                            Get.back();
                          },
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                              border: Border.fromBorderSide(BorderSide(color: Colors.black, width: 4)),
                            ),
                            child: Center(
                              child: Text(
                                'لغو',
                                style: kTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          backgroundColor: kYellowColor,
          child: const Icon(Icons.add, color: Colors.black),
        ),
        appBar: AppBar(
          backgroundColor: kYellowColor,
          title: Text('انتخاب بازیکنان', style: kTextStyle),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FutureBuilder(
                  future: Hive.openBox('Users'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return nameList();
                      } else {
                        return Center(
                            child: Text('خطا در بارگذاری داده‌ها', style: kTextStyle));
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                onTap: () {
                  int len = 0;
                  Box userBox = Hive.box('Users');
                  for (var item in userBox.values) {
                    User user = item;
                    if (user.isActive) {
                      len++;
                    }
                  }
                  if (len > 3) {
                    Get.to(const SelectRoleScreen());
                  } else {
                    Get.snackbar('تعداد بازیکن ها کافی نمی باشد!', 'باید حداقل 4 بازیکن را انتخاب نمایید.');
                  }
                },
                child: Container(
                  height: 80,
                  width: Get.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    border: Border.fromBorderSide(BorderSide(color: kYellowColor, width: 5)),
                  ),
                  child: Center(
                    child: Text(
                      'انتخاب نقش ها',
                      style: kTextStyle.copyWith(color: kYellowColor, fontSize: 25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> add(String text) async {
    var box = await Hive.openBox('Users');
    User user = User(text, false);
    await box.add(user);
  }

  Widget nameList() {
    Box userBox = Hive.box('Users');
    return ValueListenableBuilder(
      valueListenable: userBox.listenable(),
      builder: (context, Box box, child) {
        if (box.values.isEmpty) {
          return Center(child: Text('هیچ بازیکنی اضافه نشده است', style: kTextStyle));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: box.length,
            itemBuilder: (context, index) {
              User user = box.getAt(index);
              return Card(
                shape: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: kYellowColor,
                child: ListTile(
                  leading: Icon(
                    user.isActive ? Icons.check_circle_rounded : Icons.circle_outlined,
                    color: Colors.black,
                  ),
                  onTap: () {
                    box.putAt(index, User(user.name, !user.isActive));
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(user.name, style: kTextStyle),
                      IconButton(
                        onPressed: () {
                          box.deleteAt(index);
                        },
                        icon: const Icon(Icons.delete, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
