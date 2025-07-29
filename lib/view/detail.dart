import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class Detailscreen extends StatefulWidget {
  final String image, source, author, title, description;

  const Detailscreen({
    super.key,
    required this.image,
    required this.source,
    required this.author,
    required this.title,
    required this.description,
  });

  @override
  State<Detailscreen> createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
     appBar: AppBar(
       backgroundColor: Colors.black,
  elevation: 0,
  leading: IconButton(
    icon: Icon(Icons.arrow_back_ios, color: Colors.white), 
      onPressed: () {
      Navigator.pop(context); // Go back to the previous page
    },
  ),
),


// Set the background color here
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Container(
              height: height * 0.6,
              width: height * 0.9, // Adjusted width
              padding: EdgeInsets.symmetric(
                horizontal: height * 0.02,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: CachedNetworkImage(
                  imageUrl: widget.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    child: SpinKitCircle(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),

            // Text Content
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white, // White text for contrast
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: height * 0.02),

                  // Source Row
                  Row(
                    children: [
                      Text(
                        widget.source,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white, // White text for contrast
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 10), // Spacing between text
                    ],
                  ),
                  SizedBox(height: height * 0.03),

                  // Description
                  Text(
                    widget.description,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.white, // White text for contrast
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
