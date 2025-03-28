import 'package:fitness_freaks/features/weight/presentation/providers/weight_state.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart'; // Removed hook import
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/colors.dart';
import '../../domain/entities/weight_entry.dart';
import '../providers/weight_providers.dart';
import '../widgets/line_chart.dart';

/// Page displaying detailed weight history and statistics - Converted to StatefulWidget
class WeightDetailPage extends ConsumerStatefulWidget {
  // Changed to ConsumerStatefulWidget
  const WeightDetailPage({Key? key}) : super(key: key);

  @override
  ConsumerState<WeightDetailPage> createState() =>
      _WeightDetailPageState(); // Create state
}

class _WeightDetailPageState extends ConsumerState<WeightDetailPage> {
  // State class
  // State variables
  late DateRange _selectedTimeRange;
  late WeightSortOrder _sortOrder;
  late bool _showSortOptions;

  @override
  void initState() {
    super.initState();
    // Initialize state variables
    _selectedTimeRange = DateRange.month();
    _sortOrder = WeightSortOrder.newest;
    _showSortOptions = false;
  }

  // Helper to update selected time range state
  void _updateSelectedTimeRange(DateRange newRange) {
    setState(() {
      _selectedTimeRange = newRange;
    });
  }

  // Helper to update sort order state
  void _updateSortOrder(WeightSortOrder newOrder) {
    setState(() {
      _sortOrder = newOrder;
    });
  }

