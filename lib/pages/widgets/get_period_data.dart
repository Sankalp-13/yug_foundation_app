// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:yug_foundation_app/utils/colors.dart';

import '../period_tracker_dashboard.dart';

class GetPeriodDataPage extends StatefulWidget {
  const GetPeriodDataPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CycleLength createState() => _CycleLength();
}

class _CycleLength extends State<GetPeriodDataPage> {
  int menstrualCycleLength = 28;
  int periodLength=4;// Default value

  void _showCycleLengthPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CycleLengthPickerDialog(
          initialCycleLength: menstrualCycleLength,
          onChanged: (value) {
            setState(() {
              menstrualCycleLength = value;
            });
          },
          onSaved: () {
            // Use the selected menstrual cycle length (menstrualCycleLength) as needed
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showPeriodLengthPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PeriodLengthPickerDialog(
          initialPeriodLength: periodLength,
          onChanged: (value) {
            setState(() {
              periodLength = value;
            });
          },
          onSaved: () {
            // Use the selected menstrual cycle length (menstrualCycleLength) as needed
            Navigator.of(context).pop();
          },
        );
      },
    );
  }


  DateTime _recentPeriodDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _recentPeriodDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _recentPeriodDate) {
      setState(() {
        _recentPeriodDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 38,
              ),
              Text(
                'Set Menstrual Cycle Length:',
                style: TextStyle(fontSize: width * 0.0765, color: ColorConstants.mainThemeColor),
              ),
              const SizedBox(
                height: 20
              ),
              CycleLengthValueText(
                menstrualCycleLength: menstrualCycleLength,
              ),
              const SizedBox(
                height: 20
              ),
              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  border: Border.fromBorderSide(
                      BorderSide(color: ColorConstants.darkWidgetColor, width: 1.5)),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: TextButton(
                  onPressed: _showCycleLengthPicker,
                  child: Text(
                    'Set Menstrual Cycle Length',
                    style: TextStyle(color: ColorConstants.darkWidgetColor),
                    selectionColor: ColorConstants.darkWidgetColor,
                  ),
                ),
              ),
              const SizedBox(
                  height: 20
              ),
              Text(
                'Set Period Length:',
                style: TextStyle(fontSize: width * 0.0765, color: ColorConstants.mainThemeColor),
              ),
              const SizedBox(
                height: 20
              ),

              PeriodLengthValueText(periodLength: periodLength),

              const SizedBox(
                height: 20
              ),
              // Button to show the modal bottom sheet

              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  border: Border.fromBorderSide(
                      BorderSide(color: ColorConstants.darkWidgetColor, width: 1.5)),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: TextButton(
                  onPressed: _showPeriodLengthPicker,
                  child: Text(
                    'Set Blood Flow Length',
                    style: TextStyle(color: ColorConstants.darkWidgetColor),
                    selectionColor: ColorConstants.darkWidgetColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 20
              ),
              Text(
                'Select your recent period date:',
                style: TextStyle(
                  color: ColorConstants.mainThemeColor,
                  fontSize: width * 0.0765,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 20,),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(
                          text: "${_recentPeriodDate.toLocal()}".split(' ')[0]),
                      keyboardType: TextInputType.datetime,
                      decoration:  InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        enabledBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConstants.mainThemeColor),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorConstants.mainThemeColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        labelText: "Recent Period Date",
                        labelStyle: TextStyle(color: ColorConstants.mainThemeColor)
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Icon(
                      Icons.calendar_today,
                      color: ColorConstants.mainThemeColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height:20),
              TextButton.icon(
                onPressed: () async {
                  const storage = FlutterSecureStorage();
                  await storage.write(key: 'PERIOD_LENGTH', value: periodLength.toString());
                  await storage.write(key: 'CYCLE_LENGTH', value: menstrualCycleLength.toString());
                  await storage.write(key: 'LAST_PERIOD', value: _recentPeriodDate.toIso8601String());
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return const PeriodDashboard();
                  }));
                },
                icon: const Icon(Icons.done),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: ColorConstants.mainThemeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.25, vertical: height * 0.02418),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CycleLengthPickerDialog extends StatefulWidget {
  final int initialCycleLength;
  final ValueChanged<int> onChanged;
  final VoidCallback onSaved;

  const CycleLengthPickerDialog({
    super.key,
    required this.initialCycleLength,
    required this.onChanged,
    required this.onSaved,
  });

  @override
  _CycleLengthPickerDialogState createState() =>
      _CycleLengthPickerDialogState();
}

