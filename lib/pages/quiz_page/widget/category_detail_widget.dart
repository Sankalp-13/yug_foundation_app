import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yug_foundation_app/utils/colors.dart';

import '../../../domain/models/quiz_response_model.dart';

class CategoryDetailWidget extends StatelessWidget {
  final QuizResponseModel category;
  final ValueChanged<QuizResponseModel> onSelectedCategory;

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
                category.topic!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 4),
              Text(
                DateFormat('d/M/y').format(DateTime.parse(category.created!)),
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
      );

  Widget buildImage() => Container(
        height: 150,
        decoration: BoxDecoration(
          color: ColorConstants.lightWidgetColor,
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(image: NetworkImage("https://appxcontent.kaxa.in/quiz_series/2024-04-01-0.05692524218308659.png")),
        ),
      );
}
