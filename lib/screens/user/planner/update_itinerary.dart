import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tuktraapp/screens/user/planner/detail_planner.dart';
import 'package:tuktraapp/services/plan_service.dart';
import 'package:tuktraapp/services/transport_service.dart';
import 'package:tuktraapp/utils/alert.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';

class UpdateItinerary extends StatefulWidget {
  final int dayId, id;
  final String planId, planTitle;
  final String title, source, destination, startTime, endTime, transportation;
  final int transportationCost;
  const UpdateItinerary(
      {super.key,
      required this.dayId,
      required this.id,
      required this.planId,
      required this.planTitle,
      required this.title,
      required this.source,
      required this.destination,
      required this.startTime,
      required this.endTime,
      required this.transportation,
      required this.transportationCost});

  @override
  State<UpdateItinerary> createState() => _UpdateItineraryState();
}

var startTimeIdx = 0, endTimeIdx = 0, transportIdx = 0;

int searchValue(List<Map<String, dynamic>> list, String key) {
  for (var i = 0; i < list.length; i++) {
    if (list[i].containsKey(key)) {
      return list[i].values.first;
    }
  }
  return -1;
}

class _UpdateItineraryState extends State<UpdateItinerary> {
  PlanService planService = PlanService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleTxt = TextEditingController();
  TextEditingController sourceTxt = TextEditingController();
  TextEditingController destinationTxt = TextEditingController();
  TextEditingController budgetTxt = TextEditingController(text: '0');
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController transportationController = TextEditingController();
  TransportService transService = TransportService();

  List<Map<int, String>> _transportations = [];
  List<String> startParts = [];
  List<String> endParts = [];
  int selectTransportation = 0;

  bool isLoading = false;
  int budget = 0;

  @override
  void dispose() {
    titleTxt.dispose();
    sourceTxt.dispose();
    destinationTxt.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    transportationController.dispose();
    super.dispose();
  }

