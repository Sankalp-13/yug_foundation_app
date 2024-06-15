import 'package:flutter/material.dart';
import 'package:yug_foundation_app/domain/models/category.dart';

class CategoryDetailWidget extends StatelessWidget {
  final CategoriesModel category;
  final ValueChanged<CategoriesModel> onSelectedCategory;

  const CategoryDetailWidget({super.key,
    required this.category,
    required this.onSelectedCategory,
  }) ;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onSelectedCategory(category),
        child: Container(
          padding: EdgeInsets.only(right: 10),
          width: MediaQuery.of(context).size.width * 0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildImage(),
              SizedBox(height: 12),
              Text(
                category.categoryName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 4),
              Text(
                category.description,
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
      );

  Widget buildImage() => Container(
        height: 150,
        decoration: BoxDecoration(
          color: category.backgroundColor,
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(image: AssetImage(category.imageUrl)),
        ),
      );
}
