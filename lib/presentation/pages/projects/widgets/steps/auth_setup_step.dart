import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../bloc/project_creation/project_creation_bloc.dart';
import '../../../../bloc/project_creation/project_creation_event.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../bloc/project_creation/project_creation_state.dart';
import '../../../../../data/models/auth_strategy.dart';

class AuthSetupStep extends StatefulWidget {
  final ProjectCreationInitial state;

  const AuthSetupStep({super.key, required this.state});

  @override
  State<AuthSetupStep> createState() => _AuthSetupStepState();
}

class _AuthSetupStepState extends State<AuthSetupStep> {
  bool _hasAuth = false;
  String _selectedStrategy = 'oauth2';
  final List<String> _selectedScopes = [];
  String _customStrategyName = '';
  List<Map<String, String>> _customConfigFields = [];

  @override
  void initState() {
    super.initState();
    _hasAuth = widget.state.hasAuth;
    // Create a basic auth strategy if one exists
    if (widget.state.authStrategy != null) {
      _selectedStrategy = widget.state.authStrategy!.type.name;
    }
  }

  void _updateAuthSettings() {
    AuthStrategy? authStrategy;

    if (_hasAuth) {
      authStrategy = AuthStrategy(
        type: AuthType.values.firstWhere(
          (e) => e.name == _selectedStrategy,
          orElse: () => AuthType.oauth2,
        ),
        config: _getDefaultConfig(_selectedStrategy),
        requiredFields: _getRequiredFields(_selectedStrategy),
      );
    }

    context.read<ProjectCreationBloc>().add(
      UpdateAuthSettings(hasAuth: _hasAuth, authStrategy: authStrategy),
    );
  }

  Map<String, dynamic> _getDefaultConfig(String strategy) {
    switch (strategy) {
      case 'jwt':
        return {'algorithm': 'HS256', 'expiresIn': '1h', 'issuer': 'mock-api'};
      case 'apiKey':
        return {'header': 'X-API-Key', 'location': 'header'};
      case 'oauth2':
        return {
          'authorizationUrl': 'https://example.com/oauth/authorize',
          'tokenUrl': 'https://example.com/oauth/token',
          'scopes': _selectedScopes,
        };
      case 'bearer':
        return {'tokenType': 'Bearer', 'location': 'header'};
      case 'custom':
        return {'name': _customStrategyName, 'fields': _customConfigFields};
      default:
        return {};
    }
  }

  List<String> _getRequiredFields(String strategy) {
    switch (strategy) {
      case 'jwt':
        return ['secret', 'algorithm'];
      case 'apiKey':
        return ['apiKey'];
      case 'oauth2':
        return ['clientId', 'clientSecret'];
      case 'bearer':
        return ['token'];
      case 'custom':
        return _customConfigFields.map((field) => field['key'] ?? '').toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.runtimeType != ProjectCreationInitial) {
      return Container();
    }
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
    final strategies = ['oauth2', 'bearer', 'apiKey', 'jwt', 'custom'];
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
          Text(
            'Auth Strategy',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedStrategy,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: strategies
                .map(
                  (s) => DropdownMenuItem(
                    value: s,
                    child: Text(
                      s == 'custom' ? 'Custom...' : s.toUpperCase(),
                      style: GoogleFonts.inter(),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedStrategy = value!;
                if (value == 'custom') {
                  _customStrategyName = '';
                  _customConfigFields = [];
                }
              });
              _updateAuthSettings();
            },
          ),
          if (_selectedStrategy == 'custom') ...[
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Custom Strategy Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _customStrategyName = val;
                });
                _updateAuthSettings();
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Custom Config Fields',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: Icon(Icons.add, size: 16),
                  label: Text('Add Field'),
                  onPressed: () {
                    setState(() {
                      _customConfigFields.add({'key': '', 'value': ''});
                    });
                    _updateAuthSettings();
                  },
                ),
              ],
            ),
            ..._customConfigFields.asMap().entries.map((entry) {
              final idx = entry.key;
              final field = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Key',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        initialValue: field['key'],
                        onChanged: (val) {
                          setState(() {
                            _customConfigFields[idx]['key'] = val;
                          });
                          _updateAuthSettings();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Value',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        initialValue: field['value'],
                        onChanged: (val) {
                          setState(() {
                            _customConfigFields[idx]['value'] = val;
                          });
                          _updateAuthSettings();
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _customConfigFields.removeAt(idx);
                        });
                        _updateAuthSettings();
                      },
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
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
}
