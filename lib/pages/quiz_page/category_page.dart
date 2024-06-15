import 'package:flutter/material.dart';
import 'package:yug_foundation_app/pages/quiz_page/widget/question_numbers_widget.dart';
import 'package:yug_foundation_app/pages/quiz_page/widget/questions_widget.dart';
import 'package:yug_foundation_app/utils/colors.dart';

import '../../domain/models/category.dart';
import '../../domain/models/option.dart';
import '../../domain/models/question.dart';

class CategoryPage extends StatefulWidget {
  final CategoriesModel category;

  const CategoryPage({super.key, required this.category}) ;

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  PageController controller = PageController();
  late Question question;

  @override
  void initState() {
    super.initState();

    controller = PageController();
    question = widget.category.questions.first;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: buildAppBar(context),
        body: QuestionsWidget(
          category: widget.category,
          controller: controller,
          onChangedPage: (index) => nextQuestion(index: index),
          onClickedOption: selectOption,
        ),
      );

  AppBar buildAppBar(context) => AppBar(
    automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: ColorConstants.mainThemeColor
          ),
        ),
        title: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: QuestionNumbersWidget(
              questions: widget.category.questions,
              question: question,
              onClickedNumber: (index) =>
                  nextQuestion(index: index, jump: true),
            ),
          ),
        ),
      );

  void selectOption(Option option) {
    if (question.isLocked) {
      return;
    } else {
      setState(() {
        question.isLocked = true;
        question.selectedOption = option;
      });
    }
  }

  void nextQuestion({required int index, bool jump = false}) {
    final nextPage = controller.page! + 1;
    final indexPage = index ?? nextPage.toInt();

    setState(() {
      question = widget.category.questions[indexPage];
    });

    if (jump) {
      controller.jumpToPage(indexPage);
    }
  }
}
