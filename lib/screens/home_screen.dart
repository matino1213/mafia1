import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mafia1/constants.dart';
import 'package:mafia1/screens/select_name_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              width: 250,
              child: Image.asset('assets/images/logo.png'),
            ),
            const SizedBox(
              height: 50,
            ),
            Material(
              color: kYellowColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(25),
              ),
              child: InkWell(
                onTap: () {
                  Get.to(SelectNameScreen());
                },
                borderRadius: const BorderRadius.all(
                  Radius.circular(25),
                ),
                child: SizedBox(
                  height: 100,
                  width: Get.width * 0.7,
                  child: const Center(
                    child: Text(
                      'شروع بازی',
                      style: TextStyle(color: Colors.black, fontSize: 30,fontFamily: 'Sans',fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
