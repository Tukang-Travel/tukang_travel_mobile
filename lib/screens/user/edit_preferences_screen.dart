import 'package:flutter/material.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/alert.dart';
import 'package:tuktraapp/utils/utils.dart';

class EditPreferencesScreen extends StatefulWidget {
  const EditPreferencesScreen({super.key});

  @override
  State<EditPreferencesScreen> createState() => _EditPreferencesScreenState();
}

class _EditPreferencesScreenState extends State<EditPreferencesScreen> {
  List<Map<String, dynamic>> genres = [];
  List<String> selectedGenres = []; // Initialize it with the user's existing preferences

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  Future<void> getPreferences() async {
    // Retrieve the user's existing preferences and update selectedGenres
    List<String> existingPreferences =
        await UserService().getUserPreference(); // Adjust this based on your implementation

    List<Map<String, dynamic>> preferences =
        await UserService().getPreferencesTemplate();

    setState(() {
      genres = preferences;
      selectedGenres = existingPreferences;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Your Preferences'),
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
                        color: Colors.transparent,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: isSelected ? 50.0 : 40.0,
                            backgroundColor: Colors.white,
                            backgroundImage: const AssetImage(
                                'asset/images/default_profile.png'),
                            foregroundImage: NetworkImage(genreImage),
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
