// import 'package:cscc_app/features/screens/add_post_screen.dart';
import 'package:cscc_app/home_screen_items.dart';
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
    // final authService = ref.read(authServiceProvider);

    return Scaffold(
      backgroundColor: Colors.white10,
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(color: primaryColor.withOpacity(0.3), width: 1),
          ),

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
                Icons.android,
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
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: primaryColor,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      //   child: const Icon(Icons.add, color: Colors.white, size: 32),
      //   onPressed: () {
      //     showModalBottomSheet(
      //       context: context,
      //       isScrollControlled: true,
      //       backgroundColor: Colors.transparent,
      //       builder: (context) => FractionallySizedBox(
      //         heightFactor: 1,
      //         child: const AddPostScreen(),
      //       ),
      //     );
      //   },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
