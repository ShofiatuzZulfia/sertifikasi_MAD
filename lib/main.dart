import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moments/app/modules/login/controllers/login_controller.dart';
import 'package:moments/app/utils/loading.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authC = Get.put(LoginController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: authC.streamAuthStatus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            print(snapshot);
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Moments",
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
              theme: ThemeData(
                primarySwatch: Colors.indigo,
              ),
            );
          }
          return LoadingView();
        });
  }
}
