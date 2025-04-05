# Scaffold Class

## Table of contents

1. [Scaffold Widget](#scaffold-widget)
2. [App bar](#appbar)

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
        //bottom part of app bar
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
