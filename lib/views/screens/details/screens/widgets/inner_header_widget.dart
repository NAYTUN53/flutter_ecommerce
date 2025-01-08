import 'package:flutter/material.dart';

class InnerHeaderWidget extends StatelessWidget {
  const InnerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.15,
      child: Stack(
        children: [
          Image.asset(
            "assets/icons/searchBanner.jpeg",
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),

          Positioned(
            top: 68,
            left: 6,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 68,
            left: 48,
            child: SizedBox(
              width: 250,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 16),
                  hintText: "Enter text",
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F7F7F),
                  ),
                  prefixIcon: Image.asset("assets/icons/searc1.png"),
                  suffixIcon: Image.asset("assets/icons/cam.png"),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
              ),
            ),
          ),

          // Notification Icon
          Positioned(
            top: 78,
            left: 354,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {},
                child: Ink(
                  height: 31,
                  width: 31,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/icons/bell.png"),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Message Icon
          Positioned(
            top: 78,
            left: 311,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {},
                child: Ink(
                  height: 31,
                  width: 31,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/icons/message.png"),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
