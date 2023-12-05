import 'package:flutter/material.dart';
import 'package:tuktraapp/screens/user/planner/detail_planner.dart';
import 'package:tuktraapp/screens/user/planner/insert_planner.dart';
import 'package:tuktraapp/screens/user/planner/update_planner.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';

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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
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
                                    width: 110.0,
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        'Title',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 22.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    'start_date - end_date',
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'source - destination',
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Number of people',
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Budget',
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
                                          NavigationUtils.pushRemoveTransition(context, const DetailPlanner());
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
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}