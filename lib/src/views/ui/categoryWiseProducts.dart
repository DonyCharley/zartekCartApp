import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:zartech_cart_app/src/business_logic/models/CartItemsModel.dart';
import 'package:zartech_cart_app/src/business_logic/models/CategoryProductListModel.dart';
import 'package:zartech_cart_app/src/business_logic/models/ItemCartModel.dart';
import 'package:zartech_cart_app/src/business_logic/utils/authentication.dart';
import 'package:zartech_cart_app/src/views/ui/CartItems.dart';
import 'package:zartech_cart_app/src/views/ui/sign_in_screen.dart';

class CategoryWiseProducts extends StatefulWidget {
  List<TableMenuList> tableMenuLists;
  User user;

  CategoryWiseProducts(User user, List<TableMenuList> tableMenuLists) {
    this.tableMenuLists = tableMenuLists;
    this.user = user;
  }

  @override
  _CategoryWiseProductsState createState() =>
      _CategoryWiseProductsState(tableMenuLists, user);
}

class _CategoryWiseProductsState extends State<CategoryWiseProducts>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int tabIndex;
  List<CartItems> cartItems = new List.empty(growable: true);
  List<TableMenuList> tableMenuList =
      new List<TableMenuList>.empty(growable: true);
  User user;

  _CategoryWiseProductsState(List<TableMenuList> tableMenuLists, User user) {
    this.tableMenuList = tableMenuLists;
    this.user = user;
  }

  bool isloading = false;
  int cartIemCount = 0;

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: tableMenuList.length,
      vsync: this,
    );

    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController categorySearch = new TextEditingController();
  TextEditingController productSearch = new TextEditingController();
  List<CartItemList> cartItemList =
      new List<CartItemList>.empty(growable: true);
  List<TextEditingController> qty =
      new List<TextEditingController>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer(),
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1.0,
        leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.blueGrey,
            ),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }),
        backgroundColor: Colors.white,
        actions: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
                height: 150.0,
                width: 30.0,
                child: new GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CartItemsList(cartItems, user)));
                  },
                  child: new Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        right: 5,
                        top: 0,
                        child: new IconButton(
                          icon: new Icon(
                            Icons.shopping_cart,
                            color: Colors.blueGrey,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CartItemsList(cartItems, user)));
                          },
                        ),
                      ),
                      cartItems.length == 0
                          ? new Container()
                          : new Positioned(
                              right: 10,
                              top: 10,
                              child: new Stack(
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  new Icon(Icons.brightness_1,
                                      size: 20.0, color: Colors.red),
                                  new Positioned(
                                      top: 3.0,
                                      right: 6.0,
                                      child: new Center(
                                        child: new Text(
                                          cartItems.length.toString(),
                                          style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )),
                                ],
                              )),
                    ],
                  ),
                )),
          )
        ],
        bottom: TabBar(
          indicatorColor: Colors.red,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          controller: _tabController,
          isScrollable: true,
          tabs: List<Widget>.generate(tableMenuList.length, (int index) {
            return new Tab(
                child: Text(tableMenuList[index].menuCategory,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                        color: Colors.red)));
          }),
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: List<Widget>.generate(tableMenuList.length, (int index) {
            return getCategoryPage(tableMenuList[index],
                index); //new Text(tableMenuList[index].menuCategory);
          })),
    );
  }

  Future<bool> onWillPop() {}

  Widget drawer() {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.green[600],
                      Colors.green[300],
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),

                // border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Column(
              children: [
                widget.user.photoURL != null
                    ? Container(
                        width: 80.0,
                        height: 80.0,
                        //padding: EdgeInsets.all(50),
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.transparent,
                                width: 2.0,
                                style: BorderStyle.solid),
                            image: new DecorationImage(
                                fit: BoxFit.scaleDown,
                                image: NetworkImage(widget.user.photoURL))),
                        // child:
                      )
                    : Container(
                        width: 80.0,
                        height: 80.0,
                        //padding: EdgeInsets.all(50),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.transparent,
                              width: 2.0,
                              style: BorderStyle.solid),
                          /* image: new DecorationImage(
                          fit: BoxFit.scaleDown, image: ())*/
                        ),
                        child: Icon(Icons.account_circle)),
                Text(
                  widget.user.displayName == null
                      ? ""
                      : widget.user.displayName,
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "ID: "+widget.user.uid,
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.logout,
                ),
                SizedBox(
                  width: 20,
                ),
                Text("Log out"),
              ],
            ),
            onTap: () async {
              setState(() {
                isloading = true;
              });
              await Authentication.signOut(context: context);
              setState(() {
                isloading = false;
              });
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SignInScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget getCategoryPage(TableMenuList tableMenuList, int index) {
    List<CategoryDishes> categoryDishes = tableMenuList.categoryDishes;

    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(bottom: 20, top: 5, left: 0, right: 0),
            itemCount: categoryDishes.length,
            itemBuilder: (BuildContext context1, int index) {
              TextEditingController productController =
                  new TextEditingController(
                      text: categoryDishes[index].dishQuantity.toString());
              return Card(
                  elevation: 1.0,
                  child: new Container(
                      height: 250,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Stack(
                        overflow: Overflow.visible,
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                                width: MediaQuery.of(context).size.width,

                                // height: 300,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 25,
                                              width: 25,
                                              margin: EdgeInsets.only(
                                                  top: 10, left: 5),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomLeft,
                                                    colors: [
                                                      Colors.white,
                                                      Colors.white70
                                                    ],
                                                  )),
                                              child: Image(
                                                image: categoryDishes[index]
                                                            .dishType ==
                                                        2
                                                    ? AssetImage(
                                                        'assets/images/veg.png')
                                                    : AssetImage(
                                                        'assets/images/non_veg.png'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .6,
                                              padding: EdgeInsets.only(
                                                top: 5,
                                                left: 20,
                                              ),
                                              child: Text(
                                                categoryDishes[index].dishName,
                                                style: TextStyle(
                                                    fontFamily: 'Muli',
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .6,
                                              padding: EdgeInsets.only(
                                                top: 5,
                                                left: 20,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Rs." +
                                                        categoryDishes[index]
                                                            .dishPrice
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Muli',
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                  Text(
                                                    categoryDishes[index]
                                                            .dishCalories
                                                            .toStringAsFixed(
                                                                0) +
                                                        " Calories",
                                                    style: TextStyle(
                                                        fontFamily: 'Muli',
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .60,
                                              padding: EdgeInsets.only(
                                                top: 5,
                                                left: 20,
                                              ),
                                              child: ReadMoreText(
                                                categoryDishes[index]
                                                    .dishDescription,
                                                //trimLines: 1,
                                                trimLines: 5,
                                                colorClickableText: Colors.pink,
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText:
                                                    '..Read More',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black38),
                                                trimExpandedText: ' Less',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 10, left: 10, right: 10),
                                              decoration: BoxDecoration(
                                              //  color: Colors.green[900],
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      5.0), //                 <--- border radius here
                                                ),
                                              ),
                                              height: 70,
                                              width: 70,
                                              child:  FadeInImage.assetNetwork(
                                placeholder: 'assets/images/no_image.png',
                                image:categoryDishes[index].dishImage
                            ) /*Image.network(
                                                categoryDishes[index].dishImage,
                                              ),*/
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 150,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            border: Border.all(
                                              color: Colors.green,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),

                                          child: new TextFormField(
                                              controller: productController,
                                              readOnly: true,
                                              textAlign: TextAlign.center,
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(
                                                  fontFamily: 'Muli',
                                                  color: Colors.white),
                                              cursorColor: Colors.white,
                                              // controller: categorySearch,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 0),
                                                // hintText: productfilteredLists[ind].qty.toString(),

                                                prefixIcon: IconButton(
                                                    icon: new Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: categoryDishes[
                                                                    index]
                                                                .dishQuantity >
                                                            0
                                                        ? () {
                                                            this.setState(() =>
                                                                categoryDishes[
                                                                        index]
                                                                    .dishQuantity--);
                                                            productController =
                                                                new TextEditingController(
                                                                    text: categoryDishes[
                                                                            index]
                                                                        .dishQuantity
                                                                        .toString());
                                                            productController
                                                                    .selection =
                                                                TextSelection.fromPosition(
                                                                    TextPosition(
                                                                        offset: productController
                                                                            .text
                                                                            .length));

                                                            if (categoryDishes[
                                                                        index]
                                                                    .dishQuantity !=
                                                                0) {
                                                              int pos = getListPositionofDishInCartList(
                                                                  categoryDishes[
                                                                          index]
                                                                      .dishId);
                                                              cartItems
                                                                  .removeAt(
                                                                      pos);

                                                              cartItems.insert(
                                                                  pos,
                                                                  new CartItems(
                                                                      dISHID: categoryDishes[
                                                                              index]
                                                                          .dishId,
                                                                      dISHCOUNT:
                                                                          categoryDishes[index]
                                                                              .dishQuantity,
                                                                      dISHPRICE:
                                                                          categoryDishes[index]
                                                                              .dishPrice,
                                                                      dISHNAME:
                                                                          categoryDishes[index]
                                                                              .dishName,
                                                                      iTEMTYPE:
                                                                          categoryDishes[index]
                                                                              .dishType,
                                                                      cALORIES:
                                                                          categoryDishes[index]
                                                                              .dishCalories));
                                                            } else {
                                                              int pos = getListPositionofDishInCartList(
                                                                  categoryDishes[
                                                                          index]
                                                                      .dishId);
                                                              cartItems
                                                                  .removeAt(
                                                                      pos);
                                                            }
                                                          }
                                                        : null),
                                                suffixIcon: IconButton(
                                                    icon: new Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      this.setState(() =>
                                                          categoryDishes[index]
                                                              .dishQuantity++);
                                                      productController =
                                                          new TextEditingController(
                                                              text: categoryDishes[
                                                                      index]
                                                                  .dishQuantity
                                                                  .toString());
                                                      productController
                                                              .selection =
                                                          TextSelection.fromPosition(
                                                              TextPosition(
                                                                  offset: productController
                                                                      .text
                                                                      .length));

                                                      bool b = checkDishInCart(
                                                          categoryDishes[index]
                                                              .dishId);

                                                      if (b == true) {
                                                        int pos =
                                                            getListPositionofDishInCartList(
                                                                categoryDishes[
                                                                        index]
                                                                    .dishId);
                                                        cartItems.removeAt(pos);
                                                        cartItems.insert(
                                                            pos,
                                                            new CartItems(
                                                                dISHID:
                                                                    categoryDishes[
                                                                            index]
                                                                        .dishId,
                                                                dISHCOUNT:
                                                                    categoryDishes[
                                                                            index]
                                                                        .dishQuantity,
                                                                dISHPRICE:
                                                                    categoryDishes[
                                                                            index]
                                                                        .dishPrice,
                                                                dISHNAME:
                                                                    categoryDishes[
                                                                            index]
                                                                        .dishName,
                                                                iTEMTYPE:
                                                                    categoryDishes[
                                                                            index]
                                                                        .dishType,
                                                                cALORIES: categoryDishes[
                                                                        index]
                                                                    .dishCalories));
                                                      } else {
                                                        cartItems.add(new CartItems(
                                                            dISHID:
                                                                categoryDishes[
                                                                        index]
                                                                    .dishId,
                                                            dISHCOUNT:
                                                                categoryDishes[
                                                                        index]
                                                                    .dishQuantity,
                                                            dISHPRICE:
                                                                categoryDishes[
                                                                        index]
                                                                    .dishPrice,
                                                            dISHNAME:
                                                                categoryDishes[
                                                                        index]
                                                                    .dishName,
                                                            iTEMTYPE:
                                                                categoryDishes[
                                                                        index]
                                                                    .dishType,
                                                            cALORIES:
                                                                categoryDishes[
                                                                        index]
                                                                    .dishCalories));
                                                      }
                                                    }),

                                                //  labelText: searchfieldText,
                                                labelStyle: TextStyle(
                                                    color: Colors.white),

                                                fillColor: Colors.blueGrey,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  borderSide: BorderSide(
                                                    color: Colors.green,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
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
                                    categoryDishes[index].addonCat.length > 0
                                        ? Container(
                                            padding: EdgeInsets.all(20),
                                            child: Text(
                                              "Customizations Available",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        : SizedBox(
                                            height: 2,
                                          ),
                                  ],
                                )),
                          ),

                        ],
                      )


                      //)
                      ));
            }));
  }

  bool checkDishInCart(String dishId) {
    print(cartItems.length);

    for (int i = 0; i < cartItems.length; i++) {
      if (cartItems[i].dISHID == dishId) {
        return true;
      }
    }

    return false;
  }

  int getListPositionofDishInCartList(String dishId) {
    for (int i = 0; i < cartItems.length; i++) {
      if (cartItems[i].dISHID == dishId) {
        return i;
      }
    }
  }

}