  // initialny dibikin waktu yang dipilih sama user
  Future<void> _selectTime(BuildContext context,
      TextEditingController controller, int hour, int minute) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    );

    if (picked != null && context.mounted) {
      controller.text = picked.format(context);
    }
  }

  String convertToWib(String time) {
    List<String> parts = time.split(" ");

    if (parts.length != 2) {
      // Handle invalid input format
      return ''; // or throw an exception
    }

    List<String> timeParts = parts[0].split(":");

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    if (parts[1] == "PM" && hour != 12) {
      hour += 12;
    } else if (parts[1] == "AM" && hour == 12) {
      hour = 0;
    }

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  Future<void> _getAllData() async {
    List<Map<String, dynamic>> results = await transService.getTransports();

    setState(() {
      _transportations = transformList(results);
    });

    titleTxt.text = widget.title;
    sourceTxt.text = widget.source;
    destinationTxt.text = widget.destination;
    startTimeController.text = widget.startTime;
    endTimeController.text = widget.endTime;
    transportationController.text = widget.transportation;
    budgetTxt.text = widget.transportationCost.toString();
    budget = widget.transportationCost;
    transportIdx = searchSelected();
    startParts = startTimeController.text.split(":");
    endParts = endTimeController.text.split(":");
  }

  int searchSelected() {
    for (var t in _transportations) {
      if (t.values.single == transportationController.text) {
        return t.keys.single;
      }
    }
    return -1;
  }

  Future<bool> validateTime() async {
    DateFormat format = DateFormat("h:mm a");
    DateTime startTime = format.parse(startTimeController.text);
    DateTime endTime = format.parse(endTimeController.text);

    if (startTime.isAfter(endTime)) {
      Alert.alertValidation(
          'Waktu awal tidak bisa lebih besar tadi waktu akhir!', context);
      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();

    _getAllData();
  }

  List<Map<int, String>> transformList(List<Map<String, dynamic>> inputList) {
    List<Map<int, String>> resultList = [];

    for (int i = 0; i < inputList.length; i++) {
      resultList.add({i: inputList[i]['name']!});
    }

    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 70.0, bottom: 10.0, left: 5.0),
                  child: Text(
                    widget.planTitle,
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0, left: 5.0),
                  child: Text(
                    'Ubah rencana keseharianmu selama perjalanan disini!',
                    style: TextStyle(
                        fontSize: 15.0, color: Color.fromARGB(255, 81, 81, 81)),
                  ),
                ),
                Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: RichText(
                            text: const TextSpan(
                                text: 'Judul ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: Offset(1, 1),
                                  color: Color.fromARGB(128, 170, 188, 192),
                                )
                              ]),
                          child: TextFormField(
                            controller: titleTxt,
                            decoration: InputDecoration(
                                hintText: 'Judul',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(128, 170, 188, 192),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(20)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(128, 170, 188, 192),
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: RichText(
                            text: const TextSpan(
                                text: 'Lokasi Awal ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: Offset(1, 1),
                                  color: Color.fromARGB(128, 170, 188, 192),
                                )
                              ]),
                          child: TextFormField(
                            controller: sourceTxt,
                            decoration: InputDecoration(
                                hintText: 'Lokasi Awal',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(128, 170, 188, 192),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(20)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(128, 170, 188, 192),
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: RichText(
                            text: const TextSpan(
                                text: 'Lokasi Destinasi ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: Offset(1, 1),
                                  color: Color.fromARGB(128, 170, 188, 192),
                                )
                              ]),
                          child: TextFormField(
                            controller: destinationTxt,
                            decoration: InputDecoration(
                                hintText: 'Lokasi Destinasi',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(128, 170, 188, 192),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(20)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(128, 170, 188, 192),
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: RichText(
                            text: const TextSpan(
                                text: 'Dari Jam ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        // DropdownButtonFormField<int>(
                        //   value: _times[startTimeIdx].values.first,
                        //   onChanged: (int? selectedStartTime) {
                        //     if (selectedStartTime != null) {
                        //       setState(() {
                        //         selectStartTime = selectedStartTime;
                        //         startTimeController.text = (_times
                        //                 .firstWhere((time) =>
                        //                     time.values.first ==
                        //                     selectedStartTime)
                        //                 .values
                        //                 .first)
                        //             .toString();
                        //       });
                        //     }
                        //   },
                        //   items: _times.map((Map<String, dynamic> startTime) {
                        //     return DropdownMenuItem<int>(
                        //       value: startTime.values.first,
                        //       child: Text(startTime.keys.first),
                        //     );
                        //   }).toList(),
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //     fillColor: Colors.white,
                        //     labelText: 'Pilih Waktu',
                        //     focusedBorder: OutlineInputBorder(
                        //       borderSide: const BorderSide(
                        //         color: Color.fromARGB(128, 170, 188, 192),
                        //         width: 1.0,
                        //       ),
                        //       borderRadius: BorderRadius.circular(20),
                        //     ),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderSide: const BorderSide(
                        //         color: Color.fromARGB(128, 170, 188, 192),
                        //       ),
                        //       borderRadius: BorderRadius.circular(20),
                        //     ),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(20),
                        //     ),
                        //   ),
                        // ),
                        TextFormField(
                          controller: startTimeController,
                          onTap: () => _selectTime(
                              context,
                              startTimeController,
                              int.parse(startParts[0]),
                              int.parse(startParts[0])),
                          decoration: InputDecoration(
                            labelText: 'Pilih Waktu Awal',
                            hintText: 'Pilih Waktu Awal',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: RichText(
                            text: const TextSpan(
                                text: 'Sampai Jam ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        // DropdownButtonFormField<int>(
                        //   value: _times[endTimeIdx].values.first,
                        //   onChanged: (int? selectedEndTime) {
                        //     if (selectedEndTime != null) {
                        //       setState(() {
                        //         selectEndTime = selectedEndTime;
                        //         endTimeController.text = (_times
                        //                 .firstWhere((time) =>
                        //                     time.values.first ==
                        //                     selectedEndTime)
                        //                 .values
                        //                 .first)
                        //             .toString();
                        //       });
                        //     }
                        //   },
                        //   items: _times.map((Map<String, dynamic> endTime) {
                        //     return DropdownMenuItem<int>(
                        //       value: endTime.values.first,
                        //       child: Text(endTime.keys.first),
                        //     );
                        //   }).toList(),
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //     fillColor: Colors.white,
                        //     labelText: 'Pilih Waktu',
                        //     focusedBorder: OutlineInputBorder(
                        //       borderSide: const BorderSide(
                        //         color: Color.fromARGB(128, 170, 188, 192),
                        //         width: 1.0,
                        //       ),
                        //       borderRadius: BorderRadius.circular(20),
                        //     ),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderSide: const BorderSide(
                        //         color: Color.fromARGB(128, 170, 188, 192),
                        //       ),
                        //       borderRadius: BorderRadius.circular(20),
                        //     ),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(20),
                        //     ),
                        //   ),
                        // ),
                        TextFormField(
                          controller: endTimeController,
                          onTap: () => _selectTime(context, endTimeController,
                              int.parse(endParts[0]), int.parse(endParts[0])),
                          decoration: InputDecoration(
                            labelText: 'Pilih Waktu Akhir',
                            hintText: 'Pilih Waktu Akhir',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: RichText(
                            text: const TextSpan(
                                text: 'Tranportasi ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        DropdownButtonFormField<int>(
                          value: _transportations[transportIdx].keys.first,
                          onChanged: (int? selectedTransportation) {
                            if (selectedTransportation != null) {
                              setState(() {
                                selectTransportation = selectedTransportation;
                                transportationController.text =
                                    (_transportations
                                            .firstWhere((time) =>
                                                time.keys.first ==
                                                selectedTransportation)
                                            .values
                                            .first)
                                        .toString();
                              });
                            }
                          },
                          items: _transportations
                              .map((Map<int, String> transport) {
                            return DropdownMenuItem<int>(
                              value: transport.keys.first,
                              child: Text(transport.values.first),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Pilih Transportasi',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: RichText(
                            text: const TextSpan(
                              text: 'Biaya Perjalanan',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: Offset(1, 1),
                                  color: Color.fromARGB(128, 170, 188, 192),
                                )
                              ]),
                          child: TextFormField(
                            controller: budgetTxt,
                            keyboardType: TextInputType.number,
                            onEditingComplete: () {
                              setState(() {
                                budget = int.tryParse(budgetTxt.text) ?? budget;
                              });
                            },
                            onTapOutside: (event) {
                              setState(() {
                                budget = int.tryParse(budgetTxt.text) ?? budget;
                              });
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              prefixIcon: IconButton(
                                icon: const Icon(
                                    Icons.remove_circle_outline_rounded),
                                onPressed: () {
                                  setState(() {
                                    budget = (int.tryParse(budgetTxt.text)! > 0)
                                        ? int.tryParse(budgetTxt.text)! - 100000
                                        : 0;
                                    budgetTxt.text = budget.toString();
                                  });
                                },
                              ),
                              labelText: 'Biaya Perjalanan',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(128, 170, 188, 192),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(20)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(128, 170, 188, 192),
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                    Icons.add_circle_outline_rounded),
                                onPressed: () {
                                  setState(() {
                                    budget =
                                        int.tryParse(budgetTxt.text)! + 100000;
                                    budgetTxt.text = budget.toString();
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    )),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (titleTxt.text.isEmpty) {
                        Alert.alertValidation('Judul harus diisi!', context);
                      } else if (sourceTxt.text.isEmpty) {
                        Alert.alertValidation(
                            'Lokasi Awal harus diisi!', context);
                      } else if (destinationTxt.text.isEmpty) {
                        Alert.alertValidation(
                            'Lokasi Destinasi harus diisi!', context);
                      } else if (transportationController.text.isEmpty) {
                        Alert.alertValidation(
                            'Transportasi harus dipilih!', context);
                      } else {
                        bool isValidTime = await validateTime();
                        if (!isValidTime) {
                          return;
                        }
                        setState(() {
                          isLoading = true;
                        });
                        Map<String, dynamic> itinerary = {
                          'title': titleTxt.text,
                          'source': sourceTxt.text,
                          'destination': destinationTxt.text,
                          'startTime': convertToWib(startTimeController.text),
                          'endTime': convertToWib(endTimeController.text),
                          'transportation': transportationController.text,
                          'transportation_cost': budget,
                        };
                        try {
                          await planService.updateSubItinerary(widget.planId,
                              widget.dayId, widget.id, itinerary);
                          if (context.mounted) {
                            NavigationUtils.pushRemoveTransition(
                                context, DetailPlanner(id: widget.planId));
                            Alert.successMessage(
                                'Kegiatan berhasil diperbaharui.', context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Alert.alertValidation(
                                "Gagal Memperbarui Kegiatan, Mohon Coba Lagi Ya.",
                                context);
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 82, 114, 255)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child: Text(
                        'Ubah',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 80.0, left: 30.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: () {
              NavigationUtils.pushRemoveTransition(
                  context, DetailPlanner(id: widget.planId));
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 6.0),
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
      ),
    );
  }
}
