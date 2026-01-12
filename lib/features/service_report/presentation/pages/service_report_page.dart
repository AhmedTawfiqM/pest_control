import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/active_visit_model.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/pest_icon_helper.dart';
import '../../../visits/data/models/visit_model.dart';
import '../../data/models/pest_model.dart';
import '../../data/models/chemical_model.dart';
import '../../data/models/service_report_model.dart';

class ServiceReportPage extends StatefulWidget {
  static const String routeName = '/service-report';

  const ServiceReportPage({super.key});

  @override
  State<ServiceReportPage> createState() => _ServiceReportPageState();
}

class _ServiceReportPageState extends State<ServiceReportPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controlled pests (dropped into container)
  final List<PestModel> _controlledPests = [];

  // Chemical usage tracking
  final Map<String, TextEditingController> _chemicalQuantities = {};
  final Map<String, bool> _selectedChemicals = {};

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var controller in _chemicalQuantities.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ValueListenableBuilder(
      valueListenable: Hive.box<ActiveVisitModel>(AppConstants.activeVisitBox).listenable(),
      builder: (context, Box<ActiveVisitModel> box, _) {
        final activeVisit = box.get(AppConstants.activeVisitKey);

        if (activeVisit == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.serviceReport)),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noActiveVisit,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.startVisitToCreateReport,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: Text(l10n.backToDashboard),
                  ),
                ],
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(l10n.serviceReport),
              backgroundColor: AppTheme.primaryGreen,
              elevation: 0,
              bottom: TabBar(
                controller: _tabController,
                isScrollable: false,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.6),
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                tabs: [
                  Tab(icon: const Icon(Icons.bug_report), text: l10n.pestControl),
                  Tab(icon: const Icon(Icons.science), text: l10n.chemicals),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildPestControlTab(),
                _buildChemicalsTab(),
              ],
            ),
            bottomNavigationBar: _buildSubmitButton(activeVisit),
          ),
        );
      },
    );
  }

  Widget _buildPestControlTab() {
    final l10n = AppLocalizations.of(context);

    return ValueListenableBuilder(
      valueListenable: Hive.box<PestModel>(AppConstants.pestBox).listenable(),
      builder: (context, Box<PestModel> pestBox, _) {
        final allPests = pestBox.values.toList();
        final availablePests = allPests
            .where((pest) => !_controlledPests.any((cp) => cp.id == pest.id))
            .toList();

        return Column(
          children: [
            // Instructions
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: AppTheme.info.withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(Icons.touch_app, color: AppTheme.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.dragDropPests,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Row(
                children: [
                  // Available Pests (Left Side)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            l10n.availablePests,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        Expanded(
                          child: availablePests.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle,
                                        size: 48,
                                        color: Colors.grey[400]
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        l10n.allPestsControlled,
                                        style: TextStyle(color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: availablePests.length,
                                  itemBuilder: (context, index) {
                                    final pest = availablePests[index];
                                    return _buildDraggablePest(pest);
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Container(width: 2, color: Colors.grey[300]),

                  // Controlled Container (Right Side)
                  Expanded(
                    child: _buildControlledContainer(l10n),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDraggablePest(PestModel pest) {
    return Draggable<PestModel>(
      data: pest,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PestIconHelper.getPestIconWidget(pest.name, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                pest.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildPestCard(pest, isDragging: true),
      ),
      child: _buildPestCard(pest),
    );
  }

  Widget _buildPestCard(PestModel pest, {bool isDragging = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isDragging ? 0 : 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              pest.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: PestIconHelper.getPestIconWidget(pest.name, color: Colors.orange, size: 24),
                ),
                const SizedBox(width: 12),

                // Name and ID Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      const SizedBox(height: 4),
                      Text(
                        'ID: ${pest.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Drag Indicator
                const SizedBox(width: 8),
                const Icon(Icons.drag_indicator, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlledContainer(AppLocalizations l10n) {
    return DragTarget<PestModel>(
      onAccept: (pest) {
        setState(() {
          _controlledPests.add(pest);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${pest.name} added to controlled pests'),
            backgroundColor: AppTheme.success,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppTheme.success),
                  const SizedBox(width: 8),
                  Text(
                    '${l10n.controlledPestsWithCount} (${_controlledPests.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.success,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isHovering
                      ? AppTheme.success.withOpacity(0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isHovering ? AppTheme.success : Colors.grey[300]!,
                    width: isHovering ? 3 : 2,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: _controlledPests.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.download_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.dropPestsHere,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.dragControlledPestsIntoThisArea,
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _controlledPests.length,
                        itemBuilder: (context, index) {
                          final pest = _controlledPests[index];
                          return _buildControlledPestItem(pest, index);
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildControlledPestItem(PestModel pest, int index) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (value * 0.2),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 4,
        shadowColor: AppTheme.success.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppTheme.success,
            width: 2,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.success.withValues(alpha: 0.15),
                AppTheme.success.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Pest-specific icon
                PestIconHelper.getPestIconWithSeverityColor(
                  pest.name,
                  size: 20,
                ),
                const SizedBox(width: 12),

                // Pest Name - takes most space
                Expanded(
                  child: Text(
                    pest.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppTheme.success,
                      letterSpacing: 0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 8),

                // Remove Button - smaller and simpler
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _controlledPests.removeAt(index);
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.error.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppTheme.error,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChemicalsTab() {
    final l10n = AppLocalizations.of(context);

    return ValueListenableBuilder(
      valueListenable: Hive.box<ChemicalModel>(AppConstants.chemicalBox).listenable(),
      builder: (context, Box<ChemicalModel> chemicalBox, _) {
        final chemicals = chemicalBox.values.toList();

        return Column(
          children: [
            // Instructions
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: AppTheme.info.withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(Icons.science, color: AppTheme.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.selectChemicals,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: chemicals.isEmpty
                  ? Center(child: Text(l10n.noChemicalsAvailable))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: chemicals.length,
                      itemBuilder: (context, index) {
                        final chemical = chemicals[index];
                        return _buildChemicalItem(chemical);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChemicalItem(ChemicalModel chemical) {
    final l10n = AppLocalizations.of(context);

    _selectedChemicals.putIfAbsent(chemical.id, () => false);
    _chemicalQuantities.putIfAbsent(
      chemical.id,
      () => TextEditingController(),
    );

    final isSelected = _selectedChemicals[chemical.id] ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isSelected ? 4 : 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      _selectedChemicals[chemical.id] = value ?? false;
                      if (!value!) {
                        _chemicalQuantities[chemical.id]?.clear();
                      }
                    });
                  },
                  activeColor: AppTheme.primaryGreen,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chemical.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${chemical.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    chemical.unit.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryOrange,
                    ),
                  ),
                ),
              ],
            ),

            if (isSelected) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _chemicalQuantities[chemical.id],
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  // Dismiss keyboard when Done button is pressed
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  labelText: '${l10n.quantity} (${chemical.unit})',
                  hintText: l10n.enterQuantity,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.edit),
                  suffixText: chemical.unit,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(ActiveVisitModel activeVisit) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    Icons.bug_report,
                    l10n.pests,
                    _controlledPests.length.toString(),
                    AppTheme.success,
                  ),
                  Container(width: 1, height: 30, color: Colors.grey[300]),
                  _buildSummaryItem(
                    Icons.science,
                    l10n.chemicals,
                    _selectedChemicals.values.where((v) => v).length.toString(),
                    AppTheme.secondaryOrange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting
                    ? null
                    : () {
                        // Dismiss keyboard before submitting
                        FocusScope.of(context).unfocus();
                        _submitReport(activeVisit);
                      },
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  _isSubmitting ? l10n.submitting : l10n.submitReport,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _submitReport(ActiveVisitModel activeVisit) async {
    final l10n = AppLocalizations.of(context);

    // Validation
    if (_controlledPests.isEmpty && _selectedChemicals.values.every((v) => !v)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseAddPestOrChemical),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    // Validate chemical quantities
    final selectedChemicalIds = _selectedChemicals.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    for (final chemicalId in selectedChemicalIds) {
      final quantity = _chemicalQuantities[chemicalId]?.text.trim() ?? '';
      if (quantity.isEmpty || double.tryParse(quantity) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.pleaseEnterValidQuantities),
            backgroundColor: AppTheme.error,
          ),
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);

    try {
      // Prepare controlled pests
      final controlledPests = _controlledPests
          .map((pest) => ControlledPestModel(
                pestId: pest.id,
                pestName: pest.name,
              ))
          .toList();

      // Prepare used chemicals
      final chemicalBox = Hive.box<ChemicalModel>(AppConstants.chemicalBox);
      final usedChemicals = <UsedChemicalModel>[];

      for (final chemicalId in selectedChemicalIds) {
        final chemical = chemicalBox.get(chemicalId);
        final quantity = double.parse(_chemicalQuantities[chemicalId]!.text.trim());

        if (chemical != null) {
          usedChemicals.add(UsedChemicalModel(
            chemicalId: chemical.id,
            chemicalName: chemical.name,
            quantity: quantity,
            unit: chemical.unit,
          ));
        }
      }

      // Get visit directly by ID from active visit
      final visitBox = Hive.box<VisitModel>(AppConstants.visitBox);
      final targetVisit = visitBox.get(activeVisit.visitId);

      if (targetVisit == null) {
        throw Exception('Visit not found in database. Please ensure the visit was started correctly.');
      }

      // Check if visit already has a report
      if (targetVisit.serviceReportId != null) {
        throw Exception('This visit already has a service report');
      }

      // Create service report
      final uuid = const Uuid();
      final reportId = uuid.v4();

      final serviceReport = ServiceReportModel(
        id: reportId,
        visitId: targetVisit.id,
        controlledPests: controlledPests,
        usedChemicals: usedChemicals,
        createdAt: DateTime.now(),
      );

      // Save service report to Hive
      final serviceReportBox = Hive.box<ServiceReportModel>(AppConstants.serviceReportBox);
      await serviceReportBox.put(reportId, serviceReport);

      final updatedVisit = VisitModel(
        id: targetVisit.id,
        supervisorId: targetVisit.supervisorId,
        customerId: targetVisit.customerId,
        projectId: targetVisit.projectId,
        date: targetVisit.date,
        startTime: targetVisit.startTime,
        endTime: targetVisit.endTime,
        teamMemberIds: targetVisit.teamMemberIds,
        serviceReportId: reportId,
      );

      // Update visit in database directly by key
      await visitBox.put(targetVisit.id, updatedVisit);

      // Show success and navigate back
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.reportSubmitted),
            backgroundColor: AppTheme.success,
            duration: const Duration(seconds: 3),
          ),
        );

        // Clear form
        setState(() {
          _controlledPests.clear();
          _selectedChemicals.clear();
          for (var controller in _chemicalQuantities.values) {
            controller.clear();
          }
          _isSubmitting = false;
        });

        // Navigate back to dashboard
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      setState(() => _isSubmitting = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorSubmittingReport}: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }
}

