import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/controls/auth_controller.dart';
import 'package:untitled/providers/cart_provider.dart';
import 'package:untitled/providers/delivered_order_count_provider.dart';
import 'package:untitled/providers/favourite_provider.dart';
import 'package:untitled/providers/user_provider.dart';
import 'package:untitled/views/screens/details/screens/order_screen.dart';
import 'package:untitled/views/screens/shipping_address_screen.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final AuthController _authController = AuthController();

  void showSignOutDiaglog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              "Are you sure?",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              "Are you sure want to sign out?",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                  ),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    await _authController.signOutUser(
                        context: context, ref: ref);
                  },
                  child: Text(
                    "Sign Out",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final cartCount = ref.read(cartProvider);
    final favouriteCount = ref.read(favouriteProvider);

    final buyerId = ref.read(userProvider)!.id;
    ref
        .read(delveredOrderCountProvider.notifier)
        .fetchDeliveredOrderCount(buyerId, context);

    final deliveredOrderCount = ref.watch(delveredOrderCountProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 450,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.network(
                      "https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/FBrbGWQJqIbpA5ZHEpajYAEh1V93%2Fuploads%2Fimages%2F78dbff80_1dfe_1db2_8fe9_13f5839e17c1_bg2.png?alt=media",
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 20,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        "assets/icons/not.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      const Align(
                        alignment: Alignment(0, -0.53),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundImage: NetworkImage(
                              "https://cdn.pixabay.com/photo/2014/04/03/10/32/businessman-310819_1280.png"),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0.23, -0.61),
                        child: InkWell(
                          onTap: () {},
                          child: Image.asset(
                            "assets/icons/edit.png",
                            width: 19,
                            height: 19,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: const Alignment(0, 0.03),
                    child: user!.fullName != ''
                        ? Text(
                            user.fullName,
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white),
                          )
                        : Text(
                            "Username",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white),
                          ),
                  ),
                  Align(
                    alignment: const Alignment(0, 0.2),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ShippingAddressScreen();
                        }));
                      },
                      child: user.state != ''
                          ? Text(
                              user.state,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Text(
                              "State",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.9, 0.81),
                    child: SizedBox(
                      width: 287,
                      height: 117,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // complete region
                          Positioned(
                            left: 200,
                            top: 66,
                            child: Text(
                              deliveredOrderCount.toString(),
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Colors.white,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 170,
                            top: 99,
                            child: Text(
                              "Completed",
                              style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.white,
                                  letterSpacing: 0.3),
                            ),
                          ),
                          Positioned(
                            left: 180,
                            top: 2,
                            child: Container(
                              width: 52,
                              height: 58,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Ff0db1e22e37c1e2a001bbb5bd4b9aafc.png",
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                      left: 13,
                                      top: 17,
                                      child: Image.network(
                                          width: 26,
                                          height: 26,
                                          "https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F4ad2eb1752466c61c6bb41a0e223251a906a1a7bcorrect%201.png?alt=media&token=57abd4a6-50b4-4609-bb59-b48dce4c8cc6"))
                                ],
                              ),
                            ),
                          ),

                          // Favourite region
                          Positioned(
                            left: 90,
                            top: 66,
                            child: Text(
                              favouriteCount.length.toString(),
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Colors.white,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 65,
                            top: 99,
                            child: Text(
                              "Favourite",
                              style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.white,
                                  letterSpacing: 0.3),
                            ),
                          ),
                          Positioned(
                            left: 68,
                            top: 2,
                            child: Container(
                              width: 52,
                              height: 58,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Ff0db1e22e37c1e2a001bbb5bd4b9aafc.png",
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                      left: 15,
                                      top: 18,
                                      child: Image.network(
                                          width: 26,
                                          height: 26,
                                          "https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F068bdad59a9aff5a9ee67737678b8d5438866afewish-list%201.png?alt=media&token=4a8abc27-022f-4a53-8f07-8c10791468e4"))
                                ],
                              ),
                            ),
                          ),

                          // Cart region
                          Positioned(
                            left: -30,
                            top: 66,
                            child: Text(
                              cartCount.length.toString(),
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Colors.white,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          Positioned(
                            left: -32,
                            top: 99,
                            child: Text(
                              "Cart",
                              style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.white,
                                  letterSpacing: 0.3),
                            ),
                          ),
                          Positioned(
                            left: -47,
                            top: 0,
                            child: Container(
                              width: 52,
                              height: 58,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fe0080f58f1ec1f2200fcf329b10ce4c4.png",
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 13,
                                    top: 18,
                                    child: Image.network(
                                        width: 26,
                                        height: 26,
                                        "https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fc2afb7fb33cd20f4f1aed312669aa43b8bb2d431cart%20(2)%201.png?alt=media&token=be3d8494-1ccd-4925-91f1-ee30402dfb0e"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const OrderScreen();
                }));
              },
              leading: Image.asset("assets/icons/orders.png"),
              title: Text(
                "Track your order",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const OrderScreen();
                }));
              },
              leading: Image.asset("assets/icons/history.png"),
              title: Text(
                "History",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {},
              leading: Image.asset("assets/icons/help.png"),
              title: Text(
                "Help",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                showSignOutDiaglog(context);
              },
              leading: Image.asset("assets/icons/logout.png"),
              title: Text(
                "Logout",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
