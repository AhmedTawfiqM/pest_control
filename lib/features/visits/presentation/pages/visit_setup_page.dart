import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_datetime.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/models/active_visit_model.dart';
import '../../../dashboard/data/models/customer_model.dart';
import '../../../dashboard/data/models/project_model.dart';

class VisitSetupPage extends StatefulWidget {
  static const String routeName = '/visit-setup';

  const VisitSetupPage({super.key});

  @override
  State<VisitSetupPage> createState() => _VisitSetupPageState();
}

class _VisitSetupPageState extends State<VisitSetupPage> {
  String? selectedCustomerId;
  String? selectedProjectId;

  // Debouncer for search optimization
  late final Debouncer _searchDebouncer;

  @override
  void initState() {
    super.initState();
    _searchDebouncer = Debouncer(milliseconds: 300);
  }

  @override
  void dispose() {
    _searchDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Visit'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ActiveVisitModel>(AppConstants.activeVisitBox).listenable(),
        builder: (context, Box<ActiveVisitModel> activeVisitBox, _) {
          final activeVisit = activeVisitBox.get(AppConstants.activeVisitKey);
          final isVisitActive = activeVisit != null;

          return ValueListenableBuilder(
            valueListenable: Hive.box<CustomerModel>(AppConstants.customerBox).listenable(),
            builder: (context, Box<CustomerModel> customerBox, _) {
              return ValueListenableBuilder(
                valueListenable: Hive.box<ProjectModel>(AppConstants.projectBox).listenable(),
                builder: (context, Box<ProjectModel> projectBox, _) {
                  final customers = customerBox.values.toList();
                  final projects = projectBox.values.toList();

                  // Filter projects based on selected customer
                  final filteredProjects = selectedCustomerId != null
                      ? projects.where((p) => p.customerId == selectedCustomerId).toList()
                      : <ProjectModel>[];

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Customer Selection - Always enabled
                        _buildSectionTitle('Select Customer'),
                        const SizedBox(height: 8),
                        _buildCustomerSelector(customers, isVisitActive),
                        const SizedBox(height: 24),

                        // Project Selection - Always shown, enabled only when customer selected
                        _buildSectionTitle('Select Project'),
                        const SizedBox(height: 8),
                        _buildProjectSelector(filteredProjects, isVisitActive, selectedCustomerId == null),
                        const SizedBox(height: 24),

                        // Visit Timer Section - Always shown, enabled only when project selected
                        _buildSectionTitle('Visit Session'),
                        const SizedBox(height: 16),
                        _buildTimerSection(context, customers, projects),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildCustomerSelector(List<CustomerModel> customers, bool isVisitActive) {
    if (customers.isEmpty) {
      return Card(
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey.shade600),
              const SizedBox(width: 12),
              const Text('No customers available'),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Autocomplete<CustomerModel>(
          displayStringForOption: (customer) => customer.name,
          optionsBuilder: (TextEditingValue textEditingValue) {
            // Support search with single character or more
            final searchText = textEditingValue.text.trim();

            // Return all customers if search is empty
            if (searchText.isEmpty) {
              return customers;
            }

            // Filter customers based on search query
            // This will work with any length of text including single characters
            return customers.where((customer) {
              return customer.name
                  .toLowerCase()
                  .startsWith(searchText.toLowerCase());
            });
          },
          optionsViewOpenDirection: OptionsViewOpenDirection.down,
          onSelected: !isVisitActive
              ? (CustomerModel customer) {
                  setState(() {
                    selectedCustomerId = customer.id;
                    selectedProjectId = null;
                  });
                }
              : null,
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            // Set initial value if customer is selected
            if (selectedCustomerId != null && textEditingController.text.isEmpty) {
              final selectedCustomer = customers.firstWhere(
                (c) => c.id == selectedCustomerId,
                orElse: () => customers.first,
              );
              textEditingController.text = selectedCustomer.name;
            }

            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              enabled: !isVisitActive,
              onChanged: !isVisitActive
                  ? (value) {
                      // Debounce search for better performance
                      _searchDebouncer.run(() {
                        if (mounted) {
                          setState(() {});
                        }
                      });
                    }
                  : null,
              decoration: InputDecoration(
                labelText: 'Select Customer',
                hintText: 'Search or select customer... (${customers.length} available)',
                prefixIcon: Icon(Icons.business, color: AppTheme.primaryGreen),
                suffixIcon: textEditingController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          textEditingController.clear();
                          _searchDebouncer.cancel();
                          setState(() {
                            selectedCustomerId = null;
                            selectedProjectId = null;
                          });
                        },
                      )
                    : const Icon(Icons.arrow_drop_down),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.primaryGreen, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            );
          },
          optionsViewBuilder: (
            BuildContext context,
            AutocompleteOnSelected<CustomerModel> onSelected,
            Iterable<CustomerModel> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final customer = options.elementAt(index);
                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.business,
                            color: AppTheme.primaryGreen,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          customer.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          onSelected(customer);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProjectSelector(List<ProjectModel> filteredProjects, bool isVisitActive, bool isDisabled) {
    final bool canInteract = !isVisitActive && !isDisabled;

    if (isDisabled) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Opacity(
          opacity: 0.5,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Select Project',
                hintText: 'Select customer first...',
                prefixIcon: Icon(Icons.assignment, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Autocomplete<ProjectModel>(
          displayStringForOption: (project) => project.name,
          optionsBuilder: (TextEditingValue textEditingValue) {
            // Support search with single character or more
            final searchText = textEditingValue.text.trim();

            // Return all projects if search is empty
            if (searchText.isEmpty) {
              return filteredProjects;
            }

            // Debounced search - filter projects based on search query
            // This will work with any length of text including single characters
            return filteredProjects.where((project) {
              return project.name
                  .toLowerCase()
                  .startsWith(searchText.toLowerCase());
            });
          },
          optionsViewOpenDirection: OptionsViewOpenDirection.down,
          onSelected: canInteract
              ? (ProjectModel project) {
                  setState(() {
                    selectedProjectId = project.id;
                  });
                }
              : null,
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            // Set initial value if project is selected
            if (selectedProjectId != null && textEditingController.text.isEmpty) {
              final selectedProject = filteredProjects.firstWhere(
                (p) => p.id == selectedProjectId,
                orElse: () => filteredProjects.isNotEmpty ? filteredProjects.first : ProjectModel(id: '', customerId: '', name: ''),
              );
              if (selectedProject.id.isNotEmpty) {
                textEditingController.text = selectedProject.name;
              }
            }

            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              enabled: canInteract,
              onChanged: canInteract
                  ? (value) {
                      // Debounce search for better performance
                      _searchDebouncer.run(() {
                        if (mounted) {
                          setState(() {});
                        }
                      });
                    }
                  : null,
              decoration: InputDecoration(
                labelText: 'Select Project',
                hintText: filteredProjects.isEmpty
                    ? 'No projects available'
                    : 'Search or select project... (${filteredProjects.length} available)',
                prefixIcon: Icon(Icons.assignment, color: AppTheme.secondaryOrange),
                suffixIcon: textEditingController.text.isNotEmpty && canInteract
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          textEditingController.clear();
                          _searchDebouncer.cancel();
                          setState(() {
                            selectedProjectId = null;
                          });
                        },
                      )
                    : const Icon(Icons.arrow_drop_down),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.secondaryOrange, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            );
          },
          optionsViewBuilder: (
            BuildContext context,
            AutocompleteOnSelected<ProjectModel> onSelected,
            Iterable<ProjectModel> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final project = options.elementAt(index);
                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryOrange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.assignment,
                            color: AppTheme.secondaryOrange,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          project.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          onSelected(project);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimerSection(BuildContext context, List<CustomerModel> customers, List<ProjectModel> projects) {
    final activeVisitBox = Hive.box<ActiveVisitModel>(AppConstants.activeVisitBox);
    final activeVisit = activeVisitBox.get(AppConstants.activeVisitKey);
    final isVisitActive = activeVisit != null;
    final canStartVisit = selectedCustomerId != null && selectedProjectId != null && !isVisitActive;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Opacity(
        opacity: canStartVisit || isVisitActive ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isVisitActive
                  ? [AppTheme.success, AppTheme.success.withValues(alpha: 0.8)]
                  : canStartVisit
                      ? [AppTheme.primaryGreen, AppTheme.primaryGreen.withValues(alpha: 0.8)]
                      : [Colors.grey, Colors.grey.withValues(alpha: 0.8)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                isVisitActive ? Icons.timer : Icons.play_circle_outline,
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                isVisitActive
                    ? 'Visit In Progress'
                    : canStartVisit
                        ? 'Ready to Start'
                        : 'Select Customer & Project',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: (canStartVisit || isVisitActive)
                      ? () async {
                          if (isVisitActive) {
                            _showEndVisitDialog(context);
                          } else {
                            // Get selected customer and project
                            final selectedCustomer = customers.firstWhere((c) => c.id == selectedCustomerId);
                            final selectedProject = projects.firstWhere((p) => p.id == selectedProjectId);

                            // Save active visit to Hive with UTC time
                            final newVisit = ActiveVisitModel(
                              customerId: selectedCustomer.id,
                              projectId: selectedProject.id,
                              customerName: selectedCustomer.name,
                              projectName: selectedProject.name,
                              startTimeUtc: AppDateTime.nowUtc(), // Store as UTC
                            );

                            await activeVisitBox.put(AppConstants.activeVisitKey, newVisit);

                            if (context.mounted) {
                              // Navigate back to dashboard
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Visit started successfully!'),
                                  backgroundColor: AppTheme.success,
                                ),
                              );
                            }
                          }
                        }
                      : null,
                  icon: Icon(
                    isVisitActive ? Icons.stop : Icons.play_arrow,
                    size: 28,
                  ),
                  label: Text(
                    isVisitActive ? 'End Visit' : 'Start Visit',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: isVisitActive
                        ? AppTheme.error
                        : canStartVisit
                            ? AppTheme.primaryGreen
                            : Colors.grey,
                    elevation: 0,
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

  void _showEndVisitDialog(BuildContext context) {
    final activeVisitBox = Hive.box<ActiveVisitModel>(AppConstants.activeVisitBox);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.warning),
            SizedBox(width: 8),
            Text('End Visit'),
          ],
        ),
        content: const Text(
          'Are you sure you want to end this visit?\n\n'
          'You will be asked to select team members who participated.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              // Clear active visit from Hive
              await activeVisitBox.delete(AppConstants.activeVisitKey);

              if (context.mounted) {
                // Navigate back to dashboard
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Visit ended successfully!'),
                    backgroundColor: AppTheme.success,
                  ),
                );
              }

              // TODO: Navigate to team selection screen and save visit to database
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('End Visit'),
          ),
        ],
      ),
    );
  }
}

