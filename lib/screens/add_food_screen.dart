import 'package:flutter/material.dart';
import '../db/app_database.dart';
import '../models/food_item.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  List<FoodItem> foods = [];
  String name = "";
  double cost = 0;

  @override
  void initState() {
    super.initState();
    loadFoods();
  }

  Future<void> loadFoods() async {
    foods = await AppDatabase.instance.getFoodItems();
    setState(() {});
  }

  Future<void> addFood() async {
    await AppDatabase.instance.addFood(FoodItem(name: name, cost: cost));
    await loadFoods();
  }

  Future<void> updateFood(FoodItem item) async {
    await AppDatabase.instance.updateFood(item);
    await loadFoods();
  }

  Future<void> deleteFood(int id) async {
    await AppDatabase.instance.deleteFood(id);
    await loadFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Foods")),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: "Food Name"),
            onChanged: (val) => name = val,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Cost"),
            keyboardType: TextInputType.number,
            onChanged: (val) => cost = double.tryParse(val) ?? 0,
          ),
          ElevatedButton(onPressed: addFood, child: Text("Add Food")),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, i) {
                final f = foods[i];
                return ListTile(
                  title: Text("${f.name} — \$${f.cost}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => updateFood(
                          FoodItem(id: f.id, name: f.name, cost: f.cost + 1),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteFood(f.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
