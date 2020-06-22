import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/address/actions/address_actions.dart';
import 'package:esamudaayapp/modules/address/models/addess_models.dart';
import 'package:esamudaayapp/modules/register/action/register_Action.dart';
import 'package:esamudaayapp/modules/register/model/register_request_model.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/custom_widgets.dart';
import 'package:esamudaayapp/utilities/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  String latitude, longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
          onInit: (store) {
//                store.dispatch(GetLocationAction());
//                store.dispatch(GetCartFromLocal());
          },
          model: _ViewModel(),
          builder: (context, snapshot) {
            return WillPopScope(
              onWillPop: () async {
                return Future.value(
                    false); //return a `Future` with false value so this route cant be popped or closed.
              },
              child: ModalProgressHUD(
                inAsyncCall: snapshot.loadingStatus == LoadingStatus.loading,
                child: Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    brightness: Brightness.light,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 100,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: Hero(
                              tag: '#text',
                              child: Material(
                                type: MaterialType.transparency,
                                child: Text('screen_register.title',
                                        style: const TextStyle(
                                            color: const Color(0xff797979),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Avenir",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 18.0),
                                        textAlign: TextAlign.left)
                                    .tr(),
                              ),
                            ),
                          ),
                          //name
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextInputBG(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextFormField(
                                          validator: (value) {
                                            if (value.length == 0) return null;
                                            if (value.length < 3) {
                                              return tr(
                                                  'screen_register.name.empty_error');
                                              return null;
                                            }
                                            return null;
                                          },
                                          autovalidate: true,
                                          controller: nameController,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            hintText: tr(
                                                'screen_register.name.title'),
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          style: const TextStyle(
                                              color: const Color(0xff1a1a1a),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Avenir",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 13.0),
                                          textAlign: TextAlign.center),
                                    ),
                                    Icon(
                                      Icons.account_circle,
                                      color: Colors.blueAccent,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          //address
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextInputBG(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextFormField(
                                          maxLines: null,
                                          // enableInteractiveSelection: false,
                                          validator: (value) {
                                            if (value.isEmpty) return null;
//                                          if (value.length < 10) {
//                                            return tr(
//                                                'screen_register.address.empty_error');
//                                            return null;
//                                          }
                                            return null;
                                          },
                                          autovalidate: true,
                                          controller: addressController,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            hintText: tr(
                                                'screen_register.address.title'),
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          style: const TextStyle(
                                              color: const Color(0xff1a1a1a),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Avenir",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 13.0),
                                          textAlign: TextAlign.center),
                                    ),
                                    Material(
                                      type: MaterialType.transparency,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PlacePicker(
                                                apiKey: Keys
                                                    .googleAPIkey, // Put YOUR OWN KEY here.
                                                onPlacePicked: (result) {
                                                  // Handle the result in your way
                                                  print(
                                                      result?.formattedAddress);
                                                  // print(result?.a);
                                                  if (result
                                                          ?.formattedAddress !=
                                                      null) {
                                                    addressController.text =
                                                        result
                                                            ?.formattedAddress;
                                                  }
//                                                if (result?.postalCode !=
//                                                    null) {
//                                                  pinCodeController.text =
//                                                      result?.postalCode;
//                                                }
                                                  latitude = result
                                                      .geometry.location.lat
                                                      .toString();
                                                  longitude = result
                                                      .geometry.location.lng
                                                      .toString();
                                                  print(result.adrAddress);
                                                  Navigator.of(context).pop();
                                                },
//                                              initialPosition: HomePage.kInitialPosition,
                                                useCurrentLocation: true,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.add_location,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          //pin code
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 40),
                            child: TextInputBG(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextFormField(
                                          validator: (value) {
                                            if (value.length == 0) return null;

                                            if (value.isEmpty
//                                                ||
//                                                !pinCodeController.text
//                                                    .contains(new RegExp(
//                                                        r'^[1-9][0-9]{5}$'))
                                                ) {
                                              return tr(
                                                  'screen_register.pin_code.title');
                                              return null;
                                            }
                                            return null;
                                          },
                                          autovalidate: true,
                                          controller: pinCodeController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: tr(
                                                'screen_register.pin_code.title'),
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          style: const TextStyle(
                                              color: const Color(0xff1a1a1a),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Avenir",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 13.0),
                                          textAlign: TextAlign.center),
                                    ),
                                    Icon(
                                      Icons.local_post_office,
                                      color: Colors.blueAccent,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          //location
                          //Register_but
                          // Rectangle 10
                          Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              onTap: () {
                                if (nameController.text.isNotEmpty &&
                                    addressController.text.isNotEmpty &&
                                    pinCodeController.text.isNotEmpty) {
                                  if ((nameController.text.length < 3 ||
                                      !nameController.text
                                          .contains(new RegExp(r'[a-z]')))) {
                                    Fluttertoast.showToast(
                                        msg: tr(
                                            'screen_register.name.empty_error'));
                                  } else if (pinCodeController.text.isEmpty
//                                      ||
//                                      !pinCodeController.text
//                                          .contains(new RegExp(r'^\d{6}$'))

                                      ) {
                                    Fluttertoast.showToast(
                                        msg: tr(
                                            'screen_register.pin_code.title'));
                                  } else {
                                    snapshot.updateCustomerDetails(
                                        CustomerDetailsRequest(
                                            profileName: nameController.text,
                                            clusterCode: pinCodeController.text,
                                            role: "AGENT"));
                                    snapshot.addAddress(Address(
                                      addressName: nameController.text,
                                      lat: double.parse(latitude),
                                      lon: double.parse(longitude),
                                      prettyAddress: addressController.text,
                                    ));
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "all fields required");
                                }
                              },
                              child: Hero(
                                tag: '#getOtp',
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      height: 60,
                                      child: Stack(children: [
                                        // Rectangle 10
                                        PositionedDirectional(
                                          top: 0,
                                          start: 0,
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2,
                                              height: 52,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(100)),
                                                  gradient: LinearGradient(
                                                      begin: Alignment(
                                                          0.023085936903953545,
                                                          0.5),
                                                      end: Alignment(
                                                          0.980859398841858,
                                                          0.5),
                                                      colors: [
                                                        const Color(0xff00dab2),
                                                        const Color(0xff3a90d3),
                                                        const Color(0xff3a90d3)
                                                      ]))),
                                        ),
                                        // Get OTP
                                        PositionedDirectional(
                                          top: 16.000030517578125,
                                          start: 0,
                                          child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2,
                                              height: 22,
                                              child: Text(
                                                      'screen_register.register',
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xffffffff),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Avenir",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 16.0),
                                                      textAlign:
                                                          TextAlign.center)
                                                  .tr()),
                                        )
                                      ])),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void dispose() {
    nameController.dispose();
    addressController.dispose();
    pinCodeController.dispose();
    super.dispose();
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  LoadingStatus loadingStatus;
  Function(CustomerDetailsRequest request) updateCustomerDetails;
  Function(Address) addAddress;
  Function navigateToHomePage;
  String phoneNumber;
  _ViewModel.build(
      {this.navigateToHomePage,
      this.updateCustomerDetails,
      this.addAddress,
      this.loadingStatus,
      this.phoneNumber})
      : super(equals: [loadingStatus, phoneNumber]);

  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        loadingStatus: state.authState.loadingStatus,
        phoneNumber: state.authState.getOtpRequest.phone,
        navigateToHomePage: () {
          dispatch(NavigateAction.pushNamed('/myHomeView'));
        },
        addAddress: (address) {
          dispatch(AddAddressAction(request: address));
        },
        updateCustomerDetails: (request) {
          dispatch(AddUserDetailAction(request: request));
        });
  }
}