class _CycleLengthPickerDialogState extends State<CycleLengthPickerDialog> {
  int selectedCycleLength = 28;

  @override
  void initState() {
    super.initState();
    selectedCycleLength = widget.initialCycleLength;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Menstrual Cycle Length'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          NumberPicker(
            step: 1,
            value: selectedCycleLength,
            minValue: 15,
            maxValue: 50,
            onChanged: (value) {
              setState(() {
                selectedCycleLength = value;
                widget.onChanged(value);
              });
            },
            itemWidth: 60,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.pink),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.pink),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}


class CycleLengthValueText extends StatefulWidget {
  final int menstrualCycleLength;

  const CycleLengthValueText({
    super.key,
    required this.menstrualCycleLength,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CycleLengthValueTextState createState() => _CycleLengthValueTextState();
}

class _CycleLengthValueTextState extends State<CycleLengthValueText> {
  late int menstrualCycleLength;

  @override
  void initState() {
    super.initState();
    menstrualCycleLength = widget.menstrualCycleLength;
  }

  @override
  void didUpdateWidget(CycleLengthValueText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.menstrualCycleLength != oldWidget.menstrualCycleLength) {
      setState(() {
        menstrualCycleLength = widget.menstrualCycleLength;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$menstrualCycleLength',
      style: TextStyle(color: ColorConstants.darkWidgetColor, fontSize: 30),
    );
  }
}




class PeriodLengthPickerDialog extends StatefulWidget {
  final int initialPeriodLength;
  final ValueChanged<int> onChanged;
  final VoidCallback onSaved;

  const PeriodLengthPickerDialog({
    super.key,
    required this.initialPeriodLength,
    required this.onChanged,
    required this.onSaved,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PeriodLengthPickerDialogState createState() =>
      _PeriodLengthPickerDialogState();
}

class _PeriodLengthPickerDialogState extends State<PeriodLengthPickerDialog> {
  int _periodLength = 4;

  @override
  void initState() {
    super.initState();
    _periodLength = widget.initialPeriodLength;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Blood Flow Length',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          NumberPicker(
            step: 1,
            value: _periodLength,
            minValue: 1,
            maxValue: 10, // Adjust the maximum value as needed
            onChanged: (value) {
              setState(() {
                _periodLength = value;
                widget.onChanged(value);
              });
            },
            itemWidth: 60,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.pink),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.pink),
          ),
          onPressed: () {
            // Use the selected menstrual cycle length (flowLengthNotifier.value) as needed
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class PeriodLengthValueText extends StatefulWidget {
  late int periodLength;

  PeriodLengthValueText({
    super.key,
    required this.periodLength,
  });

  @override
  _PeriodLengthValueTextState createState() => _PeriodLengthValueTextState();
}

class _PeriodLengthValueTextState extends State<PeriodLengthValueText> {
  late int periodLength;

  @override
  void initState() {
    super.initState();
    periodLength = widget.periodLength;
  }

  @override
  void didUpdateWidget(PeriodLengthValueText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.periodLength != oldWidget.periodLength) {
      setState(() {
        periodLength = widget.periodLength;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$periodLength',
      style: TextStyle(
        fontSize: 33,
        color: ColorConstants.darkWidgetColor,
      ),
    );
  }
}
