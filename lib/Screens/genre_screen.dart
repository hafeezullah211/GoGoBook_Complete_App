import 'package:flutter/material.dart';

class SelectGenresScreen extends StatefulWidget {
  @override
  _SelectGenresScreenState createState() => _SelectGenresScreenState();
}

class _SelectGenresScreenState extends State<SelectGenresScreen> {
  final List<String> genres = [
    'Action',
    'Adventure',
    'Biography',
    'Comedy',
    'Crime',
    'Drama',
    'Fantasy',
    'Historical',
    'Horror',
    'Mystery',
    'Romance',
    'Science Fiction',
    'Self-help',
    'Thriller',
    'Western',
    'Young Adult',
    'Children',
    'Cooking',
  ];

  List<String> selectedGenres = [];

  bool get canProceed => selectedGenres.length >= 3;

  void toggleGenreSelection(String genre) {
    setState(() {
      if (selectedGenres.contains(genre)) {
        selectedGenres.remove(genre);
      } else {
        selectedGenres.add(genre);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Select Genres',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      fontFamily: 'Sora',
                    ),
                  ),
                ),


                SizedBox(height: 16),
                Card(
                  color: Color.fromRGBO(49, 51, 51, 0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16,),
                        const Center(
                          child: Text(
                            'Select the type of book you enjoy reading.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sora'
                            ),
                          ),
                        ),

                        SizedBox(height: 16,),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: genres
                              .map((genre) => GenreTag(
                            genre: genre,
                            isSelected: selectedGenres.contains(genre),
                            onTap: () => toggleGenreSelection(genre),
                          ))
                              .toList(),

                        ),

                        SizedBox(height: 16,),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(16.0, 14, 16, 14),
                          child: ElevatedButton(
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                fontFamily: "Sora",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            onPressed: canProceed ? () {
                              Navigator.pushNamed(context, '/home');
                            } : null,
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
                                backgroundColor: Color(0xFF07abb8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                )),
                          ),
                        ),

                        SizedBox(height: 16),
                        Center(
                          child: Text(
                            'Select 3 or more genres to continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sora'
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GenreTag extends StatelessWidget {
  final String genre;
  final bool isSelected;
  final VoidCallback onTap;

  const GenreTag({
    required this.genre,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
            if (isSelected) {
              return Color(0xFF07abb8); // Change to your desired selected color
            } else {
              return Colors.white;
            }
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isSelected
              ? Icon(Icons.check,
              color: Colors.white) // Tick sign when selected
              : Icon(Icons.add,
            color: Colors.black,
          ), // Plus sign when not selected
          SizedBox(width: 8),
          isSelected ? Text(
            genre,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Sora',
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          ): Text(genre,
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Sora',
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
