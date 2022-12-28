import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tripmap/models/comment.dart';
import 'package:tripmap/models/location.dart';
import 'package:tripmap/screens/loadingscreen.dart';
import 'package:tripmap/screens/loginscreen.dart';
import '../services/authservices.dart';
import 'package:google_fonts/google_fonts.dart';

class ContentScreen extends StatefulWidget {
  final Location location;
  const ContentScreen({Key? key, required this.location}) : super(key: key);

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  OverlayEntry? entry;
  int activeIndex = 0;
  List<Comment> commentList = [];
  List<String> usernames = [];
  bool isBookmarked = false;

  void getComments() async {
    await AuthService().getlocationcomments(widget.location.id).then(
      (val) async {
        commentList = val.map((json) => Comment.fromJson(json)).toList();
        for (int i = 0; i < commentList.length; i++) {
          await AuthService()
              .getusernamefromid(commentList[i].userID)
              .then((val) {
            usernames.add(val);
          });
        }
        setState(() {
          hideLoadingOverlay();
        });
      },
    );
  }

  void addtobookmarks() async {
    await AuthService().addtobookmarks(LoginScreen.userid, widget.location.id);
    setState(() {
      isBookmarked = true;
      hideLoadingOverlay();
    });
  }

  void removefrombookmarks() async {
    await AuthService()
        .removefrombookmarks(LoginScreen.userid, widget.location.id);
    setState(() {
      isBookmarked = false;
      hideLoadingOverlay();
    });
  }

  void checkifitsinbookmarks() async {
    if (LoadingScreen.isLogined) {
      isBookmarked = await AuthService()
          .checkifitsinbookmarks(LoginScreen.userid, widget.location.id);
    } else {
      isBookmarked = false;
    }
    setState(() {});
  }

  void goto() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => showLoadingOverlay());
    if (LoadingScreen.isLogined) {
      await AuthService().addtoroutes(LoginScreen.userid, widget.location.name);
    }
    String coordinate = widget.location.coordinate;
    List<String> latitudelongitude = coordinate.split(',').toList();
    LatLng destination = LatLng(
        double.parse(latitudelongitude[0]), double.parse(latitudelongitude[1]));
    hideLoadingOverlay();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushNamed('/map', arguments: [destination]);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showLoadingOverlay());
    checkifitsinbookmarks();
    getComments();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 35,
              width: 125,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6C43BC),
                    Color(0xFF72DFC5),
                  ],
                  stops: [
                    0.2,
                    1.0,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextButton(
                onPressed: () {
                  goto();
                },
                child: const Text(
                  'GİT',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 450,
              child: Stack(
                children: [
                  (widget.location.imageurls).length > 1
                      ? CarouselSlider.builder(
                          itemCount: (widget.location.imageurls).length,
                          itemBuilder: (context, index, realIndex) {
                            final urlImage = widget.location.imageurls;
                            return buildImage(urlImage[index], index);
                          },
                          options: CarouselOptions(
                            height: 450,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            viewportFraction: 1,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 10),
                            onPageChanged: (index, reason) =>
                                setState(() => activeIndex = index),
                          ),
                        )
                      : Image.network(
                          widget.location.imageurls[0],
                          height: 450,
                          fit: BoxFit.cover,
                        ),
                  (widget.location.imageurls).length > 1
                      ? Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 60.0),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: buildIndicator(),
                          ),
                        )
                      : Container(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back),
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.only(left: 5),
                        color: const Color.fromARGB(169, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.location.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (LoadingScreen.isLogined) {
                                  if (isBookmarked == false) {
                                    setState(() {
                                      showLoadingOverlay();
                                    });
                                    addtobookmarks();
                                  } else {
                                    setState(() {
                                      showLoadingOverlay();
                                    });
                                    removefrombookmarks();
                                  }
                                } else {
                                  Navigator.of(context).pushNamed('/login');
                                }
                              },
                              icon: Icon(
                                isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            sliver: SliverToBoxAdapter(
              child: RatingBarIndicator(
                rating: widget.location.avaragerating.toDouble(),
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Text(
                widget.location.defination,
                style: GoogleFonts.inter(fontSize: 17),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(childCount: usernames.length,
                (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(
                  children: [
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Image.asset(
                              'png/gigaChad.jpg',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            children: [
                              Text(
                                usernames[index],
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              RatingBarIndicator(
                                rating: (commentList[index].rating).toDouble(),
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 14.0,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(commentList[index].content),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildImage(String urlImage, int index) => Image.network(
        urlImage,
        fit: BoxFit.cover,
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: (widget.location.imageurls).length,
        effect: const ScrollingDotsEffect(
          dotColor: Color.fromARGB(131, 255, 255, 255),
          activeDotColor: Colors.white,
          dotWidth: 10.0,
          dotHeight: 10.0,
          spacing: 4.0,
        ),
        onDotClicked: (index) {},
      );
}
