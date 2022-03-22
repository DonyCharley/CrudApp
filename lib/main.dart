import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Pages/auth_checker.dart';
import 'Pages/error_screen.dart';
import 'Pages/loading_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

//  This is a FutureProvider that will be used to check whether the firebase has been initialized or not
final firebaseInitializerProvider = FutureProvider<FirebaseApp>((ref) async {
  return await Firebase.initializeApp();
});

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final initialize = ref.watch(firebaseInitializerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: initialize.when(
          data: (data) {
            return const AuthChecker();
          },
          loading: () => const LoadingScreen(),
          error: (e, stackTrace) => ErrorScreen(e, stackTrace)),
    );
  }
}