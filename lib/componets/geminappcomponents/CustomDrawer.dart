import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade400,
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 35.0,
                    backgroundImage:  NetworkImage(
                      'https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg',
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Ps9',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Ps9.dev',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: Text(
                'Home',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.white),
              title: Text(
                'Favorites',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: Text(
                'Settings',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.white),
              title: Text(
                'Help',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}