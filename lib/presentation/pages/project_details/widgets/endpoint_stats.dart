import '../../../../core/utils/export_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../data/models/models.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? color;
  final Color? iconColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: color ?? Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null)
              Center(
                child: Icon(
                  icon,
                  color: iconColor ?? color ?? Theme.of(context).primaryColor,
                  size: 32,
                ),
              ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textPrimary(context),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary(context),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (subtitle != null)
              Center(
                child: Text(
                  subtitle!,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class EndpointStatsDialog extends StatelessWidget {
  final Endpoint endpoint;
  final String basePath;

  const EndpointStatsDialog({
    super.key,
    required this.endpoint,
    required this.basePath,
  });

  @override
  Widget build(BuildContext context) {
    final analytics = endpoint.analytics;
    final mainStats = [
      StatCard(
        title: 'Method',
        value: endpoint.method.name.toUpperCase(),
        subtitle: 'Path: $basePath${endpoint.path}',
        icon: FontAwesomeIcons.codeBranch,
      ),
      StatCard(
        title: 'Total Calls',
        value: analytics.totalCalls.toString(),
        icon: FontAwesomeIcons.chartLine,
      ),
      StatCard(
        title: 'Successful Calls',
        value: analytics.successfulCalls.toString(),
        icon: FontAwesomeIcons.squareCheck,
        color: Colors.green[50],
      ),
      StatCard(
        title: 'Error Calls',
        value: analytics.errorCalls.toString(),
        icon: FontAwesomeIcons.squareXmark,
        color: Colors.red[50],
        iconColor: Colors.red[700],
      ),
      StatCard(
        title: 'Avg. Response Time',
        value: '${analytics.averageResponseTime.toStringAsFixed(2)} ms',
        icon: FontAwesomeIcons.stopwatch,
      ),
      StatCard(
        title: 'Last Called',
        value: analytics.lastCalledAt.toLocal().toString(),
        icon: FontAwesomeIcons.clock,
      ),
    ];
    final responseCodeCards = analytics.responseCodeCounts.entries
        .map(
          (e) => StatCard(
            title: 'Code ${e.key}',
            value: e.value.toString(),
            icon: FontAwesomeIcons.hashtag,
          ),
        )
        .toList();
    final recentCallCards = analytics.recentDataPoints
        .take(3)
        .map(
          (dp) => StatCard(
            title: 'Code ${dp.responseCode}',
            value: '${dp.responseTime} ms',
            subtitle: 'At: ${dp.timestamp.toLocal()}',
            icon: dp.isSuccessful
                ? FontAwesomeIcons.check
                : FontAwesomeIcons.xmark,
            color: dp.isSuccessful ? Colors.green[50] : Colors.red[50],
          ),
        )
        .toList();

    final List<Widget> allCards = [
      ...mainStats,
      if (responseCodeCards.isNotEmpty)
        StatCard(
          title: 'Response Codes',
          value: '',
          icon: FontAwesomeIcons.hashtag,
        ),
      ...responseCodeCards,
      if (recentCallCards.isNotEmpty)
        StatCard(
          title: 'Recent Calls',
          value: '',
          icon: FontAwesomeIcons.clock,
        ),
      ...recentCallCards,
    ];

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
                itemCount: allCards.length,
                itemBuilder: (context, index) => allCards[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
