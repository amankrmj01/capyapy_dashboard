import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../bloc/project_builder/project_builder_bloc.dart';
import '../../../bloc/project_builder/project_builder_event.dart';
import '../../../bloc/project_builder/project_builder_state.dart';
import '../../../../core/constants/app_colors.dart';
import 'steps/basic_info_step.dart';
import 'steps/auth_setup_step.dart';
import 'steps/data_models_step.dart';
import 'steps/endpoints_step.dart';

class ProjectCreationWizard extends StatelessWidget {
  final VoidCallback onClose;

  const ProjectCreationWizard({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBuilderBloc, ProjectBuilderState>(
      builder: (context, state) {
        if (state is ProjectBuilderCreating) {
          return _buildLoadingView(context);
        }

        if (state is ProjectBuilderInProgress) {
          return _buildWizardView(context, state);
        }

        // Handle initial state - show loading until wizard is ready
        if (state is ProjectBuilderInitial) {
          return Container(
            color: AppColors.background(context),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // Handle error state
        if (state is ProjectBuilderError) {
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

  Widget _buildWizardView(
    BuildContext context,
    ProjectBuilderInProgress state,
  ) {
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

  Widget _buildHeader(BuildContext context, ProjectBuilderInProgress state) {
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
                  _getStepTitle(state.currentStep),
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
    ProjectBuilderInProgress state,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index == state.currentStep;
          final isCompleted = index < state.currentStep;

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
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

  Widget _buildStepContent(
    BuildContext context,
    ProjectBuilderInProgress state,
  ) {
    switch (state.currentStep) {
      case 0:
        return BasicInfoStep(state: state);
      case 1:
        return AuthSetupStep(state: state);
      case 2:
        return DataModelsStep(state: state);
      case 3:
        return EndpointsStep(state: state);
      default:
        return Container();
    }
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    ProjectBuilderInProgress state,
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
          if (state.currentStep > 0)
            OutlinedButton.icon(
              onPressed: () {
                context.read<ProjectBuilderBloc>().add(const PreviousStep());
              },
              icon: Icon(Icons.arrow_back, size: 18),
              label: Text('Previous'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                side: BorderSide(color: AppColors.border(context)),
              ),
            ),
          const Spacer(),
          if (state.currentStep < 3)
            ElevatedButton.icon(
              onPressed: state.canProceedToNext
                  ? () {
                      context.read<ProjectBuilderBloc>().add(const NextStep());
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
                      context.read<ProjectBuilderBloc>().add(
                        const CreateProject(),
                      );
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

  Widget _buildLoadingView(BuildContext context) {
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

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Step 1: Basic Information';
      case 1:
        return 'Step 2: Authentication Setup';
      case 2:
        return 'Step 3: Data Models';
      case 3:
        return 'Step 4: API Endpoints';
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
        return 'Data Models';
      case 3:
        return 'Endpoints';
      default:
        return '';
    }
  }
}
