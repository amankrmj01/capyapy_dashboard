import '../../../../core/utils/export_utils.dart';
import '../../../bloc/user/user_bloc.dart';

class ProjectDetailsSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const ProjectDetailsSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      color: AppColors.background(context),
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(12),
          border: Border(
            right: BorderSide(color: AppColors.border(context), width: 1),
          ),
        ),
        child: Column(
          children: [
            // Logo/Header
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      context.go("/dashboard/project");
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text('🚀', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CapyAPI',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        Text(
                          'Mock Service Hub',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildNavItem(
                    context,
                    icon: '🧭',
                    label: 'Overview',
                    index: 0,
                    isSelected: selectedIndex == 0,
                  ),
                  _buildNavItem(
                    context,
                    icon: '🗂️',
                    label: 'Data Models',
                    index: 1,
                    isSelected: selectedIndex == 1,
                  ),
                  _buildNavItem(
                    context,
                    icon: '💳',
                    label: 'Endpoints',
                    index: 2,
                    isSelected: selectedIndex == 2,
                  ),
                  _buildNavItem(
                    context,
                    icon: '⚙️',
                    label: 'Settings',
                    index: 3,
                    isSelected: selectedIndex == 3,
                  ),
                ],
              ),
            ),

            // User Profile Section
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is UserLoaded) {
                  final user = state.user;
                  final initials = (user.username.isNotEmpty)
                      ? user.username
                            .trim()
                            .split(' ')
                            .map((e) => e.isNotEmpty ? e[0] : '')
                            .take(2)
                            .join()
                            .toUpperCase()
                      : '';
                  return Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.border(context),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blue,
                          child: Text(
                            initials,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.username,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              Text(
                                user.email,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.textSecondary(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is UserError) {
                  return Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Error loading user',
                      style: GoogleFonts.inter(color: Colors.red),
                    ),
                  );
                }
                // Initial or other states
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  child: Text('No user info', style: GoogleFonts.inter()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onItemSelected(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: Colors.blue.withValues(alpha: 0.3))
                  : null,
            ),
            child: Row(
              children: [
                Text(icon, style: TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Colors.blue
                        : AppColors.textPrimary(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
