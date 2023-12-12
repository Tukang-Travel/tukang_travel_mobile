import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuktraapp/screens/user/planner/detail_planner.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';

class UpdateItinerary extends StatefulWidget {
  final int dayId, id;
  final String planId, planTitle;
  final String title, source, destination, startTime, endTime, transportation;
  final int transportationCost;
  const UpdateItinerary({super.key, required this.dayId, required this.id, required this.planId, required this.planTitle, required this.title, required this.source, required this.destination, required this.startTime, required this.endTime, required this.transportation, required this.transportationCost});

  @override
  State<UpdateItinerary> createState() => _UpdateItineraryState();
}

var isSet = false;
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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleTxt = TextEditingController();
  TextEditingController sourceTxt = TextEditingController();
  TextEditingController destinationTxt = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController transportationController = TextEditingController();

  final List<Map<String, dynamic>> _times = [{'Pilih Waktu': 0}, {'00:00': 1}, {'01:00': 2}, {'02:00': 3}, {'03:00': 4}, {'04:00': 5}, {'05:00': 6}, {'06:00': 7}, {'07:00': 8}, {'08:00': 9}, {'09:00': 10}, {'10:00': 11}, {'11:00': 12}, {'12:00': 13}, {'13:00': 14}, {'14:00': 15}, {'15:00': 16}, {'16:00': 17}, {'17:00': 18}, {'18:00': 19}, {'19:00': 20}, {'20:00': 21}, {'21:00': 22}, {'22:00': 23}, {'23:00': 24}];
  final List<Map<String, dynamic>> _tranportations = [{'Pilih Transportasi': 0}, {'Mobil': 1}, {'Motor': 2}, {'Sepeda': 3}, {'Bis': 4}, {'Kereta': 5}, {'Kapal': 6}, {'Pesawat': 7},];

  int selectStartTime = 1;
  int selectEndTime = 1;
  int selectTransportation = 1;

  bool isLoading = false;
  int budget = 0;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.dayId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!isSet) {
      titleTxt.text = widget.title;
      sourceTxt.text = widget.source;
      destinationTxt.text = widget.destination;
      startTimeController.text = widget.startTime;
      endTimeController.text = widget.endTime;
      transportationController.text = widget.transportation;
      budget = widget.transportationCost;

      startTimeIdx = searchValue(_times, startTimeController.text);
      endTimeIdx = searchValue(_times, endTimeController.text);
      transportIdx = searchValue(_tranportations, transportationController.text);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 70.0, bottom: 10.0, left: 5.0),
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
                      fontSize: 15.0,
                      color: Color.fromARGB(255, 81, 81, 81)
                    ),
                  ),
                ),

                Form(
                  key: formKey,
                  child: Column(
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
                            children: <TextSpan> [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                              )
                            ]
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),
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
                          ]
                        ),
                        child: TextFormField(
                          controller: titleTxt,
                          validator: ((value) => value!.isEmpty ? 'Judul harus diisi' : null),
                          decoration: InputDecoration(
                            hintText: 'Judul',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                                width: 1.0
                              ),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                              ),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                            )
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),

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
                            children: <TextSpan> [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                              )
                            ]
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),
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
                          ]
                        ),
                        child: TextFormField(
                          controller: sourceTxt,
                          validator: ((value) => value!.isEmpty ? 'Lokasi awal harus diisi' : null),
                          decoration: InputDecoration(
                            hintText: 'Lokasi Awal',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                                width: 1.0
                              ),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                              ),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                            )
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),
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
                            children: <TextSpan> [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                              )
                            ]
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),
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
                          ]
                        ),
                        child: TextFormField(
                          controller: destinationTxt,
                          validator: ((value) => value!.isEmpty ? 'Lokasi destinasi harus diisi' : null),
                          decoration: InputDecoration(                 hintText: 'Lokasi Destinasi',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                                width: 1.0
                              ),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                              ),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                            )
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),

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
                            children: <TextSpan> [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                              )
                            ]
                          ),
                        ),
                      ),

                      const SizedBox(height: 10.0,),
                      DropdownButtonFormField<int>(
                        value: _times[startTimeIdx].values.first,
                        onChanged: (int? selectedStartTime) {
                          if (selectedStartTime != null) {
                            setState(() {
                              selectStartTime = selectedStartTime;
                              startTimeController.text = (_times.firstWhere((time) => time.values.first == selectedStartTime).values.first).toString();
                            });
                            print(startTimeController.text);
                          }
                        },
                        items: _times.map((Map<String, dynamic> startTime) {
                          return DropdownMenuItem<int>(
                            value: startTime.values.first,
                            child: Text(startTime.keys.first), 
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Pilih Waktu',
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

                      const SizedBox(height: 10.0,),
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
                            children: <TextSpan> [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                              )
                            ]
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      DropdownButtonFormField<int>(
                        value: _times[endTimeIdx].values.first,
                        onChanged: (int? selectedEndTime) {
                          if (selectedEndTime != null) {
                            setState(() {
                              selectEndTime = selectedEndTime;
                              endTimeController.text = (_times.firstWhere((time) => time.values.first == selectedEndTime).values.first).toString();
                            });
                            print(endTimeController.text);
                          }
                        },
                        items: _times.map((Map<String, dynamic> endTime) {
                          return DropdownMenuItem<int>(
                            value: endTime.values.first,
                            child: Text(endTime.keys.first), 
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Pilih Waktu',
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
                      
                      const SizedBox(height: 10.0,),
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
                            children: <TextSpan> [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                              )
                            ]
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      DropdownButtonFormField<int>(
                        value: _tranportations[transportIdx].values.first,
                        onChanged: (int? selectedTransportation) {
                          if (selectedTransportation != null) {
                            setState(() {
                              selectTransportation = selectedTransportation;
                              transportationController.text = (_tranportations.firstWhere((time) => time.values.first == selectedTransportation).values.first).toString();
                            });
                            print(transportationController.text);
                          }
                        },
                        items: _tranportations.map((Map<String, dynamic> transport) {
                          return DropdownMenuItem<int>(
                            value: transport.values.first,
                            child: Text(transport.keys.first), 
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

                      const SizedBox(height: 10.0,),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Biaya Transportasi ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
              
                      const SizedBox(height: 10.0,),
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
                          ]
                        ),
                        child: TextFormField(
                          controller: TextEditingController(text: budget.toString()),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.remove_circle_outline_rounded),
                              onPressed: () {
                                setState(() {
                                  budget = (budget > 0) ? budget - 100000 : 0;
                                });
                              },
                            ),
                            labelText: 'Biaya Transportasi',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                                width: 1.0
                              ),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                              ),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.add_circle_outline_rounded),
                              onPressed: () {
                                setState(() {
                                  budget = budget + 100000;
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10.0,),
                    ],
                  )
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if(formKey.currentState!.validate()) {
                        setState(() {
                          // isLoading = true;
                          // _insertUser();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      backgroundColor: const Color.fromARGB(255, 82, 114, 255)
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      child: Text(
                        'Ubah',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
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
              NavigationUtils.pushRemoveTransition(context, DetailPlanner(id: widget.planId,));
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