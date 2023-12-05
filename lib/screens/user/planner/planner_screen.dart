import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuktraapp/screens/user/planner/detail_planner.dart';
import 'package:tuktraapp/screens/user/planner/insert_planner.dart';
import 'package:tuktraapp/screens/user/planner/update_planner.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';
import 'package:intl/intl.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50.0, bottom: 10.0, left: 5.0),
                child: Row(
                  children: [
                    const Text(
                      'Rencana Perjalanan',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ), 
                    const SizedBox(width: 8.0,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0)
                        ),
                        backgroundColor: const Color.fromARGB(255, 82, 114, 255)
                      ),
                      onPressed: () {
                        NavigationUtils.pushRemoveTransition(context, const InsertPlanner());
                      }, 
                      child: const Icon(Icons.add)
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0, left: 5.0),
                child: Text(
                  'Berikut adalah rencana perjalanan yang sudah pernah kamu buat sebelumnya',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color.fromARGB(255, 81, 81, 81)
                  ),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('planners').snapshots(),
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

                  var planners = snapshot.data!.docs;

                  return Container(
                    height: h * 0.55,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: planners.length,
                      itemBuilder: (context, index) {
                        var planner = planners[index];
                        var plannerId = planner.id;
                        DateTime startDate = DateTime.parse(planner['startDate']);
                        DateTime endDate = DateTime.parse(planner['endDate']);

                        String formatStart = DateFormat('d MMMM yyyy').format(startDate);
                        String formatEnd = DateFormat('d MMMM yyyy').format(endDate);

                        return Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Center(
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: SizedBox(
                                width: w * 0.8,
                                height: h * 0.48,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            planner['title'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 22.0,
                                            ),
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
                                        'Perkiraan Budget: ${planner['budget']}',
                                      ),
                                      const SizedBox(height: 30.0),
                                      Center(
                                        child: Container(
                                          width: 350,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color.fromARGB(255, 82, 114, 255),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              )
                                            ),
                                            onPressed: () {
                                              NavigationUtils.pushRemoveTransition(context, DetailPlanner(id: plannerId,));
                                            }, 
                                            child: Text('Rencana Keseharian')
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          width: 350,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              )
                                            ),
                                            onPressed: () {
                                              NavigationUtils.pushRemoveTransition(context, const UpdatePlanner());
                                            }, 
                                            child: const Text('Ubah Rencana')
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          width: 350,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              )
                                            ),
                                            onPressed: () {}, 
                                            child: Text('Hapus Rencana')
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  );
                }
              )
            ],
          ),
        )
      ),
    );
  }
}