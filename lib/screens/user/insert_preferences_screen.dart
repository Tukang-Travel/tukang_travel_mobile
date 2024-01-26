import 'package:flutter/material.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/alert.dart';

class InsertPreferenceScreen extends StatefulWidget {
  const InsertPreferenceScreen({super.key});

  @override
  State<InsertPreferenceScreen> createState() =>
      _InsertPreferenceScreenState();
}

class _InsertPreferenceScreenState extends State<InsertPreferenceScreen> {
  List<Map<String, dynamic>> genres = [];

  List<String> selectedGenres = [];

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  Future<void> getPreferences() async {
    List<Map<String, dynamic>> preferences =
        await UserService().getPreferencesTemplate();

    setState(() {
      genres = preferences;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atur Preferensi Perjalananmu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: genres.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  String genreName = genres[index]['name'];
                  String genreImage = genres[index]['src'];
                  bool isSelected = selectedGenres.contains(genreName);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedGenres.remove(genreName);
                        } else {
                          selectedGenres.add(genreName);
                        }
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent, // Remove the border color
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: isSelected ? 50.0 : 40.0,
                            backgroundColor: Colors.white,
                            backgroundImage: const AssetImage(
                                'asset/images/default_profile.png'), // Placeholder
                            foregroundImage:
                                NetworkImage(genreImage), // Profile
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              genreName,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: () async {
                String res = await UserService()
                    .createUpdateUserPreferences(selectedGenres);
                if (res == 'success') {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    Alert.successMessage('Preferensi berhasil ditambahkan.', context);
                  }
                } else {
                  if (context.mounted) {
                    Alert.alertValidation(res, context);
                  }
                }
              },
              label: const Text('Simpan'),
            ),
          ),
        ),
      ),
    );
  }
}
