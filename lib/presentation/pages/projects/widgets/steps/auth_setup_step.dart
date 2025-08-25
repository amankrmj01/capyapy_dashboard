import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../data/models/auth_strategy.dart';
import '../../../../bloc/project_builder/project_builder_bloc.dart';
import '../../../../bloc/project_builder/project_builder_event.dart';
import '../../../../bloc/project_builder/project_builder_state.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../data/models/project_model.dart';

class AuthSetupStep extends StatefulWidget {
  final ProjectBuilderInProgress state;

  const AuthSetupStep({super.key, required this.state});

  @override
  State<AuthSetupStep> createState() => _AuthSetupStepState();
}

class _AuthSetupStepState extends State<AuthSetupStep> {
  bool _hasAuth = false;
  String _selectedStrategy = 'oauth2';
  List<String> _selectedScopes = [];

  @override
  void initState() {
    super.initState();
    _hasAuth = widget.state.hasAuth;
    _selectedStrategy = widget.state.authStrategy?.strategy ?? 'oauth2';
    _selectedScopes = widget.state.authStrategy?.scopes ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 32),
          _buildAuthToggle(context),
          if (_hasAuth) ...[
            const SizedBox(height: 32),
            _buildAuthStrategy(context),
            const SizedBox(height: 24),
            _buildScopesSection(context),
          ],
          const SizedBox(height: 32),
          _buildInfoSection(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('🔐', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              'Authentication Setup',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Configure authentication for your API endpoints. You can always change these settings later.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary(context),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthToggle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context)),
      ),
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
                      'Enable Authentication',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add authentication to protect your API endpoints',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _hasAuth,
                onChanged: (value) {
                  setState(() {
                    _hasAuth = value;
                  });
                  _updateAuthSettings();
                },
                activeThumbColor: Colors.blue,
              ),
            ],
          ),
          if (_hasAuth) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'A default User model will be automatically added to your data models with username, password, and email fields.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAuthStrategy(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Authentication Strategy',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildStrategyOption(
              context,
              'oauth2',
              '🔑 OAuth 2.0',
              'Industry standard for secure authorization',
              isSelected: _selectedStrategy == 'oauth2',
            ),
            _buildStrategyOption(
              context,
              'jwt',
              '🎫 JWT Tokens',
              'JSON Web Tokens for stateless authentication',
              isSelected: _selectedStrategy == 'jwt',
            ),
            _buildStrategyOption(
              context,
              'apikey',
              '🗝️ API Key',
              'Simple API key-based authentication',
              isSelected: _selectedStrategy == 'apikey',
            ),
            _buildStrategyOption(
              context,
              'basic',
              '🔐 Basic Auth',
              'Username and password authentication',
              isSelected: _selectedStrategy == 'basic',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStrategyOption(
    BuildContext context,
    String strategy,
    String title,
    String description, {
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedStrategy = strategy;
        });
        _updateAuthSettings();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withValues(alpha: 0.1)
              : AppColors.surface(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : AppColors.border(context),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.blue
                    : AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary(context),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScopesSection(BuildContext context) {
    final availableScopes = [
      'read:users',
      'write:users',
      'delete:users',
      'read:projects',
      'write:projects',
      'admin:all',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Permission Scopes',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select the permissions your API will support',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary(context),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableScopes.map((scope) {
            final isSelected = _selectedScopes.contains(scope);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedScopes.remove(scope);
                  } else {
                    _selectedScopes.add(scope);
                  }
                });
                _updateAuthSettings();
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : AppColors.surface(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.blue : AppColors.border(context),
                  ),
                ),
                child: Text(
                  scope,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textPrimary(context),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                'Pro Tip',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'You can start without authentication and add it later. This is useful for prototyping and testing your API structure first.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.orange.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _updateAuthSettings() {
    AuthStrategy? strategy;
    if (_hasAuth) {
      // Map the selected strategy to AuthType enum
      AuthType authType;
      switch (_selectedStrategy) {
        case 'oauth2':
          authType = AuthType.oauth2;
          break;
        case 'jwt':
          authType = AuthType.bearer;
          break;
        case 'apikey':
          authType = AuthType.apiKey;
          break;
        case 'basic':
          authType = AuthType.basic;
          break;
        default:
          authType = AuthType.bearer;
      }

      strategy = AuthStrategy(
        type: authType,
        config: {'strategy': _selectedStrategy, 'scopes': _selectedScopes},
      );
    }

    context.read<ProjectBuilderBloc>().add(
      UpdateAuthSettings(hasAuth: _hasAuth, authStrategy: strategy),
    );
  }
}
