import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controller = TextEditingController();
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
                  print(controller.text);
                },
                child: Text("Press here"),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.blue[200],
        height: 50,
        child: Center(child: Text("Bottom Sheet")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Hello")));
        },
        child: Icon(Icons.message_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
