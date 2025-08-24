import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController(
    text: 'Alex Johnson',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'alex.johnson@example.com',
  );

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildHeader(context),
        _buildPersonalDetails(context),
        _buildThemeSettings(context),
        _buildBillingDetails(context),
        _buildDocumentationHelp(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 120,
      collapsedHeight: 70,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final isCollapsed = constraints.maxHeight <= 80;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: isCollapsed
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: isCollapsed
                  ? AppColors.surface(context)
                  : Colors.transparent,
              borderRadius: isCollapsed
                  ? BorderRadius.circular(16)
                  : BorderRadius.zero,
              boxShadow: isCollapsed
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: FlexibleSpaceBar(
              background: Container(color: Colors.transparent),
              titlePadding: EdgeInsets.only(
                left: isCollapsed ? 20 : 24,
                bottom: isCollapsed ? 20 : 16,
                right: isCollapsed ? 20 : 24,
              ),
              title: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: isCollapsed
                    ? Row(
                        children: [
                          Text('⚙️', style: GoogleFonts.inter(fontSize: 20)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Settings',
                              style: GoogleFonts.inter(
                                color: AppColors.textPrimary(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isCollapsed ? 1.0 : 0.0,
                            child: Text(
                              'Tune CapyAPY to Your Vibe',
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary(context),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      )
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '⚙️ Settings',
                              style: GoogleFonts.inter(
                                color: AppColors.textPrimary(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tune CapyAPY to Your Vibe',
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary(context),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalDetails(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      sliver: SliverToBoxAdapter(
        child: _buildSettingsCard(
          context,
          title: '🧑 Personal Details',
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    child: Text('🐹', style: TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile Picture',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: _changeAvatar,
                          icon: const Icon(Icons.camera_alt, size: 18),
                          label: const Text('Change Avatar'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildTextField(
                context,
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                context,
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _updatePersonalInfo,
                  icon: const Icon(Icons.save),
                  label: const Text('Update Info'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSettings(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: _buildSettingsCard(
          context,
          title: '🎨 Theme Settings',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appearance',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: 12),
              BlocBuilder<ThemeCubit, AppThemeMode>(
                builder: (context, themeMode) {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildThemeTile(
                          context,
                          AppThemeMode.light,
                          'Light',
                          '☀️',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildThemeTile(
                          context,
                          AppThemeMode.dark,
                          'Dark',
                          '🌙',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillingDetails(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: _buildSettingsCard(
          context,
          title: '💳 Billing Details',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBillingItem(
                context,
                icon: Icons.credit_card,
                title: 'Payment Methods',
                subtitle: '•••• •••• •••• 4242',
                onTap: _managePaymentMethods,
              ),
              const Divider(height: 32),
              _buildBillingItem(
                context,
                icon: Icons.location_on,
                title: 'Billing Address',
                subtitle: '123 Developer St, Tech City, TC 12345',
                onTap: _updateBillingAddress,
              ),
              const Divider(height: 32),
              _buildBillingItem(
                context,
                icon: Icons.receipt,
                title: 'Download Invoices',
                subtitle: 'Get your billing history',
                onTap: _downloadInvoices,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentationHelp(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: _buildSettingsCard(
          context,
          title: '📚 Documentation & Help',
          child: Column(
            children: [
              _buildHelpItem(
                context,
                icon: '📖',
                title: 'CapyAPY Documentation',
                subtitle: 'Learn how to use all features',
                onTap: _openDocumentation,
              ),
              const Divider(height: 24),
              _buildHelpItem(
                context,
                icon: '❓',
                title: 'Frequently Asked Questions',
                subtitle: 'Quick answers to common questions',
                onTap: _openFAQ,
              ),
              const Divider(height: 24),
              _buildHelpItem(
                context,
                icon: '💬',
                title: 'Contact Support',
                subtitle: 'Capy\'s here to help! 🐹',
                onTap: _contactSupport,
              ),
              const Divider(height: 24),
              _buildHelpItem(
                context,
                icon: '🌟',
                title: 'Rate CapyAPY',
                subtitle: 'Help us improve with your feedback',
                onTap: _rateApp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
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

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: AppColors.background(context),
      ),
    );
  }

  Widget _buildThemeTile(
    BuildContext context,
    AppThemeMode mode,
    String title,
    String emoji,
  ) {
    final isSelected = context.read<ThemeCubit>().state == mode;

    return GestureDetector(
      onTap: () => context.read<ThemeCubit>().setTheme(mode),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withValues(alpha: 0.1)
              : AppColors.background(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? Colors.blue
                    : AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  // Action methods
  void _changeAvatar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Avatar change feature coming soon! 🐹')),
    );
  }

  void _updatePersonalInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Personal information updated successfully!'),
      ),
    );
  }

  void _managePaymentMethods() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment methods management coming soon!')),
    );
  }

  void _updateBillingAddress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Billing address update coming soon!')),
    );
  }

  void _downloadInvoices() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Downloading invoices...')));
  }

  void _openDocumentation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening CapyAPY documentation...')),
    );
  }

  void _openFAQ() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('❓ FAQ'),
        content: const Text(
          'Coming soon! We\'re preparing helpful answers for you.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💬 Contact Support'),
        content: const Text(
          'Capy\'s here to help! 🐹\n\nReach us at:\nsupport@capyapy.com\n\nOr use the chat widget in the bottom right.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🌟 Rate CapyAPY'),
        content: const Text(
          'Love CapyAPY? Help us by rating it in your app store!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thanks! Opening app store...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }
}
