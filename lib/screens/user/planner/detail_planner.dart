import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuktraapp/screens/main_screen.dart';
import 'package:tuktraapp/screens/user/planner/insert_itinerary.dart';
import 'package:tuktraapp/screens/user/planner/update_itinerary.dart';
import 'package:tuktraapp/services/plan_service.dart';
import 'package:tuktraapp/utils/alert.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';

class DetailPlanner extends StatefulWidget {
  final String id;

  const DetailPlanner({super.key, required this.id});

  @override
  State<DetailPlanner> createState() => _DetailPlannerState();
}

class _DetailPlannerState extends State<DetailPlanner> {
  Map<String, dynamic> plan = {};
  PlanService planService = PlanService();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    try {
      List<dynamic> results = await Future.wait([
        planService.getPlan(widget.id),
      ]);

      setState(() {
        plan = results[0];
      });
    } catch (e) {
      if (context.mounted) {
        Alert.alertValidation(
            "Terjadi Kesalahan, Mohon Coba Lagi Ya.", context);
      }
    }
  }

  Future<void> _getPlan() async {
    List<dynamic> results = await Future.wait([
      planService.getPlan(widget.id),
    ]);
    setState(() {
      plan = results[0];
    });
  }

  String convertToAmPm(String time) {
    List<String> timeParts = time.split(":");

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    String period = (hour >= 12) ? 'PM' : 'AM';

    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  @override
  void initState() {
    super.initState();
    _getPlan();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>>? days;
    if (plan.containsKey('days')) {
      days = (plan['days'] as List).cast<Map<String, dynamic>>();
    }
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
                  color: const Color.fromARGB(217, 82, 114, 255),
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    width: w * 0.8,
                    height: h * 0.28,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              width: 200,
                              child: Text(
                                plan['title'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22.0,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            '${DateFormat('d MMMM yyyy').format(DateTime.parse(plan['startDate']))} - ${DateFormat('d MMMM yyyy').format(DateTime.parse(plan['endDate']))}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            '${plan['source']} - ${plan['destination']}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Jumlah Orang: ${plan['people']}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Anggaran: ${NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp',
                            ).format(plan['budget'])}',
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
                  color: Colors.white,
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    width: w * 0.8,
                    height: h * 0.42,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                days == null
                                    ? const Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              'Belum ada rencana keseharian',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18.0,
                                                color: Colors.red,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50.0,
                                            ),
                                            Text(
                                              'Tekan "Tambah Hari" untuk mulai merancang rencana keseharian anda.',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: days.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          var day = days?[index];
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      child: Text(
                                                        'Hari ${day?['day']}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 20.0,
                                                        ),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100.0)),
                                                            backgroundColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    82,
                                                                    114,
                                                                    255)),
                                                        onPressed: () {
                                                          NavigationUtils.pushTransition(
                                                              context,
                                                              InsertItinerary(
                                                                  id: widget.id,
                                                                  planTitle: plan[
                                                                      'title'],
                                                                  day: day?[
                                                                      'day'],
                                                                  type: 'sub'));
                                                        },
                                                        child: const Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    for (var i = 0;
                                                        i <
                                                            day?['itineraries']
                                                                .length;
                                                        i++)
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 20.0,
                                                                horizontal:
                                                                    5.0),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 12.0,
                                                              height: 12.0,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        82,
                                                                        114,
                                                                        255),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 10.0),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  day?['itineraries']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'title'] ??
                                                                      '',
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                                Text(
                                                                    '${day?['itineraries'][i]['source']} - ${day?['itineraries'][i]['destination']}'),
                                                                Text(
                                                                    '${day?['itineraries'][i]['startTime']} - ${day?['itineraries'][i]['endTime']}'),
                                                                Text(day?['itineraries']
                                                                            [i][
                                                                        'transportation'] ??
                                                                    ''),
                                                                Text(
                                                                    'Biaya: ${NumberFormat.currency(
                                                                  locale:
                                                                      'id_ID',
                                                                  symbol: 'Rp',
                                                                ).format(day?['itineraries'][i]['transportation_cost'])}'),
                                                                const SizedBox(
                                                                    width:
                                                                        20.0),
                                                                Row(
                                                                  children: [
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(
                                                                                    100.0)),
                                                                            backgroundColor: const Color.fromARGB(
                                                                                255,
                                                                                82,
                                                                                114,
                                                                                255)),
                                                                        onPressed:
                                                                            () {
                                                                          NavigationUtils.pushRemoveTransition(
                                                                              context,
                                                                              UpdateItinerary(
                                                                                dayId: (int.parse(day?['day']) - 1),
                                                                                id: i,
                                                                                planId: widget.id,
                                                                                planTitle: plan['title'],
                                                                                title: day?['itineraries'][i]['title'],
                                                                                source: day?['itineraries'][i]['source'],
                                                                                destination: day?['itineraries'][i]['destination'],
                                                                                startTime: convertToAmPm(day?['itineraries'][i]['startTime']),
                                                                                endTime: convertToAmPm(day?['itineraries'][i]['endTime']),
                                                                                transportation: day?['itineraries'][i]['transportation'],
                                                                                transportationCost: day?['itineraries'][i]['transportation_cost'],
                                                                              ));
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          'Ubah',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )),
                                                                    const SizedBox(
                                                                        width:
                                                                            10.0),
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(
                                                                                    100.0)),
                                                                            backgroundColor: const Color.fromRGBO(
                                                                                209,
                                                                                26,
                                                                                42,
                                                                                1.0)),
                                                                        onPressed:
                                                                            () {
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return AlertDialog(
                                                                                content: Text(
                                                                                  'Apakah anda yakin untuk menghapus rencana "${day?['itineraries'][i]['title']}"?',
                                                                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                                                                ),
                                                                                actions: <Widget>[
                                                                                  TextButton(
                                                                                    onPressed: () {
                                                                                      if (context.mounted) {
                                                                                        Navigator.of(context).pop();
                                                                                      }
                                                                                    },
                                                                                    child: const Text(
                                                                                      'Batal',
                                                                                      style: TextStyle(color: Colors.black),
                                                                                    ),
                                                                                  ),
                                                                                  ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(209, 26, 42, 1.0)),
                                                                                    child: const Text(
                                                                                      'Hapus',
                                                                                      style: TextStyle(color: Colors.white),
                                                                                    ),
                                                                                    onPressed: () async {
                                                                                      try {
                                                                                        await planService.deleteSubItinerary(widget.id, (int.parse(day?['day']) - 1), i);
                                                                                        setState(() {
                                                                                          _getPlan();
                                                                                        });

                                                                                        if (context.mounted) {
                                                                                          Navigator.of(context).pop();
                                                                                          Alert.successMessage("Kegiatan berhasil dihapus.", context);
                                                                                        }
                                                                                      } catch (e) {
                                                                                        if (context.mounted) {
                                                                                          Alert.alertValidation("Gagal Memperbarui Kegiatan, Mohon Coba Lagi Ya.", context);
                                                                                        }
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          'Hapus',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
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
                      if(days == null) {
                        NavigationUtils.pushTransition(
                        context,
                        InsertItinerary(
                            id: widget.id,
                            planTitle: plan['title'],
                            day: days == null
                                ? "1"
                                : (days.length + 1).toString(),
                            type: 'full'));
                      }
                      else {
                        DateTime startDate = DateTime.parse(plan['startDate']);
                        DateTime endDate = DateTime.parse(plan['endDate']);

                        // Calculate the difference in days
                        int diff = endDate.difference(startDate).inDays;
                        if(days!.length >= diff) {
                          Alert.alertValidation('Anda tidak dapat menambahkan hari lagi karena perjalanan Anda hanya berlangsung selama $diff hari!', context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 82, 114, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        )),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                      child: Text(
                        'Tambah Hari',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
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
                NavigationUtils.pushRemoveTransition(
                    context, const MainScreen(page: 3));
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
