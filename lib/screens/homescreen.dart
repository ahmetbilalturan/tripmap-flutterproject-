import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tripmap/models/district.dart';
import 'package:tripmap/models/location.dart';
import 'package:tripmap/models/locationtype.dart';
import 'package:tripmap/services/authservices.dart';
import 'package:tripmap/widgets/gridview.dart';
import 'package:tripmap/widgets/scrollablelist.dart';

class HomeScreen extends StatefulWidget {
  final int currentindex;
  const HomeScreen({Key? key, required this.currentindex}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool isFetched = false;
  bool isGrid = true;
  OverlayEntry? entry;
  int _currentDistrictIndex = 0;
  late TabController _controller;
  late AnimationController _animationControllerOn;
  late AnimationController _animationControllerOff;
  late Animation _colorTweenBackgroundOn;
  late Animation _colorTweenBackgroundOff;
  int _currentIndex = 0;
  int _prevControllerIndex = 0;
  double _aniValue = 0.0;
  double _prevAniValue = 0.0;
  final Color _backgroundOn = const Color(0xff6c43bc);
  final Color _backgroundOff = Colors.white;
  final ScrollController _scrollController = ScrollController();
  final List _keys = [];
  bool _buttonTap = false;
  List<District> districtslist = [];
  List<District> districtsdummylist = [];
  List<Location> locationlist = [];
  List<LocationType> typelist = [];
  List<Widget> gridviewlist = [];
  List<Widget> scrollableviewlist = [];
  List<Location> randomlocationlist = [];
  List<Location> alllocations = [];

  void initializedata(int districtid, bool isinitializing) async {
    setState(() {
      isFetched = false;
    });
    gridviewlist.clear();
    scrollableviewlist.clear();
    alllocations.clear();
    if (isinitializing) {
      await AuthService().getalllocations().then(
        (val) {
          alllocations = val.map((json) => Location.fromJson(json)).toList();
          randomlocationlist.clear();
          for (int i = 0; i < 10; i++) {
            randomlocationlist.add(getRandomElement(alllocations));
          }
        },
      );
      alllocations.clear();
      await AuthService().getdistricts().then((val) {
        districtsdummylist.clear();
        districtsdummylist =
            val.map((json) => District.fromJson(json)).toList();
        for (int i = 0; i < districtsdummylist.length; i++) {
          if (districtsdummylist[i].districtlocationcount > 0) {
            districtslist.add(districtsdummylist[i]);
          }
        }
        districtsdummylist.clear();
      });
    }
    await AuthService().getlocations(districtid).then((val) {
      locationlist.clear();
      locationlist = val.map((json) => Location.fromJson(json)).toList();
    });
    await AuthService().gettypes().then((val) {
      typelist.clear();
      typelist = val.map((json) => LocationType.fromJson(json)).toList();
    });
    for (int index = 0; index < typelist.length; index++) {
      // create a GlobalKey for each Tab
      if (isinitializing) {
        _keys.add(GlobalKey());
      }
      gridviewlist.add(GridViewWidget(
        locationslist: locationlist,
        typeid: typelist[index].id,
      ));
      scrollableviewlist.add(ScrollableListWidget(
        locationslist: locationlist,
        typeid: typelist[index].id,
      ));
    }
    if (isinitializing) {
      _controller = TabController(vsync: this, length: typelist.length);
      _controller.animation!.addListener(_handleTabAnimation);
      _controller.addListener(_handleTabChange);
      _animationControllerOff = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 75));
      _animationControllerOff.value = 1.0;
      _colorTweenBackgroundOff =
          ColorTween(begin: _backgroundOn, end: _backgroundOff)
              .animate(_animationControllerOff);

      _animationControllerOn = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 150));
      _animationControllerOn.value = 1.0;
      _colorTweenBackgroundOn =
          ColorTween(begin: _backgroundOff, end: _backgroundOn)
              .animate(_animationControllerOn);
    }

    setState(() {
      hideLoadingOverlay();
      isFetched = true;
    });
  }

  T getRandomElement<T>(List<T> list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
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
    if (widget.currentindex == 0) {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) => showLoadingOverlay());
      initializedata(1, true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.currentindex == 0
          ? NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    title: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Image.asset(
                        'png/DuzLogo.PNG',
                        width: 150,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Önerilenler'),
                              ],
                            ),
                          ),
                          Container(
                            height: 225,
                            color: Colors.white,
                            child: ListView.builder(
                              clipBehavior: Clip.none,
                              itemCount: randomlocationlist.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (() {
                                      Navigator.of(context).pushNamed(
                                        '/content',
                                        arguments: [randomlocationlist[index]],
                                      );
                                    }),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: 300,
                                        height: 250,
                                        color: Colors.black,
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              height: 250,
                                              child: ShaderMask(
                                                shaderCallback: (rect) {
                                                  return const LinearGradient(
                                                    begin: Alignment.bottomLeft,
                                                    end: Alignment.topRight,
                                                    colors: [
                                                      Colors.black,
                                                      Color.fromARGB(
                                                          124, 0, 0, 0),
                                                      Colors.transparent,
                                                    ],
                                                    stops: [
                                                      .35,
                                                      .75,
                                                      1,
                                                    ],
                                                  ).createShader(
                                                    Rect.fromLTRB(
                                                        0,
                                                        0,
                                                        rect.width,
                                                        rect.height),
                                                  );
                                                },
                                                blendMode: BlendMode.dstIn,
                                                child: Image.network(
                                                  randomlocationlist[index]
                                                      .imageurls[0],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '${(randomlocationlist[index].avaragerating).toDouble().toStringAsFixed(2)}/5',
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 30,
                                                  color: const Color.fromARGB(
                                                      113, 0, 0, 0),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: Text(
                                                          randomlocationlist[
                                                                  index]
                                                              .name,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 175,
                      color: Colors.white,
                      child: ListView.builder(
                        clipBehavior: Clip.none,
                        itemCount: districtslist.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (_currentDistrictIndex != index) {
                                    _currentDistrictIndex = index;
                                    showLoadingOverlay();
                                    initializedata(
                                        districtslist[index].districtid, false);
                                  }
                                });
                              },
                              child: Container(
                                width: 125,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _currentDistrictIndex == index
                                        ? const Color(0xff6c43bc)
                                        : Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: ShaderMask(
                                          shaderCallback: (rect) {
                                            return const LinearGradient(
                                              begin: Alignment.bottomLeft,
                                              end: Alignment.topRight,
                                              colors: [
                                                Colors.black,
                                                Color.fromARGB(124, 0, 0, 0),
                                                Colors.transparent,
                                              ],
                                              stops: [
                                                .35,
                                                .95,
                                                1,
                                              ],
                                            ).createShader(
                                              Rect.fromLTRB(0, 0, rect.width,
                                                  rect.height),
                                            );
                                          },
                                          blendMode: BlendMode.dstIn,
                                          child: Image.network(
                                            districtslist[index]
                                                .districtimageurl,
                                            fit: BoxFit.fitHeight,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${districtslist[index].districtavaragerating.toDouble().toStringAsFixed(2)}/5',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(113, 0, 0, 0),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                          ),
                                          height: 25,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  districtslist[index]
                                                      .districtname,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 49.0,
                      // this generates our tabs buttons
                      child: ListView.builder(
                        // this gives the TabBar a bounce effect when scrolling farther than it's size
                        physics: const BouncingScrollPhysics(),
                        controller: _scrollController,
                        // make the list horizontal
                        scrollDirection: Axis.horizontal,
                        // number of tabs
                        itemCount: typelist.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            // each button's key
                            key: _keys[index],
                            // padding for the buttons
                            padding: const EdgeInsets.all(6.0),
                            child: ButtonTheme(
                              child: AnimatedBuilder(
                                animation: _colorTweenBackgroundOn,
                                builder: (context, child) => ElevatedButton(
                                  // get the color of the button's background (dependent of its state)
                                  // make the button a rectangle with round corners
                                  style: ButtonStyle(
                                      fixedSize:
                                          MaterialStateProperty.all<Size>(
                                        const Size.fromWidth(90),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: const BorderSide(
                                            color: Color(0xff6c43bc),
                                          ),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              _getBackgroundColor(index))),
                                  onPressed: () {
                                    setState(
                                      () {
                                        _buttonTap = true;
                                        // trigger the controller to change between Tab Views
                                        _controller.animateTo(index);
                                        // set the current index
                                        _setCurrentIndex(index);
                                        // scroll to the tapped button (needed if we tap the active button and it's not on its position)
                                        _scrollTo(index);
                                      },
                                    );
                                  },
                                  child: Text(
                                    // get the icon
                                    typelist[index].name,
                                    style: TextStyle(
                                      color: index == _currentIndex
                                          ? Colors.white
                                          : const Color(0xff6c43bc),
                                    ),
                                    // get the color of the icon (dependent of its state)
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 30,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/showAll',
                              arguments: [typelist[_currentIndex].id]);
                        },
                        child: const Text(
                          'Türe Ait Tüm Yerleri Görüntüle',
                          style: TextStyle(
                            color: Color(0xFF6C43BC),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton(
                                underline:
                                    const SizedBox(), //Daha sonra burası list ile düzeltilecek
                                value:
                                    'Popülerlik', //Daha sonra burası list ile düzeltilecek
                                items: const [
                                  //Daha sonra burası list ile düzeltilecek
                                  DropdownMenuItem(
                                    //Daha sonra burası list ile düzeltilecek
                                    value:
                                        'Popülerlik', //Daha sonra burası list ile düzeltilecek
                                    child: Text(
                                        'Popülerlik'), //Daha sonra burası list ile düzeltilecek
                                  ) //Daha sonra burası list ile düzeltilecek
                                ],
                                onChanged: (String? newValue) {}),
                          ),
                          Row(
                            children: [
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
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: isFetched
                  ? TabBarView(
                      controller: _controller,
                      children: isFetched
                          ? (isGrid ? gridviewlist : scrollableviewlist)
                          : [],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            )
          : Container(),
    );
  }

  // runs during the switching tabs animation
  _handleTabAnimation() {
    // gets the value of the animation. For example, if one is between the 1st and the 2nd tab, this value will be 0.5
    _aniValue = _controller.animation!.value;

    // if the button wasn't pressed, which means the user is swiping, and the amount swipped is less than 1 (this means that we're swiping through neighbor Tab Views)
    if (!_buttonTap && ((_aniValue - _prevAniValue).abs() < 1)) {
      // set the current tab index
      _setCurrentIndex(_aniValue.round());
    }

    // save the previous Animation Value
    _prevAniValue = _aniValue;
  }

  // runs when the displayed tab changes
  _handleTabChange() {
    // if a button was tapped, change the current index
    if (_buttonTap) _setCurrentIndex(_controller.index);

    // this resets the button tap
    if ((_controller.index == _prevControllerIndex) ||
        (_controller.index == _aniValue.round())) _buttonTap = false;

    // save the previous controller index
    _prevControllerIndex = _controller.index;
  }

  _setCurrentIndex(int index) {
    // if we're actually changing the index
    if (index != _currentIndex) {
      setState(() {
        // change the index
        _currentIndex = index;
      });

      // trigger the button animation
      _triggerAnimation();
      // scroll the TabBar to the correct position (if we have a scrollable bar)
      _scrollTo(index);
    }
  }

  _triggerAnimation() {
    // reset the animations so they're ready to go
    _animationControllerOn.reset();
    _animationControllerOff.reset();

    // run the animations!
    _animationControllerOn.forward();
    _animationControllerOff.forward();
  }

  _scrollTo(int index) {
    // get the screen width. This is used to check if we have an element off screen
    double screenWidth = MediaQuery.of(context).size.width;

    // get the button we want to scroll to
    RenderBox renderBox = _keys[index].currentContext.findRenderObject();
    // get its size
    double size = renderBox.size.width;
    // and position
    double position = renderBox.localToGlobal(Offset.zero).dx;

    // this is how much the button is away from the center of the screen and how much we must scroll to get it into place
    double offset = (position + size / 2) - screenWidth / 2;

    // if the button is to the left of the middle
    if (offset < 0) {
      // get the first button
      renderBox = _keys[0].currentContext.findRenderObject();
      // get the position of the first button of the TabBar
      position = renderBox.localToGlobal(Offset.zero).dx;

      // if the offset pulls the first button away from the left side, we limit that movement so the first button is stuck to the left side
      if (position > offset) offset = position;
    } else {
      // if the button is to the right of the middle

      // get the last button
      renderBox = _keys[typelist.length - 1].currentContext.findRenderObject();
      // get its position
      position = renderBox.localToGlobal(Offset.zero).dx;
      // and size
      size = renderBox.size.width;

      // if the last button doesn't reach the right side, use it's right side as the limit of the screen for the TabBar
      if (position + size < screenWidth) screenWidth = position + size;

      // if the offset pulls the last button away from the right side limit, we reduce that movement so the last button is stuck to the right side limit
      if (position + size - offset < screenWidth) {
        offset = position + size - screenWidth;
      }
    }

    // scroll the calculated ammount
    _scrollController.animateTo(offset + _scrollController.offset,
        duration: const Duration(milliseconds: 150), curve: Curves.easeInOut);
  }

  _getBackgroundColor(int index) {
    if (index == _currentIndex) {
      // if it's active button
      return _colorTweenBackgroundOn.value;
    } else if (index == _prevControllerIndex) {
      // if it's the previous active button
      return _colorTweenBackgroundOff.value;
    } else {
      // if the button is inactive
      return _backgroundOff;
    }
  }
}
