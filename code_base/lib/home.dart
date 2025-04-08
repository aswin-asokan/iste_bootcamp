import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controller = TextEditingController();

  // Variables go here
  String name = "";
  int count = 0;

  // Functions go here
  void increment() {
    setState(() {
      count++;
    });
  }

  String greetUser(String userName) {
    if (userName == "Aswin") {
      return "Hello $userName";
    } else {
      return "Hello User";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder:
              (context) => IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu),
              ),
        ),

        title: Text(
          "Home",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(controller: controller),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    name = controller.text;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(greetUser(name)),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text("Press here"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          increment();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(count.toString())));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
