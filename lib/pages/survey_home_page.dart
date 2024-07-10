import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yug_foundation_app/pages/survey_page.dart';
import 'package:yug_foundation_app/providers/survey_home/survey_home_cubit.dart';
import 'package:yug_foundation_app/providers/survey_home/survey_home_states.dart';

import '../utils/colors.dart';

class SurveyHomepage extends StatefulWidget {
  const SurveyHomepage({super.key});

  @override
  State<SurveyHomepage> createState() => _SurveyHomepageState();
}

class _SurveyHomepageState extends State<SurveyHomepage> {
  TextEditingController editingController = TextEditingController();


  @override
  void initState() {
    BlocProvider.of<SurveyHomeCubit>(context).getSurveyHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark
      ),
      body:  SafeArea(
        child: BlocConsumer<SurveyHomeCubit, SurveyHomeState>(
            listener: (BuildContext context, SurveyHomeState state) {
              if (state is SurveyHomeErrorState) {
                SnackBar snackBar = SnackBar(
                  content: Text(state.error),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            builder: (context, state)  {
        
              if (state is SurveyHomeLoadingState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.mainThemeColor,
                  ),
                );
              }
              if (state is SurveyHomeLoadedState) {
            return Container(
              width: screenWidth,
              color: Colors.white,
              child: Column(
                children: [

                  const SizedBox(height: 12,),
                  Text("SURVEY",style: Theme.of(context).textTheme.displayLarge,),

                  const SizedBox(height: 28,),
                  state.response.length !=0?Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: state.response.length??0,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorConstants.lightWidgetColor,
                                  width: 2),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                                // Add rounded corners to the top left
                              ),
                            ),
                            child: Column(
                              children: [
                                // SizedBox(height: screenHeight*0.005,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10, top: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              state.response[index].topic!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                  fontWeight:
                                                  FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              state.response[index].description!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(width: 20,),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:
                                            ColorConstants.mainThemeColor,
                                            foregroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)))),
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SurveyPage(ques: state.response[index].questions!, title: state.response[index].topic!, des: state.response[index].description!,surveyId: state.response[index].id!)));
                                        },
                                        child: Text(
                                          "Take Survey",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20,),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                              ],
                            ),
                          );
                        }),
                  ):Expanded(child: Center(child: Text("There are no surveys Available right now!",style: Theme.of(context).textTheme.bodyLarge,),))
                ],
              ),
            );}
              return const Center(
                child: Text("Something went wrong!"),
              );
          }
        ),
      ),
    );
  }
}
