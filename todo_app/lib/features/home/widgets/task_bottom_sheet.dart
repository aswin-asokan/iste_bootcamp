import 'package:flutter/material.dart';
import 'package:todo_app/features/shared/widgets/custom_button.dart';
import 'package:todo_app/features/shared/widgets/custom_text_field.dart';

class TaskBottomSheet extends StatelessWidget {
  const TaskBottomSheet({
    super.key,
    required this.isEdit,
    required this.deleteFunction,
    required this.changeStatus,
    required this.onSave,
    required this.taskController,
  });
  final bool isEdit;
  final VoidCallback deleteFunction;
  final VoidCallback changeStatus;
  final VoidCallback onSave;
  final TextEditingController taskController;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 250,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEdit ? "Edit Task" : "Create New Task",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              Row(
                children: [
                  if (isEdit)
                    IconButton(
                      onPressed: () {
                        deleteFunction();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.delete_outline),
                    ),
                  IconButton(
                    onPressed: () {
                      changeStatus();
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ],
          ),
          CustomTextField(
            nameController: taskController,
            hint: "Enter task name",
          ),
          SizedBox(height: 20),
          CustomButton(
            buttonLabel: isEdit ? "Update task" : "Add task",
            action: () {
              onSave();
              Navigator.pop(context);
            },
            color: Colors.black87,
          ),
        ],
      ),
    );
  }
}
