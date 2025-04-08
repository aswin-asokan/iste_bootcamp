# Scaffold Class

## Table of contents

1. [Scaffold Widget](#scaffold-widget)
2. [App bar](#appbar)
3. [Drawer](#drawer)
4. [Bottom sheet](#bottomsheet)
5. [Floating action button](#floating-action-button)

### Scaffold widget

Scaffold is the basic layout structure used for development in flutter. Given below are the basic properties of Scaffold used for app development.

![scaffold](https://aswin-asokan.github.io/iste_bootcamp/images/scaffold.jpg)

**Scaffold properties**

```dart
return Scaffold(
      appBar: AppBar(),//to create an app bar
      drawer: Drawer(),//to create a drawer
      body: Container(),//to create a container as main content
      floatingActionButton: IconButton(onPressed: (){}, icon: Icon(Icons.add)),//to create a floating action button
      bottomSheet: Container(),//to create a bottom sheet
    );
```

---

#### Appbar

![scaffold](https://aswin-asokan.github.io/iste_bootcamp/images/app_bar.png)

To implement an appbar type **appBar:** inside the Scaffold() and use the **AppBar()** widget.

```dart
return Scaffold(
      appBar: AppBar(
        //leading icon shown on top left corner
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        // title shown after leading icon
        title: Text("Title"),
        // icons shown on right side
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
        //bottom part of app bar, it always uses PreferredSize() widget
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: Divider(),
        ),
      ),
    );
```

The above code will give you an appbar like this,

![scaffold](https://aswin-asokan.github.io/iste_bootcamp/images/appbar.png)

- **leading:** property defines the widget to be shown at left most side of appbar
- **title:** property defines the title of the appbar
- **actions:** is list in which we can give multiple widgets to be shown at right most side
- **bottom:** this widget is shown at the bottom of the appbar

---

### Drawer

Drawer is a simple way to navigate between different sections of a Flutter app. To access the drawer, one can tap on the drawer icon on the left edge of the Appbar, and the drawer slides out, revealing a list of options.

To create a drawer,

**1. Add a iconbutton on leading part of appbar to open the drawer**

```dart
AppBar(
    leading: Builder(
    builder: (context) => IconButton(
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      icon: Icon(Icons.menu),
    ),
  ),
)
```

> **Note:** In Flutter, when you use Scaffold.of(context) or ScaffoldMessenger.of(context), the context must be a child of the Scaffold. But the leading widget (which is inside AppBar) doesn’t have access to the full Scaffold context yet. Builder creates a new BuildContext that is now a child of the Scaffold. This allows Scaffold.of(context) to successfully find the Scaffold and open the drawer.

![drawer_icon](https://aswin-asokan.github.io/iste_bootcamp/images/drawer_icon.png)

**2. Using drawer property of Scaffold create a Drawer widget**

```dart
drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.5,
        backgroundColor: Colors.white,
        child: ListView(
          children: [
          DrawerHeader(child: Image.asset("assets/images/flutter.png")),
            ListTile(
              title: Text("Button"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Button"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
```

| Property        | Description                                            |
| --------------- | ------------------------------------------------------ |
| width           | Controls how wide the drawer is                        |
| backgroundColor | Changes the background color of the drawer.            |
| child           | The content of the drawer. Often a ListView or Column. |

> **Notes**

**DrawerHeader :** a special widget provided by Flutter to place a decorative or informative header at the top of the Drawer.

**MediaQuery.of(context).size.width:** this return the width of the screen. Multiplying with 0.5 gives value as half the width of screen. Changing width to height can give the height value.

**Listview:** ListView is a scrollable column. It lays out its children vertically and allows the user to scroll if the content is too long for the screen.

**ListTile:** is a pre-built widget to create a clickable row with:

| Property | Description                          |
| -------- | ------------------------------------ |
| title    | main text                            |
| subtitle | optional smaller text                |
| leading  | an icon or image on the left         |
| trailing | an icon or widget on the right       |
| onTap    | what happens when the tile is tapped |

**Navigator.pop(context):** it is used to close the current context on the screen. Here pressing on listtile closes the drawer.

![drawer_](https://aswin-asokan.github.io/iste_bootcamp/images/drawer_.png)

---

### Bottomsheet

A BottomSheet is a panel that slides up from the bottom of the screen. It’s perfect for showing, extra options (like "Edit", "Delete"), a small form or message, etc. For this use the **bottomSheet** property of Scaffold.

```dart
bottomSheet: Container(
        color: Colors.blue[200],
        height: 50,
        child: Center(child: Text("Bottom Sheet")),
        //center aligns child to center of parent
      ),
```

<img src="https://aswin-asokan.github.io/iste_bootcamp/images/bottom_sheet.png" height=500/>

---

### Floating action Button

A Floating Action Button (FAB) is a circular button that usually "floats" above your UI, typically in the bottom-right corner. It's meant to represent the primary action on a screen.

```dart
floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Hello")));
        },
        child: Icon(Icons.message_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

```

> **Notes**

**ScaffoldMessenger:** A Flutter widget that displays SnackBars (the small message boxes at the bottom of the screen).

**floatingActionButtonLocation:** This tells Flutter where to place your FAB on the screen. Commonly used values are,

| Values      | Description   |
| ----------- | ------------- |
| centerFloat | Bottom center |
| endFloat    | Bottom right  |
| startFloat  | Bottom left   |
| centerTop   | Top center    |
| endTop      | Top right     |
| startTop    | Top left      |

| Floating action Button                                                                  | Snackbar Messenger                                                            |
| --------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| ![floating_icon](https://aswin-asokan.github.io/iste_bootcamp/images/floating_icon.png) | ![snackbar](https://aswin-asokan.github.io/iste_bootcamp/images/snackbar.png) |
