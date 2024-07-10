import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yug_foundation_app/pages/widgets/blogs_helper.dart';
import 'package:yug_foundation_app/providers/blogs/blogs_cubit.dart';
import 'package:yug_foundation_app/providers/blogs/blogs_states.dart';
import '../utils/colors.dart';

class BlogsPage extends StatefulWidget {
  const BlogsPage({super.key});

  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  @override
  void initState() {
    BlocProvider.of<BlogsCubit>(context).getBlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark),
      body: SafeArea(
        child: BlocConsumer<BlogsCubit, BlogsState>(
          listener: (BuildContext context, BlogsState state) {
            if (state is BlogsErrorState) {
              SnackBar snackBar = SnackBar(
                content: Text(state.error),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (context, state) {
            if (state is BlogsLoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.mainThemeColor,
                ),
              );
            }
            if (state is BlogsLoadedState) {
              return state.response.data?.length != 0
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 22),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListHeading("Featured", 0),
                            SizedBox(
                                height: 250.0,
                                child: ListView.builder(
                                  itemCount: state.response.data!.length >= 3
                                      ? 3
                                      : state.response.data?.length ?? 0,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  //            physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return PostCard(state.response.data![index],
                                        isFeaturedList: true);
                                  },
                                )),
                            const ListHeading('Latest', 0),
                            Flexible(
                              fit: FlexFit.loose,
                              child: PostsList(
                                posts: state.response.data!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(
                  child: Text(
                    "There are no blogs Available right now!",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                                      );
            }

            return const Center(
              child: Text("Something went wrong!"),
            );
          },
        ),
      ),
    );
  }
}
