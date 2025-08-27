import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/models/models.dart';
import '../../../../bloc/project_creation/project_creation_bloc.dart';

class StorageStep extends StatefulWidget {
  final ProjectCreationInitial state;

  const StorageStep({super.key, required this.state});

  @override
  State<StorageStep> createState() => _StorageStepState();
}

class _StorageStepState extends State<StorageStep> {
  late bool _hasStorage;
  late StorageType _selectedStorageType;
  late String _connectionString;
  late String _databaseName;
  late Map<String, dynamic> _options;

  @override
  void initState() {
    super.initState();
    _hasStorage = widget.state.hasStorage;
    final config = widget.state.storageConfig;
    _selectedStorageType = config?.type ?? StorageType.mongodb;
    _connectionString = config?.connectionString ?? '';
    _databaseName = config?.databaseName ?? '';
    _options = Map<String, dynamic>.from(config?.options ?? {});
  }

  void _updateStorageSettings() {
    StorageConfig? config;
    if (_hasStorage) {
      config = StorageConfig(
        type: _selectedStorageType,
        connectionString: _connectionString,
        databaseName: _databaseName,
        options: _options,
      );
    }
    context.read<ProjectCreationBloc>().add(
      UpdateStorageSettings(storageConfig: config),
    );
  }

  void _addOption(String key, String value) {
    setState(() {
      _options[key] = value;
    });
    _updateStorageSettings();
  }

  void _removeOption(String key) {
    setState(() {
      _options.remove(key);
    });
    _updateStorageSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Storage Setup',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 16),
        SwitchListTile(
          title: Text('Enable Storage'),
          value: _hasStorage,
          onChanged: (val) {
            setState(() {
              _hasStorage = val;
            });
            _updateStorageSettings();
          },
        ),
        if (_hasStorage) ...[
          SizedBox(height: 16),
          DropdownButtonFormField<StorageType>(
            initialValue: _selectedStorageType,
            items: StorageType.values
                .map(
                  (type) =>
                      DropdownMenuItem(value: type, child: Text(type.name)),
                )
                .toList(),
            onChanged: (val) {
              setState(() {
                _selectedStorageType = val!;
              });
              _updateStorageSettings();
            },
            decoration: InputDecoration(labelText: 'Storage Type'),
          ),
          SizedBox(height: 16),
          TextFormField(
            initialValue: _connectionString,
            decoration: InputDecoration(labelText: 'Connection String'),
            onChanged: (val) {
              setState(() {
                _connectionString = val;
              });
              _updateStorageSettings();
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            initialValue: _databaseName,
            decoration: InputDecoration(labelText: 'Database Name'),
            onChanged: (val) {
              setState(() {
                _databaseName = val;
              });
              _updateStorageSettings();
            },
          ),
          SizedBox(height: 16),
          Text('Options', style: Theme.of(context).textTheme.titleMedium),
          ..._options.entries.map(
            (entry) => Row(
              children: [
                Expanded(child: Text('${entry.key}: ${entry.value}')),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removeOption(entry.key),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'Key'),
                  onFieldSubmitted: (key) {
                    if (key.isNotEmpty) {
                      _addOption(key, '');
                    }
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'Value'),
                  onFieldSubmitted: (value) {
                    // Optionally handle value input
                  },
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
