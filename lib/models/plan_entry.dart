class PlanEntry {
  final int? id;
  final String date;
  final String foodName;
  final double foodCost;

  PlanEntry({
    this.id,
    required this.date,
    required this.foodName,
    required this.foodCost,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'foodName': foodName,
        'foodCost': foodCost,
      };

  factory PlanEntry.fromMap(Map<String, dynamic> map) => PlanEntry(
        id: map['id'],
        date: map['date'],
        foodName: map['foodName'],
        foodCost: map['foodCost'],
      );
}
