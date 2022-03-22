import 'package:crud_lp/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'error_screen.dart';
import 'home_page.dart';

import 'loading_screen.dart';
import 'login_page.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final _authState = ref.watch(authStateProvider);
    return _authState.when(
        data: (data) {


          if (data != null) return  HomePage(data);
          return const LoginPage();
        },
        loading: () => const LoadingScreen(),
        error: (e, trace) => ErrorScreen(e, trace));
  }
}
