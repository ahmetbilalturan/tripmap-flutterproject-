import 'package:flutter/material.dart';
import 'package:tripmap/models/location.dart';
import 'package:tripmap/services/authservices.dart';
import 'package:tripmap/widgets/searchbody.dart';
import 'package:tripmap/widgets/searchwidget.dart';

class SearchScreen extends StatefulWidget {
  final int currentindex;
  const SearchScreen({Key? key, required this.currentindex}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Location> alllocations = [];
  List<Location> dummylocations = [];
  OverlayEntry? entry;
  String query = '';
  bool isHidden = true;

  void getlocations() async {
    await AuthService().getalllocations().then((val) {
      alllocations = val.map((json) => Location.fromJson(json)).toList();
      dummylocations = alllocations;
      setState(() {
        hideLoadingOverlay();
      });
    });
  }

  @override
  void initState() {
    if (widget.currentindex == 1) {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) => showLoadingOverlay());
      getlocations();
    }
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

  Widget buildSearch() {
    return SearchWidget(
      text: query,
      hintText: 'Lokasyon İsmi',
      onChanged: searchLocation,
    );
  }

  void searchLocation(String query) {
    final dummylocations = alllocations.where((location) {
      final titleLower = location.name.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.startsWith(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.dummylocations = dummylocations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.currentindex == 1
        ? Scaffold(
            backgroundColor: Colors.white,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Image.asset(
                      'png/DuzLogo.PNG',
                      width: 150,
                    ),
                  ),
                  actions: [
                    IconButton(
                        color: isHidden ? Colors.grey : const Color(0xff6c43bc),
                        onPressed: () {
                          setState(() {
                            if (isHidden) {
                              isHidden = false;
                            } else {
                              isHidden = true;
                            }
                          });
                        },
                        icon: const Icon(Icons.search))
                  ],
                ),
                isHidden
                    ? const SliverToBoxAdapter(
                        child: SizedBox(),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        sliver: SliverToBoxAdapter(
                          child: buildSearch(),
                        ),
                      ),
                SliverToBoxAdapter(
                  child: isHidden
                      ? null
                      : Center(
                          child: Text(
                              '${dummylocations.length} tane sonuç listeleniyor')),
                ),
                SearchBody(locations: dummylocations),
              ],
            ),
          )
        : const Scaffold(backgroundColor: Colors.white);
  }
}
