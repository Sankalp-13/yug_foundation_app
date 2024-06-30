import 'package:flutter/material.dart';

import '../../../domain/models/option.dart';
import '../../../domain/models/question.dart';
import '../../../domain/models/quiz_response_model.dart';
import '../../../utils.dart';

class OptionsWidget extends StatelessWidget {
  final Questions question;
  final ValueChanged<Option> onClickedOption;

  const OptionsWidget({
    super.key,
    required this.question,
    required this.onClickedOption,
  });

  @override
  Widget build(BuildContext context) => ListView(
        physics: const BouncingScrollPhysics(),
        children: Utils.heightBetween(
          question.options!
              .map((option) => buildOption(context, option))
              .toList(),
          height: 8,
        ),
      );

  Widget buildOption(BuildContext context, Option option) {
    final color = getColorForOption(option, question);

    return GestureDetector(
      onTap: () {
        onClickedOption(option);
        if (option.text == question.correctAnswer){
          option.isCorrect = true;
        }else{
          option.isCorrect = false;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            buildAnswer(option),
            buildSolution(question.selectedOption, option),
          ],
        ),
      ),
    );
  }

  Widget buildAnswer(Option option) => Container(
        height: 50,
        child: Row(children: [
          Text(
            option.code!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(width: 12),
          Text(
            option.text!,
            style: TextStyle(fontSize: 20),
          )
        ]),
      );

  Widget buildSolution(Option? solution, Option answer) {
    if (solution == answer) {
      return Text(
        "The correct answer was ${question.correctAnswer!}!",
        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
      );
    } else {
      return Container();
    }
  }

  Color getColorForOption(Option option, Questions question) {
    final isSelected = option == question.selectedOption;
    print(option.isCorrect);
    print("**************");
    if (!isSelected || option.isCorrect == null) {
      return Colors.grey.shade200;
    } else {
      return option.isCorrect! ? Colors.green : Colors.red;
    }
  }
}
