import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuktraapp/services/plan_service.dart';
import 'package:tuktraapp/utils/alert.dart';

class UpdatePlanner extends StatefulWidget {
  final String id;
  const UpdatePlanner({super.key, required this.id});

  @override
  State<UpdatePlanner> createState() => _UpdatePlannerState();
}


class _UpdatePlannerState extends State<UpdatePlanner> {
  PlanService planService = PlanService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<String, dynamic>? plan;

  TextEditingController titleTxt = TextEditingController();
  TextEditingController sourceTxt = TextEditingController();
  TextEditingController destinationTxt = TextEditingController();
  final TextEditingController _dateStartController = TextEditingController();
  final TextEditingController _dateEndController = TextEditingController();

  bool isLoading = false;
  int numOfPeople = 0;
  int budget = 0;
  DateTime? _selectedStartDate, _selectedEndDate;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        _dateStartController.text =
            _selectedStartDate!.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
        _dateEndController.text =
            _selectedEndDate!.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _getAllData() async {
    List<dynamic> results = await Future.wait([planService.getPlan(widget.id)]);
    plan = results[0];
    
    setState(() {
      titleTxt.text = plan?['title'];
      sourceTxt.text = plan?['source'];
      destinationTxt.text = plan?['destination'];
      _dateStartController.text = plan?['startDate'];
      _dateEndController.text = plan?['endDate'];
      budget = plan?['budget'];
      numOfPeople = plan?['people'];
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _getAllData();
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
                const Padding(
                  padding: EdgeInsets.only(top: 70.0, bottom: 10.0, left: 5.0),
                  child: Text(
                    'Ubah Rencanamu',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0, left: 5.0),
                  child: Text(
                    'Rancanglah rencana perjalananmu disini, sesuai dengan keinginan kamu!',
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
                                text: 'Dari Tanggal ',
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
                            controller: _dateStartController,
                            readOnly: true,
                            onTap: () => _selectStartDate(context),
                            decoration: InputDecoration(
                              labelText: 'Pilih Tanggal',
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
                              suffixIcon:
                                  const Icon(Icons.calendar_today_rounded),
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
                                text: 'Sampai Tanggal ',
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
                            controller: _dateEndController,
                            readOnly: true,
                            onTap: () => _selectEndDate(context),
                            decoration: InputDecoration(
                              labelText: 'Pilih Tanggal',
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
                              suffixIcon:
                                  const Icon(Icons.calendar_today_rounded),
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
                                text: 'Anggaran ',
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
                            controller:
                                TextEditingController(text: budget.toString()),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              prefixIcon: IconButton(
                                icon: const Icon(
                                    Icons.remove_circle_outline_rounded),
                                onPressed: () {
                                  setState(() {
                                    budget = (budget > 0) ? budget - 100000 : 0;
                                  });
                                },
                              ),
                              labelText: 'Anggaran Perjalanan',
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
                                    budget = budget + 100000;
                                  });
                                },
                              ),
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
                                text: 'Banyak Orang ',
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
                            controller: TextEditingController(
                                text: numOfPeople.toString()),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              prefixIcon: IconButton(
                                icon: const Icon(
                                    Icons.remove_circle_outline_rounded),
                                onPressed: () {
                                  setState(() {
                                    numOfPeople =
                                        (numOfPeople > 0) ? numOfPeople - 1 : 0;
                                  });
                                },
                              ),
                              labelText: 'Banyak orang',
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
                                    numOfPeople = numOfPeople + 1;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if(titleTxt.text.isEmpty) {
                          Alert.alertValidation('Judul harus diisi!', context);
                        }
                        else if(sourceTxt.text.isEmpty) {
                          Alert.alertValidation('Lokasi awal harus diisi!', context);
                        }
                        else if(destinationTxt.text.isEmpty) {
                          Alert.alertValidation('Lokasi destinasi harus diisi!', context);
                        }
                        else if(_dateStartController.text.isEmpty) {
                          Alert.alertValidation('Tanggal Awal harus diisi!', context);
                        }
                        else if(_dateEndController.text.isEmpty) {
                          Alert.alertValidation('Tanggal Akhir harus diisi!', context);
                        }
                        else if(budget == 0) {
                          Alert.alertValidation('Anggaran harus lebih dari 0!', context);
                        }
                        else if(numOfPeople == 0) {
                          Alert.alertValidation('Banyak orang harus lebih dari 0!', context);
                        }
                        else {
                          setState(() {
                            isLoading = true;
                            planService.updatePlanner(
                                widget.id,
                                titleTxt.text,
                                sourceTxt.text,
                                destinationTxt.text,
                                _dateStartController.text,
                                _dateEndController.text,
                                budget,
                                numOfPeople);
                            Navigator.of(context).pop();
                            Alert.successMessage('Rencana berhasil diperbaharui.', context);
                          });
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
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white
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
              Navigator.of(context).pop();
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
