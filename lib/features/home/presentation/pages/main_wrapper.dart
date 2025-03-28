import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter_hooks/flutter_hooks.dart'; // Removed hook import

import '../../../profile/presentation/pages/profile_page.dart';
import '../widgets/app_tab_bar.dart';
import 'home_page.dart';

/// Provider for the currently selected tab
final selectedTabProvider = StateProvider<int>((ref) => 0);

/// Main wrapper containing the tab navigation and pages - Converted to StatefulWidget
class MainWrapper extends ConsumerStatefulWidget {
  // Changed to ConsumerStatefulWidget
  const MainWrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<MainWrapper> createState() =>
      _MainWrapperState(); // Create state
}

class _MainWrapperState extends ConsumerState<MainWrapper> {
  // State class
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Initialize PageController with the initial tab from the provider
    _pageController =
        PageController(initialPage: ref.read(selectedTabProvider));
    // _setupTabListener(); // Listen for tab changes // REMOVED CALL
  }

  /* REMOVED METHOD
  void _setupTabListener() {
    // Listen to the selectedTabProvider for changes
    ref.listen<int>(selectedTabProvider, (previous, next) {
      // Animate or jump to the new page when the tab changes
      if (_pageController.hasClients) {
        // Check if the page controller is attached to a PageView
        // Using jumpToPage for instant switch as before
        _pageController.jumpToPage(next);
      } else {
        // If controller is not ready, re-initialize it (should be rare)
        _pageController = PageController(initialPage: next);
      }
    });
  }
  */

  @override
  void dispose() {
    _pageController.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(selectedTabProvider);

    // Listen to the selectedTabProvider for changes inside build method
    ref.listen<int>(selectedTabProvider, (previous, next) {
      // Animate or jump to the new page when the tab changes
      if (_pageController.hasClients && _pageController.page?.round() != next) {
        // Check if the page controller is attached and not already on the target page
        _pageController.jumpToPage(next);
      }
    });

    return Scaffold(
      extendBody: true, // Important to let the pages draw behind the tab bar
      body: PageView(
        controller: _pageController, // Use state's controller
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        onPageChanged: (index) {
          // Update the tab state if changed programmatically (e.g., swipe, if enabled)
          // Check if the provider state actually needs updating
          if (ref.read(selectedTabProvider) != index) {
            // Use write access to update the provider state
            // No need for microtask here as onPageChanged happens outside build phase
            ref.read(selectedTabProvider.notifier).state = index;
          }
        },
        children: [
          // Home page
          const HomePage(),

          // Fitness page (placeholder)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Center(
              child: Text(
                'Fitness Page\nComing Soon',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Chat page (placeholder)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Center(
              child: Text(
                'Chat Page\nComing Soon',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Profile page
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: AppTabBar(
        selectedIndex: selectedTab,
        onTap: (index) {
          // Update the provider state when a tab is tapped
          ref.read(selectedTabProvider.notifier).state = index;
        },
      ),
    );
  }
}
