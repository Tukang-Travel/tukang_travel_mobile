import 'package:flutter/material.dart';
import 'package:tuktraapp/screens/main_screen.dart';
import 'package:tuktraapp/screens/user/planner/insert_itinerary.dart';
import 'package:tuktraapp/screens/user/planner/update_itinerary.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';

class DetailPlanner extends StatefulWidget {
  const DetailPlanner({super.key});

  @override
  State<DetailPlanner> createState() => _DetailPlannerState();
}

class _DetailPlannerState extends State<DetailPlanner> {
  @override
  Widget build(BuildContext context) {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 75.0),
              child: Center(
                child: Card(
                  color: Color.fromARGB(217, 82, 114, 255),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                  ),
                  child: SizedBox(
                    width: w * 0.8,
                    height: h * 0.25,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Title',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'start_date - end_date',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'source - destination',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Number of people',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Budget',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Center(
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
                  ),
                  child: SizedBox(
                    width: w * 0.8,
                    height: h * 0.42,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 110,
                                        child: Text(
                                          'Hari X',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20.0
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20.0),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(100.0)
                                          ),
                                          backgroundColor: const Color.fromARGB(255, 82, 114, 255)
                                        ),
                                        onPressed: () {
                                          NavigationUtils.pushRemoveTransition(context, const UpdateItinerary());
                                        }, 
                                        child: const Icon(Icons.edit)
                                      ),
                                      const SizedBox(width: 10.0),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(100.0)
                                          ),
                                          backgroundColor: const Color.fromARGB(255, 82, 114, 255)
                                        ),
                                        onPressed: () {}, 
                                        child: Icon(Icons.delete)
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 12.0,
                                              height: 12.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color.fromARGB(255, 82, 114, 255),
                                              ),
                                            ),
                                            SizedBox(width: 10.0),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Title',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                Text('source - destination'),
                                                Text('start_time - end_time'),
                                                Text('transportation'),
                                                Text('transportation_cost'),
                                              ],
                                            ),
                                            SizedBox(width: 10.0),
                                          ],
                                        ),
                                      ),
                                                          
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 12.0,
                                              height: 12.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color.fromARGB(255, 82, 114, 255),
                                              ),
                                            ),
                                            SizedBox(width: 10.0),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Title',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                Text('source - destination'),
                                                Text('start_time - end_time'),
                                                Text('transportation'),
                                                Text('transportation_cost'),
                                              ],
                                            ),
                                            SizedBox(width: 10.0),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 35.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    NavigationUtils.pushRemoveTransition(context, const InsertItinerary());
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 82, 114, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    )
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                    child: Text('Tambah Hari'),
                  )
                ),
              ),
            )
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 30.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: () {
                NavigationUtils.pushRemoveTransition(context, const MainScreen(page: 2));
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
        ),
      ),
    );
  }
}