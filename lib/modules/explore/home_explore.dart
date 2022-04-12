import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/logic/providers/theme_provider.dart';
import 'package:new_motel/models/enum.dart';
import 'package:new_motel/modules/explore/restaurant_home_view.dart';
import 'package:new_motel/modules/myTrips/hotel_list_view_page.dart';
import 'package:new_motel/modules/profile/profile_screen.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:new_motel/widgets/bottom_top_move_animation_view.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:new_motel/widgets/common_card.dart';
import 'package:new_motel/widgets/common_search_bar.dart';
import '../../models/hotel_list_data.dart';
import 'home_explore_slider_view.dart';
import 'popular_list_view.dart';
import 'title_view.dart';
import 'package:provider/provider.dart';

class HomeExploreScreen extends StatefulWidget {
  final AnimationController animationController;

  const HomeExploreScreen({Key? key, required this.animationController})
      : super(key: key);
  @override
  _HomeExploreScreenState createState() => _HomeExploreScreenState();
}

class _HomeExploreScreenState extends State<HomeExploreScreen>
    with TickerProviderStateMixin {
  RestaurantListData restaurantListData = RestaurantListData();
  late ScrollController controller;
  late AnimationController _animationController;
  var sliderImageHieght = 0.0;

  @override
  void initState() {
    fetchRestaurant();

    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    widget.animationController.forward();
    controller = ScrollController(initialScrollOffset: 0.0);
    controller
      ..addListener(() {
        if (mounted) {
          if (controller.offset < 0) {
            // we static set the just below half scrolling values
            _animationController.animateTo(0.0);
          } else if (controller.offset > 0.0 &&
              controller.offset < sliderImageHieght) {
            // we need around half scrolling values
            if (controller.offset < ((sliderImageHieght / 1.5))) {
              _animationController
                  .animateTo((controller.offset / sliderImageHieght));
            } else {
              // we static set the just above half scrolling values "around == 0.64"
              _animationController
                  .animateTo((sliderImageHieght / 1.5) / sliderImageHieght);
            }
          }
        }
      });
    super.initState();
  }

  var hotelList = [];
  bool showAddress = false;

  fetchRestaurant() async {
    hotelList = await RestaurantListData().fetchRestaurants();

    setState(() {
      showAddress = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    sliderImageHieght = MediaQuery.of(context).size.width * 1.3;
    return Scaffold(
      body: SafeArea(
        top: true,
        minimum: EdgeInsets.only(top: 40),
        child: BottomTopMoveAnimationView(
          animationController: widget.animationController,
          child: Consumer<ThemeProvider>(
            builder: (context, provider, child) => SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.7,
                            child: Text('Les meilleurs restaurants en Tunisie',style: TextStyles(context).getBoldStyle().copyWith(fontSize: 20),)),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                           // NavigationServices(context).gotoProfileScreen();
                          },
                            child: CircleAvatar(child: Icon(MdiIcons.accountOutline))),
                      ],
                    ),
                  ),
                  serachUI(),
                  SizedBox(
                    height: 30,
                  ),
                  _buildListExplore(),
                  TitleView(
                    titleTxt: AppLocalizations(context).of("popular_destination"),
                    subTxt: '',
                    animation:
                        Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: widget.animationController,
                      curve:
                          Interval((1 / 5) * 1, 1.0, curve: Curves.fastOutSlowIn),
                    )),
                    animationController: widget.animationController,
                    click: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    //Popular Destinations animation view
                    child: PopularListView(
                      hotelData: restaurantListData,
                      animationController: widget.animationController,
                      callBack: (index) {},
                    ),
                  ),
                  TitleView(
                    titleTxt: AppLocalizations(context).of("best_deal"),
                    subTxt: AppLocalizations(context).of("view_all"),
                    animation:
                        Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: widget.animationController,
                      curve:
                          Interval((1 / 5) * 1, 1.0, curve: Curves.fastOutSlowIn),
                    )),
                    isLeftButton: true,
                    animationController: widget.animationController,
                    click: () {},
                  ),
                  getDealListView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _viewHotelsButton(AnimationController _animationController) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        var opecity = 1.0 -
            (_animationController.value > 0.64
                ? 1.0
                : _animationController.value);
        return Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: sliderImageHieght * (1.0 - _animationController.value),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 32,
                left: context.read<ThemeProvider>().languageType ==
                        LanguageType.ar
                    ? null
                    : 24,
                right: context.read<ThemeProvider>().languageType ==
                        LanguageType.ar
                    ? 24
                    : null,
                child: Opacity(
                  opacity: opecity,
                  child: CommonButton(
                    onTap: () {
                      if (opecity != 0) {
                        NavigationServices(context).gotoHotelHomeScreen();
                      }
                    },
                    buttonTextWidget: Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 8),
                      child: Text(
                        AppLocalizations(context).of("view_hotel"),
                        style: TextStyles(context)
                            .getRegularStyle()
                            .copyWith(color: AppTheme.blueTextColor),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sliderUI() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          // we calculate the opecity between 0.64 to 1.0
          var opecity = 1.0 -
              (_animationController.value > 0.64
                  ? 1.0
                  : _animationController.value);
          return SizedBox(
            height: sliderImageHieght * (1.0 - _animationController.value),
            child: HomeExploreSliderView(
              opValue: opecity,
              click: () {},
            ),
          );
        },
      ),
    );
  }

  Widget getDealListView() {
    List<Widget> list = [];
    hotelList.forEach((f) {
      var animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: widget.animationController,
          curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn),
        ),
      );
      list.add(
        HotelListViewPage(
          callback: () {
            NavigationServices(context).gotoHotelDetailes(f);
          },
          hotelData: f,
          animation: animation,
          animationController: widget.animationController,
        ),
      );
    });
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: showAddress ? Column(children: list) : Container(),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<RestaurantListData>? results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      setState(() {
        results = hotelList.cast<RestaurantListData>();
      });
    } else {
      results = hotelList
          .where((restaurant) => restaurant.titleTxt.toLowerCase()
          .contains(enteredKeyword.toLowerCase())).cast<RestaurantListData>()
          .toList();
    }

    setState(() {
      hotelList = results!;
    });
  }

  Widget serachUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 24,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          SizedBox(
            width: MediaQuery.of(context).size.width*0.75,
            child: CommonCard(
              radius: 36,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(38)),
                // onTap: () {
                //   NavigationServices(context).gotoHotelHomeScreen();
                // },
                child: CommonSearchBar(
                  iconData: FontAwesomeIcons.search,
                  enabled: true,
                  text: AppLocalizations(context).of("where_are_you_going"),
                  onchanged: (text){
                    _runFilter(text);
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            flex: 3,
            child: CommonCard(
              radius: 50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(38)),
                  onTap: () {
                    NavigationServices(context).gotoFiltersScreen();
                  },
                  child: Icon(MdiIcons.tuneVariant,color: AppTheme.primaryColor,),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListExplore() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 0, bottom: 0, right: 24, left: 8),
        itemCount: hotelList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var count = hotelList.length-400 > 10 ? 10 : hotelList.length-400;
          var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: _animationController!,
              curve: Interval((1 / count) * index, 1.0,
                  curve: Curves.fastOutSlowIn)));
          _animationController?.forward();
          //Population animation photo and text view
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RestaurantListView(
              hotelData: hotelList[index],
              animation: animation,
              animationController: _animationController!,
              callback: () {
                NavigationServices(context).gotoHotelDetailes(hotelList[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
