import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuktraapp/screens/user/planner/detail_planner.dart';
import 'package:tuktraapp/services/plan_service.dart';
import 'package:tuktraapp/utils/alert.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';

class InsertItinerary extends StatefulWidget {
  final String id, planTitle, day, type;
  const InsertItinerary({super.key, required this.id, required this.planTitle, required this.day, required this.type});

  @override
  State<InsertItinerary> createState() => _InsertItineraryState();
}

class _InsertItineraryState extends State<InsertItinerary> {
  PlanService planService = PlanService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>>? days;
  List<Map<String, dynamic>>? itinerary;
  Map<String, dynamic> subItinerary = {};

  TextEditingController titleTxt = TextEditingController();
  TextEditingController sourceTxt = TextEditingController();
  TextEditingController destinationTxt = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController transportationController = TextEditingController();

  final List<Map<String, dynamic>> _tranportations = [];
  int selectStartTime = 0;
  int selectEndTime = 0;
  int selectTransportation = 0;

  bool isLoading = false;
  int budget = 0;

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      controller.text = picked.format(context);
      print(controller.text);
    }
  }

  @override
  void didChangeDependencies() async {
    List<Map<String, dynamic>> results = await Future.wait([
      
    ]);
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
                  padding: const EdgeInsets.only(top: 70.0, bottom: 10.0, left: 5.0),
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
                    'Buat rencana keseharianmu selama perjalanan disini!',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Color.fromARGB(255, 81, 81, 81)
                    ),
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
                      // DropdownButtonFormField<int>(
                      //   value: _times[0].values.first,
                      //   onChanged: (int? selectedStartTime) {
                      //     if (selectedStartTime != null) {
                      //       setState(() {
                      //         selectStartTime = selectedStartTime;
                      //         startTimeController.text = (_times.firstWhere((time) => time.values.first == selectedStartTime).values.first).toString();
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
                        onTap: () => _selectTime(context, startTimeController),
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

                      // DropdownButtonFormField<int>(
                      //   value: _times[0].values.first,
                      //   onChanged: (int? selectedEndTime) {
                      //     if (selectedEndTime != null) {
                      //       setState(() {
                      //         selectEndTime = selectedEndTime;
                      //         endTimeController.text = (_times.firstWhere((time) => time.values.first == selectedEndTime).values.first).toString();
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
                        onTap: () => _selectTime(context, endTimeController),
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
                      
                      const SizedBox(height: 10.0,),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Transportasi ',
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
                        value: _tranportations[0].values.first,
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
                    ],
                  ) 
                ),

                const SizedBox(height: 10.0,),

                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      if(startTimeController.text.isEmpty || endTimeController.text.isEmpty) {
                        Alert.alertValidation('Waktu harus dipilih!', context);
                      }
                      else if(selectEndTime < selectStartTime) {
                        Alert.alertValidation('Waktu awal tidak bisa lebih besar tadi waktu akhir!', context);
                      }
                      else if(selectTransportation == 0) {
                        Alert.alertValidation('Transportasi harus dipilih!', context);
                      }
                      else if(formKey.currentState!.validate()) {
                        if(widget.type == "full") {
                          setState(() {
                            itinerary = [{
                              'title': titleTxt.text,
                              'source': sourceTxt.text,
                              'destination': destinationTxt.text,
                              'startTime': startTimeController.text,
                              'endTime': endTimeController.text,
                              'transportation': _tranportations[int.parse(transportationController.text)].keys.first,
                              'transportation_cost': budget,
                            },];
                            
                            days = [{
                              'day': widget.day,
                              'itineraries': itinerary,
                            },];
                            isLoading = true;
                            planService.insertItinerary(widget.id, days);
                          });
                        }
                        else if (widget.type == "sub") {
                          subItinerary = {
                            'title': titleTxt.text,
                            'source': sourceTxt.text,
                            'destination': destinationTxt.text,
                            'startTime': startTimeController.text,
                            'endTime': endTimeController.text,
                            'transportation': _tranportations[int.parse(transportationController.text)].keys.first,
                            'transportation_cost': budget,
                          };
                          await planService.insertSubItinerary(widget.id, widget.day, subItinerary);
                        }

                        NavigationUtils.pushRemoveTransition(context, DetailPlanner(id: widget.id));
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
                        'Buat',
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
              NavigationUtils.pushRemoveTransition(context, DetailPlanner(id: widget.id,));
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