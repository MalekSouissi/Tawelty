import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_motel/constants/helper.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/models/avis.dart';
import 'package:new_motel/modules/hotel_detailes/replysectionpage.dart';
import 'package:new_motel/modules/hotel_detailes/review_data_view.dart';
import 'package:new_motel/services/avis.services.dart';
import 'package:new_motel/widgets/common_appbar_view.dart';
import 'package:new_motel/widgets/common_card.dart';
import 'package:new_motel/widgets/custom_dialog.dart';
import '../../models/hotel_list_data.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:new_motel/constants/helper.dart';

class ReviewsListScreen extends StatefulWidget {
  @override
  _ReviewsListScreenState createState() => _ReviewsListScreenState();
}

class _ReviewsListScreenState extends State<ReviewsListScreen>
    with TickerProviderStateMixin {
  List<RestaurantListData> reviewsList = RestaurantListData.reviewsList;
  AvisServices avisServices = AvisServices();
  late AnimationController animationController;
  bool _isLoading = false;
  var reviews = [];
  TextEditingController controller = TextEditingController();
  TextEditingController controllerUpdate = TextEditingController();
  Helper helper = Helper();
  final f = new DateFormat('yyyy-MM-dd');
  addReview(avis) async {
    setState(() {
      _isLoading = false;
    });
    await avisServices.addAvis(avis).then((value) => fetchReviews());
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    fetchReviews();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List filedata = [];

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
            reviews = await avisServices.getListAvis();
    print(reviews);
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
              fetchReviews();
              Navigator.pop(context);
            },
            titleText: "Review(${reviews.length})",
          ),
          // animation of Review and feedback data
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                  top: 8, bottom: MediaQuery.of(context).padding.bottom + 8),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                var count = reviewsList.length > 10 ? 10 : reviewsList.length;
                var animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: animationController,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn)));
                animationController.forward();
                // page to redirect the feedback and review data
                return GestureDetector(
                  onLongPress: () {
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 200,
                            //color: Colors.amber,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        _deleteReview(reviews[index].id);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(CupertinoIcons.delete),
                                          SizedBox(width: 10,),
                                          Text('Delete'),
                                        ],
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        _updateReview(index);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit_outlined),
                                          SizedBox(width: 10,),
                                          Text('Edit'),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: ReviewsView(
                    callback: () {},
                    reviewsList: reviews[index],
                    animation: animation,
                    animationController: animationController,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 48,
                        child: CommonCard(
                          radius: 8,
                          color: AppTheme.whiteColor,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            child: AspectRatio(
                              aspectRatio: 1,
                              // child: Image.asset(
                              //   reviewsList.imagePath,
                              //   fit: BoxFit.cover,
                              // ),
                              child: Icon(
                                Icons.person,
                                size: 24,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                // border: OutlineInputBorder(),
                                hintText: 'Add your comment',
                                hintStyle: new TextStyles(context)
                                    .getDescriptionStyle()
                                    .copyWith(
                                      fontWeight: FontWeight.w100,
                                      color: Theme.of(context).disabledColor,
                                    ),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        onTap: () {
                          addReview(Avis(
                              id: 3,
                              text: controller.text,
                              restaurantId: 55,
                              userId: 67,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now()));
                          setState(() {
                            controller.clear();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'post',
                                textAlign: TextAlign.left,
                                style: TextStyles(context)
                                    .getRegularStyle()
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                              SizedBox(
                                height: 38,
                                width: 26,
                                child: Icon(
                                  Icons.send,
                                  size: 14,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _deleteReview(id) async {
    bool isOk = await helper.showCommonPopup(
      "Are you sure?",
      "You want to Delete this comment ?",
      context,
      barrierDismissible: true,
      isYesOrNoPopup: true,
    );
    if (isOk) {
      delete(id);
    }
  }

  delete(ID) async {
    await avisServices
        .deleteAvis(ID.toString())
        .then((value) => fetchReviews());
    setState(() {
      _isLoading = true;
    });
  }

  _updateReview(index) {
    return showDialog(
      context: context,
      //barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
        actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        buttonPadding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Text(
                "Modifier commentaire",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: controllerUpdate,
                decoration: InputDecoration(
                  hintText: reviews[index].text,
                  border: InputBorder.none,
                  hintStyle:
                      new TextStyles(context).getDescriptionStyle().copyWith(
                            fontWeight: FontWeight.w100,
                            color: Theme.of(context).disabledColor,
                          ),
                ),
              ),
              SizedBox(height: 10),
              Divider(),
            ],
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white54,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              print(reviews[index].id);
              print(controllerUpdate.text);
              print(reviews[index].createdAt);
              setState(() {
                _isLoading=false;
              });
              await avisServices.updateAvis(
                  reviews[index].id.toString(),
                  Avis(
                      id: reviews[index].id,
                      text: controllerUpdate.text,
                      createdAt: reviews[index].createdAt,
                      updatedAt: DateTime.now(),
                      restaurantId: 30,
                      userId: 67)).then((value) => fetchReviews());
              setState(() {
                _isLoading=true;
              });
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Text(
                "Update",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white54,
                ),
              ),
            ),
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
