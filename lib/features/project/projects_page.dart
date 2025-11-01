import 'package:flutter/material.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Project Page ")),
      body: Center(
        child: Text("Empty !"),
      ),

      floatingActionButton: ElevatedButton.icon(
        onPressed: () {},
        label: Icon(Icons.add),
      ),
    );
  }
}
