import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DepartmentsPage extends StatelessWidget {
  const DepartmentsPage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> departments = [
      {
        'name': 'Development',
        'icon': Icons.computer,
        'projects': [
          {
            'title': 'CSCC Website',
            'sender': 'Ali Ben',
            'link': 'https://github.com/cscc/website',
          },
          {
            'title': 'Mobile App',
            'sender': 'Sana B.',
            'link': 'https://github.com/cscc/mobile-app',
          },
        ],
        'announcements': [
          {'title': 'Code freeze this Friday', 'sender': 'Ali Ben'},
          {'title': 'New Flutter update available', 'sender': 'Sana B.'},
        ],
      },
      {
        'name': 'Security',
        'icon': Icons.security,
        'projects': [
          {
            'title': 'CTF Challenge',
            'sender': 'Imane T.',
            'link': 'https://github.com/cscc/ctf-challenge',
          },
          {
            'title': 'Network Hardening',
            'sender': 'Rachid O.',
            'link': 'https://github.com/cscc/network-hardening',
          },
        ],
        'announcements': [
          {'title': 'Security audit next week', 'sender': 'Imane T.'},
          {'title': 'VPN maintenance on Sunday', 'sender': 'Rachid O.'},
        ],
      },
      {
        'name': 'Robotics',
        'icon': Icons.smart_toy,
        'projects': [
          {
            'title': 'AI Vision Robot',
            'sender': 'Hamza L.',
            'link': 'https://github.com/cscc/ai-robot',
          },
          {
            'title': 'Gesture Control Arm',
            'sender': 'Mouad K.',
            'link': 'https://github.com/cscc/robotic-arm',
          },
        ],
        'announcements': [
          {'title': 'Workshop on Arduino this weekend', 'sender': 'Zineb M.'},
          {'title': 'Robot demo on Friday', 'sender': 'Hamza L.'},
        ],
      },
      {
        'name': 'Communication',
        'icon': Icons.connect_without_contact,
        'projects': [
          {
            'title': 'Social Media Campaign',
            'sender': 'Aya R.',
            'link': 'https://github.com/cscc/social-media',
          },
          {
            'title': 'Podcast Setup',
            'sender': 'Ibrahim J.',
            'link': 'https://github.com/cscc/podcast',
          },
        ],
        'announcements': [
          {'title': 'New event promo this week', 'sender': 'Aya R.'},
          {'title': 'Team meeting at 3 PM today', 'sender': 'Nour H.'},
        ],
      },
    ];

    void showBottomInfoSheet({
      required BuildContext context,
      required String department,
      required String title,
      required String sender,
      String? link,
    }) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A8BFF), Color(0xFF82B1FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.person, color: Color(0xFF4A8BFF)),
                    const SizedBox(width: 8),
                    Text(
                      "Sender: $sender",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.apartment, color: Color(0xFF4A8BFF)),
                    const SizedBox(width: 8),
                    Text(
                      "Department: $department",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                if (link != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.link, color: Color(0xFF4A8BFF)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () => _launchURL(link),
                          child: Text(
                            link,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A8BFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text(
                      "Close",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Departments"),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A8BFF),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final dept = departments[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ExpansionTile(
              leading: Icon(
                dept['icon'] as IconData,
                color: const Color(0xFF4A8BFF),
              ),
              title: Text(
                dept['name'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A8BFF),
                ),
              ),
              childrenPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: [
                const Divider(),
                const Text(
                  "Projects:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                ...List.generate((dept['projects'] as List).length, (i) {
                  final project =
                      (dept['projects'] as List<Map<String, dynamic>>)[i];
                  return ListTile(
                    leading: const Icon(
                      Icons.build_circle_rounded,
                      color: Colors.green,
                    ),
                    title: Text(project['title']),
                    onTap: () => showBottomInfoSheet(
                      context: context,
                      department: dept['name'],
                      title: project['title'],
                      sender: project['sender'],
                      link: project['link'],
                    ),
                  );
                }),
                const Divider(),
                const Text(
                  "Announcements:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                ...List.generate((dept['announcements'] as List).length, (i) {
                  final ann =
                      (dept['announcements'] as List<Map<String, dynamic>>)[i];
                  return ListTile(
                    leading: const Icon(
                      Icons.campaign,
                      color: Colors.orangeAccent,
                    ),
                    title: Text(ann['title']),
                    onTap: () => showBottomInfoSheet(
                      context: context,
                      department: dept['name'],
                      title: ann['title'],
                      sender: ann['sender'],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
