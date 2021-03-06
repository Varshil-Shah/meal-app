import 'package:flutter/material.dart';
import 'package:meal_app/dummy_data.dart';
import 'package:meal_app/models/filters.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/screens/categories.dart';
import 'package:meal_app/screens/category_meals.dart';
import 'package:meal_app/screens/fliters.dart';
import 'package:meal_app/screens/meal_detail.dart';
import 'package:meal_app/screens/tabs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FilterData _filtersData = FilterData(
    isGlutenFree: false,
    isLactoseFree: false,
    isVegetarian: false,
    isVegan: false,
  );

  List<Meal> _availableMeals = DUMMY_MEALS;
  final List<Meal> _favouriteMeals = [];

  void _setFilters(FilterData filteredData) {
    setState(() {
      _filtersData = filteredData;
      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filtersData.isGlutenFree && !meal.isGlutenFree) return false;
        if (_filtersData.isLactoseFree && !meal.isLactoseFree) return false;
        if (_filtersData.isVegan && !meal.isVegan) return false;
        if (_filtersData.isVegetarian && !meal.isVegetarian) return false;
        return true;
      }).toList();
    });
  }

  void _toggleFavourite(String mealId) {
    final existingMealIndex =
        _favouriteMeals.indexWhere((meal) => meal.id == mealId);
    if (existingMealIndex >= 0) {
      setState(() {
        _favouriteMeals.removeAt(existingMealIndex);
      });
    } else {
      setState(() {
        _favouriteMeals
            .add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      });
    }
  }

  bool _isFavouriteMeal(String mealId) {
    return _favouriteMeals.any((meal) => meal.id == mealId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Junction',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: const TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: const TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline1: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      routes: {
        "/": (ctx) => TabsScreen(
              favouriteMeals: _favouriteMeals,
            ),
        CategoryMeals.routeName: (ctx) => CategoryMeals(
              availableMeals: _availableMeals,
            ),
        MealDetail.routeName: (ctx) => MealDetail(
              toggleFavourite: _toggleFavourite,
              isFavouriteMeal: _isFavouriteMeal,
            ),
        Filter.routeName: (ctx) => Filter(
              saveFilters: _setFilters,
              currentFilters: _filtersData,
            ),
      },
      onUnknownRoute: (settings) {
        debugPrint(settings.name);
        debugPrint(settings.arguments.toString());
        return MaterialPageRoute(builder: (ctx) => const CatogriesScreen());
      },
    );
  }
}
