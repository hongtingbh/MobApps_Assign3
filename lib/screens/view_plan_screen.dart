import 'package:flutter/material.dart';
import '../db/app_database.dart';
import '../models/plan_entry.dart';

class ViewPlanScreen extends StatefulWidget {
  const ViewPlanScreen({super.key});

  @override
  State<ViewPlanScreen> createState() => _ViewPlanScreenState();
}

class _ViewPlanScreenState extends State<ViewPlanScreen> {
  String queryDate = "";
  List<PlanEntry> results = [];

  Future<void> search() async {
    results = await AppDatabase.instance.getPlanByDate(queryDate);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Plan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Date (YYYY-MM-DD)"),
              onChanged: (val) => queryDate = val,
            ),
            ElevatedButton(onPressed: search, child: Text("Search")),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, i) {
                  final p = results[i];
                  return ListTile(
                    title: Text(p.foodName),
                    subtitle: Text("\$${p.foodCost}"),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
