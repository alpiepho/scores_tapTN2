//import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoreboard_tap_tn2/components/score_card.dart';
import 'package:scoreboard_tap_tn2/components/score_card_content.dart';
//import 'package:scoreboard_tap_tn2/components/settings_button.dart';
//import 'package:scoreboard_tap_tn2/components/settings_modal.dart';
import 'package:scoreboard_tap_tn2/constants.dart';
import 'package:scoreboard_tap_tn2/engine.dart';
import 'package:scoreboard_tap_tn2/components/floating_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

class ScoresPage extends StatefulWidget {
  @override
  _ScoresPageState createState() => _ScoresPageState();
}

class _ScoresPageState extends State<ScoresPage> {
  //
  // for display
  //

  Color _colorTextLeft = Colors.black;
  Color _colorBackgroundLeft = Colors.red;
  Color _colorTextRight = Colors.black;
  Color _colorBackgroundRight = Colors.blueAccent;

  String _labelLeft = "Away";
  String _labelRight = "Home";
  int _valueLeft = 0;
  int _valueRight = 0;

  FontTypes _fontType = FontTypes.system;

  bool _zoom = false;
  bool _setsShow = false;
  bool _sets5 = false;
  int _setsLeft = 0;
  int _setsRight = 0;

  // for increment/decrement swiping
  // double _panPositionYLeft = 0.0;
  // double _panPositionYRight = 0.0;

  Engine _engine = Engine();

  void _loadEngine() async {
    final prefs = await SharedPreferences.getInstance();
    var packed = prefs.getString('engine') ?? "";
    _engine.unpack(packed);
    _fromEngine();
  }

