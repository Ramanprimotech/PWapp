import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:pwlp/pw_app.dart';

class LocationSearch extends StatefulWidget {
  const LocationSearch({Key? key, fun}) : super(key: key);

  @override
  _LocationSearchState createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  final TextEditingController _filter = TextEditingController();
  final dio = Dio();
  final String _searchText = "";
  List names = [];
  List filteredNames = [];
  bool? checkVal;
  late LocationData locationData;
  Icon _searchIcon = const Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget _appBarTitle = const Text('Search Address');
  String editText = "";
  String unit_location_desc = "";

  _LocationSearchState() {
    _filter.addListener(() {});
  }

  firstCall() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.get("SelctedSpeciality");
    locAPIFirst(
        "a", sharedPreferences.get("SelctedSpeciality") as String?, context);
  }

  @override
  initState() {
    firstCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: _buildBar(context) as PreferredSizeWidget?,
      body: Container(
        child: _buildList(),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    ToastContext().init(context);
    return AppBar(
      backgroundColor: const Color(0xff4725a3),
      centerTitle: true,
      title: _appBarTitle,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
      ],
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = [];
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['company']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return names.isNotEmpty
        ? ListView.builder(
            // ignore: unnecessary_null_comparison
            itemCount: names == null ? 0 : filteredNames.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(
                    "${filteredNames[index]['company']}",
                    style: const TextStyle(
                        fontFamily: 'texgyreadventor-regular', fontSize: 14),
                  ),
                  subtitle: Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    "${filteredNames[index]['address_1']}, ${filteredNames[index]['city']}, ${filteredNames[index]['state']}\n${filteredNames[index]['unit_location_desc'] == "null" ? "" : "- ATTN: " + filteredNames[index]['unit_location_desc']}  ",
                    style: const TextStyle(
                        fontFamily: 'texgyreadventor-regular', fontSize: 12),
                  ),
                  onTap: () {
                    String finalStr =
                        "${filteredNames[index]['company']}, ${filteredNames[index]['address_1']}, ${filteredNames[index]['city']}, ${filteredNames[index]['state']}";

                    String attnStr;
                    if (filteredNames[index]['unit_location_desc'] != "null") {
                      attnStr = "${filteredNames[index]['unit_location_desc']}";
                    } else {
                      attnStr = "";
                    }
                    String addressId = "${filteredNames[index]['id']}";
                    const RegisterVC().updateUI(finalStr, addressId, attnStr);
                    Navigator.of(context).pop();
                  });
            },
          )
        : Center(
            child: checkVal == true
                ? const Text(
                    "No result found",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  )
                : const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xff4725a3)),
                  ));
  }

  _searchPressed() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = const Icon(Icons.close);
        _appBarTitle = TextField(
          controller: _filter,
          cursorColor: Colors.white,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'texgyreadventor-regular'),
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: 'Search...',
              hintStyle: TextStyle(
                  color: Colors.white, fontFamily: 'texgyreadventor-regular')),
          onChanged: (text) {
            locAPIFirst(text,
                sharedPreferences.get("SelctedSpeciality") as String?, context);
            checkVal = false;
            if (text.isEmpty) {
              locAPIFirst(
                  "a",
                  sharedPreferences.get("SelctedSpeciality") as String?,
                  context);
            }
          },
        );
      } else {
        _searchIcon = const Icon(
          Icons.search,
          color: Colors.white,
        );
        _appBarTitle = const Text(
          'Search Address',
          style: TextStyle(fontFamily: 'texgyreadventor-regular'),
        );

        setState(() {
          checkVal = false;
          filteredNames = names;
        });
        if (_filter.text.isNotEmpty) {
          locAPIFirst("a",
              sharedPreferences.get("SelctedSpeciality") as String?, context);
        }

        _filter.clear();
      }
    });
  }

  locAPIFirst(
      String enteredkeyword, String? specialty, BuildContext context) async {
    setState(() {
      names.clear();
      filteredNames.clear();
    });

    GetGeoLocation getGeoLocation = GetGeoLocation();
    Position? position = await getGeoLocation.getCurrentPosition(context);
    var data = <String, String>{};
    if (Api.baseUrl == BaseUrl.stageUrl) {
      data = {
        'keyword': enteredkeyword,
        "specialty": specialty!,
        "latitude": "${position!.latitude}",
        "longitude": "${position.longitude}"
      };
    } else {
      data = {
        'keyword': enteredkeyword,
        "specialty": specialty!,
        "latitude": "${position!.latitude}",
        "longitude": "${position.longitude}"
      };
    }

    log(data.toString(), name: "Request");
    String url = "${Api.baseUrl}" "${Api().get_address}";
    var response = await http.post(Uri.parse(url), body: data);
    print(response.body);
    if (response.statusCode == 200) {
      locationData = LocationData.fromJson(json.decode(response.body));
      List tempList = [];
      for (int i = 0; i < locationData.data!.length; i++) {
        tempList.add(locationData.data![i].toJson());
      }
      setState(() {
        names = tempList;
        filteredNames = names;
      });
    } else {
      log("Failure API 27Feb");

      setState(() {
        checkVal = true;
      });
    }
  }
}
