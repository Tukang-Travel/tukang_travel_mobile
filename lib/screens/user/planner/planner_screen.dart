import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuktraapp/screens/user/planner/detail_planner.dart';
import 'package:tuktraapp/screens/user/planner/insert_planner.dart';
import 'package:tuktraapp/screens/user/planner/update_planner.dart';
import 'package:tuktraapp/services/plan_service.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/alert.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';
import 'package:intl/intl.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  PlanService planService = PlanService();
  UserService userService = UserService();
  int idx = 0;

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>?>
      getPlansStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield await planService.getPlans(userService.currUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          title: Row(
                children: [
                  const Text(
                    'Rencana Perjalanan',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0)),
                          backgroundColor:
                              const Color.fromARGB(255, 82, 114, 255)),
                      onPressed: () {
                        NavigationUtils.pushTransition(
                            context, const InsertPlanner());
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ))
                ],
              ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding:
            //       const EdgeInsets.only(top: 50.0, bottom: 10.0, left: 5.0),
            //   child: Row(
            //     children: [
            //       const Text(
            //         'Rencana Perjalanan',
            //         style: TextStyle(
            //           fontSize: 25.0,
            //           fontWeight: FontWeight.w900,
            //         ),
            //       ),
            //       const SizedBox(
            //         width: 8.0,
            //       ),
            //       ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(100.0)),
            //               backgroundColor:
            //                   const Color.fromARGB(255, 82, 114, 255)),
            //           onPressed: () {
            //             NavigationUtils.pushTransition(
            //                 context, const InsertPlanner());
            //           },
            //           child: const Icon(
            //             Icons.add,
            //             color: Colors.white,
            //           ))
            //     ],
            //   ),
            // ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0, left: 5.0),
              child: Text(
                'Berikut adalah rencana perjalanan yang sudah pernah kamu buat sebelumnya',
                style: TextStyle(
                    fontSize: 15.0, color: Color.fromARGB(255, 81, 81, 81)),
              ),
            ),
            StreamBuilder(
                stream: getPlansStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var planners = snapshot.data!;

                  if (planners.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 150.0),
                      child: Center(
                        child: Text(
                          "Belum ada rencana perjalanan",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  }

                  return SizedBox(
                    height: h * 0.55,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: planners.length,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot<Map<String, dynamic>> planner =
                              planners[index];
                          var plannerId = planner.id;
                          print('Plan id from planner screen: $plannerId');
                          DateTime startDate =
                              DateTime.parse(planner['startDate']);
                          DateTime endDate = DateTime.parse(planner['endDate']);

                          String formatStart =
                              DateFormat('d MMMM yyyy').format(startDate);
                          String formatEnd =
                              DateFormat('d MMMM yyyy').format(endDate);

                          return Container(
                            margin: const EdgeInsets.only(right: 20.0),
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Center(
                              child: Card(
                                color: Colors.white,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: SizedBox(
                                  width: w * 0.8,
                                  height: h * 0.48,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: SizedBox(
                                            width: 200,
                                            child: Text(
                                              planner['title'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700, fontSize: 22.0),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          '$formatStart - $formatEnd',
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          '${planner['source']} - ${planner['destination']}',
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          'Jumlah Orang: ${planner['people']}',
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          'Anggaran: ${NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: 'Rp',
                                          ).format(planner['budget'])}',
                                        ),
                                        const SizedBox(height: 30.0),
                                        Center(
                                          child: SizedBox(
                                            width: 350,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 82, 114, 255),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    )),
                                                onPressed: () {
                                                  NavigationUtils
                                                      .pushTransition(
                                                          context,
                                                          DetailPlanner(
                                                            id: plannerId,
                                                          ));
                                                },
                                                child: const Text(
                                                  'Rencana Keseharian',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          ),
                                        ),
                                        Center(
                                          child: SizedBox(
                                            width: 350,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    )),
                                                onPressed: () {
                                                  NavigationUtils
                                                      .pushTransition(
                                                          context,
                                                          UpdatePlanner(
                                                            id: plannerId,
                                                          ));
                                                },
                                                child: const Text(
                                                  'Ubah Rencana',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          ),
                                        ),
                                        Center(
                                          child: SizedBox(
                                            width: 350,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromRGBO(
                                                            209, 26, 42, 1.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    )),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        backgroundColor: Colors.white,
                                                        content: Text(
                                                            'Apakah anda yakin untuk menghapus rencana "${planner['title']}"?',
                                                            style: const TextStyle(fontWeight: FontWeight.w500),),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancel'),
                                                            child: const Text(
                                                                'Batal',
                                                                style: TextStyle(color: Colors.black),),
                                                          ),
                                                          ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      const Color
                                                                          .fromRGBO(
                                                                          209,
                                                                          26,
                                                                          42,
                                                                          1.0)),
                                                              child: const Text(
                                                                'Hapus',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              onPressed: () {
                                                                planService
                                                                    .deletePlanner(
                                                                        plannerId);
                                                                Navigator.of(context).pop();
                                                                Alert.successMessage("Rencana berhasil dihapus.", context);
                                                              }),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: const Text(
                                                  'Hapus Rencana',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                }),
          ],
        ),
      )),
    );
  }
}