  void _saveEngine() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('engine', _engine.pack());
  }

  void _fromEngine() async {
    setState(() {
      _labelLeft = this._engine.getLabelLeft();
      _labelRight = this._engine.getLabelRight();
      _valueLeft = this._engine.valueLeft;
      _valueRight = this._engine.valueRight;

      _colorTextLeft = this._engine.colorTextLeft;
      _colorBackgroundLeft = this._engine.colorBackgroundLeft;
      _colorTextRight = this._engine.colorTextRight;
      _colorBackgroundRight = this._engine.colorBackgroundRight;

      _fontType = this._engine.fontType;

      _zoom = this._engine.zoom;
      _setsShow = this._engine.setsShow;
      _sets5 = this._engine.sets5;
      _setsLeft = this._engine.setsLeft;
      _setsRight = this._engine.setsRight;
    });
  }

  // void _reflectorSendComment() async {
  //   if (_engine.reflectorSite.length > 0 && _engine.scoreKeeper.length > 0) {
  //     if (_engine.reflectorComment.length > 0) {
  //       String urlString = "";
  //       urlString += _engine.reflectorSite;
  //       urlString += "/add?data=";
  //       urlString += _engine.scoreKeeper;
  //       urlString += ",";
  //       urlString += _engine.reflectorComment;
  //       var encoded = Uri.encodeFull(urlString);
  //       Uri _url = Uri.parse(encoded);

  //       _engine.reflectorComment = "";
  //       try {
  //         //  send GET without opening browser window, dont care about response
  //         await http.get(_url);
  //       } catch (exception, _) {}
  //     }
  //   }
  // }

  void _reflectorSendScores() async {
    if (_engine.reflectorSite.length > 0 && _engine.scoreKeeper.length > 0) {
      String urlString = "";
      urlString += _engine.reflectorSite;
      urlString += "/add?data=";
      urlString += _engine.scoreKeeper;
      urlString += ",";

      // build score to send
      // ie. timestamp,shannon,000000,ffffff,ffffff,000000,Them,Us,0,0, 10, 8,  0

      urlString += _engine.colorTextLeft.hashCode.toRadixString(16);
      urlString += ",";
      urlString += _engine.colorBackgroundLeft.hashCode.toRadixString(16);
      urlString += ",";
      urlString += _engine.colorTextRight.hashCode.toRadixString(16);
      urlString += ",";
      urlString += _engine.colorBackgroundRight.hashCode.toRadixString(16);
      urlString += ",";
      urlString += _engine.labelLeft;
      urlString += ",";
      urlString += _engine.labelRight;
      urlString += ",";
      urlString += _engine.setsLeft.toString();
      urlString += ",";
      urlString += _engine.setsRight.toString();
      urlString += ",";
      urlString += _engine.valueLeft.toString();
      urlString += ",";
      urlString += _engine.valueRight.toString();
      urlString += ",";
      urlString += (_engine.lastPointLeft ? "1" : "2");
      //urlString += ",";

      var encoded = Uri.encodeFull(urlString);
      Uri _url = Uri.parse(encoded);

      _engine.reflectorComment = "";
      try {
        //  send GET without opening browser window, dont care about response
        await http.get(_url);
      } catch (exception, _) {}
    }
  }

  // void _incrementLeft() async {
  //   this._engine.incrementLeft();
  //   _fromEngine();
  //   _notify7();
  //   _notify8();
  //   _reflectorSendScores();
  // }

  // void _decrementLeft() async {
  //   this._engine.decrementLeft();
  //   _fromEngine();
  //   _reflectorSendScores();
  // }

  // void _incrementRight() async {
  //   this._engine.incrementRight();
  //   _fromEngine();
  //   _notify7();
  //   _notify8();
  //   _reflectorSendScores();
  // }

  // void _decrementRight() async {
  //   this._engine.decrementRight();
  //   _fromEngine();
  //   _reflectorSendScores();
  // }

  // void _clearBoth() async {
  //   showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Clear Scores',
  //           style: kSettingsTextEditStyle,
  //         ),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text(
  //                 'Clear scores?',
  //                 style: kSettingsTextEditStyle,
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text(
  //               'Cancel',
  //               style:
  //                   kSettingsTextEditStyle.copyWith(color: Colors.blueAccent),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text(
  //               'Clear',
  //               style:
  //                   kSettingsTextEditStyle.copyWith(color: Colors.blueAccent),
  //             ),
  //             onPressed: () {
  //               this._engine.clearBoth();
  //               _fromEngine();
  //               Navigator.of(context).pop();
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //   _reflectorSendScores();
  // }

  // void _resetBoth() async {
  //   showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Reset All',
  //           style: kSettingsTextEditStyle,
  //         ),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('Would you reset everything?'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text(
  //               'Cancel',
  //               style:
  //                   kSettingsTextEditStyle.copyWith(color: Colors.blueAccent),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text(
  //               'Reset',
  //               style:
  //                   kSettingsTextEditStyle.copyWith(color: Colors.blueAccent),
  //             ),
  //             onPressed: () {
  //               this._engine.resetBoth();
  //               _fromEngine();
  //               _saveEngine();
  //               Navigator.of(context).pop();
  //               Navigator.of(context).pop();
  //               _reflectorSendScores();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _swapTeams() async {
  //   this._engine.swapTeams();
  //   _fromEngine();
  //   _saveEngine();
  //   Navigator.of(context).pop();
  //   _reflectorSendScores();
  // }

  // List<String> _list = [
  //   "2022-08-07_06:42:20,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,1,1,15,5,1",
  //   "2022-08-07_06:42:20,dude,WOO HOO!",
  //   "2022-08-07_06:42:15,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,1,15,5,1",
  //   "2022-08-07_06:42:15,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,1,14,5,1",
  //   "2022-08-07_06:42:15,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,1,13,5,1",
  //   "2022-08-07_06:42:15,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,1,12,5,1",
  //   "2022-08-07_06:42:11,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,1,11,5,1",
  //   "2022-08-07_06:42:03,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,1,11,5,1",
  //   "2022-08-07_06:41:59,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,0,11,5,1",
  //   "2022-08-07_06:41:59,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,0,10,5,1",
  //   "2022-08-07_06:41:58,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,0,9,5,1",
  //   "2022-08-07_06:41:58,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,0,8,5,1",
  //   "2022-08-07_06:41:58,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,0,7,5,1",
  //   "2022-08-07_06:41:58,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,0,6,5,1",
  //   "2022-08-07_06:41:57,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,0,5,5,2",
  //   "2022-08-07_06:41:57,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,0,5,4,2",
  //   "2022-08-07_06:41:56,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,0,5,3,2",
  //   "2022-08-07_06:41:56,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,0,5,2,2",
  //   "2022-08-07_06:41:56,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,0,5,1,2",
  //   "2022-08-07_06:41:54,dude,fff44336,ff000000,ff448aff,ff000000,Away2,Home2,0,0,5,0,1",
  //   "2022-08-07_06:41:38,dude,fff44336,ff000000,ff448aff,ff000000,Away,Home,0,0,5,0,1",
  //   "2022-08-07_06:41:38,dude,fff44336,ff000000,ff448aff,ff000000,Away,Home,0,0,4,0,1",
  //   "2022-08-07_06:41:38,dude,fff44336,ff000000,ff448aff,ff000000,Away,Home,0,0,3,0,1",
  //   "2022-08-07_06:41:37,dude,fff44336,ff000000,ff448aff,ff000000,Away,Home,0,0,2,0,1",
  //   "2022-08-07_06:41:37,dude,fff44336,ff000000,ff448aff,ff000000,Away,Home,0,0,1,0,1",
  //   "2022-08-07_06:41:34,dude,fff44336,ff000000,ff448aff,ff000000,Away,Home,0,0,0,0,2",
  //   "2022-08-07_06:42:20,dude,HERE WE GO!  And the match is about to start",
  // ];
  // int _index = -1;

  void _refreshReflector() async {
    if (_engine.reflectorSite.isEmpty || _engine.scoreKeeper.isEmpty) {
      return;
    }

    // _engine.reflectorSite = "http://10.0.0.13:3000";
    // _engine.scoreKeeper = "dude";

    String event = "";
    String urlString = "";
    urlString += _engine.reflectorSite;
    urlString += "/";
    urlString += _engine.scoreKeeper;
    urlString += "/0/json";

    var encoded = Uri.encodeFull(urlString);
    Uri _url = Uri.parse(encoded);
    //print(encoded);

    try {
      http.Response response = await http.get(_url);
      //print(response.statusCode);
      //print(response.body);
      final data = jsonDecode(response.body);
      //print(data);
      event = data['entry'];
    } catch (exception, message) {
      print(exception);
      print(message);
    }

    // FAKE: cycle thru fake_list
    // if (_index < 0) _index = _list.length - 1;
    // event = _list[_index];
    // _index--;

    this._engine.listAdd(event);
    String comment = this._engine.parseLastRefelector();

    if (comment.isNotEmpty) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              this._engine.scoreKeeper + ': ',
              style: kSettingsTextEditStyle,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    comment,
                    style: kSettingsTextEditStyle,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Done',
                  style:
                      kSettingsTextEditStyle.copyWith(color: Colors.blueAccent),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    _fromEngine();
  }

  void _savePending() async {
    // this._engine.savePending();
    // _fromEngine();
    // _saveEngine();
    // Navigator.of(context).pop();
    // _reflectorSendScores();
  }

  void _saveReflector() async {
    //this._engine.savePending();
    _fromEngine();
    _saveEngine();
    Navigator.of(context).pop();
    _reflectorSendScores();
  }

  // void _saveComment() async {
  //   Navigator.of(context).pop();
  //   _reflectorSendComment();
  // }

  // void _panUpdateLeft(DragUpdateDetails details) async {
  //   // use swipe to adjust score
  //   if (details.delta.dy.abs() > 1) {
  //     _panPositionYLeft += details.delta.dy;
  //     if (_panPositionYLeft < -100) {
  //       _panPositionYLeft = 0.0;
  //       _incrementLeft();
  //     } else if (_panPositionYLeft > 100) {
  //       _panPositionYLeft = 0.0;
  //       _decrementLeft();
  //     }
  //   } else {
  //     _panPositionYLeft = 0.0;
  //   }
  // }

  // void _panUpdateRight(DragUpdateDetails details) async {
  //   // use swipe to adjust score
  //   if (details.delta.dy.abs() > 1) {
  //     _panPositionYRight += details.delta.dy;
  //     if (_panPositionYRight < -100) {
  //       _panPositionYRight = 0.0;
  //       _incrementRight();
  //     } else if (_panPositionYRight > 100) {
  //       _panPositionYRight = 0.0;
  //       _decrementRight();
  //     }
  //   } else {
  //     _panPositionYRight = 0.0;
  //   }
  // }

  // void _notify7() async {
  //   if (this._engine.notify7()) {
  //     showDialog<void>(
  //       context: context,
  //       barrierDismissible: false, // user must tap button!
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(
  //             'At 7 Points',
  //             style: kSettingsTextEditStyle,
  //           ),
  //           content: SingleChildScrollView(
  //             child: ListBody(
  //               children: <Widget>[
  //                 Text(
  //                   'Swap teams?',
  //                   style: kSettingsTextEditStyle,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               child: Text(
  //                 'Cancel',
  //                 style:
  //                     kSettingsTextEditStyle.copyWith(color: Colors.blueAccent),
  //               ),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             TextButton(
  //               child: Text(
  //                 'Swap',
  //                 style:
  //                     kSettingsTextEditStyle.copyWith(color: Colors.blueAccent),
  //               ),
  //               onPressed: () {
  //                 this._engine.swapTeams();
  //                 _fromEngine();
  //                 _saveEngine();
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  // void _notify8() async {
  //   if (this._engine.notify8()) {
  //     showDialog<void>(
  //       context: context,
  //       barrierDismissible: false, // user must tap button!
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(
  //             'At 8 Points',
  //             style: kSettingsTextEditStyle,
  //           ),
  //           content: SingleChildScrollView(
  //             child: ListBody(
  //               children: <Widget>[
  //                 Text(
  //                   'Would you swap teams?',
  //                   style: kSettingsTextEditStyle,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               child: Text(
  //                 'Cancel',
  //                 style:
  //                     kSettingsTextEditStyle.copyWith(color: Colors.blueAccent),
  //               ),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             TextButton(
  //               child: Text(
  //                 'Swap',
  //                 style:
  //                     kSettingsTextEditStyle.copyWith(color: Colors.blueAccent),
  //               ),
  //               onPressed: () {
  //                 this._engine.swapTeams();
  //                 _fromEngine();
  //                 _saveEngine();
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  @override
  initState() {
    super.initState();
    _loadEngine();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    TextStyle labelTextStyle = kLabelTextStyle_system;
    TextStyle numberTextStyle = kNumberTextStyle_system;

    labelTextStyle = getLabelFont(_fontType);
    numberTextStyle = getNumberFont(_fontType);

    var teamScoreCardTop = TeamScoreCard(
      // onPress: _incrementLeft,
      // onPan: _panUpdateLeft,
      color: _colorBackgroundLeft,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
      cardChild: TeamScoreCardContent(
        label: _labelLeft,
        textStyle: labelTextStyle,
        colorText: _colorTextLeft,
        value: _valueLeft,
        numberTextStyle: numberTextStyle,
        zoom: _zoom,
        setsShow: _setsShow,
        sets5: _sets5,
        sets: _setsLeft,
      ),
    );
    var teamScoreCardBottom = TeamScoreCard(
      // onPress: _incrementRight,
      // onPan: _panUpdateRight,
      color: _colorBackgroundRight,
      margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
      cardChild: TeamScoreCardContent(
        label: _labelRight,
        textStyle: labelTextStyle,
        colorText: _colorTextRight,
        value: _valueRight,
        numberTextStyle: numberTextStyle,
        zoom: _zoom,
        setsShow: _setsShow,
        sets5: _sets5,
        sets: _setsRight,
      ),
    );
    var teamScoreCardLeft = TeamScoreCard(
      // onPress: _incrementLeft,
      // onPan: _panUpdateLeft,
      color: _colorBackgroundLeft,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
      cardChild: TeamScoreCardContent(
        label: _labelLeft,
        textStyle: labelTextStyle,
        colorText: _colorTextLeft,
        value: _valueLeft,
        numberTextStyle: numberTextStyle,
        zoom: _zoom,
        setsShow: _setsShow,
        sets5: _sets5,
        sets: _setsLeft,
      ),
    );
    var teamScoreCardRight = TeamScoreCard(
      // onPress: _incrementRight,
      // onPan: _panUpdateRight,
      color: _colorBackgroundRight,
      margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
      cardChild: TeamScoreCardContent(
        label: _labelRight,
        textStyle: labelTextStyle,
        colorText: _colorTextRight,
        value: _valueRight,
        numberTextStyle: numberTextStyle,
        zoom: _zoom,
        setsShow: _setsShow,
        sets5: _sets5,
        sets: _setsRight,
      ),
    );

    // goal:
    // in portrait, current left/right immediately hide with opacity, and
    // top and bottom animate in from left
    // in lascape: current tp/bottom immediately hide with opacity, and
    // left and right animate in from top
    //
    // to get close to direct left->right or top->bottom transition,
    // the start value of say the bottom panel needs to be based on
    // horizontal values.  this is due to simply hiding unused panels.
    // althought not shown, they are positioned.

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    double offscreen = portrait ? -1.1 * width : -1.1 * height;
    var duration1 = Duration(milliseconds: 1000);
    var curve1 = Curves.linear;
    var duration2 = Duration(milliseconds: 1000);
    var curve2 = Curves.linear;

    return Scaffold(
      backgroundColor: kInputPageBackgroundColor,
      body: Stack(
        children: [
          // vertical/portrait
          // top
          AnimatedPositioned(
            left: (!portrait ? offscreen : 0),
            top: 0,
            duration: duration1,
            curve: curve1,
            child: Opacity(
              opacity: (!portrait ? 0 : 1),
              child: AnimatedOpacity(
                opacity: (!portrait ? 0 : 1),
                duration: duration2,
                curve: curve2,
                child: teamScoreCardTop,
              ),
            ),
          ),
          // bottom
          AnimatedPositioned(
            left: (!portrait ? offscreen : 0),
            top: (!portrait ? width / 2 : height / 2), // see note above
            duration: duration1,
            curve: curve1,
            child: Opacity(
              opacity: (!portrait ? 0 : 1),
              child: AnimatedOpacity(
                opacity: (!portrait ? 0 : 1),
                duration: duration2,
                curve: curve2,
                child: teamScoreCardBottom,
              ),
            ),
          ),
          // horizontal/landscape
          // left
          AnimatedPositioned(
            left: 0,
            top: (portrait ? offscreen : 0),
            duration: duration1,
            curve: curve1,
            child: Opacity(
              opacity: (portrait ? 0 : 1),
              child: AnimatedOpacity(
                opacity: (portrait ? 0 : 1),
                duration: duration2,
                curve: curve2,
                child: teamScoreCardLeft,
              ),
            ),
          ),
          // right
          AnimatedPositioned(
            left: (portrait ? height / 2 : width / 2), // see note above
            top: (portrait ? offscreen : 0),
            duration: duration1,
            curve: curve1,
            child: Opacity(
              opacity: (portrait ? 0 : 1),
              child: AnimatedOpacity(
                opacity: (portrait ? 0 : 1),
                duration: duration2,
                curve: curve2,
                child: teamScoreCardRight,
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: SettingsButton(onPress: () {
      //   this._engine.setPending();
      //   showModalBottomSheet(
      //     context: context,
      //     builder: (BuildContext bc) {
      //       return SettingsModal(
      //         context,
      //         this._engine,
      //         // _resetBoth,
      //         // _clearBoth,
      //         // _swapTeams,
      //         _savePending,
      //         _saveReflector,
      //         // _saveComment,
      //       );
      //     },
      //     isScrollControlled: true,
      //   );
      // }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingButtons(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        engine: _engine,
        onRefreshFromReflector: _refreshReflector,
        onSavePending: _savePending,
        onSaveReflector: _saveReflector,
      ),
    );
  }
}