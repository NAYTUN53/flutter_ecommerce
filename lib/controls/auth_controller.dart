import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/global_variables.dart';
import 'package:untitled/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/providers/user_provider.dart';
import 'package:untitled/services/manage_http_response.dart';
import 'package:untitled/views/screens/authentication_screens/login_screen.dart';
import 'package:untitled/views/screens/main_screen.dart';

final providerContainer = ProviderContainer();

class AuthController {
  Future<void> signUpUsers(
      {required context,
      required String fullName,
      required String email,
      required String password}) async {
    try {
      User user = User(
          id: "",
          fullName: fullName,
          email: email,
          state: '',
          city: '',
          locality: '',
          password: password,
          token: '');
      http.Response response = await http.post(Uri.parse('$uri/api/signup'),
          body: user.toJson(),
          // Set the header for the request
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8',
          });
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
            showSnackBar(context, 'Account has been created.');
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> signInUsers(
      {required context, required email, required password}) async {
    try {
      http.Response response = await http.post(Uri.parse('$uri/api/signin'),
          body: jsonEncode({'email': email, 'password': password}),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          });
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            // Save authentication token
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            String token = jsonDecode(response.body)['token'];
            preferences.setString('auth_token', token);

            //Save user data after converting json to dart object
            final userJson = jsonEncode(jsonDecode(response.body)['user']);
            providerContainer.read(userProvider.notifier).setUser(userJson);
            await preferences.setString('user', userJson);

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false);
            showSnackBar(context, "Successfully login");
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // SignOut
  Future<void> signOutUser({required context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      // clear the token and user data from shared preference
      await preferences.remove('auth_token');
      await preferences.remove('user');

      // clear the user state
      providerContainer.read(userProvider.notifier).signOut();

      // navigate the user back to the login screen
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
      showSnackBar(context, "Successfully Sign Out");
    } catch (e) {
      showSnackBar(context, "error in signing out. The error is $e");
    }
  }
}
