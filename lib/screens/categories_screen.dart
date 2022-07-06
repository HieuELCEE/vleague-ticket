import 'package:flutter/material.dart';

import '../data/categories_data.dart';
import '../widgets/category_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return CategoryItem(
          id: LIST_CATEGORIES[index].id,
          title: LIST_CATEGORIES[index].title,
          imgUrl: LIST_CATEGORIES[index].imgUrl,
        );
      },
      itemCount: LIST_CATEGORIES.length,
    );
  }
}
