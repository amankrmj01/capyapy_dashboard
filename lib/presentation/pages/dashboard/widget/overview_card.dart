import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class OverviewCard extends StatefulWidget {
  final String title;
  final String value;
  final String subtitle;
  final String icon;
  final Color color;
  final String tooltip;
  final double? progress;
  final bool hasToggle;
  final bool isToggled;
  final VoidCallback? onToggle;

  const OverviewCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.tooltip,
    this.progress,
    this.hasToggle = false,
    this.isToggled = false,
    this.onToggle,
  });

  @override
  State<OverviewCard> createState() => _OverviewCardState();
}

class _OverviewCardState extends State<OverviewCard> {
  bool _isToggled = false;

  @override
  void initState() {
    super.initState();
    _isToggled = widget.isToggled;
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const Spacer(),
                  if (widget.hasToggle)
                    Switch(
                      value: _isToggled,
                      onChanged: (value) {
                        setState(() {
                          _isToggled = value;
                        });
                        widget.onToggle?.call();
                      },
                      activeThumbColor: widget.color,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.subtitle,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  widget.value,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ),
              if (widget.progress != null) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: widget.progress!,
                  backgroundColor: widget.color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
