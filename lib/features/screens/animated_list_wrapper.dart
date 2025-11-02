import 'package:cscc_app/cores/widgets/post_card.dart';
import 'package:flutter/material.dart';

class AnimatedListWrapper extends StatelessWidget {
  final List<Map<String, dynamic>> docs;

  const AnimatedListWrapper({Key? key, required this.docs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        final offsetAnim = Tween<Offset>(
          begin: const Offset(0, 0.03),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offsetAnim, child: child),
        );
      },
      child: ListView.builder(
        key: ValueKey(docs.hashCode),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: docs.length,
        itemBuilder: (ctx, index) => PostCard(snap: docs[index]),
      ),
    );
  }
}
