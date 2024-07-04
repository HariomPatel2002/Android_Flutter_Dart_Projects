import 'package:flutter/material.dart';
import 'package:myproject1/main.dart';
import 'package:myproject1/data/dummy_data.dart';
import 'package:myproject1/models/category.dart';
import 'package:myproject1/screens/meals.dart';
import 'package:myproject1/widgets/category_grid_item.dart';

import '../models/meal.dart';
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({
    super.key,
    required this.onToggleFavorite,
    required this.availableMeals
  });

  final void Function(Meal meal) onToggleFavorite;
  final List<Meal> availableMeals;

  void _selectCategory(BuildContext context ,Category category){
    final filteredMeals = availableMeals.where((meal) => meal.categories.contains(category.id)).toList();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          onToggleFavorite: onToggleFavorite,
        ),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pick your category"),),
      body: GridView(
        padding: EdgeInsets.all(24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 20,
          mainAxisExtent: 120,
        ),
        children: [
          // availableCategories.map((category) => CategoryGrid(category: category))
          for(final category in availableCategories)
            CategoryGridItem(category: category,
              onSelectCategory: (){
              _selectCategory(context,category);
              },
            )
        ],
      ),
    );
  }
}

