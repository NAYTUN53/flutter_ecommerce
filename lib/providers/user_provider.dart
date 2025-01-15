import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

class UserProvider extends StateNotifier<User?> {
  UserProvider()
      : super(User(
            id: "",
            fullName: '',
            email: '',
            state: '',
            city: '',
            locality: '',
            password: '',
            token: ''));

  User? get user => state;

  void signOut() {
    state = null;
  }

  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }

  // Method to recreate the user state
  void recreateUserState({
    required String state,
    required String city,
    required String locality,
  }) {
    if (this.state != null) {
      this.state = User(
          id: this.state!.id, // preserve the id
          fullName: this.state!.fullName,
          email: this.state!.email,
          state: state,
          city: city,
          locality: locality,
          password: this.state!.password,
          token: this.state!.token);
    }
  }
}

final userProvider =
    StateNotifierProvider<UserProvider, User?>((ref) => UserProvider());