  // Helper to toggle sort options visibility
  void _toggleSortOptionsVisibility(bool show) {
    setState(() {
      _showSortOptions = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch weight entries
    final weightState = ref.watch(weightNotifierProvider);
    final isLoading =
        weightState.status == WeightStatus.loading || weightState.isSyncing;

    // Get filtered entries based on time range
    final filteredEntries = ref.watch(filteredWeightEntriesProvider(
        _selectedTimeRange)); // Use state variable

    // Get statistics
    final statistics = ref.watch(weightStatisticsProvider);

    // Apply sorting to entries
    final sortedEntries =
        _applySorting(filteredEntries, _sortOrder); // Use state variable

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accent1.withOpacity(0.7),
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0, 0.5],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom header
              _buildHeader(context, ref),

              // Main content
              Expanded(
                child: isLoading && filteredEntries.isEmpty
                    ? _buildLoadingView()
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Time range selector
                              _buildTimeRangeSelector(
                                  // Pass state and updater
                                  _selectedTimeRange,
                                  _updateSelectedTimeRange),

                              // Graph section
                              _buildGraphSection(
                                filteredEntries,
                                statistics,
                              ),

                              // Stats section
                              _buildStatsSection(statistics),

                              // Entries list with sort controls
                              _buildEntriesSection(
                                // Pass state and updaters
                                context,
                                sortedEntries,
                                _sortOrder,
                                _updateSortOrder,
                                _showSortOptions,
                                _toggleSortOptionsVisibility,
                              ),
                            ],
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

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Title
          const Text(
            'Weight History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const Spacer(),

          // Sync button
          InkWell(
            onTap: () {
              ref.read(weightNotifierProvider.notifier).getWeightEntries();
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sync,
                color: AppColors.accent1,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildTimeRangeSelector(
    DateRange currentRange,
    ValueChanged<DateRange> onRangeSelected,
  ) {
    final timeRanges = [
      {'label': 'Week', 'range': DateRange.week()},
      {'label': 'Month', 'range': DateRange.month()},
      {'label': '3 Months', 'range': DateRange.threeMonths()},
      {'label': '6 Months', 'range': DateRange.sixMonths()},
      {'label': 'Year', 'range': DateRange.year()},
      {'label': 'All Time', 'range': DateRange.all()},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Time Range',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: timeRanges.map((item) {
              final label = item['label'] as String;
              final range = item['range'] as DateRange;
              final isSelected =
                  _areDateRangesEqual(currentRange, range); // Use currentRange

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _buildTimeRangeChip(
                  label: label,
                  isSelected: isSelected,
                  onTap: () {
                    onRangeSelected(range); // Call the updater function
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24), // Add spacing after time range
      ],
    );
  }

  Widget _buildTimeRangeChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent1 : Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? Colors.transparent : Colors.white.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildGraphSection(
    List<WeightEntryEntity> entries,
    WeightStatistics statistics,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weight Trend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          // Weight stats
          _buildWeightStats(statistics),

          const SizedBox(height: 16),

          // Weight chart
          SizedBox(
            height: 250,
            child: entries.length > 1
                ? WeightLineChart(
                    entries: entries,
                    lineColor: AppColors.accent1,
                    gradientColor: AppColors.accent1,
                  )
                : const Center(
                    child: Text(
                      'Not enough data for selected time range',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightStats(WeightStatistics statistics) {
    return Row(
      children: [
        // Current weight
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current',
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 2),
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

        // Weight change
        if (statistics.weightChange != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Change',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: statistics.weightChange!.isGain
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildStatsSection(WeightStatistics statistics) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Average weight
              _buildStatBox(
                label: 'Average',
                value: statistics.averageWeight.toStringAsFixed(1),
                unit: 'kg',
                icon: Icons.scale,
                color: AppColors.accent1,
              ),

              const SizedBox(width: 12),

              // Highest weight
              _buildStatBox(
                label: 'Highest',
                value: statistics.highestWeight.toStringAsFixed(1),
                unit: 'kg',
                icon: Icons.arrow_upward,
                color: Colors.red,
              ),

              const SizedBox(width: 12),

              // Lowest weight
              _buildStatBox(
                label: 'Lowest',
                value: statistics.lowestWeight.toStringAsFixed(1),
                unit: 'kg',
                icon: Icons.arrow_downward,
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox({
    required String label,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            // Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 18,
              ),
            ),

            const SizedBox(height: 8),

            // Label
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 4),

            // Value with unit
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntriesSection(
    BuildContext context,
    List<WeightEntryEntity> entries,
    WeightSortOrder currentSortOrder,
    ValueChanged<WeightSortOrder> onSortOrderChanged,
    bool showSortOptions,
    ValueChanged<bool> onShowSortOptionsChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with sort button
          Row(
            children: [
              const Text(
                'All Entries',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const Spacer(),

              Text(
                '${entries.length} records',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(width: 12),

              // Sort button
              _buildSortControl(
                  // Pass state and updaters
                  currentSortOrder,
                  onSortOrderChanged,
                  showSortOptions,
                  onShowSortOptionsChanged),
            ],
          ),

          // Sort options
          if (showSortOptions)
            _buildSortOptionsDropdown(currentSortOrder, onSortOrderChanged),

          const SizedBox(height: 16),

          // Entries list
          if (entries.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Text(
                  'No entries for selected time range',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.white.withOpacity(0.1),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final entry = entries[index];
                return _buildEntryItem(entry);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSortControl(
    WeightSortOrder currentSortOrder,
    ValueChanged<WeightSortOrder> onSortOrderChanged,
    bool showSortOptions,
    ValueChanged<bool> onShowSortOptionsChanged,
  ) {
    final sortText = currentSortOrder == WeightSortOrder.newest
        ? 'Newest First'
        : 'Oldest First';

    return InkWell(
      onTap: () {
        onShowSortOptionsChanged(!showSortOptions); // Use updater
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sortText,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              showSortOptions ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: Colors.white.withOpacity(0.9),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOptionsDropdown(
    WeightSortOrder currentSortOrder,
    ValueChanged<WeightSortOrder> onSortOrderChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: WeightSortOrder.values.map((order) {
          final isSelected = order == currentSortOrder;
          final text = order == WeightSortOrder.newest
              ? 'Sort by Newest First'
              : 'Sort by Oldest First';
          return ListTile(
            dense: true,
            title: Text(
              text,
              style: TextStyle(
                color: isSelected
                    ? AppColors.accent1
                    : Colors.white.withOpacity(0.8),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check, color: AppColors.accent1, size: 18)
                : null,
            onTap: () {
              onSortOrderChanged(order); // Use updater
              _toggleSortOptionsVisibility(
                  false); // Hide dropdown after selection
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEntryItem(WeightEntryEntity entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          // Date column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMM d, yyyy').format(entry.dateObject),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('h:mm a').format(entry.dateObject),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Weight value
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                entry.weight.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 2),
              const Text(
                'kg',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          // Camera icon if has image
          if (entry.image != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.camera_alt,
                color: AppColors.accent1,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }

  // Helper methods
  bool _areDateRangesEqual(DateRange a, DateRange b) {
    return a.startDate.day == b.startDate.day &&
        a.startDate.month == b.startDate.month &&
        a.startDate.year == b.startDate.year &&
        a.endDate.day == b.endDate.day &&
        a.endDate.month == b.endDate.month &&
        a.endDate.year == b.endDate.year;
  }

  List<WeightEntryEntity> _applySorting(
    List<WeightEntryEntity> entries,
    WeightSortOrder sortOrder,
  ) {
    final sorted = List<WeightEntryEntity>.from(entries);

    switch (sortOrder) {
      case WeightSortOrder.newest:
        sorted.sort((a, b) => b.dateObject.compareTo(a.dateObject));
        break;
      case WeightSortOrder.oldest:
        sorted.sort((a, b) => a.dateObject.compareTo(b.dateObject));
        break;
      case WeightSortOrder.highestWeight:
        sorted.sort((a, b) => b.weight.compareTo(a.weight));
        break;
      case WeightSortOrder.lowestWeight:
        sorted.sort((a, b) => a.weight.compareTo(b.weight));
        break;
    }

    return sorted;
  }
}

/// Sort orders for weight entries
enum WeightSortOrder {
  newest,
  oldest,
  highestWeight,
  lowestWeight,
}
