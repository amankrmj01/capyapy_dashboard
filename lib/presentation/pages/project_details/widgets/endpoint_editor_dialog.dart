import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../../data/models/models.dart';

class EndpointEditorDialog extends StatefulWidget {
  final Endpoint? endpoint;
  final Function(Endpoint) onSave;

  const EndpointEditorDialog({super.key, this.endpoint, required this.onSave});

  @override
  State<EndpointEditorDialog> createState() => _EndpointEditorDialogState();
}

class _EndpointEditorDialogState extends State<EndpointEditorDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _pathController;
  late TextEditingController _descriptionController;
  late TextEditingController _responseBodyController;
  late TextEditingController _requestBodyController;

  HttpMethod _selectedMethod = HttpMethod.get;
  bool _authRequired = false;
  String _responseStatus = '200';
  String _responseContentType = 'application/json';
  String _requestContentType = 'application/json';
  Map<String, String> _pathParams = {};
  Map<String, String> _queryParams = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    final endpoint = widget.endpoint;
    _pathController = TextEditingController(text: endpoint?.path ?? '');
    _descriptionController = TextEditingController(
      text: endpoint?.description ?? '',
    );
    _responseBodyController = TextEditingController(
      text: endpoint?.response.schema.toString() ?? '{}',
    );
    _requestBodyController = TextEditingController();

    if (endpoint != null) {
      _selectedMethod = endpoint.method;
      _authRequired = endpoint.authRequired;
      _responseStatus = endpoint.response.statusCode.toString();
      _responseContentType = endpoint.response.contentType;
      _pathParams = Map.from(endpoint.pathParams ?? {});
      _queryParams = Map.from(endpoint.queryParams ?? {});

      if (endpoint.request != null) {
        _requestContentType = endpoint.request!.contentType;
        _requestBodyController.text = endpoint.request!.bodySchema.toString();
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pathController.dispose();
    _descriptionController.dispose();
    _responseBodyController.dispose();
    _requestBodyController.dispose();
    super.dispose();
  }

  void _save() {
    if (_pathController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter an endpoint path',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    RequestConfig? request;
    if (_selectedMethod != HttpMethod.get &&
        _requestBodyController.text.isNotEmpty) {
      try {
        request = RequestConfig(
          contentType: _requestContentType,
          bodySchema: {
            'type': 'object',
            'example': _requestBodyController.text,
          },
        );
      } catch (e) {
        // Handle invalid JSON
        debugPrint('Error parsing request body: $e');
      }
    }

    final endpoint = ProjectEndpoint(
      id:
          widget.endpoint?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      path: _pathController.text,
      method: _selectedMethod,
      description: _descriptionController.text,
      authRequired: _authRequired,
      request: request,
      response: ResponseConfig(
        statusCode: int.parse(_responseStatus),
        contentType: _responseContentType,
        schema: _parseResponseBody(_responseBodyController.text),
      ),
      pathParams: _pathParams.isEmpty ? null : _pathParams,
      queryParams: _queryParams.isEmpty ? null : _queryParams,
      analytics:
          widget.endpoint?.analytics ??
          EndpointAnalytics(lastCalledAt: DateTime.now()),
      createdAt: widget.endpoint?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      // Call the onSave callback provided by the parent
      widget.onSave(endpoint);
      // Don't close the dialog here - let the parent handle it
    } catch (e, stackTrace) {
      debugPrint(
        'Error in EndpointEditorDialog onSave:\nException: $e\nStackTrace: $stackTrace',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Map<String, dynamic> _parseResponseBody(String body) {
    try {
      // Try to parse as JSON, if it fails return a simple schema
      return {'example': body, 'type': 'object'};
    } catch (e) {
      return {'example': body, 'type': 'string'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBasicTab(),
                  _buildRequestTab(),
                  _buildResponseTab(),
                  _buildParametersTab(),
                ],
              ),
            ),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border(context))),
      ),
      child: Row(
        children: [
          Icon(Icons.api, color: AppColors.primary(context), size: 24),
          const SizedBox(width: 12),
          Text(
            widget.endpoint == null ? 'Create Endpoint' : 'Edit Endpoint',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: AppColors.textSecondary(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      labelColor: AppColors.primary(context),
      unselectedLabelColor: AppColors.textSecondary(context),
      indicatorColor: AppColors.primary(context),
      tabs: const [
        Tab(text: 'Basic'),
        Tab(text: 'Request'),
        Tab(text: 'Response'),
        Tab(text: 'Parameters'),
      ],
    );
  }

  Widget _buildBasicTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HTTP Method',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<HttpMethod>(
                      initialValue: _selectedMethod,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: HttpMethod.values.map((method) {
                        return DropdownMenuItem(
                          value: method,
                          child: Text(
                            method.name.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: _getMethodColor(method),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMethod = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _buildTextField(
                  'Endpoint Path',
                  _pathController,
                  'e.g., /users/{id}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTextField(
            'Description',
            _descriptionController,
            'Brief description of what this endpoint does',
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: _authRequired,
                onChanged: (value) {
                  setState(() {
                    _authRequired = value ?? false;
                  });
                },
                activeColor: AppColors.primary(context),
              ),
              Text(
                'Requires Authentication',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequestTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
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
                      'Content Type',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _requestContentType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items:
                          [
                            'application/json',
                            'application/x-www-form-urlencoded',
                            'multipart/form-data',
                            'text/plain',
                          ].map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(
                                type,
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _requestContentType = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Request Body Schema/Example',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: _requestBodyController,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                hintText: _selectedMethod == HttpMethod.get
                    ? 'GET requests typically don\'t have a request body'
                    : 'Enter request body example or schema',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                alignLabelWithHint: true,
              ),
              style: GoogleFonts.sourceCodePro(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
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
                      'Status Code',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: int.parse(_responseStatus),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: [200, 201, 400, 401, 403, 404, 500].map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(
                            '$status',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: _getStatusColor(status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _responseStatus = value.toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Content Type',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _responseContentType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items:
                          [
                            'application/json',
                            'text/plain',
                            'text/html',
                            'application/xml',
                          ].map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(
                                type,
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _responseContentType = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Response Body Example',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: _responseBodyController,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                hintText: 'Enter expected response body',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                alignLabelWithHint: true,
              ),
              style: GoogleFonts.sourceCodePro(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParametersTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildParameterSection(
                    'Path Parameters',
                    _pathParams,
                    'e.g., id, userId',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildParameterSection(
                    'Query Parameters',
                    _queryParams,
                    'e.g., page, limit',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParameterSection(
    String title,
    Map<String, String> params,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  params[''] = '';
                });
              },
              icon: Icon(Icons.add, color: AppColors.primary(context)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: params.isEmpty
              ? Center(
                  child: Text(
                    'No parameters added',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: params.length,
                  itemBuilder: (context, index) {
                    final key = params.keys.elementAt(index);
                    final value = params[key] ?? '';
                    final keyController = TextEditingController(text: key);
                    final valueController = TextEditingController(text: value);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: keyController,
                              decoration: InputDecoration(
                                labelText: 'Parameter',
                                hintText: hint,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              style: GoogleFonts.inter(fontSize: 14),
                              onChanged: (newKey) {
                                setState(() {
                                  if (key != newKey) {
                                    params.remove(key);
                                    params[newKey] = valueController.text;
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: valueController,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              style: GoogleFonts.inter(fontSize: 14),
                              onChanged: (newValue) {
                                setState(() {
                                  params[key] = newValue;
                                });
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                params.remove(key);
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary(context)),
            ),
          ),
          style: GoogleFonts.inter(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border(context))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: AppColors.textSecondary(context)),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              widget.endpoint == null ? 'Create Endpoint' : 'Save Changes',
              style: GoogleFonts.inter(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getMethodColor(HttpMethod method) {
    switch (method) {
      case HttpMethod.get:
        return Colors.green;
      case HttpMethod.post:
        return Colors.blue;
      case HttpMethod.put:
        return Colors.orange;
      case HttpMethod.delete:
        return Colors.red;
      case HttpMethod.patch:
        return Colors.purple;
    }
  }

  Color _getStatusColor(int status) {
    if (status >= 200 && status < 300) return Colors.green;
    if (status >= 300 && status < 400) return Colors.orange;
    if (status >= 400) return Colors.red;
    return Colors.grey;
  }
}
