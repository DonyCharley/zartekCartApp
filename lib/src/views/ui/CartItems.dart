import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:zartech_cart_app/src/business_logic/models/CategoryProductListModel.dart';
import 'package:zartech_cart_app/src/business_logic/models/ItemCartModel.dart';
import 'package:zartech_cart_app/src/business_logic/utils/preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:zartech_cart_app/src/business_logic/utils/constants.dart';

import 'categoryWiseProducts.dart';

class CartItemsList extends StatefulWidget {
  List<CartItems> cartItems;
  User user;

  CartItemsList(List<CartItems> cartItems, User user) {
    this.cartItems = cartItems;
    this.user = user;
  }

  @override
  _CartItemsListState createState() => _CartItemsListState();
}

class _CartItemsListState extends State<CartItemsList> {
  Widget getCards(List<CartItems> cartItems, int ind, BuildContext context) {
    int productCount = cartItems[ind].dISHCOUNT;
    TextEditingController qtyC =
        new TextEditingController(text: productCount.toString());
    return new Container(
        height: 200,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(

                  // height: 300,
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        /*   margin: EdgeInsets.only(
                                    top: 10, left: 5),*/
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomLeft,
                              colors: [Colors.white, Colors.white70],
                            )),
                        child: Image(
                          image: cartItems[ind].iTEMTYPE == 2
                              ? AssetImage('assets/images/veg.png')
                              : AssetImage('assets/images/non_veg.png'),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .20,
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          cartItems[ind].dISHNAME,
                          style: TextStyle(
                              fontFamily: 'Muli',
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 120,
                            /* padding:
                                EdgeInsets.all(15),*/
                            decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(
                                color: Colors.green,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: new TextFormField(
                                controller: qtyC,
                                readOnly: true,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontFamily: 'Muli', color: Colors.white),
                                cursorColor: Colors.white,
                                // controller: categorySearch,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),

                                  prefixIcon: IconButton(
                                    icon: new Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: new Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),

                                  //  labelText: searchfieldText,
                                  labelStyle: TextStyle(color: Colors.white),

                                  fillColor: Colors.blueGrey,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Colors.green,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Colors.green,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                onChanged: (v) {}),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5, left: 20),
                        child: Text(
                          "INR " +  (cartItems[ind].dISHPRICE * cartItems[ind].dISHCOUNT)
                            .toStringAsFixed(2),
                          style: TextStyle(
                              fontFamily: 'Muli',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, left: 20, bottom: 0),
                    child: Text(
                      "INR " +
                          cartItems[ind].dISHPRICE.toStringAsFixed(2),
                      style: TextStyle(
                          fontFamily: 'Muli',
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, left: 20, bottom: 20),
                    child: Text(
                      cartItems[ind].cALORIES.toStringAsFixed(0) + " Calories",
                      style: TextStyle(
                          fontFamily: 'Muli',
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    //padding: EdgeInsets.only(left: 40, right: 20),
                    child: Divider(
                      color: Colors.black38,
                      thickness: .5,
                    ),
                  ),
                  ind < cartItems.length - 1
                      ? SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Amount",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "INR " + getGrandTotal(cartItems),
                              style: TextStyle(
                                fontSize: 23,
                                color: Colors.green[600],
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                ],
              )),
            ),
          ],
        )

        //  Text(appDetailsReport[ind].BK_PAT_NAME)

        );
  }

//  List<CartDeleteResults> cartDeleteResults;

  bool isloading = false;
  SharedPref sharedPref = SharedPref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .85,
              decoration: BoxDecoration(
                  color: Colors.green[900],
                  borderRadius: BorderRadius.all(Radius.circular(26))),
              child: FlatButton(
                onPressed: () {
                  flutterToast("Order successfully placed!");
                  getCategoriesWiseProducts();
                  Timer(Duration(seconds: 2), () {
                    // 5s over, navigate to a new page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CategoryWiseProducts(widget.user, tableMenuList)),
                    );
                  });
                },
                child: Text("Place Order",
                    style: TextStyle(color: Colors.white, fontSize: 17)),
              ),
            )
          ],
        ),
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.blueGrey,
              )),
          actions: [],
          backgroundColor: Colors.white,
          title: Text(
            'Order Summary',
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
        body: LoadingOverlay(
          color: Colors.white,
          opacity: .5,
          isLoading: isloading,
          progressIndicator:
              /* CircularProgressIndicator(
          semanticsLabel: "LoadingOverlay..",
        ),*/

              CircularProgressIndicator(
                  backgroundColor: Colors.deepPurple,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 5.0),
          child: Card(
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            elevation: 1.0,
            child: ListView(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.green[900],
                      //  color:   Color(0xffa13699),
                      /* border: Border.all(
                                width: 1.0,
                                color: Color(0xff3d1588),
                              ),*/
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                            5.0), //                 <--- border radius here
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.cartItems.length.toString() +
                            " Dishes - " +
                            getTotalItems(widget.cartItems) +
                            " Items",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                ),
                Container(
                    // height: MediaQuery.of(context).size.height,
                    child: Column(
                        children: List<Widget>.generate(widget.cartItems.length,
                            (ind) {
                  return getCards(widget.cartItems, ind, context);
                })))
              ],
            ),
          ),
        ));
  }

  String getTotalItems(List<CartItems> cartItems) {
    int totalItems = 0;
    for (int i = 0; i < cartItems.length; i++) {
      totalItems = totalItems + cartItems[i].dISHCOUNT;
    }
    return totalItems.toString();
  }

  String getGrandTotal(List<CartItems> cartItems) {
    double granTotal = 0;
    for (int i = 0; i < cartItems.length; i++) {
      granTotal = granTotal + (cartItems[i].dISHPRICE * cartItems[i].dISHCOUNT);
    }
    return granTotal.toStringAsFixed(2);
  }

  Restaurants restaurantsList = new Restaurants();

  int tableMenuListcount = 0;
  List<TableMenuList> tableMenuList =
      new List<TableMenuList>.empty(growable: true);

  Future<void> getCategoriesWiseProducts() async {
    try {
      setState(() {
        isloading = true;
      });
      String configuredIP = '';
      String empId = "";

      String url = getUrlOf("5dfccffc310000efc8d2c1ad");
      var res = await http
          .post(Uri.parse(url), headers: {"Content-Type": "application/json"});

      setState(() {
        setState(() {
          isloading = false;
        });

        List<dynamic> list = json.decode(res.body);
        restaurantsList = Restaurants.fromJson(list[0]);

        var tablemenulistrest = list[0]['table_menu_list'] as List;
        tableMenuList = tablemenulistrest
            .map<TableMenuList>((json) => TableMenuList.fromJson(json))
            .toList();

        print("tableMenuLists.length" + tableMenuList.length.toString());

        tableMenuListcount = tableMenuList.length;
      });
    } on SocketException catch (_) {
      setState(() {
        isloading = false;
        flutterToast("Server Error!" + "Please check Internet Connectivity");
      });
      print("Server Error!" + "Please check Internet Connectivity");
    }
  }
}
