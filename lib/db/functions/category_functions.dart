import 'package:fin_trackr/models/category/category_model_db.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

// ignore: constant_identifier_names
const CATEGORY_DB_NAME = 'category-database';

abstract class CategoryDBfunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> addCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryId);
}

class CategoryDB implements CategoryDBfunctions {
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();
  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryNotifier = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryNotifier =
      ValueNotifier([]);

  @override
  Future<void> addCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);

    await categoryDB.put(value.id, value);
    getAllCategory();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    // ignore: non_constant_identifier_names
    final CategoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    incomeCategoryNotifier.notifyListeners();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    expenseCategoryNotifier.notifyListeners();
    return CategoryDB.values.toList();
  }

  Future<void> getAllCategory() async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    incomeCategoryNotifier.value.clear();
    expenseCategoryNotifier.value.clear();

    incomeCategoryNotifier.value.addAll(categoryDB.values);
    expenseCategoryNotifier.value.addAll(categoryDB.values);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    incomeCategoryNotifier.notifyListeners();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    expenseCategoryNotifier.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String id) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.delete(id);
    getAllCategory();
  }

  late CategoryModel editCategoryModel;
  editCategory({
    required CategoryModel editCategoryModel,
    required String id,
    required String name,
  }) async {
    // ignore: unused_local_variable
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    editCategoryModel.id = id;
    editCategoryModel.name = name;
    editCategoryModel.save();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    incomeCategoryNotifier.notifyListeners();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    expenseCategoryNotifier.notifyListeners();
  }
}
