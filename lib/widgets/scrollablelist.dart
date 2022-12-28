import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripmap/models/location.dart';

class ScrollableListWidget extends StatefulWidget {
  final List<Location> locationslist;
  final int typeid;
  const ScrollableListWidget(
      {Key? key, required this.locationslist, required this.typeid})
      : super(key: key);

  @override
  State<ScrollableListWidget> createState() => _ScrollableListWidgetState();
}

class _ScrollableListWidgetState extends State<ScrollableListWidget> {
  List<Location> typelocationslist = [];
  List<bool> isBookmarkeds = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  void gettypelocations() {
    for (int i = 0; i < widget.locationslist.length; i++) {
      if (widget.locationslist[i].locationtypeid == widget.typeid) {
        typelocationslist.add(widget.locationslist[i]);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    gettypelocations();
  }

  @override
  Widget build(BuildContext context) {
    return typelocationslist.isEmpty
        ? const Center(
            child: Text('Bu liste boştur'),
          )
        : ListView.builder(
            itemCount: typelocationslist.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/content',
                      arguments: [typelocationslist[index]]);
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                      child: SizedBox(
                        height: 200,
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  height: 175,
                                  width: 120,
                                  child: Image.network(
                                    (typelocationslist[index].imageurls)[0],
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
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
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(3, 10, 3, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            typelocationslist[index].name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: RatingBarIndicator(
                                        rating: typelocationslist[index]
                                            .avaragerating
                                            .toDouble(),
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 17,
                                        direction: Axis.horizontal,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        maxLines: 7,
                                        overflow: TextOverflow.ellipsis,
                                        typelocationslist[index].defination,
                                        style: GoogleFonts.inter(
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 13,
                        right: 13,
                      ),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
