import 'package:flutter/material.dart';
import 'package:tikidemo/Api/Api_mock.dart';
import 'package:tikidemo/Model/Products.dart';
import 'package:tikidemo/Screen/Details.dart';

class ProductSearch extends SearchDelegate {
  List<String> allData = ['Samsung', '1', '2'];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == '') return Container();
    return FutureBuilder<List<Album>>(
        future: findByName(query),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
                'Opsss. Error found (${DateTime.now()}). ${snapshot.error}');
          } else if (snapshot.hasData) {
            final productList = snapshot.data!;

            return ListView.separated(
                itemCount: productList.length,
                separatorBuilder: (context, index) {
                  return const Divider(height: .1);
                },
                itemBuilder: (BuildContext context, int index) {
                  Album p = productList[index];
                  return InkWell(
                      onTap: () {
                        print('choosed product ${p.id}');
                        Navigator.pushNamed(
                          context,
                          Details.routeName,
                          arguments: p.id,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 1),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.2),
                          ),
                          child: Column(children: [
                            Row(children: [
                              buildMatch(query, p.name, context),
                            ]),
                            Container(
                              child: buildMatch(query, p.name, context),
                            ),
                          ]),
                        ),
                      ));
                });
          }

          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == '') return Container();

    return FutureBuilder<List<Album>>(
        future: findByName(query),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
                'Opsss. Error found (${DateTime.now()}). ${snapshot.error}');
          } else if (snapshot.hasData) {
            final productList = snapshot.data!;

            return ListView.separated(
                itemCount: productList.length,
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(height: .1),
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  Album p = productList[index];

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.2),
                      ),
                      child: Column(children: [
                        Row(children: [
                          Text(' ${p.name}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                        ]),
                        Text(
                          '${p.price}',
                        )
                      ]),
                    ),
                  );
                });
          }

          return const Center(child: CircularProgressIndicator());
        });
  }

  buildMatch(String query, String found, BuildContext context) {
    var tabs = found.toLowerCase().split(query.toLowerCase());
    List<TextSpan> list = [];
    for (var i = 0; i < tabs.length; i++) {
      if (i % 2 == 1) {
        list.add(TextSpan(
            text: query,
            style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 15)));
      }
      list.add(TextSpan(text: tabs[i]));
    }
    return RichText(
      text:
          TextSpan(style: const TextStyle(color: Colors.black), children: list),
    );
  }
}
