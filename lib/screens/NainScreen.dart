import 'package:flutter/material.dart';
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              indicatorColor: Colors.white,
              enableFeedback: true,
              unselectedLabelColor: Colors.blue.shade300,
              tabs:const [
                Tab(
                  icon: Icon(Icons.home),
                ),
                Tab(
                  icon: Icon(Icons.search),
                ),
                Tab(
                  icon: Icon(Icons.person),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Center(child: Text("Home Page")),  // Content of the First Tab
              Center(child: Text("Favorites Page")),  // Content of the Second Tab
              Center(child: Text("Profile Page")),
            ],
          ),
        ),
      ),
    );
  }
}
