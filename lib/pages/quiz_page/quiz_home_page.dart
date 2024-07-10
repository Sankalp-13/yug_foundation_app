import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yug_foundation_app/domain/models/category.dart';
import 'package:yug_foundation_app/domain/models/quiz_response_model.dart';
import 'package:yug_foundation_app/pages/quiz_page/widget/category_detail_widget.dart';
import 'package:yug_foundation_app/pages/quiz_page/widget/category_header_widget.dart';
import 'package:yug_foundation_app/providers/quiz/quiz_cubit.dart';

import '../../data/categories.dart';
import '../../providers/Quiz/Quiz_states.dart';
import '../../utils/colors.dart';
import 'category_page.dart';

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: SafeArea(
                  child: Center(
                      child: Text(
                "Quizzes",
                style: Theme.of(context).textTheme.displayLarge,
              ))),
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
          ),
        ),
        body: BlocConsumer<QuizCubit, QuizState>(
            listener: (BuildContext context, QuizState state) {
              if (state is QuizErrorState) {
                SnackBar snackBar = SnackBar(
                  content: Text(state.error),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            builder: (context, state) {
              if (state is QuizLoadingState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.mainThemeColor,
                  ),
                );
              }
              if (state is QuizLoadedState){
            return state.response.length !=0?
            ListView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                SizedBox(height: 8),
                Container(
                  height: 300,
                  child: GridView.builder(
                    primary: false,
                    itemCount: state.response.length >=4?4:state.response.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4 / 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return CategoryHeaderWidget(category: state.response[index],);
                    },
                  ),
                ),
                SizedBox(height: 32),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Popular',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 240,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.response.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CategoryDetailWidget(
                            category: state.response[index],
                            onSelectedCategory: (QuizResponseModel category) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CategoryPage(category: category),
                              ));
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ):Expanded(child: Center(child: Text("There are no quizzes Available right now!",style: Theme.of(context).textTheme.bodyLarge,),))
            ;}

              return const Center(
                child: Text("Something went wrong!"),
              );
          }
        ),
      );

  @override
  void initState() {
    super.initState();

    BlocProvider.of<QuizCubit>(context).getQuiz();

  }
}
