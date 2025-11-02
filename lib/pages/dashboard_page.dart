import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:biodata_app/controllers/name_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, String>> activities = [];
  final NameController nameController = Get.put(NameController()); // <== Tambahan GetX controller

  // Function untuk tambah aktivitas
  void addActivity() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const ActivityDialog(),
    );

    if (result != null && mounted) {
      setState(() {
        activities.add(result);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aktivitas berhasil ditambahkan!')),
      );
    }
  }

  // Function untuk edit aktivitas
  void editActivity(int index) async {
    final current = activities[index];
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => ActivityDialog(
        initialActivity: current['activity'],
        initialMood: current['mood'],
      ),
    );

    if (result != null && mounted) {
      setState(() {
        activities[index] = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aktivitas berhasil diupdate!')),
      );
    }
  }

  // Function untuk hapus aktivitas
  void deleteActivity(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Aktivitas?'),
        content: const Text('Yakin ingin menghapus aktivitas ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => activities.removeAt(index));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Aktivitas dihapus')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final userName = args?['name'] ?? 'User';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade400,
              Colors.purple.shade200,
              Colors.pink.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, $userName 👋',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Bagaimana mood kamu hari ini?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // === Bagian aktivitas lama ===
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Aktivitas Hari Ini',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                Text(
                                  '${activities.length} aktivitas tercatat',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            Text(
                              activities.isEmpty ? '🌤️' : '✨',
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        activities.isEmpty
                            ? const Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.mood_outlined,
                                        size: 64, color: Colors.grey),
                                    SizedBox(height: 16),
                                    Text('Belum ada aktivitas',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey)),
                                    Text('Tap tombol + untuk menambah',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: activities.length,
                                itemBuilder: (context, index) {
                                  final item = activities[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: ListTile(
                                      leading: Text(
                                        item['mood'] ?? '😊',
                                        style:
                                            const TextStyle(fontSize: 32),
                                      ),
                                      title: Text(item['activity'] ?? ''),
                                      subtitle: const Text('Tap untuk edit'),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            deleteActivity(index),
                                      ),
                                      onTap: () => editActivity(index),
                                    ),
                                  );
                                },
                              ),

                        // === FITUR INPUT NAMA (TUGAS MINGGU 07) ===
                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 12),
                        const Text(
                          "Tambah Daftar Nama",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) =>
                                    nameController.inputText.value = value,
                                decoration: const InputDecoration(
                                  labelText: "Masukkan nama",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => nameController.addName(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                              ),
                              child: const Text("Tambah"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Obx(() => ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              itemCount: nameController.names.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.person,
                                      color: Colors.deepPurple),
                                  title: Text(
                                    nameController.names[index],
                                  ),
                                );
                              },
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addActivity,
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

// Dialog Widget untuk Add/Edit
class ActivityDialog extends StatefulWidget {
  final String? initialActivity;
  final String? initialMood;

  const ActivityDialog({
    super.key,
    this.initialActivity,
    this.initialMood,
  });

  @override
  State<ActivityDialog> createState() => _ActivityDialogState();
}

class _ActivityDialogState extends State<ActivityDialog> {
  late TextEditingController controller;
  late String selectedMood;

  final List<Map<String, String>> moods = [
    {'emoji': '😊', 'label': 'Senang'},
    {'emoji': '😎', 'label': 'Keren'},
    {'emoji': '😢', 'label': 'Sedih'},
    {'emoji': '😡', 'label': 'Marah'},
    {'emoji': '😴', 'label': 'Ngantuk'},
  ];

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialActivity ?? '');
    selectedMood = widget.initialMood ?? '😊';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(widget.initialActivity == null
          ? 'Tambah Aktivitas'
          : 'Edit Aktivitas'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nama Aktivitas',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Pilih Mood:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: moods.map((mood) {
              final isSelected = selectedMood == mood['emoji'];
              return ChoiceChip(
                label: Column(
                  children: [
                    Text(mood['emoji']!,
                        style: const TextStyle(fontSize: 24)),
                    Text(mood['label']!,
                        style: const TextStyle(fontSize: 10)),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => selectedMood = mood['emoji']!);
                },
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              Navigator.pop(context, {
                'activity': controller.text.trim(),
                'mood': selectedMood,
              });
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
