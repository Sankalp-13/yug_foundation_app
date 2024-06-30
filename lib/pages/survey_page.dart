import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:yug_foundation_app/domain/models/survey_answer_request_model.dart';
import 'package:yug_foundation_app/providers/survey_home/survey_home_cubit.dart';
import '../domain/models/survey_response_model.dart';
import '../providers/survey_home/survey_home_states.dart';
import '../utils/colors.dart';

class SurveyPage extends StatefulWidget {
    String title;
  List<Questions> ques;
  String des;
  SurveyPage({super.key,required this.ques,required this.title,required this.des});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {


  // Answers ans = Answers();

  late List<String> ans;


  @override
  void initState() {
    super.initState();
    ans = List.filled(widget.ques.length,"" );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    return Scaffold(
      body: BlocConsumer<SurveyHomeCubit,SurveyHomeState>(
          listener: (context, state) {
            if (state is SurveyHomeErrorState) {
              context.loaderOverlay.hide();
              SnackBar snackBar = SnackBar(
                content: Text(state.error),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).popUntil((route) => route.isFirst);
            }

            if (state is SurveyHomeLoadingState){

              context.loaderOverlay.show();
            }
            if(state is SurveyHomeLoadedState){
              context.loaderOverlay.hide();
            }

          }, builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: screenHeight,
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    widget.des,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                FocusTraversalGroup(
                    child: Form(
                      onChanged: () {
                        Form.of(primaryFocus!.context!).save();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: widget.ques.length,
                            itemBuilder: (BuildContext context, int index)  {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.ques[index].text!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(color: Colors.black.withOpacity(0.6)),
                                ),
                                // SizedBox(
                                //   child: TextField(
                                //     style: const TextStyle(fontSize: 14),
                                //     keyboardType: TextInputType.multiline,
                                //     maxLines: null,
                                //     decoration: InputDecoration(
                                //       isDense: true,
                                //         hintText: "Answer here",
                                //         hintStyle: const TextStyle(fontSize: 14),
                                //         contentPadding: const EdgeInsets.all(6),
                                //         filled: true,
                                //         fillColor: Colors.grey.shade300,
                                //         border:
                                //             const OutlineInputBorder(borderSide: BorderSide.none)),
                                //   ),
                                // ),
                                TextFormField(
                                  style: const TextStyle(fontSize: 14),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "Answer here",
                                      hintStyle: const TextStyle(fontSize: 14),
                                      contentPadding: const EdgeInsets.all(6),
                                      filled: true,
                                      fillColor: Colors.grey.shade300,
                                      border:
                                      const OutlineInputBorder(borderSide: BorderSide.none)),
                                  onSaved: (String? value) {
                                    debugPrint(
                                        'Value for field $index saved as "$value"');
                                    ans[index] = value??"";
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            );
                          }
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                        ColorConstants.mainThemeColor,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(5)))),
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>SurveyPage(ques: state.response.data![index].questions!, title: state.response.data![index].topic!, des: state.response.data![index].description!)));

                      SurveyAnswerRequestModel _surveyAnswerRequestModel = SurveyAnswerRequestModel();
                      List<Answers> temp=[];
                      for(int i=0;i<ans.length;i++){
                        Answers a = Answers();
                        a.questionId = widget.ques[i].id;
                        a.response = ans[i];
                        temp.add(a);
                      }

                      _surveyAnswerRequestModel.answers = temp;
                      String jsonAnswers = jsonEncode(_surveyAnswerRequestModel.toJson());
                      print(jsonAnswers);

                      BlocProvider.of<SurveyHomeCubit>(context).sendAnswers(jsonAnswers);
                    },
                    child: Text(
                      "Submit Survey",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          );
        }
      ),
    );
  }
}
