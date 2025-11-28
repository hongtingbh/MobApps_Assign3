import 'package:flutter/material.dart';
import '../db/app_database.dart';
import '../models/food_item.dart';
import '../models/plan_entry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double targetCost = 0;
  String selectedDate = "";
  List<FoodItem> foodList = [];
  List<FoodItem> selectedItems = [];
  double totalCost = 0;

  @override
  void initState() {
    super.initState();
    loadFood();
  }

  Future<void> loadFood() async {
    foodList = await AppDatabase.instance.getFoodItems();
    setState(() {});
  }

  void toggleSelect(FoodItem item) {
    if ((totalCost + item.cost) <= targetCost) {
      selectedItems.add(item);
      totalCost += item.cost;
      setState(() {});
    }
  }

  Future<void> savePlan() async {
    for (var item in selectedItems) {
      await AppDatabase.instance.savePlan(PlanEntry(
        date: selectedDate,
        foodName: item.name,
        foodCost: item.cost,
      ));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Plan saved!")),
    );

    setState(() {
      selectedItems.clear();
      totalCost = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Planner")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Target Cost"),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                targetCost = double.tryParse(val) ?? 0;
                setState(() {});
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Date (YYYY-MM-DD)"),
              onChanged: (val) => selectedDate = val,
            ),
            SizedBox(height: 10),
            Text(
              "Total Selected Cost: \$${totalCost.toStringAsFixed(2)} / \$${targetCost.toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Divider(),

            Expanded(
              child: ListView.builder(
                itemCount: foodList.length,
                itemBuilder: (context, i) {
                  final item = foodList[i];
                  return ListTile(
                    title: Text("${item.name} — \$${item.cost}"),
                    trailing: ElevatedButton(
                      child: Text("Add"),
                      onPressed: () => toggleSelect(item),
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed:
                  (selectedDate.isEmpty || selectedItems.isEmpty) ? null : savePlan,
              child: Text("Save Plan"),
            ),
          ],
        ),
      ),
    );
  }
}
