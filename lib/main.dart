import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/providers/user_provider.dart';
import 'package:untitled/views/screens/authentication_screens/login_screen.dart';
import 'package:untitled/views/screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51QEnSFBr99m9gsdtsG3BsSXa4CWJx8flLr5VtPeSxvSBXPr6rAAfnNhaHRqd15DgyF5ogS8Phe5CMw0e0FEoSK8o006irobJqD";
  Stripe.instance.applySettings();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Future<void> _checkTokenAndSetUser(WidgetRef ref) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');
    String? userJson = preferences.getString('user');

    if (token != null && userJson != null) {
      ref.read(userProvider.notifier).setUser(userJson);
    } else {
      ref.read(userProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
          future: _checkTokenAndSetUser(ref),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final user = ref.watch(userProvider);
            return user != null ? const MainScreen() : const LoginScreen();
          }),
    );
  }
}
