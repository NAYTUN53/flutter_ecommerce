import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:untitled/controls/auth_controller.dart";
import "package:untitled/views/screens/authentication_screens/login_screen.dart";

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  late String email;
  late String fullName;
  late String password;
  bool isLoading = false;

  signUpUser() async {
    setState(() {
      isLoading = true;
    });
    await _authController
        .signUpUsers(
            context: context,
            fullName: fullName,
            email: email,
            password: password)
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sign Up title Text
                Text(
                  "Create Your Account",
                  style: GoogleFonts.getFont('Lato',
                      color: const Color(0xFF0d120E),
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2),
                ),

                // SignUp subtitle Text
                Text(
                  "To explore the world exclusives",
                  style: GoogleFonts.getFont(
                    'Lato',
                    color: const Color(0xFF0d120E),
                    letterSpacing: 0.2,
                    fontSize: 14,
                  ),
                ),

                // SignUp logo image
                Image.asset(
                  "assets/images/Illustration.png",
                  width: 200,
                  height: 200,
                ),

                // Username text
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Username",
                    style: GoogleFonts.getFont('Nunito Sans',
                        fontWeight: FontWeight.bold, letterSpacing: 0.2),
                  ),
                ),

                // Username Text Form Field
                TextFormField(
                  onChanged: (value) {
                    fullName = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your username!';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      labelText: "Enter your username",
                      labelStyle: GoogleFonts.getFont("Nunito Sans",
                          fontSize: 14, letterSpacing: 0.1),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/icons/user.jpeg",
                          width: 20,
                          height: 20,
                        ),
                      )),
                ),

                const SizedBox(
                  height: 20,
                ),

                // Email text
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Email",
                    style: GoogleFonts.getFont('Nunito Sans',
                        fontWeight: FontWeight.bold, letterSpacing: 0.2),
                  ),
                ),

                // Email Text Form Field
                TextFormField(
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email!';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      labelText: "Enter your email",
                      labelStyle: GoogleFonts.getFont("Nunito Sans",
                          fontSize: 14, letterSpacing: 0.1),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/icons/email.png",
                          width: 20,
                          height: 20,
                        ),
                      )),
                ),

                const SizedBox(
                  height: 20,
                ),

                // Password text
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Password",
                    style: GoogleFonts.getFont('Nunito Sans',
                        fontWeight: FontWeight.bold, letterSpacing: 0.2),
                  ),
                ),

                // Password text form field
                TextFormField(
                  onChanged: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password!';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      labelText: "Enter your password",
                      labelStyle: GoogleFonts.getFont("Nunito Sans",
                          fontSize: 14, letterSpacing: 0.1),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/icons/password.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                      suffixIcon: const Icon(Icons.visibility)),
                ),

                const SizedBox(
                  height: 20,
                ),

                // Sign Up Button
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      signUpUser();
                    } else {}
                  },
                  child: Container(
                    width: 319,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          colors: [Color(0xFF102DE1), Color(0xCC0D6EFF)]),
                    ),
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Sign Up",
                              style: GoogleFonts.getFont(
                                "Lato",
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // Sign in Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: GoogleFonts.getFont(
                        "Roboto",
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (page) => const LoginScreen()));
                      },
                      child: Text(
                        "Sign In",
                        style: GoogleFonts.getFont(
                          "Roboto",
                          color: const Color(0xCC0D6EFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
