import 'package:flutter/material.dart';
import 'package:tripmap/models/location.dart';

class GridViewWidget extends StatefulWidget {
  final List<Location> locationslist;
  final int typeid;
  const GridViewWidget(
      {Key? key, required this.locationslist, required this.typeid})
      : super(key: key);

  @override
  State<GridViewWidget> createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
  List<Location> typelocationslist = [];

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
        : CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: .55,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    mainAxisExtent: 250,
                  ),
                  delegate: SliverChildBuilderDelegate(
                      childCount: typelocationslist.length,
                      (BuildContext context, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pushNamed('/content',
                            arguments: [typelocationslist[index]]),
                        child: Container(
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
                                          Color.fromARGB(124, 0, 0, 0),
                                          Colors.transparent,
                                        ],
                                        stops: [
                                          .35,
                                          .75,
                                          1,
                                        ]).createShader(Rect.fromLTRB(
                                        0, 0, rect.width, rect.height));
                                  },
                                  blendMode: BlendMode.dstIn,
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
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${(typelocationslist[index].avaragerating).toDouble().toStringAsFixed(2)}/5',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 18,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 5),
                                    height: 30,
                                    color: const Color.fromARGB(113, 0, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            typelocationslist[index].name,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
  }
}
