import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset.clamp(0.0, 100.0);
    });
  }

  // Calculate progress from 0.0 to 1.0 based on scroll
  double get _transitionProgress => (_scrollOffset / 100.0).clamp(0.0, 1.0);

  // Calculate header height (120 -> 70)
  double get _headerHeight => 120.0 - (50.0 * _transitionProgress);

  // Calculate if we should show collapsed layout (starts fading in at 40% progress)
  double get _collapsedOpacity =>
      ((_transitionProgress - 0.4) / 0.6).clamp(0.0, 1.0);

  // Calculate expanded layout opacity (starts fading out at 20% progress)
  double get _expandedOpacity =>
      (1.0 - (_transitionProgress / 0.5)).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(height: _headerHeight + 20),
              // Dynamic space for floating header
              _buildCurrentPlan(context),
              _buildUsageStats(context),
              _buildBillingHistory(context),
              _buildPaymentMethods(context),
              const SizedBox(height: 32),
              // Bottom padding
            ],
          ),
        ),
        _buildFloatingHeader(context),
      ],
    );
  }

  Widget _buildFloatingHeader(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      // Faster for smoother scroll
      curve: Curves.easeOut,
      margin: EdgeInsets.lerp(
        const EdgeInsets.only(left: 24, right: 24, top: 16),
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        _transitionProgress,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.lerp(
          BorderRadius.circular(12),
          BorderRadius.circular(20),
          _transitionProgress,
        ),
        boxShadow: _transitionProgress > 0.3
            ? [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.1 * _transitionProgress,
                  ),
                  blurRadius: 12 * _transitionProgress,
                  offset: Offset(0, 4 * _transitionProgress),
                ),
              ]
            : null,
      ),
      child: Container(
        height: _headerHeight,
        padding: EdgeInsets.lerp(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          _transitionProgress,
        ),
        child: Stack(
          alignment: AlignmentGeometry.centerLeft,
          children: [
            // Expanded layout (fades out early)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: _expandedOpacity,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          '💳 Billing',
                          style: GoogleFonts.inter(
                            color: AppColors.textPrimary(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('💰', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage Your Subscription & Payments',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary(context),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Collapsed layout (fades in later)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: _collapsedOpacity,
              child: Row(
                children: [
                  Text('💳', style: GoogleFonts.inter(fontSize: 20)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Billing',
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Manage Your Subscription',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary(context),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text('💰', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPlan(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: _buildBillingCard(
        context,
        title: '🚀 Current Plan',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Professional Plan',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$29.99/month',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Billed monthly • Next payment: Sep 15, 2025',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'Active',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _viewAllPlans,
                    icon: const Icon(Icons.compare_arrows, size: 18),
                    label: const Text('Compare Plans'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _managePlan,
                    icon: const Icon(Icons.settings, size: 18),
                    label: const Text('Manage Plan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 3 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.6,
        children: [
          _buildUsageCard(
            context,
            icon: '📊',
            title: 'API Calls',
            current: '15,234',
            limit: '50,000',
            percentage: 0.3,
            color: Colors.blue,
          ),
          _buildUsageCard(
            context,
            icon: '🗂️',
            title: 'Projects',
            current: '8',
            limit: '25',
            percentage: 0.32,
            color: Colors.green,
          ),
          _buildUsageCard(
            context,
            icon: '💾',
            title: 'Storage',
            current: '2.1 GB',
            limit: '10 GB',
            percentage: 0.21,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildUsageCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String current,
    required String limit,
    required double percentage,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context), width: 1),
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
              Text(icon, style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '$current / $limit',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          const SizedBox(height: 4),
          Text(
            '${(percentage * 100).toInt()}% used',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingHistory(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: _buildBillingCard(
        context,
        title: '📋 Billing History',
        child: Column(
          children: [
            _buildInvoiceItem(
              context,
              date: 'Aug 15, 2025',
              amount: '\$29.99',
              status: 'Paid',
              statusColor: Colors.green,
            ),
            const Divider(height: 24),
            _buildInvoiceItem(
              context,
              date: 'Jul 15, 2025',
              amount: '\$29.99',
              status: 'Paid',
              statusColor: Colors.green,
            ),
            const Divider(height: 24),
            _buildInvoiceItem(
              context,
              date: 'Jun 15, 2025',
              amount: '\$29.99',
              status: 'Paid',
              statusColor: Colors.green,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _viewAllInvoices,
              icon: const Icon(Icons.receipt_long, size: 18),
              label: const Text('View All Invoices'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceItem(
    BuildContext context, {
    required String date,
    required String amount,
    required String status,
    required Color statusColor,
  }) {
    return Row(
      children: [
        Icon(Icons.receipt, color: AppColors.textSecondary(context), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Professional Plan',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),
              Text(
                date,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
        IconButton(
          onPressed: () => _downloadInvoice(date),
          icon: const Icon(Icons.download, size: 16),
          tooltip: 'Download Invoice',
        ),
      ],
    );
  }

  Widget _buildPaymentMethods(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: _buildBillingCard(
        context,
        title: '💳 Payment Methods',
        child: Column(
          children: [
            _buildPaymentMethodItem(
              context,
              cardType: 'Visa',
              lastFour: '4242',
              expiryDate: '12/27',
              isDefault: true,
            ),
            const Divider(height: 24),
            _buildPaymentMethodItem(
              context,
              cardType: 'Mastercard',
              lastFour: '8888',
              expiryDate: '09/26',
              isDefault: false,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _addPaymentMethod,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Payment Method'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodItem(
    BuildContext context, {
    required String cardType,
    required String lastFour,
    required String expiryDate,
    required bool isDefault,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 28,
          decoration: BoxDecoration(
            color: cardType == 'Visa'
                ? Colors.blue.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: cardType == 'Visa'
                  ? Colors.blue.withValues(alpha: 0.3)
                  : Colors.red.withValues(alpha: 0.3),
            ),
          ),
          child: Center(
            child: Text(
              cardType == 'Visa' ? 'VISA' : 'MC',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: cardType == 'Visa' ? Colors.blue : Colors.red,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '•••• •••• •••• $lastFour',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  if (isDefault) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Default',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                'Expires $expiryDate',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) => _handlePaymentMethodAction(value, lastFour),
          itemBuilder: (context) => [
            if (!isDefault)
              const PopupMenuItem(
                value: 'default',
                child: Text('Set as Default'),
              ),
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
          child: const Icon(Icons.more_vert, size: 16),
        ),
      ],
    );
  }

  Widget _buildBillingCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  // Action methods
  void _viewAllPlans() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening plan comparison... 📊')),
    );
  }

  void _managePlan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🚀 Manage Plan'),
        content: const Text(
          'You can upgrade, downgrade, or cancel your subscription here.\n\nWould you like to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Plan management coming soon!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _viewAllInvoices() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Loading all invoices... 📋')));
  }

  void _downloadInvoice(String date) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading invoice for $date... 📄')),
    );
  }

  void _addPaymentMethod() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💳 Add Payment Method'),
        content: const Text(
          'Add a new credit card or payment method to your account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment method setup coming soon!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Method'),
          ),
        ],
      ),
    );
  }

  void _handlePaymentMethodAction(String action, String lastFour) {
    switch (action) {
      case 'default':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Set •••• $lastFour as default payment method'),
          ),
        );
        break;
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edit payment method •••• $lastFour')),
        );
        break;
      case 'delete':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('🗑️ Delete Payment Method'),
            content: Text('Are you sure you want to delete •••• $lastFour?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Deleted payment method •••• $lastFour'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        break;
    }
  }
}
