import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<TaskProvider>(
        context,
        listen: false,
      ).loadTasks();
    });
  }

  Future<void> _logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  if (!mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
}

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hapus Task?"),

          content: const Text(
            "Apakah kamu yakin ingin menghapus task ini?",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text("Batal"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Widget _buildStatisticCard({
    required String title,
    required int value,
    required bool isActive,
  }) {
    return Container(
      width: 105,

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        border: Border.all(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,

          width: 2,
        ),

        borderRadius: BorderRadius.circular(12),

        color: isActive
            ? Theme.of(context)
                .colorScheme
                .primary
                .withOpacity(0.1)
            : null,
      ),

      child: Column(
        children: [
          Text(
            "$value",

            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () => _logout(context),
          ),
        ],
      ),

      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              // =========================
              // SEARCH
              // =========================

              Padding(
                padding: const EdgeInsets.all(8),

                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Cari task...",

                    prefixIcon: Icon(Icons.search),

                    border: OutlineInputBorder(),
                  ),

                  onChanged: (value) {
                    provider.setSearchQuery(value);
                  },
                ),
              ),

              // =========================
              // FILTER / STATISTIK
              // =========================

              Padding(
                padding: const EdgeInsets.all(8),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,

                  children: [
                    GestureDetector(
                      onTap: () {
                        provider.setFilter('all');
                      },

                      child: _buildStatisticCard(
                        title: "Total",

                        value: provider.totalTasks,

                        isActive:
                            provider.filter == 'all',
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        provider.setFilter('incomplete');
                      },

                      child: _buildStatisticCard(
                        title: "Belum Selesai",

                        value: provider.incompleteTasks,

                        isActive:
                            provider.filter == 'incomplete',
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        provider.setFilter('completed');
                      },

                      child: _buildStatisticCard(
                        title: "Selesai",

                        value: provider.completedTasks,

                        isActive:
                            provider.filter == 'completed',
                      ),
                    ),
                  ],
                ),
              ),

              // =========================
              // DAFTAR TASK
              // =========================

              Expanded(
                child: provider.filteredTasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: [
                            Icon(
                              provider.tasks.isEmpty
                                  ? Icons.task_alt
                                  : Icons.search_off,

                              size: 70,
                            ),

                            const SizedBox(height: 20),

                            Text(
                              provider.tasks.isEmpty
                                  ? "Belum ada task"
                                  : "Task tidak ditemukan",

                              style: const TextStyle(
                                fontSize: 20,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              provider.tasks.isEmpty
                                  ? "Tambahkan task pertama kamu"
                                  : "Coba gunakan kata pencarian lain",
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount:
                            provider.filteredTasks.length,

                        itemBuilder: (context, index) {
                          final task =
                              provider.filteredTasks[index];

                          return TaskCard(
                            task: task,

                            onToggle: () {
                              provider.toggleTask(task);
                            },

                            onEdit: () async {
                              await Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditTaskScreen(
                                    task: task,
                                  ),
                                ),
                              );
                            },

                            onDelete: () async {
                              final shouldDelete =
                                  await _confirmDelete(
                                context,
                              );

                              if (shouldDelete) {
                                provider.deleteTask(
                                  task.id!,
                                );
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),

      // =========================
      // TOMBOL TAMBAH TASK
      // =========================

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () async {
          await Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) =>
                  const AddTaskScreen(),
            ),
          );
        },
      ),
    );
  }
}