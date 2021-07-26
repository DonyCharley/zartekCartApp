import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:zartech_cart_app/src/business_logic/models/CategoryProductListModel.dart';
import 'package:zartech_cart_app/src/business_logic/utils/constants.dart';
import 'categoryWiseProducts.dart';

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SmsAutoFill smsAutoFill = SmsAutoFill();
  String strVerificationId;
  final globalKey = GlobalKey<ScaffoldState>();
  TextEditingController phoneNumEditingController = TextEditingController();
  TextEditingController smsEditingController = TextEditingController();
  bool showVerifyNumberWidget = true;
  bool showVerificationCodeWidget = false;
  bool showSuccessWidget = false;

  @override
  void initState() {
    super.initState();
    getCurrentNumber();
  }

  getCurrentNumber() async {
    phoneNumEditingController.text = await smsAutoFill.hint;
  }

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.green[900],
          title: Text(
            'Phone number authentication',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        key: globalKey,
        resizeToAvoidBottomInset: false,
        body: LoadingOverlay(
            color: Colors.white,
            opacity: .25,
            isLoading: isloading,
            progressIndicator: CircularProgressIndicator(
              semanticsLabel: "LoadingOverlay..",
            ),
            child: Center(
              child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (showVerifyNumberWidget)
                        TextFormField(
                          controller: phoneNumEditingController,
                          decoration: const InputDecoration(
                              labelText: 'Enter Phone number'),
                          keyboardType: TextInputType.phone,
                        ),
                      SizedBox(
                        height: 25,
                      ),
                      if (showVerifyNumberWidget)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          alignment: Alignment.center,
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
                            color: Colors.green[900],
                            child: Text("Verify Number",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            onPressed: () async {
                              phoneNumberVerification();
                            },
                          ),
                        ),
                      if (showVerificationCodeWidget)
                        TextFormField(
                          controller: smsEditingController,
                          decoration: const InputDecoration(
                              labelText: 'Verification code'),
                        ),
                      SizedBox(
                        height: 25,
                      ),
                      if (showVerificationCodeWidget)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          alignment: Alignment.center,
                          child: RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
                              color: Colors.green[900],
                              onPressed: () async {

                                signInWithPhoneNumber();
                              },
                              child: Text("Sign in",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                        ),
                   /*   if (showSuccessWidget)
                        Text('You are successfully logged in!',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold))*/
                    ],
                  )),
            )));
  }

  Future<void> phoneNumberVerification() async {
    setState(() {
      isloading = true;
    });
    PhoneVerificationCompleted phoneVerificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await firebaseAuth.signInWithCredential(phoneAuthCredential);
      displayMessage(
          "Phone number is automatically verified and user signed in: ${firebaseAuth.currentUser.uid}");
      setState(() {
        isloading = false;
        showVerifyNumberWidget = false;
        showVerificationCodeWidget = false;
        showSuccessWidget = true;
      });
    };

    PhoneVerificationFailed phoneVerificationFailed =
        (FirebaseAuthException authException) {
      displayMessage(
          'Phone number verification is failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    PhoneCodeSent phoneCodeSent =
        (String verificationId, [int forceResendingToken]) async {
      displayMessage('Please check your phone for the verification code.');
      strVerificationId = verificationId;
      setState(() {
        isloading = false;
        showVerifyNumberWidget = false;
        showVerificationCodeWidget = true;
      });
    };

    PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout =
        (String verificationId) {
    //  displayMessage("verification code: " + verificationId);
      strVerificationId = verificationId;
      setState(() {
        isloading = false;
        showVerifyNumberWidget = false;
        showVerificationCodeWidget = true;
      });
    };

    try {
      await firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumEditingController.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: phoneVerificationCompleted,
          verificationFailed: phoneVerificationFailed,
          codeSent: phoneCodeSent,
          codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout);
    } catch (e) {
      setState(() {
        isloading = false;
      });
      displayMessage("Failed to Verify Phone Number: ${e}");
    }
  }

  void displayMessage(String message) {
    globalKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: strVerificationId,
        smsCode: smsEditingController.text,
      );

      final User user =
          (await firebaseAuth.signInWithCredential(credential)).user;

      displayMessage("Successfully signed in UID: ${user.uid}");

      getCategoriesWiseProducts(user);

      setState(() {
        isloading = false;
        showVerificationCodeWidget = false;
        showSuccessWidget = true;
      });
    } catch (e) {
      setState(() {
        isloading = false;
      });
      displayMessage("Failed to sign in: " + e.toString());
    }
  }

  Restaurants restaurantsList;
  List<TableMenuList> tableMenuList = new List.empty(growable: true);

  Future<void> getCategoriesWiseProducts(User user) async {
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

        print(restaurantsList.restaurantName);

        var tablemenulistrest = list[0]['table_menu_list'] as List;

        tableMenuList = tablemenulistrest
            .map<TableMenuList>((json) => TableMenuList.fromJson(json))
            .toList();

        print("tableMenuLists.length" + tableMenuList.length.toString());

        var categoryDishesrest =
            tablemenulistrest[0]['category_dishes'] as List;

        List<CategoryDishes> categoryDishes = categoryDishesrest
            .map<CategoryDishes>((json) => CategoryDishes.fromJson(json))
            .toList();

        var addonCatrest = categoryDishesrest[0]['addonCat'] as List;

        List<AddonCat> addonCat = addonCatrest
            .map<AddonCat>((json) => AddonCat.fromJson(json))
            .toList();
        setState(() {
          isloading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryWiseProducts(user, tableMenuList)),
        );
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
