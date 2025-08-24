import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String icon;
  final double? progress;
  final String? tooltip;
  final Color color;
  final bool hasToggle;
  final bool isToggled;
  final VoidCallback? onToggle;

  const OverviewCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.progress,
    this.tooltip,
    required this.color,
    this.hasToggle = false,
    this.isToggled = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12), // Reduced from 16
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row with icon and toggle/tooltip
              SizedBox(
                height: 36, // Fixed height for header
                child: Row(
                  children: [
                    Container(
                      width: 36, // Reduced from 40
                      height: 36, // Reduced from 40
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          icon,
                          style: TextStyle(fontSize: 18),
                        ), // Reduced from 20
                      ),
                    ),
                    const Spacer(),
                    if (hasToggle)
                      Transform.scale(
                        scale: 0.8, // Make switch smaller
                        child: Switch(
                          value: isToggled,
                          onChanged: (value) => onToggle?.call(),
                          activeColor: color,
                        ),
                      )
                    else if (tooltip != null)
                      Tooltip(
                        message: tooltip!,
                        child: Icon(
                          Icons.info_outline,
                          size: 14, // Reduced from 16
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 8), // Reduced from 12
              // Main content - use Expanded to take remaining space
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Value
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 20, // Reduced from 24
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2), // Reduced from 4
                    // Title
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 12, // Reduced from 14
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 1), // Reduced from 2
                    // Subtitle
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 10, // Reduced from 12
                        color: AppColors.textSecondary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Progress indicator (if provided) - make it more compact
              if (progress != null) ...[
                const SizedBox(height: 6), // Reduced from 12
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Usage',
                          style: GoogleFonts.inter(
                            fontSize: 8, // Reduced from 10
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                        Text(
                          '${(progress! * 100).toInt()}%',
                          style: GoogleFonts.inter(
                            fontSize: 8, // Reduced from 10
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2), // Reduced from 4
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.border(context),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 3, // Reduced from 4
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
