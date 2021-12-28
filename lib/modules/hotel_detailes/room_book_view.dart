import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/models/bookWaitSeat.dart';
import 'package:new_motel/models/table.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'DisabledInput.dart';
import 'confResevPage.dart';
import 'package:http/http.dart' as http;

class RoomeBookView extends StatefulWidget {
  final String restaurantId;

  const RoomeBookView({Key? key, req, required this.restaurantId})
      : super(key: key);

  @override
  _RoomeBookViewState createState() => _RoomeBookViewState();
}

class _RoomeBookViewState extends State<RoomeBookView> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  BookWaitSeat bookwaitseat = BookWaitSeat();

  TextEditingController guestNameController = TextEditingController();
  var user;
  final List<BookWaitSeat> listBWS = [];
  final List<BookWaitSeat> databaseBWS = [];
  final List<int> listTables = [];
  final List<RestaurantTable> listAllTables = [];
  final List<String> demandeSpecial = [];
  DateTime? startTime;
  DateTime? endTime;
  late int id;
  bool _isLoading = false;
  bool _validate = false;
  //final List<int> availableTables=[];
  final List<RestaurantTable> availableTables = [];
  final List<BookWaitSeat> availableBWS = [];
  final List<BookWaitSeat> unavailableBWS = [];
  String restaurantName='';

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  TimeOfDay? newTime;
  DateTime? datetime;

  String getText() {
    if (datetime == null) {
      return 'Select Date';
    } else {
      return DateFormat('dd-MM-yyyy').format(datetime!);
    }
  }

  TimeOfDay? time;

  String getTextTime() {
    if (time == null) {
      return 'Select Time';
    } else {
      final hours = time!.hour.toString().padLeft(2, '0');
      final minutes = time!.minute.toString().padLeft(2, '0');

      //print('$hours:$minutes:00');
      return '$hours:$minutes';
    }
  }

  pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    showCustomTimePicker(
            context: context,
            // It is a must if you provide selectableTimePredicate
            onFailValidation: (context) => print('Unavailable selection'),
            initialTime: TimeOfDay(hour: 2, minute: 0),
            selectableTimePredicate: (time) =>
                // time.hour > 1 &&
                //     time.hour < 14 &&
                time!.minute % 30 == 0)
        .then((time) => setState(() => newTime = time));

    if (newTime == null) return;

    setState(() => time = newTime);
  }

  var pageController = PageController(initialPage: 0);

  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  @override
  void initState() {
    print(widget.restaurantId);
    //_getUserInfo();
    _fetchBWS();
    _fetchTables();
    setState(() {
      _isLoading = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //List<String> images = widget.roomData.imagePath.split(" ");
    return Container(
      child: ListView(
        children: [
          //Text(DateTime.now().day.toString()),
          Stepper(
            //type: StepperType.horizontal,
            steps: _mySteps(),
            currentStep: this._currentStep,
            onStepTapped: (step) {
              setState(() {
                this._currentStep = step;
              });
            },
            onStepContinue: () {
              setState(() {
                if (this._currentStep < this._mySteps().length - 1) {
                  this._currentStep = this._currentStep + 1;
                } else {
                  //Logic to check if everything is completed
                  //print('Completed, check fields.');
                }
                //  _buildListAvailbaleTablesWithNbPerson(_counter);
                // _getAvailableTablesTimeAndDate();
              });
            },
            onStepCancel: () {
              setState(() {
                if (this._currentStep > 0) {
                  this._currentStep = this._currentStep - 1;
                } else {
                  this._currentStep = 0;
                }
              });
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 18.0),
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     color: Color(0xFFAF8F61).withOpacity(0.8),
          //     child: TextButton(
          //         onPressed: () {
          //           // _fetchBWS();
          //           // _fetchTables();
          //           _buildListAvailbaleTablesWithNbPerson(_counter);
          //
          //         },
          //         child: Text('get reservation',style: TextStyle(color: Colors.white,fontSize: 18),)),
          //   ),
          // ),
          CommonButton(
            padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
            buttonText: AppLocalizations(context).of("get_reservation"),
            onTap: () {
             //_fetchBWS();
              //_fetchTables();
              _buildListAvailbaleTablesWithNbPerson(_counter);
            },
          ),
        ],
      ),
    );
  }

  List<Step> _mySteps() {
    List<Step> _steps = [
      Step(
        title: Text(
          'Choose guest number',
          style: TextStyles(context).getTitleStyle(),
        ),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: AppTheme.primaryTextColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_counter',
                style: TextStyles(context).getHintStyle(),

              ),
              Column(
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.arrow_drop_up,
                      size: 30,
                      color: AppTheme.primaryTextColor,
                    ),
                    onTap: _incrementCounter,
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 30,
                        color: AppTheme.primaryTextColor                    ),
                    onTap: _decrementCounter,
                  ),
                ],
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text(
          'Pick the date',
          style: TextStyles(context).getTitleStyle(),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppTheme.primaryTextColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: AppTheme.primaryTextColor,
                    size: 30,
                  ),
                  GestureDetector(
                    child: Text(
                      getText(),
                      style: TextStyles(context).getHintStyle(),

                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate:
                            datetime == null ? DateTime.now() : datetime!,
                        initialDatePickerMode: DatePickerMode.day,
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2040),
                      ).then((date) {
                        setState(() {
                          datetime = date;
                          print(datetime);
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text(
          'Pick the time',
          style: TextStyles(context).getTitleStyle(),
        ),
        content: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppTheme.primaryTextColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.timer,
                    color: AppTheme.primaryTextColor,
                    size: 30,
                  ),
                  GestureDetector(
                    child: Text(
                      getTextTime(),
                      style: TextStyles(context).getHintStyle(),

                    ),
                    onTap: () {
                      pickTime(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text(
          'Validate info',
          style: TextStyles(context).getTitleStyle(),
        ),
        content: DisabledInput(
            controller: guestNameController,
            validate: _validate,
            inputHint: 'jhon',
            color: AppTheme.primaryTextColor),
        isActive: _currentStep >= 3,
      ),
      Step(
        title: Text(
          'Special request',
          style: TextStyles(context).getTitleStyle(),
        ),
        content: Align(
          alignment: Alignment.centerLeft,
          child: Container(
              child: Wrap(
            //spacing: 5.0,
            //runSpacing: 3.0,
            children: <Widget>[
              FilterChipWidget(
                chipName: 'Allergie',
                chips: demandeSpecial,
              ),
              FilterChipWidget(
                chipName: 'Végéteriens',
                chips: demandeSpecial,
              ),
              FilterChipWidget(
                chipName: 'Evenement',
                chips: demandeSpecial,
              ),
              FilterChipWidget(
                chipName: 'Chaise bébé',
                chips: demandeSpecial,
              ),
              FilterChipWidget(
                chipName: 'Handicapé',
                chips: demandeSpecial,
              ),
              FilterChipWidget(
                chipName: 'Table demané',
                chips: demandeSpecial,
              ),
            ],
          )),
        ),
        isActive: _currentStep >= 3,
      ),
    ];
    return _steps;
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  _fetchBWS() async {
    final response = await http.get(Uri.parse(
        'http://37.187.198.241:3000/BWS/GetALlBookWaitSeat/${widget.restaurantId}'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      for (var item in jsonData['bookwaitseat']) {
        listBWS.add(BookWaitSeat.fromJson(item));
      }
      restaurantName=jsonData['NomResto'];
      print(jsonData['bookwaitseat']);
      return listBWS;
    } else {
      throw Exception('Failed to load album');
    }
  }

  _fetchTables() async {
    final response = await http.get(Uri.parse(
        'http://37.187.198.241:3000/user/RestaurantWithTable/${widget.restaurantId}'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      for (var item in jsonData['table']) {
        listAllTables.add(RestaurantTable.fromJson(item));
        availableTables.add(RestaurantTable.fromJson(item));
        //availableTables.add(listAllTables[item]);
      }
      print(jsonData['table']);
     return availableTables;
    } else {
      throw Exception('Failed to load album');
    }
  }

  _buildListTables() {
    setState(() {
      _isLoading = true;
    });

    for (int i = 0; i < listAllTables.length; i++) {
      if (listTables.contains(listAllTables[i].ids)) {
        i++;
      } else {
        listTables.add(listAllTables[i].ids - 1630);
        availableTables.add(listAllTables[i]);
      }
    }
    //print(listTables);
    setState(() {
      _isLoading = false;
    });
  }

  _buildListAvailbaleTablesWithNbPerson(int nbPerson) {
    for (int i = 0; i < listBWS.length; i++) {
      for (int j = 0; j < availableTables.length; j++) {
        if (availableTables[j].nbCouverts == nbPerson &&
            listBWS[i].id == availableTables[j].ids - 1630) {
          print(availableTables[j].ids - 1630);

          startTime = DateTime(datetime!.year, datetime!.month, datetime!.day,
              newTime!.hour, newTime!.minute);
          endTime = DateTime(datetime!.year, datetime!.month, datetime!.day,
              newTime!.hour + 1, newTime!.minute);
          final DateTime dbStartTime = DateTime(
              listBWS[i].debut!.year,
              listBWS[i].debut!.month,
              listBWS[i].debut!.day,
              listBWS[i].debut!.hour + 2,
              listBWS[i].debut!.minute);
          final DateTime dbEndTime = DateTime(
              listBWS[i].fin!.year,
              listBWS[i].fin!.month,
              listBWS[i].fin!.day,
              listBWS[i].fin!.hour + 2,
              listBWS[i].fin!.minute);
          print(dbStartTime);
          print(dbEndTime);
          print(startTime);
          print(endTime);
          if (startTime!.compareTo(dbStartTime) >= 0 &&
                  startTime!.compareTo(dbEndTime) <= 0 ||
              (endTime!.compareTo(dbStartTime) >= 0 &&
                  endTime!.compareTo(dbEndTime) <= 0)) {
            print(databaseBWS[i].id);
            print('is unavailable');
            id = listBWS[i].id;
            unavailableBWS.add(listBWS[i]);
            print(unavailableBWS.length);
            _showMyDialog();
          } else {
            print(listBWS[i].ids);
            print('is available');
            id = listBWS[i].id;
            availableBWS.add(listBWS[i]);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConfirmPage(
                          bookWaitSeat: availableBWS,
                          restaurantName: restaurantName,
                          startTime: startTime!,
                          endTime: endTime!,
                          Tables: availableTables,
                          guestName: guestNameController.text,
                          demandeSpecial: demandeSpecial,
                          user: 65,
                          guestNumber: _counter,
                        )));
          }
        }
      }
    }
    // id = availableBWS[0].id;
    // result = 'table with id= $id is available at date :$startTime';
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Result'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('No available Tables at this time'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class FilterChipWidget extends StatefulWidget {
  final String chipName;
  final List<String> chips;
  FilterChipWidget({Key? key, this.chipName = '', required this.chips})
      : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle:TextStyles(context).getRegularStyle(),

    selected: _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
          widget.chips.add(widget.chipName);
        });
      },
      selectedColor: Theme.of(context).primaryColor,
    );
  }
}

// AnimatedBuilder(
// animation: widget.animationController,
// builder: (BuildContext context, Widget? child) {
// return FadeTransition(
// opacity: widget.animation,
// child: new Transform(
// transform: new Matrix4.translationValues(
// 0.0, 40 * (1.0 - widget.animation.value), 0.0),
// child: Column(
// children: <Widget>[
// Stack(
// alignment: Alignment.bottomCenter,
// children: <Widget>[
// AspectRatio(
// aspectRatio: 1.5,
// child: PageView(
// controller: pageController,
// pageSnapping: true,
// scrollDirection: Axis.horizontal,
// children: <Widget>[
// for (var image in images)
// Image.asset(
// image,
// fit: BoxFit.cover,
// ),
// ],
// ),
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: SmoothPageIndicator(
// controller: pageController, // PageController
// count: 3,
// effect: WormEffect(
// activeDotColor: Theme.of(context).primaryColor,
// dotColor: Theme.of(context).backgroundColor,
// dotHeight: 10.0,
// dotWidth: 10.0,
// spacing: 5.0), // your preferred effect
// onDotClicked: (index) {},
// ),
// ),
// ],
// ),
// Padding(
// padding: const EdgeInsets.only(
// left: 16, right: 16, bottom: 16, top: 16),
// child: Column(
// children: <Widget>[
// Row(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: <Widget>[
// Text(
// widget.roomData.titleTxt,
// maxLines: 2,
// textAlign: TextAlign.left,
// style: TextStyles(context)
//     .getBoldStyle()
//     .copyWith(fontSize: 24),
// overflow: TextOverflow.ellipsis,
// ),
// Expanded(child: SizedBox()),
// SizedBox(
// height: 38,
// child: CommonButton(
// buttonTextWidget: Padding(
// padding: const EdgeInsets.only(
// left: 16.0, right: 16.0, top: 4, bottom: 4),
// child: Text(
// AppLocalizations(context).of("book_now"),
// textAlign: TextAlign.center,
// style: TextStyles(context).getRegularStyle(),
// ),
// ),
// ),
// ),
// ],
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.start,
// children: <Widget>[
// Text(
// "\$${widget.roomData.perNight}",
// textAlign: TextAlign.left,
// style: TextStyles(context)
//     .getBoldStyle()
//     .copyWith(fontSize: 22),
// ),
// Padding(
// padding: const EdgeInsets.only(bottom: 0),
// child: Text(
// AppLocalizations(context).of("per_night"),
// style: TextStyles(context)
//     .getRegularStyle()
//     .copyWith(fontSize: 14),
// ),
// ),
// ],
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// crossAxisAlignment: CrossAxisAlignment.center,
// children: <Widget>[
// Text(
// Helper.getPeopleandChildren(
// widget.roomData.roomData!),
// // "${widget.roomData.dateTxt}",
// textAlign: TextAlign.left,
// style: TextStyles(context).getDescriptionStyle(),
// ),
// InkWell(
// borderRadius:
// BorderRadius.all(Radius.circular(4.0)),
// onTap: () {},
// child: Padding(
// padding: const EdgeInsets.only(left: 8, right: 4),
// child: Row(
// mainAxisSize: MainAxisSize.min,
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.center,
// children: <Widget>[
// Text(
// AppLocalizations(context)
//     .of("more_details"),
// style: TextStyles(context).getBoldStyle(),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 2),
// child: Icon(
// Icons.keyboard_arrow_down,
// // color: Theme.of(context).backgroundColor,
// size: 24,
// ),
// )
// ],
// ),
// ),
// ),
// ],
// ),
// ],
// ),
// ),
// Divider(
// height: 1,
// )
// ],
// ),
// ),
// );
// },
