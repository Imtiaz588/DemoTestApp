import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localstorage/localstorage.dart';
import 'package:movies_dashbord/control/api_controller.dart';
import 'package:movies_dashbord/model/api_data_model.dart';
import 'package:movies_dashbord/model/constant_data.dart';
import 'package:movies_dashbord/widgets/img_widget.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  late Future<ApiDataModel> futureData;
  final LocalStorage storage = LocalStorage('fav');

  @override
  void initState() {
    super.initState();
    futureData = ApiController().getApiData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ApiDataModel>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.results!.length,
              itemBuilder: (context, index) {
                var isfav =
                    storage.getItem("${snapshot.data!.results![index].id}") ??
                        false;
                return isfav
                    ? _listTile(
                        "${snapshot.data!.results![index].logoPath}",
                        "${snapshot.data!.results![index].id}",
                        "${snapshot.data!.results![index].name}")
                    : Container();
              },
            );
          } else {
            return const Center(
                child: SpinKitThreeBounce(
              color: Colors.blueAccent,
            ));
          }
        },
      ),
    );
  }

  Widget _listTile(String imagePath, String itemID, String itemName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 5,
              blurRadius: 8,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10, 20, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImgWidget(imagePath),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemID,
                      overflow: TextOverflow.ellipsis,
                      style: Constants.boldTextStyle,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      itemName,
                      overflow: TextOverflow.ellipsis,
                      style: Constants.simpleTextStyle,
                    ),
                    // const PrimaryButtonWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
