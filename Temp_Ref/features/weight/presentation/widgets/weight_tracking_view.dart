import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/colors.dart';
import '../../domain/entities/weight_entry.dart';
import '../providers/weight_providers.dart';
import '../providers/weight_state.dart';
import 'line_chart.dart';

/// Widget for displaying weight tracking functionality
class WeightTrackingView extends HookConsumerWidget {
  final bool isUserLoading;

  const WeightTrackingView({
    Key? key,
    this.isUserLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightState = ref.watch(weightNotifierProvider);

    // Use ref.listen instead of immediately modifying
    ref.listen<WeightState>(
      weightNotifierProvider,
      (previous, current) {
        // Handle errors with snackbar
        if (current.status == WeightStatus.error &&
            current.errorMessage != null) {
          // Delay showing snackbar to avoid build phase issues
          Future.microtask(() {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(current.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          });
        }
      },
    );

    return _buildWeightTrackingCard(context, ref, weightState);
  }

  Widget _buildWeightTrackingCard(
      BuildContext context, WidgetRef ref, WeightState state) {
    final isSyncing = state.isSyncing || isUserLoading;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and add button
          _buildHeader(context, ref, isSyncing),

          // Sync button row
          _buildSyncRow(context, ref, isSyncing),

          // Show appropriate content based on state
          if (state.status == WeightStatus.loading && state.entries.isEmpty)
            _buildLoadingView()
          else if (state.entries.isEmpty &&
              state.status != WeightStatus.processing)
            _buildEmptyStateView(context, ref)
          else if (state.status == WeightStatus.processing)
            _buildProcessingView(state)
          else
            _buildWeightDataView(context, ref, state),

          // View all data button
          if (state.entries.isNotEmpty &&
              state.status != WeightStatus.processing)
            _buildViewAllButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isSyncing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title
        const Text(
          'Weight Tracking',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // Add button with camera icon
        InkWell(
          onTap: () => _showCameraOptions(context, ref),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accent1.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.accent1.withOpacity(0.7),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: AppColors.accent1,
                ),
                const SizedBox(width: 6),
                Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.accent1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Add the "Tap to sync" text with sync button
  Widget _buildSyncRow(BuildContext context, WidgetRef ref, bool isSyncing) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: isSyncing
            ? null
            : () {
                // Show feedback
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Syncing weight data...'),
                //     duration: Duration(seconds: 1),
                //   ),
                // );
                // Trigger sync
                ref
                    .read(weightNotifierProvider.notifier)
                    .getWeightEntries(forceRefresh: true);
              },
        child: Row(
          children: [
            // Sync button that rotates during syncing
            _SyncIcon(isSyncing: isSyncing),

            const SizedBox(width: 8),

            Text(
              'Tap to sync',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    // Don't show spinning indicators - just show a static message
    return SizedBox(
      height: 250,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sync,
              size: 24,
              color: AppColors.accent1,
            ),
            const SizedBox(height: 16),
            const Text(
              'Loading data...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateView(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 250,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.scale_outlined,
              size: 48,
              color: AppColors.accent1,
            ),
            const SizedBox(height: 16),
            const Text(
              'No Weight Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Start tracking your weight journey by adding your first entry',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _showCameraOptions(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent1,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(width: 8),
                  Text('Add First Entry'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingView(WeightState state) {
    final progress = state.uploadProgress ?? 0.0;

    return SizedBox(
      height: 250,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Static text with percentage instead of circular progress
            Icon(
              Icons.camera,
              size: 50,
              color: AppColors.accent1.withOpacity(0.8),
            ),
            const SizedBox(height: 16),
            Text(
              'Processing (${(progress * 100).toInt()}%)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.accent1,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Processing Weight Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'AI is extracting your weight data\nPlease wait...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightDataView(
      BuildContext context, WidgetRef ref, WeightState state) {
    // Get latest entries
    final entries = state.entries;
    final statistics = ref.watch(weightStatisticsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Current weight with trend indicator
        _buildCurrentWeightSection(statistics),

        // Weight line chart
        SizedBox(
          height: 200,
          child: WeightLineChart(
            entries: entries,
            lineColor: AppColors.accent1,
            gradientColor: AppColors.accent1,
          ),
        ),

        // Recent entries list
        _buildRecentEntriesList(entries),
      ],
    );
  }

  Widget _buildCurrentWeightSection(WeightStatistics statistics) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Weight',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  statistics.currentWeight.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'kg',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),

        const Spacer(),

        // Weight change indicator
        if (statistics.weightChange != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  statistics.weightChange!.isGain
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 16,
                  color: statistics.weightChange!.isGain
                      ? Colors.red
                      : Colors.green,
                ),
                const SizedBox(width: 4),
                Text(
                  '${statistics.weightChange!.amount.abs().toStringAsFixed(1)} kg',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: statistics.weightChange!.isGain
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRecentEntriesList(List<WeightEntryEntity> entries) {
    // Show up to 3 most recent entries
    final recentEntries = entries.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Recent Entries',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),

        // Entries list
        Column(
          children: recentEntries.asMap().entries.map((entry) {
            final index = entry.key;
            final weightEntry = entry.value;

            return Column(
              children: [
                Row(
                  children: [
                    // Date
                    SizedBox(
                      width: 60,
                      child: Text(
                        weightEntry.shortDate,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Weight
                    Text(
                      '${weightEntry.weight.toStringAsFixed(1)} kg',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const Spacer(),

                    // Camera icon if entry has image
                    if (weightEntry.image != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.camera_alt,
                          size: 12,
                          color: AppColors.accent1,
                        ),
                      ),

                    // Time
                    Text(
                      _formattedTime(weightEntry.dateObject),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),

                // Divider (not for last item)
                if (index < recentEntries.length - 1)
                  Divider(
                    color: Colors.white.withOpacity(0.1),
                    height: 16,
                  ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildViewAllButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      child: ElevatedButton(
        onPressed: () {
          // Navigate to weight detail page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Weight Detail View')),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent1,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'View All Data',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  String _formattedTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  // Show camera options
  void _showCameraOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Weight Entry',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Camera option
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _captureImage(ImageSource.camera, ref);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.accent1.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: AppColors.accent1,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Take Photo',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Gallery option
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _captureImage(ImageSource.gallery, ref);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.accent2.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.photo_library,
                            color: AppColors.accent2,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Gallery',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Manual entry option
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _showManualEntryDialog(context, ref);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.accent3.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: AppColors.accent3,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Manual Entry',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Capture image from camera or gallery
  Future<void> _captureImage(ImageSource source, WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 90,
    );

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      // Show preview dialog
      // ignore: use_build_context_synchronously
      _showImagePreviewDialog(ref.context, imageFile, ref);
    }
  }

  // Show image preview dialog
  void _showImagePreviewDialog(
      BuildContext context, File imageFile, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Weight Photo Preview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.contain,
                    height: 300,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'The AI will analyze this photo to extract your weight value',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Delay provider modification to avoid build phase issues
                        Future.microtask(() {
                          ref
                              .read(weightNotifierProvider.notifier)
                              .uploadWeightImage(imageFile);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent1,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Upload'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show manual entry dialog
  void _showManualEntryDialog(BuildContext context, WidgetRef ref) {
    final weightController = TextEditingController();
    final now = DateTime.now();
    DateTime selectedDate = now;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add Weight Entry',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Weight input field
                    TextField(
                      controller: weightController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Weight (kg)',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.accent1),
                        ),
                        suffixText: 'kg',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Date picker
                    InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: now,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.dark(
                                  primary: AppColors.accent1,
                                  onPrimary: Colors.black,
                                  surface: Colors.grey[900]!,
                                  onSurface: Colors.white,
                                ),
                                dialogBackgroundColor: Colors.grey[900],
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.white.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.white70,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              DateFormat('MMMM d, yyyy').format(selectedDate),
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (weightController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a weight value'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            Navigator.pop(context);

                            // Parse weight value
                            final weightValue =
                                double.tryParse(weightController.text);
                            if (weightValue == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid weight value'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // Add weight entry with Future.microtask to avoid build phase
                            Future.microtask(() {
                              ref
                                  .read(weightNotifierProvider.notifier)
                                  .addWeightEntry(
                                    weightValue,
                                    selectedDate.toIso8601String(),
                                  );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent1,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Widget that displays a sync icon that rotates when syncing
class _SyncIcon extends StatefulWidget {
  final bool isSyncing;

  const _SyncIcon({required this.isSyncing});

  @override
  _SyncIconState createState() => _SyncIconState();
}

class _SyncIconState extends State<_SyncIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    if (widget.isSyncing) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(_SyncIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSyncing && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isSyncing && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(
        Icons.sync,
        size: 16,
        color: AppColors.accent1,
      ),
    );
  }
}
