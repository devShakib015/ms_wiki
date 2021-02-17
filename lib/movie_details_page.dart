import 'package:flutter/material.dart';
import 'package:ms_wiki/constants.dart';
import 'package:ms_wiki/network_helper.dart';

class MovieDetailsPage extends StatefulWidget {
  final String movieID;
  MovieDetailsPage({this.movieID});

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  NetworkHelper networkHelper;

  @override
  void initState() {
    super.initState();
    networkHelper =
        NetworkHelper(url: "$URLHEADER/?i=${widget.movieID}&apikey=$APIKEY");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1F1C18),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: networkHelper.getMovieDetails(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Something Went Wrong"),
            );
          } else {
            final data = snapshot.data;
            List<String> genreList = data["Genre"].split(", ");
            List<String> castList = data["Actors"].split(", ");

            if (data["Response"] == "False") {
              return Center(
                child: Text("Error Fetching The Movie Details"),
              );
            } else
              return Container(
                child: ListView(
                  children: [
                    Image.network(
                      data["Poster"] = data["Poster"] == "N/A"
                          ? "https://2gyntc2a2i9a22ifya16a222-wpengine.netdna-ssl.com/wp-content/uploads/sites/29/2014/12/Image-Not-Available.jpg"
                          : data["Poster"],
                      fit: BoxFit.cover,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'images/imdb.png',
                            width: 50,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            data["imdbRating"],
                            style: kRatingTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        data["Title"].toUpperCase(),
                        style: kTitleTextStyle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type: ${data["Type"]}",
                            style: kMetaTextStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Director: ${data["Director"]}",
                            style: kMetaTextStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Writer: ${data["Writer"]}",
                            style: kMetaTextStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Language: ${data["Language"]}",
                            style: kMetaTextStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Released: ${data["Released"]}",
                            style: kMetaTextStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Rated: ${data["Rated"]}",
                            style: kMetaTextStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${data["Country"]} | ${data["Year"]} | ${data["Runtime"]}",
                            style: kMetaTextStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Awards: ${data["Awards"]}",
                            style: kMetaTextStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: genreList
                                .map(
                                  (String value) => Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          width: 2, color: Colors.grey),
                                    ),
                                    child: Text(
                                      value,
                                      style: kMetaTextStyle,
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        data["Plot"],
                        style: kDetailsTextStyle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Text(
                          "Casts".toUpperCase(),
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Wrap(
                        spacing: 10,
                        alignment: WrapAlignment.center,
                        runSpacing: 10,
                        children: castList
                            .map(
                              (String value) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(width: 2, color: Colors.grey),
                                ),
                                child: Text(
                                  value,
                                  style: kMetaTextStyle,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
