
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:myproject1/screens/meal_details.dart';
import 'package:myproject1/widgets/meal_item.dart';
// import 'package:myproject1/screens/meals.dart';
import '../models/meal.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
     this.title,
    required this.meals,
    required this.onToggleFavorite,
  });

  final String? title;
  final List<Meal>meals;
  final void Function(Meal meal) onToggleFavorite;

  void selectMeal(BuildContext context,Meal meal){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(
          meal: meal,
          onToggleFavorite: onToggleFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content =Center(child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Uh oh ... nothingf here! ',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),),
        const SizedBox(height: 16,),
        Text('Try selecting a different category ',style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
        ),)
      ],),);
    if(meals.isNotEmpty){
      content = ListView.builder(
        itemCount: meals.length,
        itemBuilder: (ctx,index) => MealItem(meal: meals[index],onSelectMeal: (context,meal){
          selectMeal(context, meal);
        },
        ),
            // Text(
            // meals[index].title
        //),
      );
    }
    if(title == null){
      return content;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title!
        ),
      ),
      body: content,
    );
  }
}
