import 'package:fitness_freaks/features/user/presentation/providers/user_state.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart'; // Remove hook import
import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../../../core/presentation/hooks/lifecycle_hook.dart'; // Remove hook import
import '../../../user/presentation/providers/user_providers.dart';
import '../../../weight/presentation/providers/weight_providers.dart';
import '../../../weight/presentation/widgets/weight_tracking_view.dart';
import '../widgets/background_gradient.dart';
import '../widgets/graph_metrics_view.dart';
import '../widgets/workout_progress_card.dart';

/// The home page of the application - Converted to StatefulWidget
class HomePage extends ConsumerStatefulWidget {
  // Changed to ConsumerStatefulWidget
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState(); // Create state
}

class _HomePageState extends ConsumerState<HomePage> {
  // State class
  late ScrollController _scrollController; // Use standard ScrollController
  double _scrollOffset = 0;
  // bool _isLoaded = true; // This doesn't seem used, consider removing
  bool _isCardPressed = false;
  // bool _isInitialized = false; // Removed as fetch logic is moved

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _setupScrollListener();
    // _fetchInitialData(); // REMOVED: Fetch data on init
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (mounted) {
        // Use built-in mounted check
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Moved build method here
    // Get user data
    final userState = ref.watch(userNotifierProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          const BackgroundGradient(forTab: TabType.home),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(userState.user?.fullName ?? 'User'),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController, // Use state's controller
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          // Main card - WorkoutProgressCard with subtle hover animation
                          GestureDetector(
                            // Update state using setState
                            onTapDown: (_) {
                              if (mounted)
                                setState(() => _isCardPressed = true);
                            },
                            onTapUp: (_) {
                              if (mounted)
                                setState(() => _isCardPressed = false);
                            },
                            onTapCancel: () {
                              if (mounted)
                                setState(() => _isCardPressed = false);
                            },
                            child: AnimatedScale(
                              scale: _isCardPressed
                                  ? 0.98
                                  : 1.0, // Use state variable
                              duration: const Duration(milliseconds: 200),
                              child: const WorkoutProgressCard(),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Weight tracking card
                          WeightTrackingView(
                              isUserLoading:
                                  userState.status == UserStatus.loading),

                          const SizedBox(height: 24),

                          // Metrics graphs
                          const GraphMetricsView(),

                          // Bottom space for tab bar
                          const SizedBox(height: 90),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Greeting and user name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // Profile pic/button
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withAlpha(25), // Use withAlpha for clarity
              border: Border.all(
                color: Colors.white.withAlpha(77), // Use withAlpha
                width: 0.5,
              ),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
