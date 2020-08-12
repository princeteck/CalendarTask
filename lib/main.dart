import 'dart:convert';
import 'package:calendar/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './utils/calculateDIstance.dart';
import './utils/extensions/stringExtenstions.dart';
import './dataset/commonDataSet.dart' as Constants;

void main() => runApp(CalendarWeekApp());

class CalendarWeekApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // today date constant
  final DateTime _selectedDate = Constants.today;
  //defaut months
  final List<String> months = Constants.monthDefaults;
  // number of days in a given month
  int totalDaysInCurrentMonth;
  // date which is currently selected
  DateTime selectedDay;

  // DateTime dateTime;

  // width of item in listview for calendar
  double _itemWidth = 70;

  // json response string
  String jsonResponse;

  // data from json response string after decode
  var calendarData;

  // list to store the task
  List<TaskModel> _tasks = [];

  // List to store code mode for the task status
  Map<String, Color> colorCode = {
    "Done": Color(0xff25A87B),
    "Rejected": Color(0xffEF6565),
    "ToDo": Color(0xff4E77D6),
    "InProgress": Color(0xffF5C709),
  };
  // toggle value to show or hide calendar
  bool _showCalendar = false;
  // animated container default height
  double _animatedheight = 0.0;

  // scroll controller for calendar
  ScrollController _scrollController = new ScrollController();

  // offset to scroll to a certain position in calendar by default
  double _offset;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    updateTotalDaysInMonth();
    jsonResponse = await DefaultAssetBundle.of(context)
        .loadString("assets/CalendarTask.json");
    setState(() {
      calendarData = json.decode(jsonResponse) as Map<String, dynamic>;
    });
  }

  @override
  void initState() {
    if (selectedDay == null) {
      selectedDay = _selectedDate;
      _offset = _itemWidth * _selectedDate.day;
    }
    _scrollController = ScrollController(initialScrollOffset: _offset ?? 0);
    super.initState();
  }

  // function to update scroll view based on DateTime
  void scrollUpdate() {
    setState(() {
      double _offset = (selectedDay.month == _selectedDate.month)
          ? _itemWidth * _selectedDate.day
          : 0;
      _scrollController.jumpTo(_offset);
    });
  }

  // function to get total number of dates in a given month
  void updateTotalDaysInMonth() {
    setState(() {
      totalDaysInCurrentMonth =
          DateTime(selectedDay.year, selectedDay.month + 1, 0).day;
    });
  }

  // implementing pull to refersh function
  Future<void> _pullRefresh() async {
    await Future.delayed(Duration(seconds: 3))
        .then((value) => getTask(selectedDay));
  }

  // get task data
  Future getTask(DateTime x) async {
    _tasks.clear();
    calendarData['data'].forEach((result) {
      List<SubTaskModel> _subTasks = [];
      try {
        if (DateFormat.yMMMd().format(DateTime.parse(result['startTimeUtc'])) ==
            DateFormat.yMMMd().format(x)) {
          _subTasks.clear();
          result['tasks'].forEach((st) {
            _subTasks.add(SubTaskModel(
              taskId: st['taskId'],
              title: st['title'],
              isTemplate: st['isTemplate'],
              timesInMinutes: st['timesInMinutes'],
              price: st['price'],
              paymentTypeId: st['paymentTypeId'],
              createDateUtc: st['createDateUtc'],
              lastUpdateDateUtc: st['lastUpdateDateUtc'],
              paymentTypes: st['paymentTypes'],
            ));
          });
          _tasks.add(TaskModel(
            visitId: result['visitId'],
            homeBobEmployeeId: result['homeBobEmployeeId'],
            houseOwnerId: result['houseOwnerId'],
            isBlocked: result['isBlocked'],
            startTimeUtc: result['startTimeUtc'],
            endTimeUtc: result['endTimeUtc'],
            title: result['title'],
            isReviewed: result['isReviewed'],
            isFirstVisit: result['isFirstVisit'],
            isManual: result['isManual'],
            visitTimeUsed: result['visitTimeUsed'],
            rememberToday: result['rememberToday'],
            houseOwnerFirstName: result['houseOwnerFirstName'],
            houseOwnerLastName: result['houseOwnerLastName'],
            houseOwnerMobilePhone: result['houseOwnerMobilePhone'],
            houseOwnerAddress: result['houseOwnerAddress'],
            houseOwnerZip: result['houseOwnerZip'],
            houseOwnerCity: result['houseOwnerCity'],
            houseOwnerLatitude: result['houseOwnerLatitude'],
            houseOwnerLongitude: result['houseOwnerLongitude'],
            isSubscriber: result['isSubscriber'],
            rememberAlways: result['rememberAlways'],
            professional: result['professional'],
            visitState: result['visitState'],
            stateOrder: result['stateOrder'],
            expectedTime: result['expectedTime'],
            tasks: _subTasks,
            // houseOwnerAssets: result['houseOwnerAssets'],
            // visitAssets: result['visitAssets'],
            // visitMessages: result['visitMessages'],
          ));
        }
      } catch (e) {
        print(e);
      }
    });
    return _tasks;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  height: (_animatedheight != 0) ? _animatedheight / 1.2 : 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                      ),
                      Expanded(
                        child: Text(
                          "I DAG",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.grey.shade700,
                          size: 20,
                        ),
                        onPressed: () => setState(() {
                          _showCalendar = true;
                          _animatedheight = 200;
                        }),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                      future: getTask(selectedDay),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (snapshot.hasData &&
                            snapshot.data.isNotEmpty &&
                            snapshot.connectionState == ConnectionState.done) {
                          return RefreshIndicator(
                            onRefresh: _pullRefresh,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length ?? 0,
                                itemBuilder: (btx, index) {
                                  return Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.white,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: Text(
                                                  "${snapshot.data[index].houseOwnerFirstName}  ${snapshot.data[index].houseOwnerLastName}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 100,
                                                padding: EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                    color: colorCode[snapshot
                                                        .data[index]
                                                        .visitState],
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                      bottomLeft:
                                                          Radius.circular(20.0),
                                                    )),
                                                child: Text(
                                                  snapshot
                                                      .data[index].visitState,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 5.0,
                                              ),
                                              child: Text(
                                                snapshot.data[index].tasks
                                                    .map((result) =>
                                                        result.title)
                                                    .toList()
                                                    .join(', '),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0,
                                              vertical: 5.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.timer,
                                                      size: 16,
                                                      color: Colors.black54,
                                                    ),
                                                    Text(
                                                      " ${DateFormat('Hm').format(DateTime.parse(snapshot.data[index].startTimeUtc))}  / ${snapshot.data[index].expectedTime}",
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  width: 70.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.watch,
                                                        size: 16,
                                                        color: Colors.black54,
                                                      ),
                                                      Text(
                                                        "${snapshot.data[index].tasks.map((result) => result.timesInMinutes).toList().fold(0, (p, c) => p + c)} Mins",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 11),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0,
                                              vertical: 5.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.map,
                                                      size: 16,
                                                      color: Colors.black54,
                                                    ),
                                                    Text(
                                                      " ${snapshot.data[index].houseOwnerAddress}, ${snapshot.data[index].houseOwnerZip}, ${snapshot.data[index].houseOwnerCity}",
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  width: 70.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.directions,
                                                        size: 16,
                                                        color: Colors.black54,
                                                      ),
                                                      Text(
                                                        (index > 0)
                                                            ? " ${calculateDistance(
                                                                snapshot
                                                                    .data[
                                                                        index -
                                                                            1]
                                                                    .houseOwnerLatitude,
                                                                snapshot
                                                                    .data[
                                                                        index -
                                                                            1]
                                                                    .houseOwnerLongitude,
                                                                snapshot
                                                                    .data[index]
                                                                    .houseOwnerLatitude,
                                                                snapshot
                                                                    .data[index]
                                                                    .houseOwnerLongitude,
                                                              ).toStringAsFixed(2)} Km "
                                                            : " 0 Km ",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 11),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ));
                                }),
                          );
                        }
                        return Container(
                          child: Center(
                            child: Text('No Task Available !'),
                          ),
                        );
                      }),
                ),
              ],
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 50),
              curve: Curves.easeInOut,
              opacity: (_animatedheight != 0) ? 1 : 0,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    height: _animatedheight,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Color(0xff2a9f7f)),
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: (_animatedheight == 0) ? 0 : 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 100),
                            opacity: (_animatedheight != 0) ? 1 : 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${months[selectedDay.month - 1].substring(0, 3).capitalize()} ${selectedDay.year}',
                                      style: TextStyle(
                                        fontSize: 26,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(
                                              Icons.arrow_back_ios,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            onPressed: () => setState(() {
                                                  selectedDay = new DateTime(
                                                      selectedDay.year,
                                                      selectedDay.month - 1,
                                                      1);
                                                  updateTotalDaysInMonth();
                                                  scrollUpdate();
                                                })),
                                        IconButton(
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            onPressed: () => setState(() {
                                                  selectedDay = new DateTime(
                                                      selectedDay.year,
                                                      selectedDay.month + 1,
                                                      1);
                                                  updateTotalDaysInMonth();
                                                  scrollUpdate();
                                                })),
                                      ],
                                    ),
                                  ]),
                            ),
                          ),
                          Flexible(
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 100),
                              opacity: (_animatedheight != 0) ? 1 : 0,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  controller: _scrollController,
                                  itemCount: totalDaysInCurrentMonth,
                                  itemBuilder: (btx, index) {
                                    DateTime dateTime = DateTime(
                                        selectedDay.year,
                                        selectedDay.month,
                                        index + 1);
                                    return InkWell(
                                      onTap: () => setState(() {
                                        selectedDay = dateTime;
                                        _showCalendar = false;
                                      }),
                                      // The custom button
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        padding: EdgeInsets.all(12.0),
                                        width: _itemWidth,
                                        height:
                                            (_animatedheight != 0) ? 100 : 0,
                                        child: Column(
                                          children: <Widget>[
                                            (DateFormat.yMMMd().format(
                                                        _selectedDate) ==
                                                    DateFormat.yMMMd()
                                                        .format(dateTime))
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                (dateTime.day <
                                                                        10)
                                                                    ? 14
                                                                    : 10,
                                                            vertical: 10),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff1b5f4d),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    child: Text(
                                                      '${index + 1}',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                : (DateFormat.yMMMd()
                                                            .format(dateTime) ==
                                                        DateFormat.yMMMd()
                                                            .format(
                                                                selectedDay))
                                                    ? Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    (dateTime.day <
                                                                            10)
                                                                        ? 14
                                                                        : 10,
                                                                vertical: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black12,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                        ),
                                                        child: Text(
                                                          '${index + 1}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )
                                                    : Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    (dateTime.day <
                                                                            10)
                                                                        ? 14
                                                                        : 10,
                                                                vertical: 10),
                                                        child: Text(
                                                          '${index + 1}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              DateFormat('E').format(DateTime(
                                                  selectedDay.year,
                                                  selectedDay.month,
                                                  index + 1)),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _animatedheight = 0),
                    child: Container(
                      height: (_animatedheight != 0)
                          ? MediaQuery.of(context).size.height - _animatedheight
                          : 0,
                      width: double.infinity,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
