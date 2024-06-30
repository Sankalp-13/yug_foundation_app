import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yug_foundation_app/domain/models/category.dart';

import '../../../domain/models/quiz_response_model.dart';
import '../../../utils/colors.dart';
import '../category_page.dart';

class CategoryHeaderWidget extends StatelessWidget {
  final QuizResponseModel category;

  const CategoryHeaderWidget({super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CategoryPage(category: category),
        )),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ColorConstants.mainThemeColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_book_rounded, color: Colors.white, size: 36),
              const SizedBox(height: 12),
              Text(
                category.topic!,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
      );
}
