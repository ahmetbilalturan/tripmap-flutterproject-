import 'package:flutter/material.dart';
import '../models/district.dart';
import '../models/locationtype.dart';
import '../services/authservices.dart';
import '../widgets/gridview.dart';
import '../models/location.dart';
import '../widgets/scrollablelist.dart';

class ShowAllScreen extends StatefulWidget {
  final int currentindex;
  const ShowAllScreen({Key? key, required this.currentindex}) : super(key: key);

  @override
  State<ShowAllScreen> createState() => _ShowAllScreenState();
}

class _ShowAllScreenState extends State<ShowAllScreen>
    with TickerProviderStateMixin {
  bool isFetched = false;
  bool isGrid = true;
  OverlayEntry? entry;
  List<District> districtslist = [];
  List<Location> locationlist = [];
  List<LocationType> typelist = [];
  List<Widget> gridviewlist = [];
  List<Widget> scrollableviewlist = [];
  List<Location> alllocations = [];
  List<Location> dummylocations = [];

  void getlocations() async {
    await AuthService().getalllocations().then((val) {
      alllocations = val.map((json) => Location.fromJson(json)).toList();
      setState(() {
        hideLoadingOverlay();
        isFetched = true;
      });
    });
  }

  void showLoadingOverlay() {
    final overlay = Overlay.of(context)!;

    entry = OverlayEntry(
      builder: (context) => buildLoadingOverlay(),
    );

    overlay.insert(entry!);
  }

  void hideLoadingOverlay() {
    entry!.remove();
    entry = null;
  }

  Widget buildLoadingOverlay() => const Material(
        color: Colors.transparent,
        elevation: 8,
        child: Center(
          child: CircularProgressIndicator(
              color: Color.fromARGB(255, 163, 171, 192)),
        ),
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showLoadingOverlay());
    getlocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Image.asset(
            'png/DuzLogo.PNG',
            width: 150,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF6C43BC),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(
                () {
                  isGrid = true;
                },
              );
            },
            icon: Icon(
              Icons.grid_view_sharp,
              color: isGrid ? Colors.purple : Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(
                () {
                  isGrid = false;
                },
              );
            },
            icon: Icon(
              Icons.format_list_bulleted,
              color: isGrid ? Colors.grey : Colors.purple,
            ),
          ),
        ],
      ),
      body: isFetched
          ? (isGrid
              ? GridViewWidget(
                  locationslist: alllocations, typeid: widget.currentindex)
              : ScrollableListWidget(
                  locationslist: alllocations, typeid: widget.currentindex))
          : Container(),
    );
  }
}
