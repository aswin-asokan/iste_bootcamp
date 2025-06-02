import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/features/home/widgets/task_bottom_sheet.dart';
import 'package:todo_app/services/database_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseService _dbService = DatabaseService();
  final TextEditingController taskController = TextEditingController();
  String userId = "";
  bool isBottomSheetOpen = false;
  bool isLoading = true;
  List<Map<String, dynamic>> tasks = [];
  String? editingTaskId;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    userId = currentUser!.uid;
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    List<Map<String, dynamic>> fetchedTasks = await _dbService.getAllTodos(
      userId,
    );
    setState(() {
      tasks = fetchedTasks;
      isLoading = false;
    });
  }

  void createTask() async {
    if (taskController.text.trim().isEmpty) return;
    await _dbService.createTodo(userId, {
      'task': taskController.text,
      'isChecked': false,
    });
    taskController.clear();
    fetchTasks();
  }

  void updateTask() async {
    if (editingTaskId == null || taskController.text.trim().isEmpty) return;
    await _dbService.updateTodo(userId, editingTaskId!, {
      'task': taskController.text,
    });
    taskController.clear();
    editingTaskId = null;
    fetchTasks();
  }

  void deleteTask(String taskId) async {
    await _dbService.deleteTodo(userId, taskId);
    fetchTasks();
    setState(() {
      isBottomSheetOpen = false;
    });
  }

  void toggleCheckbox(int index) async {
    final task = tasks[index];
    await _dbService.updateTodo(userId, task['key'], {
      'isChecked': !(task['isChecked'] ?? false),
    });
    fetchTasks();
  }

  void openBottomSheet(Widget bottomSheet) {
    showBottomSheet(context: context, builder: (_) => bottomSheet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Todo List",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.black87))
            : tasks.isEmpty
            ? Center(child: Text("No tasks yet!"))
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isBottomSheetOpen = true;
                            taskController.text = task['task'];
                            editingTaskId = task['key'];
                          });
                          openBottomSheet(
                            TaskBottomSheet(
                              isEdit: true,
                              deleteFunction: () => deleteTask(task['key']),
                              changeStatus: () {
                                setState(() => isBottomSheetOpen = false);
                              },
                              onSave: updateTask,
                              taskController: taskController,
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 1.5,
                                    child: Checkbox(
                                      shape: CircleBorder(),
                                      activeColor: Colors.black87,
                                      value: task['isChecked'] ?? false,
                                      onChanged: (_) => toggleCheckbox(index),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    task['task'],
                                    style: TextStyle(
                                      decoration: task['isChecked']
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              ),
      ),

      floatingActionButton: isBottomSheetOpen
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.black87,
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                taskController.clear();
                openBottomSheet(
                  TaskBottomSheet(
                    isEdit: false,
                    deleteFunction: () {},
                    changeStatus: () {},
                    onSave: createTask,
                    taskController: taskController,
                  ),
                );
              },
            ),
    );
  }
}
