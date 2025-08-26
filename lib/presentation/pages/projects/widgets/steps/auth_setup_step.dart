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
  String _customStrategyName = '';
  List<Map<String, String>> _customConfigFields = [];

  @override
  void initState() {
    super.initState();
    _hasAuth = widget.state.hasAuth;
    _selectedStrategy = 'oauth2';
    _selectedScopes = [];
    _customStrategyName = '';
    _customConfigFields = [];
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
    final strategies = ['oauth2', 'bearer', 'apiKey', 'custom'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Auth Strategy',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: _selectedStrategy,
          items: strategies
              .map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(s == 'custom' ? 'Custom...' : s),
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
            _dispatchAuthUpdate();
          },
        ),
        if (_selectedStrategy == 'custom') ...[
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(labelText: 'Custom Strategy Name'),
            onChanged: (val) {
              setState(() {
                _customStrategyName = val;
              });
              _dispatchAuthUpdate();
            },
          ),
          const SizedBox(height: 8),
          Text('Custom Config Fields', style: GoogleFonts.inter(fontSize: 14)),
          ..._customConfigFields.asMap().entries.map((entry) {
            final idx = entry.key;
            final field = entry.value;
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Key'),
                    controller: TextEditingController(text: field['key']),
                    onChanged: (val) {
                      setState(() {
                        _customConfigFields[idx]['key'] = val;
                      });
                      _dispatchAuthUpdate();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Value'),
                    controller: TextEditingController(text: field['value']),
                    onChanged: (val) {
                      setState(() {
                        _customConfigFields[idx]['value'] = val;
                      });
                      _dispatchAuthUpdate();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _customConfigFields.removeAt(idx);
                    });
                    _dispatchAuthUpdate();
                  },
                ),
              ],
            );
          }),
          TextButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Config Field'),
            onPressed: () {
              setState(() {
                _customConfigFields.add({'key': '', 'value': ''});
              });
              _dispatchAuthUpdate();
            },
          ),
        ],
      ],
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

  void _dispatchAuthUpdate() {
    if (_selectedStrategy == 'custom') {
      context.read<ProjectBuilderBloc>().add(
        UpdateAuthSettings(
          hasAuth: _hasAuth,
          authStrategy: AuthStrategy(
            type: AuthType.custom,
            config: {
              'customName': _customStrategyName,
              'customConfig': _customConfigFields,
              'scopes': _selectedScopes,
            },
          ),
        ),
      );
    } else {
      AuthType type;
      switch (_selectedStrategy) {
        case 'oauth2':
          type = AuthType.oauth2;
          break;
        case 'bearer':
          type = AuthType.bearer;
          break;
        case 'apiKey':
          type = AuthType.apiKey;
          break;
        case 'basic':
          type = AuthType.basic;
          break;
        default:
          type = AuthType.bearer;
      }
      context.read<ProjectBuilderBloc>().add(
        UpdateAuthSettings(
          hasAuth: _hasAuth,
          authStrategy: AuthStrategy(
            type: type,
            config: {'strategy': _selectedStrategy, 'scopes': _selectedScopes},
          ),
        ),
      );
    }
  }
}
