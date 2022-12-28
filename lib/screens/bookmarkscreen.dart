import 'package:flutter/material.dart';
import 'package:tripmap/models/location.dart';
import 'package:tripmap/screens/loadingscreen.dart';
import 'package:tripmap/screens/loginscreen.dart';
import 'package:tripmap/services/authservices.dart';

class BookmarkScreen extends StatefulWidget {
  final int currentindex;
  const BookmarkScreen({super.key, required this.currentindex});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List locationjson = [];
  List<Location> locationlist = [];
  List<bool> isbookmarkeds = [];
  OverlayEntry? entry;
  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xFF6C43BC), Color(0xFF72DFC5)],
  ).createShader(const Rect.fromLTWH(70.0, 150.0, 200.0, 70.0));

  void getbookmarks() async {
    await AuthService().getbookmarks(LoginScreen.userid).then((val) async {
      locationjson.clear();
      isbookmarkeds.clear();
      locationlist.clear();
      for (int i = 0; i < val.length; i++) {
        await AuthService().getonefromlocations(val[i]).then((val) {
          locationjson.add(val);
          isbookmarkeds.add(true);
        });
      }
      setState(() {
        locationlist =
            locationjson.map((json) => Location.fromJson(json)).toList();
        hideLoadingOverlay();
      });
    });
  }

  void addtobookmarks(int index) async {
    await AuthService()
        .addtobookmarks(LoginScreen.userid, locationlist[index].id);
    setState(() {
      isbookmarkeds[index] = true;
      hideLoadingOverlay();
    });
  }

  void removefrombookmarks(int index) async {
    await AuthService()
        .removefrombookmarks(LoginScreen.userid, locationlist[index].id);
    setState(() {
      isbookmarkeds[index] = false;
      hideLoadingOverlay();
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
    if (widget.currentindex == 2) {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) => showLoadingOverlay());
      getbookmarks();
    }
  }

  Future refresh() async {
    showLoadingOverlay();
    getbookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.currentindex == 2
          ? LoadingScreen.isLogined
              ? RefreshIndicator(
                  onRefresh: refresh,
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
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
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: locationlist.length,
                          ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/content',
                                    arguments: [
                                      locationlist[index],
                                    ],
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFF6C43BC),
                                        Color(0xFF72DFC5),
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: SizedBox(
                                              width: 60,
                                              height: 65,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  (locationlist[index]
                                                      .imageurls)[0],
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    locationlist[index].name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  onPressed: () {
                                                    if (isbookmarkeds[index]) {
                                                      showLoadingOverlay();
                                                      removefrombookmarks(
                                                          index);
                                                    } else {
                                                      showLoadingOverlay();
                                                      addtobookmarks(index);
                                                    }
                                                  },
                                                  icon: isbookmarkeds[index]
                                                      ? const Icon(
                                                          Icons.bookmark)
                                                      : const Icon(Icons
                                                          .bookmark_outline),
                                                  color:
                                                      const Color(0xFF6C43BC),
                                                  focusColor:
                                                      const Color(0xFF6C43BC),
                                                  iconSize: 32.5,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 250,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF6C43BC),
                              Color(0xFF72DFC5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: SizedBox(
                          child: TextButton(
                            child: const Text(
                              'Devam etmeden önce giriş yap!',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/login', arguments: []);
                            },
                          ),
                        ),
                      ),
                      /* ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/login', arguments: []);
                        },
                        child: const Text('GirişYap'),
                      ), */
                    ],
                  ),
                )
          : Container(),
    );
  }
}
