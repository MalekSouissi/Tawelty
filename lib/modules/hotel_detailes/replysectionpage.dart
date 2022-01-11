import 'package:flutter/material.dart';
import 'package:new_motel/models/avis.dart';
import 'package:new_motel/modules/hotel_detailes/review_data_view.dart';
import 'package:new_motel/services/avis.services.dart';
import 'package:new_motel/widgets/common_appbar_view.dart';
import '../../models/hotel_list_data.dart';
import 'package:comment_box/comment/comment.dart';


class ReplySectionPage extends StatefulWidget {
  @override
  _ReplySectionPageState createState() => _ReplySectionPageState();
}

class _ReplySectionPageState extends State<ReplySectionPage>
    with TickerProviderStateMixin {
  List<RestaurantListData> reviewsList = RestaurantListData.reviewsList;
  AvisServices avisServices = AvisServices();
  late AnimationController animationController;
  bool _isLoading = false;
  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    fetchReviews();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List filedata = [

  ];

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                  print("Comment Clicked");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(data[i]['pic'] + "$i")),
                ),
              ),
              title: Text(
                data[i]['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data[i]['message']),
            ),
          )
      ],
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  fetchReviews() async {
    setState(() {
      _isLoading = true;
    });
    var reviews = await avisServices.getListAvis();
    print(reviews);
    print('hello');
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CommonAppbarView(
            iconData: Icons.close,
            onBackClick: () {
              //Navigator.pop(context);
              print('hello');
              fetchReviews();
              Navigator.pop(context);
            },
            titleText: "Review()",
          ),
          // animation of Review and feedback data
          Expanded(
            child: Container(
              child: CommentBox(
                userImage:
                "https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400",
                child: commentChild(filedata),
                labelText: 'Write a comment...',
                withBorder: false,
                errorText: 'Comment cannot be blank',
                sendButtonMethod: () {
                  if (formKey.currentState!.validate()) {
                    print(commentController.text);
                    setState(() {
                      var value = {
                        'name': 'New User',
                        'pic':
                        'https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400',
                        'message': commentController.text
                      };
                      filedata.insert(0, value);
                    });
                    commentController.clear();
                    FocusScope.of(context).unfocus();
                  } else {
                    print("Not validated");
                  }
                },
                formKey: formKey,
                commentController: commentController,
                backgroundColor: Color(0xFF1C3956),
                textColor: Colors.white,
                sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
              ),
            )
            /*ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                  top: 8, bottom: MediaQuery.of(context).padding.bottom + 8),
              itemCount: reviewsList.length,
              itemBuilder: (context, index) {
                var count = reviewsList.length > 10 ? 10 : reviewsList.length;
                var animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: animationController,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn)));
                animationController.forward();
                // page to redirect the feedback and review data
                return ReviewsView(
                  callback: () {},
                  reviewsList: reviewsList[index],
                  animation: animation,
                  animationController: animationController,
                );
              },
            )*/,
          ),
        ],
      ),
    );
  }

//   Widget appBar() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         SizedBox(
//           height: AppBar().preferredSize.height,
//           child: Padding(
//             padding: EdgeInsets.only(top: 8, left: 8),
//             child: Container(
//               width: AppBar().preferredSize.height - 8,
//               height: AppBar().preferredSize.height - 8,
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(32.0),
//                   ),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Icon(Icons.close),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 4, left: 24),
//           child: Text(
//             "Reviews (20)",
//             style: new TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
}
