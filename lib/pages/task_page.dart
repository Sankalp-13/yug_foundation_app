import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:yug_foundation_app/providers/tasks/task_cubit.dart';

import '../providers/tasks/task_states.dart';
import '../utils/colors.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TasksCubit>(context).getTasks();

  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              elevation: 0,
            scrolledUnderElevation: 0,
              title:
              Text("TASKS",style: Theme.of(context).textTheme.displayLarge,),
            centerTitle: true,
            automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            bottom: TabBar(

              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    // Use the default focused overlay color
                    return states.contains(MaterialState.focused) ? null : Colors.transparent;
                  }
              ),
              tabs: [
                Text("Pending", style: Theme.of(context).textTheme.headlineMedium,),
                Text("Completed", style: Theme.of(context).textTheme.headlineMedium,)
              ],
            ),
          ),

          body: BlocConsumer<TasksCubit, TasksState>(
              listener: (BuildContext context, TasksState state) {
                if (state is TasksErrorState) {
                  SnackBar snackBar = SnackBar(
                    content: Text(state.error),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              builder: (context, state) {

                if (state is TasksLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.mainThemeColor,
                    ),
                  );
                }

                if(state is TasksLoadedState){

                  print( state.response.issuedToTheUser?.length);
                  return state.response.issuedToTheUser?.length != 0?TabBarView(
                    children: [
                      Container(
                        width: screenWidth,
                        color: Colors.white,
                        child: SafeArea(
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: state.response.issuedToTheUser?.length,
                              itemBuilder: (BuildContext context, int index) {
                                DateTime time = DateTime.parse(state.response.issuedToTheUser![index].date!);
                                return state.response.issuedToTheUser?[index].status == "UPCOMING"?
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 16, right: 16, top: 8,bottom: 8),
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
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              padding: const EdgeInsets.all(12),
                                              height: 90,
                                              decoration: BoxDecoration(
                                                color: ColorConstants.lightWidgetColor
                                                    .withOpacity(0.4),
                                                // Set box color to white
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(4)),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      time.day.toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayLarge
                                                          ?.copyWith(
                                                          height: 1,
                                                          fontSize: 32,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                    ),
                                                    Text(
                                                      DateFormat('MMM').format(time),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium
                                                          ?.copyWith(
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          height: 1),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
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
                                                    state.response.issuedToTheUser![index].taskName!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.access_time_outlined),
                                                      Text(
                                                        DateFormat('hh:mm').format(time),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelSmall,
                                                      ),
                                                    ],
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
                                          SizedBox(width: 10,),
                                          // Expanded(
                                          //   child: ElevatedButton(
                                          //     style: ElevatedButton.styleFrom(
                                          //         elevation: 0,
                                          //         backgroundColor: Colors.grey.shade300,
                                          //         foregroundColor: Colors.black45,
                                          //         shape: const RoundedRectangleBorder(
                                          //             borderRadius: BorderRadius.all(
                                          //                 Radius.circular(5)))),
                                          //     onPressed: () {
                                          //
                                          //       BlocProvider.of<TasksCubit>(context).getTasks();
                                          //     },
                                          //     child: Text(
                                          //       "CANCEL",
                                          //       style: Theme.of(context)
                                          //           .textTheme
                                          //           .titleMedium
                                          //           ?.copyWith(
                                          //         color: Colors.black45,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          SizedBox(width: 10,),
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

                                                BlocProvider.of<TasksCubit>(context).completeTask(state.response.issuedToTheUser![index].id!);

                                              },
                                              child: Text(
                                                "DONE",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                    ],
                                  ),
                                ):Container();
                              }),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        color: Colors.white,
                        child: SafeArea(
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: state.response.issuedToTheUser?.length,
                              itemBuilder: (BuildContext context, int index) {
                                DateTime time = DateTime.parse(state.response.issuedToTheUser![index].date!);
                                return state.response.issuedToTheUser?[index].status == "COMPLETED"?
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 16, right: 16, top: 8,bottom: 8),
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
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              padding: const EdgeInsets.all(12),
                                              height: 90,
                                              decoration: BoxDecoration(
                                                color: ColorConstants.lightWidgetColor
                                                    .withOpacity(0.4),
                                                // Set box color to white
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(4)),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                  time.day.toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayLarge
                                                          ?.copyWith(
                                                          height: 1,
                                                          fontSize: 32,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                    ),
                                                    Text(
                                                        DateFormat('MMM').format(time),

                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium
                                                          ?.copyWith(
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          height: 1),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
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
                                                    state.response.issuedToTheUser![index].taskName!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.access_time_outlined),
                                                      Text(
                                                          DateFormat('hh:mm').format(time),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelSmall,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //   MainAxisAlignment.spaceEvenly,
                                      //   children: [
                                      //     SizedBox(width: 10,),
                                      //     Expanded(
                                      //       child: ElevatedButton(
                                      //         style: ElevatedButton.styleFrom(
                                      //             elevation: 0,
                                      //             backgroundColor: Colors.grey.shade300,
                                      //             foregroundColor: Colors.black45,
                                      //             shape: const RoundedRectangleBorder(
                                      //                 borderRadius: BorderRadius.all(
                                      //                     Radius.circular(5)))),
                                      //         onPressed: () {},
                                      //         child: Text(
                                      //           "CANCEL",
                                      //           style: Theme.of(context)
                                      //               .textTheme
                                      //               .titleMedium
                                      //               ?.copyWith(
                                      //             color: Colors.black45,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     SizedBox(width: 10,),
                                      //     Expanded(
                                      //       child: ElevatedButton(
                                      //         style: ElevatedButton.styleFrom(
                                      //             elevation: 0,
                                      //             backgroundColor:
                                      //             ColorConstants.mainThemeColor,
                                      //             foregroundColor: Colors.white,
                                      //             shape: const RoundedRectangleBorder(
                                      //                 borderRadius: BorderRadius.all(
                                      //                     Radius.circular(5)))),
                                      //         onPressed: () {},
                                      //         child: Text(
                                      //           "DONE",
                                      //           style: Theme.of(context)
                                      //               .textTheme
                                      //               .titleMedium
                                      //               ?.copyWith(
                                      //             color: Colors.white,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     SizedBox(width: 10,),
                                      //   ],
                                      // ),
                                      SizedBox(height: 10,),
                                    ],
                                  ),
                                ):Container();
                              }),
                        ),
                      ),
                    ],
                  ):Expanded(child: Center(child: Text("There are no tasks Available right now!",style: Theme.of(context).textTheme.bodyLarge,),))
                  ;
                }
                return Center(child: Text("Something went wrong"));
            }
          ),
        ),
    );
  }
}
