import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:yug_foundation_app/domain/models/blogs_response_model.dart';

import '../../utils/colors.dart';
import 'cached_image.dart';

class ListHeading extends StatelessWidget {
  final String title;
  final int categoryId;

  const ListHeading(this.title, this.categoryId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: ColorConstants.mainThemeColor),
          ),
          // GestureDetector(
          //   onTap: () {
          //     // PostCategory category = PostCategory(name: title, id: categoryId);
          //     // Navigator.push(context, MaterialPageRoute(builder: (context) => SingleCategory(category)));
          //   },
          //   child: Container(
          //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Theme.of(context).colorScheme.secondary),
          //     padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          //     child: Text('Show All'),
          //   ),
          // )
        ],
      ),
    );
  }
}


class PostCard extends StatelessWidget {
  Data post;
  bool isFeaturedList;

  PostCard(this.post, {super.key, this.isFeaturedList = false});



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = isFeaturedList ? size.width * 0.8 : size.width;
    return GestureDetector(
      onTap: () {
        if (isFeaturedList) Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetails(post)));
      },
      child: Padding(
        padding: EdgeInsets.all(isFeaturedList ? 10.0 : 5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isFeaturedList ? 14.0 : 0.0),
          child: Material(
            elevation: 14.0,
            borderRadius: BorderRadius.circular(10.0),
            shadowColor: Theme.of(context).primaryColor.withOpacity(.5),
            child: SizedBox(
              height: 200.0,
              width: width,
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: '${post.id}_post',
                    child: CachedImage(
                      post.picture!,
                      width: width,
                      height: size.height,
                    ),
                  ),
                  // Positioned.directional(
                  //   textDirection: textDirection,
                  //   end: 0,
                  //   child: CategoryPill(post: post),
                  // ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [ColorConstants.mainThemeColor, Colors.transparent])),
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 5.0, left: 5.0, right: 5.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                post.title!,
                                textAlign: TextAlign.left,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Hero(tag: '${post.id}_author',
                    child: Author(post: post,)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class Author extends StatelessWidget {
  const Author({super.key,
    required this.post,
  });

  final Data post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: CachedImage(
              post.picture!,
              height: 26.0,
              width: 26.0,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8.0),
            child: Text(
              post.authorName!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 5.0,
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 8.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class PostsList extends StatefulWidget {
  List<Data> posts;

  PostsList({required this.posts});

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {

  int page = 0;
  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;

  // void getData() {
  //   if (!isLoading) {
  //     setState(() {
  //       page++;
  //       isLoading = true;
  //     });
  //
  //     WpApi.getPostsList(category: widget.category, page: page).then((_posts) {
  //       setState(() {
  //         isLoading = false;
  //         posts.addAll(_posts);
  //       });
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // getData();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
    //     getData();
    //   }
    // });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Data> posts = widget.posts;
    return ListView.builder(
      itemBuilder: postTile,
      itemCount: posts.length + 1,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      controller: _scrollController,
    );
  }

  Widget postTile(BuildContext context, int index) {
    if(index<3){
      return Container();
    }
    List<Data> posts = widget.posts;
    if (index == posts.length) {
      return _buildProgressIndicator();
    } else {
      return PostListItem(posts[index]);
    }
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Visibility(
          visible: isLoading,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}


class PostListItem extends StatelessWidget {
  final Data post;

  PostListItem(this.post);

  @override
  Widget build(BuildContext context) {

    DateTime inputDate = DateTime.parse(post.createdAt!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetails(post)));
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: Hero(
                tag:'${post.id}_post',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedImage(
                    post.picture!,
                    width: 100,
                    height: 85,
                  ),
                ),
              ),
            ),
            Flexible(
              child: SizedBox(
                height: 95.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post.title!,
                      textAlign: TextAlign.left,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge, //TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0, fontFamily: 'Roboto'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(DateFormat('d/M/y').format(inputDate)),
                        Expanded(
                          child: Text(
                            post.region!,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



class PostDetails extends StatelessWidget {
  Data post;

  PostDetails(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
//    post.isDetailCard = true;
    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            Size size = MediaQuery.of(context).size;
            return <Widget>[
              SliverAppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                floating: true,
                expandedHeight: 300.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: <Widget>[
                      Hero(
                        tag: '${post.id}_post',
                        child: CachedImage(
                          post.picture!,
                          width: size.width,
                          height: size.height,
                        ),
                      ),
                      Positioned(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black, Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Author(post: post),
                      ),
                      Positioned(
                        bottom: 35.0,
                        child: Container(
                            width: size.width,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    post.title!,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      // Positioned.directional(
                      //   textDirection: textDirection,
                      //   bottom: 0,
                      //   end: 0,
                      //   child: CategoryPill(post: post),
                      // ),
                    ],
                  ),
                ),
              )
            ];
          },
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Html(
                data: post.content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

