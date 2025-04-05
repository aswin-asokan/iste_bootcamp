# Basic Flutter widgets

## Table of contents

1. [Container](#container)
2. [Sized Box](#sized-box)
3. [Text](#text)
4. [Buttons](#buttons)
5. [Icon](#icon)
6. [Textfield](#textfield)
7. [Image](#image)
8. [Safe area](#safearea)
9. [Padding](#padding)
10. [Row and Column](#row-and-column)
11. [Scrolling](#scrolling)

---

**Note:** Try out the following widgets inside the **body:** property of Scaffold

#### Container

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

#### Sized box

Similar to container. But, it do not support any customization other than changing height and width. Like container it can also hold a widget as it's child. Usually used to give space between widgets in multiple widget layout.

```dart
 SizedBox(height: 20, width: 100)
```

---

#### Text

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

#### Buttons

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

#### Icon

Used to create an icon. Inside the parentheses we give **Icons.icon_name** to use in-built icons in material design. size: property can be used to adjust icon size.

```dart
Icon(Icons.shopify, size: 50)//changes size to 50px
```

![icon](https://aswin-asokan.github.io/iste_bootcamp/images/icon.png)

---

#### Textfield

Textfield is used for taking user inputs.

![textfield](https://aswin-asokan.github.io/iste_bootcamp/images/textfield.png)

**1. Fill color:** set backgroud color to the textfield

- set **filled** property as true

**2. Prefix icon:** icon to be shown at left side of textfield
**3. Label:** to give the text field a label
**4. Hint text:** text to be shown as a hint, like _Enter phone number_
**5. Suffix icon:** icon to be shown at right side of textfield
**6. Activation indicator:** change color if the text field is selected
**7. Helper text:** a text that is shown below the text field

For getting the value from the text field we have to create a **TextEditingController** object for it and pass it to the controller property of the textfield like the example below. The **decoration** property is used to customise the textfield with **InputDecoration()**.

```dart
class _HomeState extends State<Home> {
    //creating controller for text field
    TextEditingController controller = TextEditingController();
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: TextField(
                //set text field controller
                controller: controller,
                decoration: InputDecoration(
                     //add prefix icon
                    prefixIcon: Icon(Icons.calendar_month),
                    //add text below text field
                    helperText: "Helper text",
                    //add label
                    label: Text("Input text"),
                    //add hint text
                    hintText: "Hint text",
                    //add border
                    border: OutlineInputBorder(),
                    //add suffix icon button
                    suffixIcon: IconButton(
                    onPressed: () {
                        //clear text field on press
                        controller.clear();
                    },
                    icon: Icon(Icons.clear),
                    ),
                    //make background color true
                    filled: true,
                     //set background color
                    fillColor: Colors.lime,
                ),
                ),
        );
    }
}
```

![textfield_output](https://aswin-asokan.github.io/iste_bootcamp/images/tfield.png)

---

#### Image

Images can be added in 2 ways,

**1. Local asset**
To add an image from local directory to your flutter project,

- Create a folder <span style="color:green">/assets/images</span> and place your image in that folder

![image_asset](https://aswin-asokan.github.io/iste_bootcamp/images/image_asset.png)

- Now open the <span style="color:green">pubspec.yaml</span> file from the project directory. Scroll down and find,

```dart
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_ham.jpeg
```

- remove the comments, right click on your image then copy it's relative path and add the path like below,

```dart
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets: // comments removed
  - assets/flutter.png //path added
  #   - images/a_dot_ham.jpeg
```

- Now use **Image.asset()** widget to add an image to your app

```dart
Image.asset("assets/images/flutter.png")//add relative path
```

**2. URL**

We can also add images directly from web by using links to it like,

```dart
Image.network(
          "https://cdn.pixabay.com/photo/2015/04/23/22/00/new-year-background-736885_1280.jpg",
        ),
```

---

#### Safearea

A widget that insets its child with sufficient padding to avoid intrusions by the operating system. Like the widgets will be displayed under the status bar in mobile devies. For this right click on the widget inside body select the **refractor** option wrap it with widget and change the widget as **SafeArea**.

- **Without safearea**

```dart
return Scaffold(
      body: SafeArea(child: Image.asset("assets/images/flutter.png")),
    );
```

<img src="https://aswin-asokan.github.io/iste_bootcamp/images/without_safearea.png" height=500>

- **With safearea**

```dart
return Scaffold(body: SafeArea(child: Image.asset("assets/images/flutter.png")));
```

<img src="https://aswin-asokan.github.io/iste_bootcamp/images/with_safearea.png" height=500>

---

### Padding

A widget that insets its child by the given padding.For this we wrap our widget with **Padding** widget and give value to the **padding:** property The below code adds a padding of 24 pixel around the image widget.

```dart
Padding(
          padding: const EdgeInsets.all(24),
          child: Image.asset("assets/images/flutter.png"),
        ),
```

- Without padding:

  <img src="https://aswin-asokan.github.io/iste_bootcamp/images/without_padding.png" height=400>

- With padding:

  <img src="https://aswin-asokan.github.io/iste_bootcamp/images/with_padding.png" height=400>

**Types**
**1. EdgeInsets.all(value):** Add a symmetric paddic of given value around the widget
**2. EdgeInsets.only(top: val,right: val,left: val,bottom: val):** Add specific padding of given value to each side
**3. EdgeInsets.symmetric(horizontal: val,vertical: val):** Give similar padding horizontally and vertically

---

#### Row and Column

These are use to arrange multiple widgets horizontally and vertically.

<img src="https://aswin-asokan.github.io/iste_bootcamp/images/row_column.png" height=500>

**1. Row**
Used to arrange widgets as a horizontal array.

```dart
Row(
    children: [
        Container(
        width: 200,
        height: 200,
        color: Colors.red,
        child: Text("container 1"),
        ),
        Container(
        width: 200,
        height: 200,
        color: Colors.red,
        child: Text("container 2"),
        ),
    ],
),
```

<img src="https://aswin-asokan.github.io/iste_bootcamp/images/row.png" height=500>

**1. Colunn**
Used to arrange widgets as a horizontal array.

```dart
Row(
    children: [
        Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Enter text',
                  border: OutlineInputBorder(),
                ),
              ),
              //add a space of 20px
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  //display text in console
                  print(controller.text);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
    ],
),
```

<img src="https://aswin-asokan.github.io/iste_bootcamp/images/column.png" height=500>

**Properties:**

Try each of these and observe the differences.

**1. Main Axis:**

- Row: The main axis is horizontal (left to right).
- Column: The main axis is vertical (top to bottom).
- mainAxisAlignment controls how children are aligned along this primary axis.

```dart
Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children[
            ....
        ]
)
```

**Values**

- **MainAxisAlignment.center:** Place the children as close to the middle of the main axis as possible.
- **MainAxisAlignment.start:** Place the children as close to the start of the main axis as possible.
- **MainAxisAlignment.end:** Place the children as close to the end of the main axis as possible.
- **MainAxisAlignment.spaceAround:** Place the free space evenly between the children as well as half of that space before and after the first and last child.
- **MainAxisAlignment.spaceBetween:** Place the free space evenly between the children.
- **MainAxisAlignment.spaceEvenly:** Place the free space evenly between the children as well as before and after the first and last child.

**2. Cross Axis:**

- Row: The cross axis is vertical (top to bottom).
- Column: The cross axis is horizontal (left to right).
- crossAxisAlignment controls how children are aligned along this secondary axis.

```dart
Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children[
            ....
        ]
)
```

**Values**

- **1. CrossAxisAlignment.start:** Place the children with their start edge aligned with the start side of the cross axis.
- **2. CrossAxisAlignment.end:** Place the children as close to the end of the cross axis as possible.
- **3. CrossAxisAlignment.center:** Place the children so that their centers align with the middle of the cross axis.

**3. Spacing**
Add equal spacing between children.

```dart
Column(
        spacing: 10,
        children[
            ....
        ]
)
```

---

#### Scrolling

For adding a scroll functionality to rows and columns. This will also ensures there are no overlflow issues in the app. To implement a scrolling function wrap the row/ column with **SingleChildScrollView**.

```dart
SingleChildScrollView(
    child: Column(
        spacing: 50,
        children: [
        Container(
            width: 200,
            height: 200,
            color: Colors.red,
            child: Text("container 1"),
        ),
        Container(
            width: 200,
            height: 200,
            color: Colors.red,
            child: Text("container 2"),
        ),
        Container(
            width: 200,
            height: 200,
            color: Colors.red,
            child: Text("container 3"),
        ),
        ],
    ),
)
```

**Notes:** Use the **scrolldirection** property of **SingleChildScrollView** for adjusting the scrolling in Row as the default one is set to vertical.

```dart
SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
        spacing: 50,
        children: [
        Container(
            width: 200,
            height: 200,
            color: Colors.red,
            child: Text("container 1"),
        ),
        Container(
            width: 200,
            height: 200,
            color: Colors.red,
            child: Text("container 2"),
        ),
        Container(
            width: 200,
            height: 200,
            color: Colors.red,
            child: Text("container 3"),
        ),
        ],
    ),
)
```
