import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/detailscreen.dart';
import 'package:eshop/mainurl.dart';
import 'package:flutter/material.dart';
import 'globalclass.dart' as globalclass;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  void _filterItems(String query) {
    globalclass.search.clear();
    query = query.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        globalclass.search.clear();
        globalclass.sear.clear();
      } else {
        globalclass.search = globalclass.menproduct
            .where((item) =>
                item.description.toLowerCase().contains(query) ||
                item.name.toLowerCase().contains(query))
            .toList();
        globalclass.sear = globalclass.womenproduct
            .where((s) =>
                s.description.toLowerCase().contains(query) ||
                s.name.toLowerCase().contains(query))
            .toList();
        for (int i = 0; i < globalclass.sear.length; i++) {
          globalclass.search.add(globalclass.sear[i]);
        }
        visible = false;
      }
    });
  }

  static bool visible = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        extendBody: true,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      "Search",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 320,
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: TextField(
                          onChanged: (query) {
                            _filterItems(query.trim());
                          },
                          decoration: InputDecoration(
                            hintText: 'Search Here...',
                            prefixIcon: const Icon(Icons.search),
                            fillColor: Colors.grey[300],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: globalclass.search.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: globalclass.search.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 70,
                                child: ListTile(
                                  trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        globalclass.search.removeAt(index);
                                        globalclass.sear.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                  ),
                                  title: Text(
                                    globalclass.search[index].name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                  subtitle: Text(
                                    globalclass.search[index].price,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  ),
                                  leading: CircleAvatar(
                                    radius: 35,
                                    child: CachedNetworkImage(
                                      imageUrl: MyUrl.fullurl +
                                          globalclass.search[index].image,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider)),
                                        );
                                      },
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                                globalclass.search[index]),
                                          ));
                                      visible = true;
                                    });
                                  },
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'No Result Found',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "NotoSans"),
                                  ),
                                ],
                              )
                            ],
                          )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
