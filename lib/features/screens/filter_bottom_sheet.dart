import 'package:cscc_app/cores/colors.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Example filter states
  List<String> selectedDepartments = [];
  List<String> selectedPostTypes = [];
  String selectedVisibility = "Everyone";

  final List<String> departments = [
    "Development",
    "Security",
    "Robotics",
    "Communication",
  ];

  final List<String> postTypes = ["Announcement", "Project", "Event"];

  final List<String> visibilities = ["Everyone", "Bureau Members Only"];

  RangeValues _dateRange = const RangeValues(0, 30); // Optional range

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          controller: scrollController,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Filters",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedDepartments.clear();
                      selectedPostTypes.clear();
                      selectedVisibility = "Everyone";
                      _dateRange = const RangeValues(0, 30);
                    });
                  },
                  child: const Text(
                    "Reset",
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Departments
            const Text(
              "Departments",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: departments.map((dept) {
                  final isSelected = selectedDepartments.contains(dept);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(dept),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            selectedDepartments.add(dept);
                          } else {
                            selectedDepartments.remove(dept);
                          }
                        });
                      },
                      selectedColor: const Color.fromARGB(255, 127, 174, 255),
                      checkmarkColor: primaryColor,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Post Types
            const Text(
              "Post Types",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: postTypes.map((type) {
                  final isSelected = selectedPostTypes.contains(type);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            selectedPostTypes.add(type);
                          } else {
                            selectedPostTypes.remove(type);
                          }
                        });
                      },
                      selectedColor: const Color.fromARGB(255, 127, 174, 255),
                      checkmarkColor: primaryColor,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Visibility
            const Text(
              "Visibility",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Column(
              children: visibilities.map((v) {
                return RadioListTile<String>(
                  value: v,
                  
                  groupValue: selectedVisibility,
                  onChanged: (val) {
                    setState(() => selectedVisibility = val!);
                  },
                  title: Text(v),
                  activeColor: primaryColor,
                );
              }).toList(),
            ),

            // // Optional slider
            // const Text(
            //   "Date Range (days)",
            //   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            // ),
            // RangeSlider(
            //   values: _dateRange,
            //   min: 0,
            //   max: 60,
            //   divisions: 12,
            //   labels: RangeLabels(
            //     "${_dateRange.start.round()}d",
            //     "${_dateRange.end.round()}d",
            //   ),
            //   activeColor: primaryColor,
            //   onChanged: (val) => setState(() => _dateRange = val),
            // ),
            const SizedBox(height: 25),

            // Done button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.pop(context, {
                  "departments": selectedDepartments,
                  "types": selectedPostTypes,
                  "visibility": selectedVisibility,
                  "dateRange": _dateRange,
                });
              },
              child: const Text(
                "Done",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
