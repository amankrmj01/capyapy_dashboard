import 'package:capyapy_dashboard/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/models.dart';

class DataModelsData extends StatelessWidget {
  final String collectionName;

  const DataModelsData({super.key, required this.collectionName});

  @override
  Widget build(BuildContext context) {
    int gridCount = 1;
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      gridCount = 4;
    } else if (width > 900) {
      gridCount = 3;
    } else if (width > 600) {
      gridCount = 2;
    }
    double aspectRatio = 1.5;

    double horizontalPadding = 48; // 24 padding on each side
    double availableWidth = width - horizontalPadding;
    double cardWidth = availableWidth / gridCount;
    if (cardWidth < 250) {
      aspectRatio = 1.2;
    } else if (cardWidth > 400) {
      aspectRatio = 1.8;
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.symmetric(horizontal: 120, vertical: 60),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Endpoint Stats',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: 3,
                itemBuilder: (context, index) =>
                    Container(height: 50, width: 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
