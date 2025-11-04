import 'package:cscc_app/features/screens/add_post_screen.dart';
import 'package:cscc_app/home_screen_items.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:cscc_app/cores/colors.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int index) {
    if (index == 2) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => FractionallySizedBox(
          heightFactor: 1,
          child: Container(
            margin: const EdgeInsets.only(top: 35),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: const AddPostScreen(),
          ),
        ),
      );
      return;
    }

    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: primaryColor,
        onDestinationSelected: navigationTapped,
        selectedIndex: _page,
        destinations: const [
          NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
          NavigationDestination(icon: Icon(Iconsax.people), label: 'Event'),
          NavigationDestination(icon: Icon(Iconsax.add_circle), label: 'Add'),
          NavigationDestination(
            icon: Icon(Iconsax.folder_cloud),
            label: 'Project',
          ),
          NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
        ],
      ),
    );
  }
}

// import 'package:cscc_app/home_screen_items.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';
// import 'package:cscc_app/cores/colors.dart';
// import 'package:iconsax/iconsax.dart';

// class HomePage extends ConsumerStatefulWidget {
//   const HomePage({super.key});

//   @override
//   ConsumerState<HomePage> createState() => HomePageState();
// }

// class HomePageState extends ConsumerState<HomePage> {
//   // const HomePageState({super.key});
//   int _page = 0;
//   late PageController pageController;

//   @override
//   void initState() {
//     super.initState();
//     pageController = PageController();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     pageController.dispose();
//   }

//   void onPageChanged(int page) {
//     setState(() {
//       _page = page;
//     });
//   }

//   void navigationTapped(int page) {
//     pageController.jumpToPage(page);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // WidgetRef ref
//     // final authService = ref.read(authServiceProvider);

//     return Scaffold(
//       backgroundColor: Colors.white10,
//       body: PageView(
//         controller: pageController,
//         onPageChanged: onPageChanged,
//         physics: const NeverScrollableScrollPhysics(),
//         children: homeScreenItems,
//       ),
//       bottomNavigationBar: NavigationBar(
//         //maintainBottomViewPadding: true,
//         // elevation: 0,
//         //   height: 80,
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         indicatorColor:
//             primaryColor,
//         onDestinationSelected: navigationTapped,
//         selectedIndex: _page,

//         destinations: [
//           NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
//           NavigationDestination(icon: Icon(Iconsax.people), label: 'Event'),
//           NavigationDestination(
//             icon: Icon(Iconsax.add_circle),
//             label: 'Add Post',
//           ),
//           NavigationDestination(
//             icon: Icon(Iconsax.folder_cloud),
//             label: 'Project',
//           ),
//           NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }
