import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubcategoryTileWidget extends StatelessWidget {
  final String image;
  final String title;

  const SubcategoryTileWidget(
      {super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                )),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 110,
            child: Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
