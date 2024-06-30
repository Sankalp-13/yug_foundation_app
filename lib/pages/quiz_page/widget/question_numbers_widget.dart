import 'package:flutter/material.dart';
import 'package:yug_foundation_app/utils/colors.dart';

import '../../../domain/models/question.dart';
import '../../../domain/models/quiz_response_model.dart';

class QuestionNumbersWidget extends StatelessWidget {
  final List<Questions> questions;
  final Questions question;
  final ValueChanged<int> onClickedNumber;

  const QuestionNumbersWidget({super.key,
    required this.questions,
    required this.question,
    required this.onClickedNumber,
  });

  @override
  Widget build(BuildContext context) {
    const double padding = 16;

    return Container(
      height: 50,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: padding),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => Container(width: padding),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final isSelected = question == questions[index];

          return buildNumber(index: index, isSelected: isSelected);
        },
      ),
    );
  }

  Widget buildNumber({
    required int index,
    required bool isSelected,
  }) {
    final color = isSelected ? ColorConstants.lightWidgetColor : Colors.white;

    return GestureDetector(
      onTap: () => onClickedNumber(index),
      child: CircleAvatar(
        backgroundColor: color,
        child: Text(
          '${index + 1}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
