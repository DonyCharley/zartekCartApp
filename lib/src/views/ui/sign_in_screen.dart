import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:zartech_cart_app/src/business_logic/models/CategoryProductListModel.dart';
import 'package:zartech_cart_app/src/business_logic/utils/authentication.dart';
import 'package:zartech_cart_app/src/business_logic/utils/constants.dart';
import 'package:zartech_cart_app/src/views/ui/verify_phone.dart';
import 'categoryWiseProducts.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}


class _SignInScreenState extends State<SignInScreen> {
  Restaurants restaurantsList;
  List <TableMenuList>tableMenuList=new List.empty(growable: true);
  bool isloading=false;

  @override
  void initState() {
    getCategoriesWiseProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,//CustomColors.firebaseNavy,
      body:
        LoadingOverlay(
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
    child:

      SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/images/firebase_logo.png',
                        height: 160,
                      ),
                    ),
                    SizedBox(height: 20),
                    SignInButtons(),
                  ],
                ),
              ),

            ],
          ),
        ),
      )),
    );
  }


  Future<void> getCategoriesWiseProducts() async {
    try {
      setState(() {
        isloading = true;
      });

      String url = getUrlOf("5dfccffc310000efc8d2c1ad");
      var res = await http
          .post(Uri.parse(url), headers: {"Content-Type": "application/json"});

      setState(() {
        setState(() {
          isloading = false;
        });

        List<dynamic> list = json.decode(res.body);
        restaurantsList = Restaurants.fromJson(list[0]);

        print(restaurantsList.restaurantName);

        var tablemenulistrest = list[0]['table_menu_list'] as List;

        tableMenuList = tablemenulistrest
            .map<TableMenuList>((json) => TableMenuList.fromJson(json))
            .toList();

     /*   print("tableMenuLists.length" + tableMenuList.length.toString());

        var categoryDishesrest =
        tablemenulistrest[0]['category_dishes'] as List;

        List<CategoryDishes> categoryDishes = categoryDishesrest
            .map<CategoryDishes>((json) => CategoryDishes.fromJson(json))
            .toList();

        var addonCatrest = categoryDishesrest[0]['addonCat'] as List;

        List<AddonCat> addonCat = addonCatrest
            .map<AddonCat>((json) => AddonCat.fromJson(json))
            .toList();*/

      });
    } on SocketException catch (_) {
      setState(() {
        isloading = false;
        flutterToast("Server Error!" + "Please check Internet Connectivity");
      });
      print("Server Error!" + "Please check Internet Connectivity");
    }
  }
  Widget SignInButtons() {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () async {


            User user =
            await Authentication.signInWithGoogle(context: context);


            if (user != null) {


              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => CategoryWiseProducts(user,tableMenuList ),
                ),
              );
            }

          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.blueAccent,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(top: 5, left: 5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white

                  ),
                  child: Center(
                    child: Image(
                      image: AssetImage("assets/images/google_logo.png"),
                      height: 25.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    ' Google',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.green[700],
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          onPressed: (){
            print("phone auth");
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(

                builder: (context) => MyLoginPage(
                ),
              ),
            );


          },
          child: Container(
            // color: Colors.green,
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //textDirection: TextDirection.rtl,

              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(top: 5, left: 5),

                  child: Center(
                      child: Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 35,
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    ' Phone',
                    //textAlign:TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}