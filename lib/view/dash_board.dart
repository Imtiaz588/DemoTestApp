import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localstorage/localstorage.dart';
import 'package:movies_dashbord/control/api_controller.dart';
import 'package:movies_dashbord/model/api_data_model.dart';
import 'package:movies_dashbord/model/constant_data.dart';
import 'package:movies_dashbord/widgets/img_widget.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final TextEditingController _searchController = TextEditingController();
  late Future<ApiDataModel> futureData;
  final LocalStorage storage = LocalStorage('fav');
  bool showOrgList = true;

  @override
  void initState() {
    super.initState();
    futureData = ApiController().getApiData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autofocus: false,
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 15, bottom: 11, top: 11, right: 15),
                  hintText: 'Search movie name',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_searchController.text.isNotEmpty) {
                          showOrgList = false;
                        } else {
                          showOrgList = true;
                        }
                      });
                    },
                    child: const Icon(
                      Icons.search,
                      size: 25,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            FutureBuilder<ApiDataModel>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return showOrgList
                      ? SizedBox(
                          height: size.height * 0.74,
                          child: ListView.builder(
                            itemCount: snapshot.data!.results!.length,
                            itemBuilder: (context, index) {
                              var isfav = storage.getItem(
                                      "${snapshot.data!.results![index].id}") ??
                                  false;
                              return _listTile(
                                "${snapshot.data!.results![index].logoPath}",
                                "${snapshot.data!.results![index].id}",
                                "${snapshot.data!.results![index].name}",
                                isfav,
                              );
                            },
                          ),
                        )
                      : SizedBox(
                          height: size.height * 0.74,
                          child: ListView.builder(
                            itemCount: snapshot.data!.results!.length,
                            itemBuilder: (context, index) {
                              var isfav = storage.getItem(
                                      "${snapshot.data!.results![index].id}") ??
                                  false;
                              return snapshot.data!.results![index].name
                                      .toString()
                                      .toLowerCase()
                                      .trim()
                                      .contains(_searchController.text
                                          .toLowerCase()
                                          .trim())
                                  ? _listTile(
                                      "${snapshot.data!.results![index].logoPath}",
                                      "${snapshot.data!.results![index].id}",
                                      "${snapshot.data!.results![index].name}",
                                      isfav,
                                    )
                                  : Container();
                            },
                          ),
                        );
                } else {
                  return Padding(
                    padding: EdgeInsets.only(top: size.height * 0.3),
                    child: const SpinKitThreeBounce(
                      color: Colors.blueAccent,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _listTile(
      String imagePath, String itemID, String itemName, bool isFvrt) {
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
              const Spacer(),
              IconButton(
                iconSize: 30.0,
                onPressed: () async {
                  if (isFvrt) {
                    await storage.deleteItem(itemID);
                  } else {
                    await storage.setItem(itemID, true);
                  }
                  setState(() {});
                },
                icon: isFvrt
                    ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
                    : const Icon(
                  Icons.favorite,
                  color: Colors.black26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
