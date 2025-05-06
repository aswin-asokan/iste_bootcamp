# Lists and Dynamic widgets

## Table of contents

1. [Listview](#listview)
2. [Gridview](#gridview)
3. [Bottom Navigationbar](#bottom-navigationbar)
4. [Dynamic widgets](#dynamically-adding-widgets)

### Listview

ListView is a scrollable list of widgets, optimized for:

- Performance with many children
- Automatic scrolling
- Lazy loading (with ListView.builder)
- Efficient memory usage

```dart
ListView(
  children: [
    Text('Item 1'),
    Text('Item 2'),
    // More items...
  ],
)
```

#### Difference between Listview and column + singlechildscrollview

| Feature                        | ListView                                    | Column + SingleChildScrollView                            |
| ------------------------------ | ------------------------------------------- | --------------------------------------------------------- |
| Scrolling                      | Built-in                                    | Requires SingleChildScrollView                            |
| Performance with many children | Better (uses laziness in ListView.builder)  | Poor — all children are built at once                     |
| Supports infinite lists        | Yes (with .builder)                         | No (builds everything)                                    |
| Layout flexibility             | Less flexible (limited by list constraints) | More flexible for complex layouts                         |
| Nesting scrollables            | Can conflict if nested                      | Needs NeverScrollableScrollPhysics to avoid scroll issues |
| Use case                       | Lists of data                               | Forms, mixed content (e.g., image + form + button)        |

**Use ListView when:**

- You have long lists, especially dynamic content
- You need performance and lazy loading

**Use Column + SingleChildScrollView when:**

- You have a fixed number of widgets (like a form)
- You want more control over the layout (e.g., spacers, fixed headers, etc.)

**Lazy loading with listview.builder:**

Lazy loading means only loading or building what's currently needed, and delaying the rest until it's actually required. When you use a widget like ListView.builder, Flutter doesn't build all the list items at once. Instead, it:

- Creates only the widgets that are visible on the screen
- Builds more as you scroll
- Disposes of off-screen widgets to save memory

If your screen only fits 10 items, Flutter will build only those 10 at first. The others are built on demand as you scroll.

```dart
List strings = ["Hello", "World", "This", "Is", "A", "List", "Of", "Strings"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: strings.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.blueAccent,
                height: 50,
                width: double.infinity,
                child: Text(strings[index]),
              ),
              SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
```

The output will be like,

<img src="https://aswin-asokan.github.io/iste_bootcamp/images/listview.png" height=500/>

### Gridview

GridView in Flutter is a scrollable, 2D array of widgets — similar to ListView, but items are laid out in a grid format (i.e., rows and columns).

```dart
return Scaffold(
    body: GridView.count(
    crossAxisCount: 2, // number of columns
    children: List.generate(6, (index) {
        return Container(
        margin: EdgeInsets.all(10),
        color: Colors.blue,
        child: Center(child: Text("Item $index")),
        );
    }),
    ),
);
```

This creates a grid with 2 columns and 6 items.

<img src="https://aswin-asokan.github.io/iste_bootcamp/images/gridview.png" height=500/>

#### Types of GridView

| Type             | Description                                 |
| ---------------- | ------------------------------------------- |
| GridView.count   | Specify number of columns (crossAxisCount)  |
| GridView.extent  | Specify max width of each item              |
| GridView.builder | Lazily builds items — great for performance |
| GridView.custom  | Full control with custom layout logic       |

## Bottom navigationbar

create two pages for home and settings ( You can create more pages if you want).

<img src="https://aswin-asokan.github.io/iste_bootcamp/images/home1.png" height=500/>
<img src="https://aswin-asokan.github.io/iste_bootcamp/images/settings.png" height=500/>

To create a tasks widget,

```dart
// create of list with task name and its checked status
List tasks = [
    {"task": "Task 1", "isChecked": false},
    {"task": "Task 2", "isChecked": false},
    {"task": "Task 3", "isChecked": false},
    {"task": "Task 4", "isChecked": false},
    {"task": "Task 5", "isChecked": false},
];
@override
  Widget build(BuildContext context) {
    return Scaffold(
        // not full code refer listview for the rest
        body: ListView.builder(
            .
            .
            .
            Container(
                padding: EdgeInsets.all(10),
                height: 50,
                width: double.infinity,
                child: Row(
                  children: [
                    // checked box widget
                    Checkbox(
                        // check status
                      value: tasks[index]['isChecked'],
                      // change status
                      onChanged: (value) {
                        setState(() {
                          tasks[index]['isChecked'] = value!;
                        });
                      },
                    ),
                    // task name
                    Text(tasks[index]['task']),
                  ],
                ),
              ),
            .
            .
            .
        )
    )
  }
```

Now coming to the bottom navigation bar we use the **bottomNavigationBar:** property of scaffold with **BottomNavigationBar** class. For this first create a file for holding the bottom navigationbar.

```dart
class _BottomnavbarState extends State<Bottomnavbar> {
    int selectedIndex = 0; // represent current page
    List<Widget> pages = [Home(), Settings()]; // list of pages
    // when a bottom nav bar item is pressed do the action
    void onItemTapped(int index) {
        setState(() {
        selectedIndex = index;
        });
    }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],// show current page as body
      // bottom nav bar class usage
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), // icon for current page
            label: "Home", // text for current page
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
          ),
        ],
        currentIndex: selectedIndex, // which page is active
        onTap: onItemTapped, // when tapped call onItemTapped
      ),
    );
  }
}
```

When we use it with the login page we can navigate to this page when the login credentials are correct.

```dart
if (isValid) {
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => Bottomnavbar()),
    );
}
```

## Dynamically adding widgets

To dynamically add widgets we need an empty list to store the dynamic widgets created, a floatingactionbutton to create new taks and a listviewbuilder to implement this dynamic widgets.

```dart
List tasks = [];
.
.
.
Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            //listview widgets
        ),
        floatingActionButton: FloatingActionButton(
            .
            .
            .
            onPressed: () {
                showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                return Container(
                    padding: EdgeInsets.all(20),
                    height: 200,
                    child: Column(
                    children: [
                        CustomTextField(
                        nameController: taskController,
                        hint: "Enter task name",
                        ),
                        SizedBox(height: 20),
                        CustomButton(
                        buttonLabel: "Add task",
                        action: () {
                            setState(() {
                            tasks.add({
                                'task': taskController.text,
                                'isChecked': false,
                            });
                            taskController.clear();
                            });
                            Navigator.pop(context);
                        },
                        color: Colors.black87,
                        ),
                    ],
                    ),
                );
                },
            );
            }
            .
            .
            .
        )
    )
}
```

**showModalBottomSheet** is a built-in Flutter method used to show a temporary modal sheet that slides up from the bottom of the screen. It’s perfect for things like:

- Adding tasks
- Choosing filters
- Showing quick forms

**isScrollControlled: true** allows the bottom sheet to expand beyond default height (useful if keyboard might open).Makes sure the UI doesn’t get squished or cut off.

**builder: (BuildContext context) =>** This is the content of the bottom sheet.

When pressed, the button:

- Adds the new task to the tasks list using setState so UI updates

```dart
// .add is used to add something at end of a list
tasks.add({
    'task': taskController.text,
    'isChecked': false,
});
```

- Clears the input field

```dart
taskController.clear();
```

- Closes the bottom sheet with Navigator.pop(context)

> **Note**
> You can use the following code inside a onPressed action to delete or edit something,

**For deletion**

```dart
body: ListView.builder(
    .
    .
    .
    return Column(
    .
    .
    .
    child: Row(
    .
    .
    .
    // for removing from list
    IconButton(
        onPressed: () {
        setState(() {
            tasks.removeAt(index);
        });
        },
        icon: Icon(Icons.delete_outline),
    ),
    .
    .
    .
    )
    )
);
```

**For editing**

```dart
//for editing
IconButton(
  onPressed: () {
    //read the current task name
    setState(() {
      taskController.text = tasks[index]['task'];
    });
    showModalBottomSheet(
      .
      .
      .
      CustomButton(
        buttonLabel: "Save task",
        action: () {
          setState(() {
            //remove the task from index
            tasks.removeAt(index);
            //update and insert the task
            tasks.insert(index, {
              'task': taskController.text,
              'isChecked': false,
            });
            taskController.clear();
          });
          Navigator.pop(context);
        },
        color: Colors.black87,
      ),
      .
      .
      .
    );
  }
)
```
