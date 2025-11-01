// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cscc_app/cores/colors.dart';
// import 'package:flutter/material.dart';

// class DraggableFeed extends StatefulWidget {
//   final Widget child;
//   const DraggableFeed({required this.child, super.key});

//   @override
//   State<DraggableFeed> createState() => _DraggableFeedState();
// }

// class _DraggableFeedState extends State<DraggableFeed> with SingleTickerProviderStateMixin {
//   double _dragOffset = 0;
//   bool _isRefreshing = false;
//   late AnimationController _animationController;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
//   }

//   Future<void> _refreshFeed() async {
//     setState(() => _isRefreshing = true);

//     // هنا ننتظر البيانات من Firestore (أو simulate)
//     await Future.delayed(const Duration(seconds: 1));

//     setState(() => _isRefreshing = false);

//     // ترجّع الصفحة لمكانها
//     _animation = Tween<double>(begin: _dragOffset, end: 0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     )..addListener(() => setState(() => _dragOffset = _animation.value));

//     _animationController.forward(from: 0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return NotificationListener<ScrollNotification>(
//       onNotification: (notification) {
//         if (_isRefreshing) return true;

//         // إذا السحب يمين وأنت في بداية الصفحة
//         if (notification is OverscrollNotification &&
//             notification.overscroll < 0 &&
//             notification.metrics.pixels <= 0) {
//           setState(() {
//             _dragOffset -= notification.overscroll;
//             if (_dragOffset > 150) _dragOffset = 150;
//           });
//         }

//         if (notification is ScrollEndNotification && _dragOffset > 100) {
//           _refreshFeed();
//         } else if (notification is ScrollEndNotification && _dragOffset > 0) {
//           _animation = Tween<double>(begin: _dragOffset, end: 0).animate(
//             CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//           )..addListener(() => setState(() => _dragOffset = _animation.value));

//           _animationController.forward(from: 0);
//         }

//         return false;
//       },
//       child: Stack(
//         children: [
//           Container(
//             color: primaryColor,
//             alignment: Alignment.centerLeft,
//             padding: const EdgeInsets.only(left: 16),
//             child: _isRefreshing
//                 ? const SizedBox(
//                     height: 24,
//                     width: 24,
//                     child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//                   )
//                 : null,
//           ),
//           Transform.translate(
//             offset: Offset(_dragOffset, 0),
//             child: widget.child,
//           ),
//         ],
//       ),
//     );
//   }
// }


// class DraggableFeed extends StatefulWidget {
//   final Widget child;

//   const DraggableFeed({required this.child, super.key});

//   @override
//   State<DraggableFeed> createState() => _DraggableFeedState();
// }

// class _DraggableFeedState extends State<DraggableFeed> with SingleTickerProviderStateMixin {
//   double _dragOffset = 0;
//   bool _isRefreshing = false;
//   late AnimationController _animationController;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//   }

//   Future<void> _refreshFeed() async {
//     setState(() => _isRefreshing = true);

//     // Simulate Firestore loading
//     await Future.delayed(const Duration(seconds: 1));

//     setState(() => _isRefreshing = false);

//     // Animate back
//     _animation = Tween<double>(begin: _dragOffset, end: 0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     )..addListener(() => setState(() => _dragOffset = _animation.value));

//     _animationController.forward(from: 0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return NotificationListener<ScrollNotification>(
//       onNotification: (notification) {
//         if (_isRefreshing) return true;

//         if (notification is OverscrollNotification &&
//             notification.overscroll < 0 &&
//             notification.metrics.pixels <= 0) {
//           // Pulling right at start of feed
//           setState(() {
//             _dragOffset -= notification.overscroll; // overscroll negative
//             if (_dragOffset > 150) _dragOffset = 150;
//           });
//         }

//         if (notification is ScrollEndNotification && _dragOffset > 100) {
//           _refreshFeed();
//         } else if (notification is ScrollEndNotification && _dragOffset > 0) {
//           _animation = Tween<double>(begin: _dragOffset, end: 0).animate(
//             CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//           )..addListener(() => setState(() => _dragOffset = _animation.value));

//           _animationController.forward(from: 0);
//         }

//         return false; // allow other gestures
//       },
//       child: Stack(
//         children: [
//           Container(
//             color: primaryColor,
//             alignment: Alignment.centerLeft,
//             padding: const EdgeInsets.only(left: 16),
//             child: _isRefreshing
//                 ? const SizedBox(
//                     height: 24,
//                     width: 24,
//                     child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//                   )
//                 : null,
//           ),
//           Transform.translate(
//             offset: Offset(_dragOffset, 0),
//             child: widget.child,
//           ),
//         ],
//       ),
//     );
//   }
// }

