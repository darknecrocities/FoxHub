import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrgCard extends StatelessWidget {
  final Map<String, dynamic> org;
  final VoidCallback onTap;

  const OrgCard({super.key, required this.org, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.shade300, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            )
          ],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.asset(
                org["banner"],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Logo + Name
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(org["logo"]),
                    radius: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      org["name"],
                      style: GoogleFonts.pressStart2p(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                        shadows: [
                          Shadow(
                            color: Colors.orange.shade300,
                            blurRadius: 6,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
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
