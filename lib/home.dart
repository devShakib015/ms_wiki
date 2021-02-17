import 'package:flutter/material.dart';
import 'package:ms_wiki/constants.dart';

import 'package:ms_wiki/network_helper.dart';
import 'movie_details_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NetworkHelper networkHelper;
  String searchKeyWord = "break";

  @override
  void initState() {
    super.initState();
    networkHelper =
        NetworkHelper(url: "$URLHEADER/?s=$searchKeyWord&apikey=$APIKEY");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                  context: context,
                  applicationName: "MS WIKI",
                  applicationLegalese: "venomShakib",
                  applicationVersion: "1.2.4",
                  applicationIcon: Image.asset(
                    'images/logo.png',
                    width: 40,
                  ));
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff8E0E00),
                Color(0xff1F1C18),
              ],
            ),
          ),
        ),
        title: Text("Movie and Series Wiki"),
        centerTitle: true,
        bottom: PreferredSize(
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                textInputAction: TextInputAction.search,
                onChanged: (String value) {
                  setState(() {
                    searchKeyWord = value;
                    if (value.length == 0) {
                      networkHelper = NetworkHelper(
                          url: "$URLHEADER/?s=break&apikey=$APIKEY");
                    } else {
                      networkHelper = NetworkHelper(
                          url: "$URLHEADER/?s=$searchKeyWord&apikey=$APIKEY");
                    }
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search By Movie or Series Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height * 0.15,
          ),
        ),
      ),
      body: FutureBuilder(
        future: networkHelper.getSearchData(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(
              color: Color(0xff1F1C18),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Container(
                child: Text("Something Went Wrong"),
                color: Color(0xff1F1C18),
              ),
            );
          } else {
            final data = snapshot.data;
            List searchResults = data["Search"];

            if (data["Response"] == "False") {
              return Center(
                child: Container(
                  child: Text("Movie Not Found"),
                  color: Color(0xff1F1C18),
                ),
              );
            } else
              return Container(
                color: Color(0xff1F1C18),
                child: ListView(
                  children: searchResults
                      .map(
                        (result) => CustomListTile(
                          title: result["Title"],
                          subtitle: "${result["Type"]} | ${result["Year"]}",
                          imageUrl: result["Poster"] = result["Poster"] == "N/A"
                              ? "https://2gyntc2a2i9a22ifya16a222-wpengine.netdna-ssl.com/wp-content/uploads/sites/29/2014/12/Image-Not-Available.jpg"
                              : result["Poster"],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailsPage(
                                  movieID: result["imdbID"],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              );
          }
        },
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Function onTap;

  CustomListTile(
      {this.title, this.subtitle, this.imageUrl, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Color(0xff8E0E00),
        child: ListTile(
          onTap: onTap,
          title: Text(title),
          subtitle: Text(subtitle),
          leading: Image.network(
            imageUrl,
            width: 32,
          ),
        ));
  }
}
