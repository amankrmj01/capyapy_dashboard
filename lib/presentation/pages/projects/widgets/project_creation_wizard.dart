import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/project_creation/project_creation_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import 'steps/basic_info_step.dart';
import 'steps/auth_setup_step.dart';
import 'steps/storage_step.dart';
import 'steps/data_models_step.dart';
import 'steps/endpoints_step.dart';
import '../../../../data/datasource/mock_project_data_source.dart';

class ProjectCreationWizard extends StatelessWidget {
  final VoidCallback onClose;

  const ProjectCreationWizard({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCreationBloc, ProjectCreationState>(
      builder: (context, state) {
        if (state is ProjectCreationLoading) {
          return _DelayedLoadingView(
            key: const ValueKey('_delayedLoadingView'),
            onComplete: () async {
              debugPrint('Project creation started, waiting 2 seconds...');
              await Future.delayed(const Duration(seconds: 2));
              debugPrint('Navigating to /dashboard/project...');
              // Navigation is now handled by the widget itself.
            },
            navigateTo: '/dashboard/project',
          );
        }
        if (state is ProjectCreationInitial) {
          return _buildWizardView(context, state);
        }
        if (state is ProjectCreationSuccess) {
          // Add project to mock data source and close wizard
          Future.microtask(() {
            // Add to mock data source
            MockProjectDataSource.addProject(state.project);
            onClose();
          });
          return Container();
        }
        if (state is ProjectCreationError) {
          return Container(
            color: AppColors.background(context),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: GoogleFonts.inter(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: onClose, child: Text('Close')),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildWizardView(BuildContext context, ProjectCreationInitial state) {
    return Container(
      color: AppColors.background(context),
      child: Column(
        children: [
          _buildHeader(context, state),
          _buildProgressIndicator(context, state),
          Expanded(child: _buildStepContent(context, state)),
          _buildNavigationButtons(context, state),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProjectCreationInitial state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        border: Border(
          bottom: BorderSide(color: AppColors.border(context), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Text('🚀', style: TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New Project',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                Text(
                  _getStepTitle(state.step),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(Icons.close),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.background(context),
              side: BorderSide(color: AppColors.border(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(
    BuildContext context,
    ProjectCreationInitial state,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(5, (index) {
          final isActive = index == state.step;
          final isCompleted = index < state.step;

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 4 ? 8 : 0),
              child: Column(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: isCompleted || isActive
                          ? Colors.blue
                          : AppColors.border(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getStepLabel(index),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isCompleted || isActive
                          ? Colors.blue
                          : AppColors.textSecondary(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, ProjectCreationInitial state) {
    switch (state.step) {
      case 0:
        return BasicInfoStep(key: ValueKey('step0'), state: state);
      case 1:
        return AuthSetupStep(key: ValueKey('step1'), state: state);
      case 2:
        return StorageStep(key: ValueKey('step2'), state: state);
      case 3:
        return DataModelsStep(key: ValueKey('step3'), state: state);
      case 4:
        return EndpointsStep(key: ValueKey('step4'), state: state);
      default:
        return Container();
    }
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    ProjectCreationInitial state,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        border: Border(
          top: BorderSide(color: AppColors.border(context), width: 1),
        ),
      ),
      child: Row(
        children: [
          if (state.step > 0)
            OutlinedButton.icon(
              onPressed: () {
                context.read<ProjectCreationBloc>().add(PreviousStep());
              },
              icon: Icon(Icons.arrow_back, size: 18),
              label: Text('Previous'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                side: BorderSide(color: AppColors.border(context)),
              ),
            ),
          const Spacer(),
          if (state.step < 4)
            ElevatedButton.icon(
              onPressed: state.canProceedToNext
                  ? () {
                      context.read<ProjectCreationBloc>().add(NextStep());
                    }
                  : null,
              icon: Icon(Icons.arrow_forward, size: 18),
              label: Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: state.canProceedToNext
                  ? () {
                      context.read<ProjectCreationBloc>().add(CreateProject());
                    }
                  : null,
              icon: Icon(Icons.rocket_launch, size: 18),
              label: Text('Create Project'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
            ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Step 1: Basic Information';
      case 1:
        return 'Step 2: Authentication Setup';
      case 2:
        return 'Step 3: Storage Setup';
      case 3:
        return 'Step 4: Data Models';
      case 4:
        return 'Step 5: API Endpoints';
      default:
        return '';
    }
  }

  String _getStepLabel(int step) {
    switch (step) {
      case 0:
        return 'Basic Info';
      case 1:
        return 'Auth Setup';
      case 2:
        return 'Storage';
      case 3:
        return 'Data Models';
      case 4:
        return 'Endpoints';
      default:
        return '';
    }
  }
}

class _DelayedLoadingView extends StatefulWidget {
  final Future<void> Function() onComplete;
  final String? navigateTo;

  const _DelayedLoadingView({
    super.key,
    required this.onComplete,
    this.navigateTo,
  });

  @override
  State<_DelayedLoadingView> createState() => _DelayedLoadingViewState();
}

class _DelayedLoadingViewState extends State<_DelayedLoadingView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.onComplete();
      if (!mounted) return;
      if (widget.navigateTo != null) {
        GoRouter.of(context).go(widget.navigateTo!, extra: {'refresh': true});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Creating your project...',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Setting up your mock API service',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
