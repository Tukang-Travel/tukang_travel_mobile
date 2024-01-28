import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuktraapp/services/plan_service.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/alert.dart';

class InsertPlanner extends StatefulWidget {
  const InsertPlanner({super.key});

  @override
  State<InsertPlanner> createState() => _InsertPlannerState();
}

class _InsertPlannerState extends State<InsertPlanner> {
  PlanService planService = PlanService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleTxt = TextEditingController();
  TextEditingController sourceTxt = TextEditingController();
  TextEditingController destinationTxt = TextEditingController();
  TextEditingController budgetTxt = TextEditingController(text: '0');
  TextEditingController bykOrgTxt = TextEditingController(text: '0');
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

  @override
  void dispose() {
    titleTxt.dispose();
    sourceTxt.dispose();
    destinationTxt.dispose();
    _dateStartController.dispose();
    _dateEndController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                      padding:
                          EdgeInsets.only(top: 100.0, bottom: 10.0, left: 5.0),
                      child: Text(
                        'Buat Rencana Baru',
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
                            fontSize: 15.0,
                            color: Color.fromARGB(255, 81, 81, 81)),
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
                                            color: Color.fromARGB(
                                                128, 170, 188, 192),
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
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
                                            color: Color.fromARGB(
                                                128, 170, 188, 192),
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
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
                                            color: Color.fromARGB(
                                                128, 170, 188, 192),
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
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
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(128, 170, 188, 192),
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
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(128, 170, 188, 192),
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
                                controller: budgetTxt,
                                onEditingComplete: () {
                                  setState(() {
                                    budget =
                                        int.tryParse(budgetTxt.text) ?? budget;
                                  });
                                },
                                onTapOutside: (value) {
                                  setState(() {
                                    budget =
                                        int.tryParse(budgetTxt.text) ?? budget;
                                  });
                                },
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
                                        budget =
                                            (int.tryParse(budgetTxt.text)! > 0)
                                                ? int.tryParse(
                                                        budgetTxt.text)! -
                                                    100000
                                                : 0;
                                        budgetTxt.text = budget.toString();
                                      });
                                    },
                                  ),
                                  labelText: 'Anggaran Perjalanan',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(128, 170, 188, 192),
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                        Icons.add_circle_outline_rounded),
                                    onPressed: () {
                                      setState(() {
                                        budget = int.tryParse(budgetTxt.text)! +
                                            100000;
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
                                controller: bykOrgTxt,
                                keyboardType: TextInputType.number,
                                onEditingComplete: () {
                                  setState(() {
                                    numOfPeople =
                                        int.tryParse(bykOrgTxt.text) ??
                                            numOfPeople;
                                  });
                                },
                                onTapOutside: (event) {
                                  setState(() {
                                    numOfPeople =
                                        int.tryParse(bykOrgTxt.text) ??
                                            numOfPeople;
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
                                        numOfPeople = (int.tryParse(
                                                    bykOrgTxt.text)! >
                                                0)
                                            ? int.tryParse(bykOrgTxt.text)! - 1
                                            : 0;
                                        bykOrgTxt.text = numOfPeople.toString();
                                      });
                                    },
                                  ),
                                  labelText: 'Banyak orang',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(128, 170, 188, 192),
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                        Icons.add_circle_outline_rounded),
                                    onPressed: () {
                                      setState(() {
                                        numOfPeople =
                                            int.tryParse(bykOrgTxt.text)! + 1;
                                        bykOrgTxt.text = numOfPeople.toString();
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
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (titleTxt.text.isEmpty) {
                              Alert.alertValidation(
                                  'Judul harus diisi!', context);
                            } else if (sourceTxt.text.isEmpty) {
                              Alert.alertValidation(
                                  'Lokasi awal harus diisi!', context);
                            } else if (destinationTxt.text.isEmpty) {
                              Alert.alertValidation(
                                  'Lokasi destinasi harus diisi!', context);
                            } else if (_dateStartController.text.isEmpty) {
                              Alert.alertValidation(
                                  'Tanggal Awal harus diisi!', context);
                            } else if (_selectedStartDate!.day <
                                DateTime.now().day) {
                              Alert.alertValidation(
                                  'Pilihan tanggal harus sama atau setelah hari ini!',
                                  context);
                            } else if (_dateEndController.text.isEmpty) {
                              Alert.alertValidation(
                                  'Tanggal Akhir harus diisi!', context);
                            } else if (_selectedEndDate!.day <
                                    DateTime.now().day ||
                                _selectedEndDate!.day <
                                    _selectedStartDate!.day) {
                              Alert.alertValidation(
                                  'Tanggal akhir tidak bisa sebelum tanggal awal!',
                                  context);
                            } else if (budget == 0) {
                              Alert.alertValidation(
                                  'Anggaran harus lebih dari 0!', context);
                            } else if (numOfPeople == 0) {
                              Alert.alertValidation(
                                  'Banyak orang harus lebih dari 0!', context);
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                await planService.insertPlanner(
                                    titleTxt.text,
                                    sourceTxt.text,
                                    destinationTxt.text,
                                    _dateStartController.text,
                                    _dateEndController.text,
                                    budget,
                                    numOfPeople,
                                    UserService().currUser!.uid);
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                  Alert.successMessage(
                                      'Rencana berhasil ditambahkan.', context);
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  Alert.alertValidation(
                                      "Gagal Menambahkan Rencana, Mohon Coba Lagi Ya.",
                                      context);
                                }
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
                            'Buat',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
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
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
