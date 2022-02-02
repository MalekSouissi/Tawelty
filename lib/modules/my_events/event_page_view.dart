import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/modules/my_events/restaurant_carousel.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:new_motel/widgets/common_card.dart';
import '../../models/hotel_list_data.dart';

class EventViewPage extends StatefulWidget {
  final RestaurantListData hotelData;

  const EventViewPage({Key? key, required this.hotelData}) : super(key: key);
  @override
  _EventViewPageState createState() => _EventViewPageState();
}

class _EventViewPageState extends State<EventViewPage>
    with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);
  var hoteltext1 =
      "Featuring a fitness center, Grand Royale Park Hote is located in Sweden, 4.7 km frome National Museum...";
  var hoteltext2 =
      "Featuring a fitness center, Grand Royale Park Hote is located in Sweden, 4.7 km frome National Museum a fitness center, Grand Royale Park Hote is located in Sweden, 4.7 km frome National Museum a fitness center, Grand Royale Park Hote is located in Sweden, 4.7 km frome National Museum";
  bool isFav = false;
  bool isintrested = false;
  bool isReadless = false;
  late AnimationController animationController;
  var imageHieght = 0.0;
  late AnimationController _animationController;
  GoogleMapController? _controller;
  late BitmapDescriptor customIcon;
  bool isMapCreated = false;
  String? _mapStyle;
  List<Marker> allMarkers = [];
  bool show = false;
  var coordinates;

  getCoordinates(var query) async {
    var addresses = [];
    var first;
    addresses = await Geocoder.local.findAddressesFromQuery(query);
    first = await addresses.first;
    coordinates=await first.coordinates;
    print("${first.countryName} : ${first.coordinates},${first.featureName}");
    setState(() {
      show=true;
    });
    return coordinates;
  }
  void setCustomMapPin() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/image/icon/marker.png');
  }
  setMarker(query)async{
    Coordinates coordinates= await getCoordinates(query);
    allMarkers.add(Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueViolet,
        ),
        markerId: MarkerId(widget.hotelData.titleTxt),
        draggable: false,
        infoWindow:
        InfoWindow(title: widget.hotelData.titleTxt, snippet: widget.hotelData.subTxt),
        position: LatLng(coordinates.latitude,coordinates.longitude)));
  }
  @override
  void initState() {
    getCoordinates(widget.hotelData.subTxt);
    setCustomMapPin();
    setMarker(widget.hotelData.subTxt);
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    animationController.forward();
    scrollController.addListener(() {
      if (mounted) {
        if (scrollController.offset < 0) {
          // we static set the just below half scrolling values
          _animationController.animateTo(0.0);
        } else if (scrollController.offset > 0.0 &&
            scrollController.offset < imageHieght) {
          // we need around half scrolling values
          if (scrollController.offset < ((imageHieght / 1.2))) {
            _animationController
                .animateTo((scrollController.offset / imageHieght));
          } else {
            // we static set the just above half scrolling values "around == 0.22"
            _animationController.animateTo((imageHieght / 1.2) / imageHieght);
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    imageHieght = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CommonCard(
            radius: 0,
            color: AppTheme.scaffoldBackgroundColor,
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.only(top: 24 + imageHieght),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          AppLocalizations(context).of("summary"),
                          style: TextStyles(context).getBoldStyle().copyWith(
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                  EdgeInsets.only(left: 24, right: 24, top: 4, bottom: 8),
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: !isReadless ? hoteltext1 : hoteltext2,
                          style: TextStyles(context)
                              .getDescriptionStyle()
                              .copyWith(
                            fontSize: 14,
                          ),
                          recognizer: new TapGestureRecognizer()..onTap = () {},
                        ),
                        TextSpan(
                          text: !isReadless
                              ? AppLocalizations(context).of("read_more")
                              : AppLocalizations(context).of("less"),
                          style: TextStyles(context).getRegularStyle().copyWith(
                              color: AppTheme.primaryColor, fontSize: 14),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                isReadless = !isReadless;
                              });
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Expanded(
                    child: Text(
                      AppLocalizations(context).of("intersted"),
                      style: TextStyles(context).getBoldStyle().copyWith(
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.5,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(coordinates.latitude,coordinates.longitude), zoom: 15.0),
                        onTap: (pos) {
                          print(pos);
                          Marker m = Marker(
                              markerId: MarkerId('1'), icon: customIcon, position: pos);
                          setState(() {
                            allMarkers.add(m);
                          });
                        },
                        markers: Set.from(allMarkers),
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                          _controller!.setMapStyle(_mapStyle);
                        },
                      ),
                    ),
                    InkWell(
                      onTap: ()async{
                        await MapsLauncher.launchQuery(
                            widget.hotelData.titleTxt);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 34, right: 10),
                        child: CommonCard(
                          color: AppTheme.primaryColor,
                          radius: 36,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              FontAwesomeIcons.mapPin,
                              color: Theme.of(context).backgroundColor,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 16, top: 16),
                  child: CommonButton(
                    buttonText: AppLocalizations(context).of("intersted"),
                    onTap: () {
                      NavigationServices(context)
                          .gotoRoomBookingScreen(widget.hotelData);
                    },
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),

          _backgraoundImageUI(widget.hotelData),

          // Arrow back Ui
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Container(
              height: AppBar().preferredSize.height,
              child: Row(
                children: <Widget>[
                  _getAppBarUi(Theme.of(context).disabledColor.withOpacity(0.4),
                      Icons.arrow_back, AppTheme.backgroundColor, () {
                        if (scrollController.offset != 0.0) {
                          scrollController.animateTo(0.0,
                              duration: Duration(milliseconds: 480),
                              curve: Curves.easeInOutQuad);
                        } else {
                          Navigator.pop(context);
                        }
                      }),
                  Expanded(
                    child: SizedBox(),
                  ),
                  // like and unlike view
                  _getAppBarUi(
                      AppTheme.backgroundColor,
                      isFav ? Icons.favorite : Icons.favorite_border,
                      AppTheme.primaryColor, () {
                    setState(() {
                      isFav = !isFav;
                    });
                  })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getAppBarUi(
      Color color, IconData icon, Color iconcolor, VoidCallback onTap) {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Padding(
        padding: EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Container(
          width: AppBar().preferredSize.height - 8,
          height: AppBar().preferredSize.height - 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              ),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon, color: iconcolor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPhotoReviewUi(
      String title, String view, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              AppLocalizations(context).of(title),
              // "Photos",
              style: TextStyles(context).getBoldStyle().copyWith(
                fontSize: 14,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations(context).of(view),
                      //  'View all',
                      textAlign: TextAlign.left,
                      style: TextStyles(context).getBoldStyle().copyWith(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 38,
                      width: 26,
                      child: Icon(
                        icon,
                        //Icons.arrow_forward,
                        size: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _backgraoundImageUI(RestaurantListData hotelData) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          var opecity = 1.0 -
              (_animationController.value >= ((imageHieght / 1.2) / imageHieght)
                  ? 1.0
                  : _animationController.value);
          return SizedBox(
            height: imageHieght * (1.0 - _animationController.value),
            child: Stack(
              children: <Widget>[
                IgnorePointer(
                  child: Container(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          top: 0,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: ProfilePicture(restaurantId: widget.hotelData.id,)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: opecity,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 24, right: 24),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            child: new BackdropFilter(
                              filter: new ImageFilter.blur(
                                  sigmaX: 10.0, sigmaY: 10.0),
                              child: Container(
                                color: Colors.black12,
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16, top: 8),
                                      child: getHotelDetails(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          bottom: 16,
                                          top: 16),
                                      child: CommonButton(
                                          buttonText: AppLocalizations(context)
                                              .of("intersted"),
                                          onTap: () {

                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            child: new BackdropFilter(
                              filter: new ImageFilter.blur(
                                  sigmaX: 10.0, sigmaY: 10.0),
                              child: Container(
                                color: Colors.black12,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.2),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(38)),
                                    onTap: () {
                                      try {
                                        scrollController.animateTo(
                                            MediaQuery.of(context).size.height -
                                                MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    5,
                                            duration:
                                            Duration(milliseconds: 500),
                                            curve: Curves.fastOutSlowIn);
                                      } catch (e) {}
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 4,
                                          bottom: 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations(context)
                                                .of("more_details"),
                                            style: TextStyles(context)
                                                .getBoldStyle()
                                                .copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 2),
                                            child: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getHotelDetails({bool isInList = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.hotelData.titleTxt,
                textAlign: TextAlign.left,
                style: TextStyles(context).getBoldStyle().copyWith(
                  fontSize: 22,
                  color: isInList ? AppTheme.fontcolor : Colors.white,
                ),
              ),
              SizedBox(
                height: 7.5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.calendar,
                    size: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                  Expanded(
                    flex:2,
                    child: Text(
                      " " +"24-26 january 2022",
                      style: TextStyles(context).getRegularStyle().copyWith(
                        fontSize: 15,
                        color: isInList
                            ? Theme.of(context).disabledColor.withOpacity(0.5)
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Icon(
                    FontAwesomeIcons.clock,
                    size: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    " "+ "4PM - 12AM",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles(context).getRegularStyle().copyWith(
                      fontSize: 15,
                      color: isInList
                          ? Theme.of(context).disabledColor.withOpacity(0.5)
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
