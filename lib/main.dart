import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/view_plan_screen.dart';
import 'screens/add_food_screen.dart';

void main() {
  runApp(MaterialApp(
    home: MainMenu(),
  ));
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Ordering App")),
      body: Column(
        children: [
          ElevatedButton(
            child: Text("Create Plan"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
            },
          ),
          ElevatedButton(
            child: Text("View Plan by Date"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ViewPlanScreen()),
              );
            },
          ),
          ElevatedButton(
            child: Text("Manage Food Items"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddFoodScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
