import 'package:flutter/material.dart';
import 'package:myproject1/data/dummy_data.dart';
import 'package:myproject1/main.dart';
import 'package:myproject1/screens/categories.dart';
import 'package:myproject1/screens/filters.dart';
import 'package:myproject1/screens/meals.dart';
import '../models/meal.dart';
import '../widgets/main_drawer.dart';

const KInitialFilters = {
  Filter.glutenFree:false,
  Filter.LactoseFree:false,
  Filter.vegetarian:false,
  Filter.vegan:false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectPageIndex  = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter,bool> selectedFilter = KInitialFilters;
  void _showInfoMessage(String message){
    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(message),
        ),
    );
  }
  
  void _toggleMealFavoriteStatus(Meal meal){
    final isExisting = _favoriteMeals.contains(meal);

    if(isExisting){
      setState(() {
        _favoriteMeals.remove(meal);
        _showInfoMessage("Meal is no longer a favorite. ");
      });
    }
    else{
      setState(() {
        _favoriteMeals.add(meal);
        _showInfoMessage("Marked as a favorite. ");
      });
    }
  }
  void _selectPage(int index){
    setState(() {
      _selectPageIndex = index;
    });
  }
  void _setScreen(String identifiers) async {
    Navigator.of(context).pop();

    if (identifiers == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter,bool>>(
        MaterialPageRoute(
          builder: (ctx) => FilterScreen(currentFilters: selectedFilter,),
        ),
      );

      setState(() {
        selectedFilter = result ?? KInitialFilters;
      });
    }
  }

  @override

  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if(selectedFilter[Filter.glutenFree]! && !meal.isGlutenFree){
        return false;
      }
      if(selectedFilter[Filter.LactoseFree]! && !meal.isLactoseFree){
        return false;
      }
      if(selectedFilter[Filter.vegetarian]! && !meal.isVegetarian){
        return false;
      }
      if(selectedFilter[Filter.vegan]! && !meal.isVegan){
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if(_selectPageIndex == 1){
      activePage = MealsScreen(
        meals: _favoriteMeals,
          onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle),),
      drawer: MainDrawer(onSelectSecreen: _setScreen,),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectPageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.set_meal),label:'Categories', ),
          BottomNavigationBarItem(icon: Icon(Icons.star),label: 'Favorites', ),
        ],
      ),
    );
  }
}
