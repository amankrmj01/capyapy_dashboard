import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class NotificationsSection extends StatelessWidget {
  const NotificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _NotificationItem(
        icon: '🚀',
        title: 'New Project Created',
        description: 'E-commerce API has been successfully deployed',
        time: '2 hours ago',
        type: NotificationType.success,
      ),
      _NotificationItem(
        icon: '⚠️',
        title: 'API Rate Limit Warning',
        description: 'You\'re approaching your daily API call limit',
        time: '4 hours ago',
        type: NotificationType.warning,
      ),
      _NotificationItem(
        icon: '🔄',
        title: 'System Maintenance',
        description: 'Scheduled maintenance tonight at 2:00 AM UTC',
        time: '1 day ago',
        type: NotificationType.info,
      ),
      _NotificationItem(
        icon: '✅',
        title: 'Backup Completed',
        description: 'All project data has been backed up successfully',
        time: '2 days ago',
        type: NotificationType.success,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '🔔 Recent Notifications',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all notifications
                },
                child: Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...notifications
              .map(
                (notification) => _buildNotificationTile(context, notification),
              )
              ,
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    _NotificationItem notification,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getNotificationColor(notification.type).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getNotificationColor(
            notification.type,
          ).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getNotificationColor(
                notification.type,
              ).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(notification.icon, style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary(context),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                notification.time,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.textSecondary(context),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.info:
        return Colors.blue;
    }
  }
}

enum NotificationType { success, warning, error, info }

class _NotificationItem {
  final String icon;
  final String title;
  final String description;
  final String time;
  final NotificationType type;

  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
  });
}
