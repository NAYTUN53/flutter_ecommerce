import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/controls/auth_controller.dart';
import 'package:untitled/providers/user_provider.dart';
import 'package:untitled/services/manage_http_response.dart';

class ShippingAddressScreen extends ConsumerStatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  ConsumerState<ShippingAddressScreen> createState() =>
      _ShppingAddressScreenState();
}

class _ShppingAddressScreenState extends ConsumerState<ShippingAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _localityController;
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    // Read the current user data from the provider
    final user = ref.read(userProvider);

    //initialize the controller with the current data if available
    // if user data is not avalible, initialize with an empty string
    _stateController = TextEditingController(text: user?.state ?? "");
    _cityController = TextEditingController(text: user?.city ?? "");
    _localityController = TextEditingController(text: user?.locality ?? "");
  }

  // show loading diaglog
  _showLoadingDiaglog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Updating...",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final updateUser = ref.read(userProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.96),
        elevation: 0,
        title: Text(
          "Delivery",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Where will your order\n be shipped.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextFormField(
                  controller: _stateController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your state';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'State',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _cityController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your city';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'City',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _localityController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your locality';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Locality',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              _showLoadingDiaglog();

              await _authController
                  .updateUserAddress(
                context: context,
                id: user!.id,
                state: _stateController.text,
                city: _cityController.text,
                locality: _localityController.text,
                ref: ref,
              )
                  .whenComplete(() {
                updateUser.recreateUserState(
                    state: _stateController.text,
                    city: _cityController.text,
                    locality: _localityController.text);
                Navigator.pop(context); // this will close the diaglog
                Navigator.pop(
                    context); // this will close the current widget(screen) and back to the previous screen
              });
            } else {
              showSnackBar(context, "Please enter all field");
            }
          },
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF3854EE)),
            child: Center(
              child: Text(
                'Save',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
