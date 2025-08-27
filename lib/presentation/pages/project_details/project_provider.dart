import 'package:flutter/widgets.dart';

import '../../../../../data/models/models.dart';

class ProjectProvider extends InheritedWidget {
  final dynamic project;
  final void Function(Project)? onProjectUpdated;

  const ProjectProvider({
    super.key,
    required super.child,
    required this.project,
    this.onProjectUpdated,
  });

  static ProjectProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProjectProvider>();
  }

  @override
  bool updateShouldNotify(ProjectProvider oldWidget) {
    return oldWidget.project != project ||
        oldWidget.onProjectUpdated != onProjectUpdated;
  }
}
