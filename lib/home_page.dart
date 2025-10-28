import 'package:cscc_app/cores/widgets/flat_button.dart';
import 'package:cscc_app/features/auth/repo/auth_repo.dart';
// import 'package:cscc_app/global_variable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cscc_app/cores/colors.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  // const HomePageState({super.key});
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    // WidgetRef ref
    final authService = ref.read(authServiceProvider);

    return Scaffold(
      backgroundColor: Colors.white10,
      // appBar: AppBar(
      //   actions: [
      //     FlatButton(
      //       text: "SIGN OUT",
      //       onPressed: () {
      //         authService.signOutUser();
      //       },
      //       colour: Colors.white,
      //     ),
      //   ],
      // ),
      body: PageView(
        // children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: (_page == 0) ? primaryColor : Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: (_page == 1) ? primaryColor : Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: (_page == 2) ? primaryColor : Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: (_page == 3) ? primaryColor : Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: (_page == 4) ? primaryColor : Colors.grey,
            ),
            label: '',
            // backgroundColor: Color(0xFF4A8BFF),
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// // import 'package:instagram_clone_flutter/utils/colors.dart';
// // import 'package:instagram_clone_flutter/utils/global_variable.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold();
//   }
// }
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // // import 'package:instagram_clone_flutter/utils/colors.dart';
// // // import 'package:instagram_clone_flutter/utils/global_variable.dart';

// // class MobileScreenLayout extends StatefulWidget {
// //   const MobileScreenLayout({Key? key}) : super(key: key);

// //   @override
// //   State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
// // }

// // class _MobileScreenLayoutState extends State<MobileScreenLayout> {
// //   int _page = 0;
// //   late PageController pageController; // for tabs animation

// //   @override
// //   void initState() {
// //     super.initState();
// //     pageController = PageController();
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //     pageController.dispose();
// //   }

// //   void onPageChanged(int page) {
// //     setState(() {
// //       _page = page;
// //     });
// //   }

// //   void navigationTapped(int page) {
// //     //Animating Page
// //     pageController.jumpToPage(page);
// //   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: pageController,
//         onPageChanged: onPageChanged,
//         children: homeScreenItems,
//       ),
//       bottomNavigationBar: CupertinoTabBar(
//         backgroundColor: mobileBackgroundColor,
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.home,
//               color: (_page == 0) ? primaryColor : secondaryColor,
//             ),
//             label: '',
//             backgroundColor: primaryColor,
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.search,
//                 color: (_page == 1) ? primaryColor : secondaryColor,
//               ),
//               label: '',
//               backgroundColor: primaryColor),
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.add_circle,
//                 color: (_page == 2) ? primaryColor : secondaryColor,
//               ),
//               label: '',
//               backgroundColor: primaryColor),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.favorite,
//               color: (_page == 3) ? primaryColor : secondaryColor,
//             ),
//             label: '',
//             backgroundColor: primaryColor,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.person,
//               color: (_page == 4) ? primaryColor : secondaryColor,
//             ),
//             label: '',
//             backgroundColor: primaryColor,
//           ),
//         ],
//         onTap: navigationTapped,
//         currentIndex: _page,
//       ),
//     );
//   }
// }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: PageView(
// //         controller: pageController,
// //         onPageChanged: onPageChanged,
// //         children: homeScreenItems,
// //       ),
// //       bottomNavigationBar: CupertinoTabBar(
// //         backgroundColor: mobileBackgroundColor,
// //         items: <BottomNavigationBarItem>[
// //           BottomNavigationBarItem(
// //             icon: Icon(
// //               Icons.home,
// //               color: (_page == 0) ? primaryColor : secondaryColor,
// //             ),
// //             label: '',
// //             backgroundColor: primaryColor,
// //           ),
// //           BottomNavigationBarItem(
// //               icon: Icon(
// //                 Icons.search,
// //                 color: (_page == 1) ? primaryColor : secondaryColor,
// //               ),
// //               label: '',
// //               backgroundColor: primaryColor),
// //           BottomNavigationBarItem(
// //               icon: Icon(
// //                 Icons.add_circle,
// //                 color: (_page == 2) ? primaryColor : secondaryColor,
// //               ),
// //               label: '',
// //               backgroundColor: primaryColor),
// //           BottomNavigationBarItem(
// //             icon: Icon(
// //               Icons.favorite,
// //               color: (_page == 3) ? primaryColor : secondaryColor,
// //             ),
// //             label: '',
// //             backgroundColor: primaryColor,
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(
// //               Icons.person,
// //               color: (_page == 4) ? primaryColor : secondaryColor,
// //             ),
// //             label: '',
// //             backgroundColor: primaryColor,
// //           ),
// //         ],
// //         onTap: navigationTapped,
// //         currentIndex: _page,
// //       ),
// //     );
// //   }
// // }
