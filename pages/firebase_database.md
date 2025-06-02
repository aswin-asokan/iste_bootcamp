# Firebase Database and CRUD operations

## Table of contents

1. [Setting up Realtime Database in Firebase Console](#setting-up-realtime-database-in-firebase-console)
2. [Creating Database Service](#creating-database-service)
3. [Creating a Todo](#creating-a-todo)
4. [Reading data](#reading-data)
5. [Updating a Todo](#updating-a-todo)
6. [Deleting a Todo](#deleting-a-todo)

### Setting up Realtime Database in Firebase Console

- From the side menu of the Project console in Firebase, choose `build -> Realtime Database`
- Press on **Create Database**
- Under rules tab change the database access rule to:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "auth != null && auth.uid === $uid",
        ".write": "auth != null && auth.uid === $uid"
      }
    }
  }
}
```

This give each user access to only their own data.

### Creating Database Service

Create a file `database_services.dart` which helps you create, read, update, and delete To-Do items for each user in Firebase Realtime Database.

```dart
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
    //_firebaseDatabase gets the instance of Firebase Realtime Database.
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  //_dbRef is a reference to the root of your database.
  late final DatabaseReference _dbRef;

    //When you create an object of this class (DatabaseService()), it initializes _dbRef to point to the root of your Firebase DB.
  DatabaseService() {
    _dbRef = _firebaseDatabase.ref();
  }

    //This just provides a way to access the root reference outside the class if needed.
  DatabaseReference get ref => _dbRef;

    //You provide a userId and the taskData (e.g., task description, isChecked status).
    //The .child('users').child(userId).child('todos') path means you are saving this To-Do inside the specific user's To-Do list
    //
  Future<String> createTodo(
    String userId,
    Map<String, dynamic> taskData,
  ) async {
    DatabaseReference newTodoRef = _dbRef
        .child('users')
        .child(userId)
        .child('todos')
        .push();
    //.push() generates a new unique key for the To-Do item.
    //.set(taskData) saves the data at that new key.
    await newTodoRef.set(taskData);
    //Returns the unique key of the newly created To-Do.
    return newTodoRef.key!;
  }

    //Given the userId, the todoId (unique key), and new data (todoData), it updates the existing To-Do item.
  Future<void> updateTodo(
    String userId,
    String todoId,
    Map<String, dynamic> todoData,
  ) async {
    await _dbRef
        .child('users')
        .child(userId)
        .child('todos')
        .child(todoId)
        .update(todoData);
    //.update() changes only the fields you specify (does not overwrite the whole item).
  }

  Future<void> deleteTodo(String userId, String todoId) async {
    await _dbRef
        .child('users')
        .child(userId)
        .child('todos')
        .child(todoId)
        .remove();
    //This deletes the To-Do item identified by todoId under that userId.
  }

    // fetches all To-Do items under a specific user.
  Future<List<Map<String, dynamic>>> getAllTodos(String userId) async {
    final snapshot = await _dbRef
        .child('users')
        .child(userId)
        .child('todos')
        .once();
    final data = snapshot.snapshot.value as Map?;

    //If no To-Dos are found (data == null), it returns an empty list.
    if (data == null) return [];

    //Otherwise, it loops through all To-Do entries and converts them to a list of maps with keys: key, task, and isChecked.
    return data.entries.map((entry) {
      return {
        'key': entry.key,
        'task': entry.value['task'],
        'isChecked': entry.value['isChecked'],
      };
    }).toList();
  }
}
```

> **What’s a DatabaseReference?**
> It’s like a pointer to a specific location in your Firebase Realtime Database. You can read from or write to that location.

### Creating a Todo

```dart
void createTask() async {
    //This line checks if the task input is empty or only has spaces.
    if (taskController.text.trim().isEmpty) return;
    //await waits until Firebase finishes saving the data.
    await _dbService.createTodo(userId, {
        //userId → to know which user’s task list to update.
      'task': taskController.text, //taskController.text gets the text from a TextField.
      'isChecked': false, //false by default because it's a new task and not completed yet.
    });
    taskController.clear(); //clears the input field so the user can type a new task.
    fetchTasks(); //reloads all tasks from Firebase and updates the UI with the new task included.
}
```

**Usage:**

```dart
onPressed: createTask // for button press
```

### Reading data

#### Fetching data at Initial State

```dart
@override
  void initState() {
    super.initState();//Always call the parent version of initState first. It's required.
    //Gets the currently logged-in user from Firebase Authentication.
    final currentUser = FirebaseAuth.instance.currentUser;
    //Extracts the unique ID of the user
    userId = currentUser!.uid;
    //initialized inside the stateful widget class
    //String userId = "";
    //Calls a custom function to load all tasks from Firebase and update the screen.
    fetchTasks();
}
```

```dart
// function for fetching data from database
Future<void> fetchTasks() async {
    //Gets all tasks for the logged-in user from Firebase.
    List<Map<String, dynamic>> fetchedTasks = await _dbService.getAllTodos(
      userId,
    );
    //Updates the UI with those tasks.
    setState(() {
      tasks = fetchedTasks;
      //Initialized inside the stateful widget class
      //List<Map<String, dynamic>> tasks = [];
      isLoading = false;//used for managing loading indicator
      //Initialized inside the stateful widget class
      //bool isLoading = true;
    });
}
```

### Updating a Todo

```dart
// updates the task text of an existing to-do item in Firebase and refreshes the task list on the screen.
void updateTask() async {
    // checks if there’s no task being edited (editingTaskId == null) or the input field is empty.
    if (editingTaskId == null || taskController.text.trim().isEmpty) return;

    // calls the update function from your DatabaseService class.
    // update task for userId, editingTaskId
    await _dbService.updateTodo(userId, editingTaskId!, {
      'task': taskController.text,//new task text you want to save.
    });

    taskController.clear(); // Clears the text field so it’s empty after editing.
    editingTaskId = null; // Resets the edit mode so the app knows you're not editing anymore.
    fetchTasks(); // Reloads the task list from Firebase so the updated text shows on the screen.
}

```

**Usage:**

```dart
onPressed: updateTask // for button press
```

#### Updating checked status

```dart
//flips the checkbox state (true <-> false) of a task and updates it in Firebase.
void toggleCheckbox(int index) async {
    //Gets the task from your tasks list at the given index.
    final task = tasks[index];
    //The current checkbox value is task['isChecked'].
    //! negates it → so true becomes false, false becomes true.
    //This updates the task’s isChecked field in Firebase using your updateTodo() method.
    await _dbService.updateTodo(userId, task['key'], {
      'isChecked': !(task['isChecked'] ?? false),
    });
    //After updating, it reloads the task list to reflect the change in the UI.
    fetchTasks();
}
```

```dart
Checkbox(
  shape: CircleBorder(),
  activeColor: Colors.black87,
  value: task['isChecked'] ?? false,//Binds the checkbox's checked state to the task’s value.
  //When the user taps the checkbox, this triggers the toggleCheckbox() function for that task’s index.
  onChanged: (_) => toggleCheckbox(index),//
),
```

### Deleting a Todo

```dart
// deletes a task from the Firebase Realtime Database
void deleteTask(String taskId) async {
    // This calls the deleteTodo() method from your DatabaseService.
    // It deletes the task under: users → userId → todos → taskId
    await _dbService.deleteTodo(userId, taskId);
    //After deletion, it reloads the list of tasks so the UI gets updated and the deleted task disappears.
    fetchTasks();
}
```

**Usage:**

```dart
onPressed: deleteTask(task['key']);
```

Each task looks like:

```json
{
  "key": "-Nf9xyz456",
  "task": "Do laundry",
  "isChecked": false
}
```

So task['key'] is the unique ID used in Firebase to find and delete the correct task.

> Full code to home screen can be found at [home.dart](https://github.com/aswin-asokan/iste_bootcamp/blob/main/todo_app/lib/features/home/screens/home.dart)
