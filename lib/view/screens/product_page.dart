import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helper/db_helper.dart';
import '../../models/product_model.dart';
import '../../provider/cart_provider.dart';
import '../../provider/theme_provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

late Future<List<Product>> getAllData;

late TabController tabController2;

int initialTabIndex2 = 0;

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController2 = TabController(length: 3, vsync: this, initialIndex: 0);
    getAllData = DBHleper.dbHleper.fetchSearchedRecode(data: "fastfood");
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: _height * 0.02),
            SizedBox(height: _height * 0.016),
            SizedBox(height: _height * 0.02),
            TabBar(
                physics: BouncingScrollPhysics(),
                isScrollable: true,
                controller: tabController2,
                labelColor: Colors.amber,
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.amber,
                onTap: (value) {
                  setState(() {
                    initialTabIndex2 = value;
                    if (initialTabIndex2 == 0) {
                      getAllData = DBHleper.dbHleper
                          .fetchSearchedRecode(data: "FastFood");
                    }

                    if (initialTabIndex2 == 1) {
                      getAllData =
                          DBHleper.dbHleper.fetchSearchedRecode(data: "Fruit");
                    }
                    if (initialTabIndex2 == 2) {
                      getAllData =
                          DBHleper.dbHleper.fetchSearchedRecode(data: "Veg");
                    }
                  });
                },
                tabs: [
                  Tab(
                    text: "    Food     ",
                  ),
                  Tab(
                    text: "     Fruit      ",
                  ),
                  Tab(
                    text: "    Vegetable",
                  )
                ]),
            FutureBuilder(
              future: getAllData,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error : ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  List<Product>? data = snapshot.data;
                  return Container(
                    height: _height * 0.5,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          mainAxisSpacing: 5),
                      itemCount: data!.length,
                      itemBuilder: (context, i) {
                        return Card(
                          elevation: 3,
                          child: Container(
                            child: Column(
                              children: [
                                Image.asset(data[i].image,
                                    height: _height * 0.12),
                                Text("${data[i].name}".split(" ")[0]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (data[i].like == "false") {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .addToFavourite(
                                                        product: data[i]);
                                              } else {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .RemoveFromFavourite(
                                                        product: data[i]);
                                              }
                                            });
                                          },
                                          icon: (data[i].like == "false")
                                              ? Icon(
                                                  CupertinoIcons.heart_fill,
                                                )
                                              : Icon(
                                                  CupertinoIcons.heart_solid,
                                                  color: Colors.amber,
                                                )),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (data[i].quantity == 0) {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .addToCart(
                                                        product: data[i]);
                                              } else {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .RemoveFromCart(
                                                        product: data[i]);
                                              }
                                            });
                                          },
                                          icon: (data[i].quantity == 0)
                                              ? Icon(Icons.shopping_cart)
                                              : Icon(Icons
                                                  .remove_shopping_cart_outlined))
                                    ]),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
    );
  }
}
