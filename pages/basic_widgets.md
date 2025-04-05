# Basic Flutter widgets

## Table of contents

1. [Scaffold Widget](#scaffold-widget)
2. [Basic Widgets](#basic-widgets)  
   2.1. [Container](#container)
   2.2. [Text](#text)
   2.3. [Buttons](#buttons)
   2.4. [Icon](#icon)

---

#### Scaffold widget

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

#### Basic widgets

**Note:** Try out the following widgetsinside the **body:** property of Scaffold

##### Container

We use the body property of the Scaffold widget to define the main content area of the screen. You can place any widget as the body.

```dart
Container(
       height: 200,
       width: 300,
       color: Colors.red,
       child: Text("data"),
     ),
```

The container widget as the name suggests holds something inside it by using **child** property, like the above example.

![basic-container](https://aswin-asokan.github.io/iste_bootcamp/images/basic-container.png)

To further customize the container use **decoration:** property and then use **BoxDecoration()** to decorate it.

```dart
Container(
       height: 200,
       width: 300,
       decoration: BoxDecoration(
         color: Colors.red,
         borderRadius: BorderRadius.circular(10),
         border: Border.all(color: Colors.blue, width: 2),
       ),
       child: Text("data"),
     ),
```

![custom-container](https://aswin-asokan.github.io/iste_bootcamp/images/custom-container.png)

**Note:** when you are using decoration property always place **color** property inside **BoxDecoration()**. Otherwise, it leads to an error.

---

##### Text

It is used to show textual data. Use **style:** property to change text style,

```dart
Text("Title",
      style: TextStyle(
      color: Colors.blue,
      fontSize: 20,
      fontWeight: FontWeight.bold,)
```

![text](https://aswin-asokan.github.io/iste_bootcamp/images/text.png)

---

##### Buttons

Buttons are used to carry out certain actions. All buttons have 1 common parameter which is,

- **onPressed:** used to define the action to be performed when a button is pressed. If no actions to be performed set to (){}

**1. Elevated Button**
An ElevatedButton in Flutter is a Material Design button that appears raised and triggers an action when pressed.

- **child:** pass any widget to this as to show inside the elevated button

```dart
ElevatedButton(onPressed: () {}, child: Text("Press here"))
```

![elevated](https://aswin-asokan.github.io/iste_bootcamp/images/elevated.png)

**2. Text Button**
A flat button commonly used to show text, like links inside website.

- **child:** pass any widget to this as to show inside the text button

```dart
TextButton(
          onPressed: () {},
          child: Text("Register here", style: TextStyle(color: Colors.blue)),
        )
```

![text_button](https://aswin-asokan.github.io/iste_bootcamp/images/text_button.png)

**3. Icon Button**
Used to create a button with an icon.

- **icon:** to create the icon to be shown on the button, we use Icon() widget to implement this

```dart
IconButton(onPressed: () {}, icon: Icon(Icons.shopify))
```

![icon_button](https://aswin-asokan.github.io/iste_bootcamp/images/icon_button.png)

---

##### Icon

Used to create an icon. Inside the parentheses we give **Icons.icon_name** to use in-built icons in material design. size: property can be used to adjust icon size.

```dart
Icon(Icons.shopify, size: 50)//changes size to 50px
```

![icon](https://aswin-asokan.github.io/iste_bootcamp/images/icon.png)

---

##### Appbar

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
