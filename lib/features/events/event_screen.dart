// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../services/post_service.dart';
// import '../models/post_model.dart';

// final postServiceProvider = Provider((ref) => PostService());
// final eventsProvider = StreamProvider<List<PostModel>>(
//   (ref) => ref.read(postServiceProvider).getEventPosts(),
// );

// class EventsScreen extends ConsumerWidget {
//   const EventsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final eventsAsync = ref.watch(eventsProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Events")),
//       body: eventsAsync.when(
//         data: (events) {
//           if (events.isEmpty) {
//             return const Center(child: Text("No events yet."));
//           }
//           return ListView.builder(
//             itemCount: events.length,
//             itemBuilder: (context, index) {
//               final event = events[index];
//               return ListTile(
//                 title: Text(event.title),
//                 subtitle: Text(event.description),
//               );
//             },
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text("Error: $e")),
//       ),
//     );
//   }
// }
