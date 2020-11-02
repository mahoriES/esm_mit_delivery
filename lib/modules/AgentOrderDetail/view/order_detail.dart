import 'dart:io';

import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/AgentHome/action/AgentAction.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/action/order_action.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/transit_models.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/view/image_view.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/store.dart';
import 'package:esamudaayapp/utilities/colors.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreen extends StatefulWidget {
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  File _startImage;
  File _endImage;

  final picker = ImagePicker();
  bool progress = false;
  String convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);

    return formatDate(
        todayDate, [dd, ' ', M, ' ', yyyy, ' ', hh, ':', nn, ' ', am]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.icColors,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                }),
          ),
          body: StoreConnector<AppState, _ViewModel>(
              model: _ViewModel(),
              onInit: (store) async {
                // orderProgressfordelete();
                // await UserManager.saveOrderProgressStatus(status: false);
                // var orderProgress = await UserManager.getOrderProgressStatus();
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {
                    progress = store.state.homePageState.selectedOrder.status ==
                            "PICKED"
                        ? true
                        : false;
                  });
                });
                // getOrderId();
                if (store.state.homePageState.selectedOrder.requestId != null) {
                  store.dispatch(GetOrderDetailsAction());
                } else {
                  store.dispatch(GetTransitDetailsAction());
                }
              },
              builder: (context, snapshot) {
                return snapshot.loadingStatus == LoadingStatus.loading
                    ? Container(
                        child: Center(
                          child: Image.asset(
                            'assets/images/indicator.gif',
                            height: 75,
                            width: 75,
                          ),
                        ),
                      )
                    : Column(
                        children: <Widget>[
                          Flexible(
                            child: ListView(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                        color: const Color(0x29000000),
                                        offset: Offset(0, 3),
                                        blurRadius: 6,
                                        spreadRadius: 0)
                                  ], color: const Color(0xffffffff)),
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      buildStatusIcon(snapshot),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '${tr("screen_home.Order_ID")} ${snapshot.selectedOrder.order.orderShortNumber},',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontFamily: 'Avenir',
                                              ),
                                            ),
                                            Text(
                                              convertDateFromString(snapshot
                                                  .selectedOrder.order.created),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'Avenir',
                                              ),
                                            ),
                                            snapshot.selectedOrder.order
                                                            .orderStatus ==
                                                        "COMPLETED" &&
                                                    snapshot.selectedOrder
                                                            .status ==
                                                        "ACCEPTED"
                                                ? RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: tr(
                                                              "screen_home.Completed"),
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff505050),
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Avenir',
                                                            fontWeight:
                                                                FontWeight.w900,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: convertDateFromString(
                                                              snapshot
                                                                  .selectedOrder
                                                                  .order
                                                                  .created),
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff959595),
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'CircularStd-Book',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(),
                                            snapshot.selectedOrder.order
                                                            .orderStatus ==
                                                        "COMPLETED" &&
                                                    snapshot.selectedOrder
                                                            .status ==
                                                        "ACCEPTED"
                                                ? RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              '${tr('screen_home.Distance')} ',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff505050),
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Avenir',
                                                            fontWeight:
                                                                FontWeight.w900,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: ': 2 km',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff959595),
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'CircularStd-Book',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            'Rs.${snapshot.selectedOrder.order.orderTotal}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: 'Avenir',
                                            ),
                                          ),
                                          Text(
                                            snapshot.selectedOrder.order
                                                        .orderItems !=
                                                    null
                                                ? snapshot.selectedOrder.order
                                                        .orderItems.length
                                                        .toString() +
                                                    " item"
                                                : "0" + " item",
                                            style: TextStyle(
                                              color: Color(0xff9d9797),
                                              fontFamily: 'Avenir',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          snapshot
                                              .selectedOrder.order.customerName,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Avenir',
                                          ),
                                        ),
                                      ),
                                      FloatingActionButton(
                                        heroTag: null,
                                        onPressed: () {
                                          // Add your onPressed code here!
                                        },
                                        child: Image.asset(
                                            'assets/images/person.png'),
                                        backgroundColor:
                                            const Color(0xffb9b8b8),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          snapshot.selectedOrder.order
                                              .deliveryAddress.prettyAddress,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Avenir',
                                          ),
                                        ),
                                      ),
                                      FloatingActionButton(
                                        heroTag: null,
                                        onPressed: () {
                                          var location = snapshot
                                              .selectedOrder
                                              .order
                                              .deliveryAddress
                                              .locationPoint;
                                          _launchMaps(location.lat.toString(),
                                              location.lon.toString());
                                          // Add your onPressed code here!
//                                          openMapsSheet(context, snapshot);
                                        },
                                        child: Image.asset(
                                            'assets/images/naviagtion.png'),
                                        backgroundColor: AppColors.icColors,
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          snapshot.selectedOrder.order
                                              .customerPhones.first,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Avenir',
                                          ),
                                        ),
                                      ),
                                      FloatingActionButton(
                                        heroTag: null,
                                        onPressed: () {
                                          _makePhoneCall(
                                              mobile:
                                                  "tel:${snapshot.selectedOrder.order.customerPhones.first}");
                                          // Add your onPressed code here!
                                        },
                                        child: Image.asset(
                                            'assets/images/phone.png'),
                                        backgroundColor: AppColors.icColors,
                                      )
                                    ],
                                  ),
                                ),

                                // snapshot.selectedOrder.pickupImages != null
                                //     ? Padding(
                                //         padding: const EdgeInsets.all(20.0),
                                //         child: Row(
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.spaceBetween,
                                //           children: <Widget>[
                                //             snapshot.selectedOrder.pickupImages
                                //                             .length >
                                //                         0 ||
                                //                     _startImage != null
                                //                 ? InkWell(
                                //                     onTap: () {
                                //                       Navigator.push(
                                //                         context,
                                //                         MaterialPageRoute(
                                //                             builder: (context) =>
                                //                                 ImageDisplay(
                                //                                   image: _startImage !=
                                //                                           null
                                //                                       ? _startImage
                                //                                       : null,
                                //                                   imageUrl: _startImage ==
                                //                                           null
                                //                                       ? snapshot
                                //                                           .selectedOrder
                                //                                           .pickupImages
                                //                                           .first
                                //                                           .photoUrl
                                //                                       : "",
                                //                                 )),
                                //                       );
                                //                     },
                                //                     child: Container(
                                //                       child: Row(
                                //                         children: <Widget>[
                                //                           Column(
                                //                             children: <Widget>[
                                //                               Padding(
                                //                                 padding:
                                //                                     const EdgeInsets
                                //                                             .all(
                                //                                         8.0),
                                //                                 child: Text(
                                //                                     'Start Picture'),
                                //                               ),
                                //                               _startImage !=
                                //                                       null
                                //                                   ? Image.file(
                                //                                       _startImage,
                                //                                       width:
                                //                                           100,
                                //                                       height:
                                //                                           100,
                                //                                       fit: BoxFit
                                //                                           .cover,
                                //                                     )
                                //                                   : Image
                                //                                       .network(
                                //                                       snapshot
                                //                                           .selectedOrder
                                //                                           .pickupImages
                                //                                           .first
                                //                                           .photoUrl,
                                //                                       width:
                                //                                           100,
                                //                                       height:
                                //                                           100,
                                //                                       fit: BoxFit
                                //                                           .cover,
                                //                                     )
                                //                             ],
                                //                           )
                                //                         ],
                                //                       ),
                                //                     ),
                                //                   )
                                //                 : Container(),
                                //             snapshot.selectedOrder.dropImages !=
                                //                             null &&
                                //                         snapshot
                                //                                 .selectedOrder
                                //                                 .dropImages
                                //                                 .length >
                                //                             0 ||
                                //                     _endImage != null
                                //                 ? InkWell(
                                //                     onTap: () {
                                //                       Navigator.push(
                                //                         context,
                                //                         MaterialPageRoute(
                                //                             builder: (context) =>
                                //                                 ImageDisplay(
                                //                                   image: _endImage !=
                                //                                           null
                                //                                       ? _endImage
                                //                                       : null,
                                //                                   imageUrl: _endImage ==
                                //                                           null
                                //                                       ? snapshot
                                //                                           .selectedOrder
                                //                                           .dropImages
                                //                                           .first
                                //                                           .photoUrl
                                //                                       : "",
                                //                                 )),
                                //                       );
                                //                     },
                                //                     child: Container(
                                //                       child: Row(
                                //                         children: <Widget>[
                                //                           Column(
                                //                             children: <Widget>[
                                //                               Padding(
                                //                                 padding:
                                //                                     const EdgeInsets
                                //                                             .all(
                                //                                         8.0),
                                //                                 child: Text(
                                //                                     'End Picture'),
                                //                               ),
                                //                               _endImage != null
                                //                                   ? Image.file(
                                //                                       _endImage,
                                //                                       width:
                                //                                           100,
                                //                                       height:
                                //                                           100,
                                //                                       fit: BoxFit
                                //                                           .cover,
                                //                                     )
                                //                                   : Image
                                //                                       .network(
                                //                                       snapshot
                                //                                           .selectedOrder
                                //                                           .dropImages
                                //                                           .first
                                //                                           .photoUrl,
                                //                                       width:
                                //                                           100,
                                //                                       height:
                                //                                           100,
                                //                                       fit: BoxFit
                                //                                           .cover,
                                //                                     )
                                //                             ],
                                //                           )
                                //                         ],
                                //                       ),
                                //                     ),
                                //                   )
                                //                 : Container(),
                                //           ],
                                //         ),
                                //       )
                                //     : Container(),

                                ImageUploadWidget(snapshot.selectedOrder),

                                SizedBox(height: 20),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: Image.asset(
                                          'assets/images/path.png',
                                          color: AppColors.icColors,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          tr("screen_home.Ordered_Products"),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontFamily: 'Avenir',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ), // Rectangle 4
                                Container(
                                    margin:
                                        EdgeInsets.only(bottom: 20, top: 20),
                                    child: Column(
                                      children: orderItemsBuilder(snapshot),
                                    ),
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: const Color(0x29000000),
                                          offset: Offset(0, 3),
                                          blurRadius: 6,
                                          spreadRadius: 0)
                                    ], color: const Color(0xffffffff))),
                              ],
                            ),
                          ),
                          // snapshot.selectedOrder.status == "PENDING"
                          //     ? Padding(
                          //         padding: const EdgeInsets.all(20.0),
                          //         child: Container(
                          //           child: Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Padding(
                          //                 padding: const EdgeInsets.only(
                          //                     right: 10.0),
                          //                 child: Image.asset(
                          //                     'assets/images/exclamation_cr.png'),
                          //               ),
                          //               Flexible(
                          //                 child: Text(
                          //                   'Take the product picture before you start',
                          //                   style: TextStyle(
                          //                     color: Colors.black,
                          //                     fontFamily: 'Avenir',
                          //                     fontWeight: FontWeight.w500,
                          //                   ),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       )
                          //     : Container(),
                          snapshot.selectedOrder.status == "PENDING" ||
                                  snapshot.selectedOrder.status == "PICKED"
                              ? InkWell(
                                  onTap: () async {
                                    if (progress &&
                                        snapshot.selectedOrder.status ==
                                            "PENDING") return;

                                    bool isPickup =
                                        snapshot.selectedOrder.status ==
                                                "PICKED"
                                            ? false
                                            : true;
                                    if (isPickup)
                                      snapshot.acceptOrder();
                                    else
                                      snapshot.dropOrder();
                                    // if (snapshot.locationDetails != null) {
                                    //   imageSelectorCamera(snapshot);
                                    // } else {
                                    //   store
                                    //       .dispatchFuture(GetLocationAction())
                                    //       .whenComplete(() {
                                    //     if (snapshot.locationDetails != null) {
                                    //       imageSelectorCamera(snapshot);
                                    //     }
                                    //   });
                                    // }
                                  },
                                  child: new Container(
                                    height: 65,
                                    decoration: new BoxDecoration(
                                        gradient: LinearGradient(
                                      colors: !progress
                                          ? [
                                              const Color(0xff5f3a9f),
                                              const Color(0xff5f3a9f),
                                              const Color(0xff5f3a9f)
                                            ]
                                          : snapshot.selectedOrder.status ==
                                                  "PICKED"
                                              ? [
                                                  const Color(0xff5f3a9f),
                                                  const Color(0xff5f3a9f),
                                                  const Color(0xff5f3a9f)
                                                ]
                                              : [
                                                  const Color(0xffa7a7a7),
                                                  const Color(0xffa7a7a7),
                                                  const Color(0xffa7a7a7)
                                                ],

                                      begin: Alignment(1.00, -0.00),
                                      end: Alignment(-1.00, 0.00),
                                      // angle: 270,
                                      // scale: undefined,
                                    )),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Spacer(),
                                        new Text(
                                            snapshot.selectedOrder.status ==
                                                    "PENDING"
                                                ? tr("screen_home.Start")
                                                : tr("screen_home.End"),
                                            style: TextStyle(
                                              fontFamily: 'Avenir',
                                              color: Color(0xffffffff),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                            )),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      );
              })),
    );
  }

//  Future<String> getOrderId() async {
//    setState(() async {
//      savedOrderId = await UserManager.getCurrentOrderId();
//    });
//  }

  // Future orderProgressfordelete() async {
  //   await UserManager.saveOrderProgressStatus(status: true);
  // }

  List<Widget> orderItemsBuilder(_ViewModel snapshot) {
    List<Widget> builder = List.generate(
        snapshot.selectedOrder.order.orderItems != null
            ? snapshot.selectedOrder.order.orderItems.length
            : 0, (index) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              child: CachedNetworkImage(
                imageUrl:
                    snapshot.selectedOrder.order.orderItems[index].images !=
                            null
                        ? snapshot.selectedOrder.order.orderItems[index].images
                                    .length >
                                0
                            ? snapshot.selectedOrder.order.orderItems[index]
                                .images.first.photoUrl
                            : ""
                        : "",
              ),
            ),
            Flexible(
              child: Text(
                  snapshot.selectedOrder.order.orderItems[index].productName,
                  style: const TextStyle(
                      color: const Color(0xff515c6f),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Avenir",
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0),
                  textAlign: TextAlign.left),
            ),
            Text(
                snapshot.selectedOrder.order.orderItems[index].variationOption
                            .size !=
                        null
                    ? snapshot.selectedOrder.order.orderItems[index]
                        .variationOption.size
                    : "" +
                        " x " +
                        snapshot.selectedOrder.order.orderItems[index].quantity
                            .toString(),
                style: TextStyle(
                  fontFamily: 'Avenir',
                  color: Color(0xff626262),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                )),
          ],
        ),
      );
    });
    builder.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Spacer(),
        Text(tr("screen_home.Total_Cost"),
            style: TextStyle(
              fontFamily: 'Avenir',
              color: Color(0xff000000),
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            )),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('₹ ${snapshot.selectedOrder.order.orderTotal}',
              style: TextStyle(
                fontFamily: 'Avenir',
                color: Color(0xff000000),
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              )),
        )
      ],
    ));
    return builder;

//    return <Widget>[
//      Container(
//        height: 40,
//        child: Row(
//          children: <Widget>[
//            Image.asset('assets/images/path.png'),
//            Text(
//              'Faux Sued Ankle Mango',
//              style: TextStyle(
//                color: Color(0xff515c6f),
//                fontSize: 15,
//                fontFamily: 'Avenir',
//                fontWeight: FontWeight.w500,
//              ),
//            ),
//            Text(
//              '500 gm x 5',
//              style: TextStyle(
//                color: Color(0xff626262),
//                fontSize: 16,
//                fontFamily: 'HelveticaNeue',
//              ),
//            ),
//          ],
//        ),
//      ),
//      Container(
//        height: 40,
//        child: Row(
//          children: <Widget>[
//            Image.asset('name'),
//            Text(
//              'Faux Sued Ankle Mango',
//              style: TextStyle(
//                color: Color(0xff515c6f),
//                fontSize: 15,
//                fontFamily: 'Avenir',
//                fontWeight: FontWeight.w500,
//              ),
//            ),
//            Text(
//              '500 gm x 5',
//              style: TextStyle(
//                color: Color(0xff626262),
//                fontSize: 16,
//                fontFamily: 'HelveticaNeue',
//              ),
//            ),
//          ],
//        ),
//      ),
//      //total
//      Container(
//        height: 40,
//        child: Row(
//          children: <Widget>[
//            Image.asset('name'),
//            Text(
//              'Total Cost',
//              style: TextStyle(
//                color: Colors.black,
//                fontSize: 16,
//                fontFamily: 'HelveticaNeue',
//              ),
//            ),
//            Text(
//              '₹ 175.00',
//              style: TextStyle(
//                color: Colors.black,
//                fontSize: 18,
//                fontFamily: 'HelveticaNeue',
//              ),
//            ),
//          ],
//        ),
//      )
//    ];
  }

  Widget buildStatusIcon(_ViewModel snapshot) {
    if (snapshot.selectedOrder.status == "DROPPED" &&
        snapshot.selectedOrder.order.orderStatus == "COMPLETED") {
      return Column(
        children: <Widget>[
          Container(
              width: 40,
              height: 40,
              child: // New
                  Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
              decoration:
                  BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
        ],
      );
    } else if (snapshot.selectedOrder.status == "REJECTED") {
      return Column(
        children: <Widget>[
          Container(
              width: 40,
              height: 40,
              child: // New
                  Center(
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
              ),
              decoration:
                  BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
        ],
      );
    } else if (snapshot.selectedOrder.status == "PICKED" &&
        snapshot.selectedOrder.order.orderStatus != "COMPLETED") {
      return Column(
        children: <Widget>[
          Container(
              width: 40,
              height: 40,
              child: // New
                  Center(
                child: Icon(
                  Icons.autorenew,
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                  color: const Color(0xffdd8126), shape: BoxShape.circle))
        ],
      );
    } else if (snapshot.selectedOrder.status == "PENDING") {
      return Column(
        children: <Widget>[
          Container(
              width: 40,
              height: 40,
              child: // New
                  Center(
                child: Text(tr("screen_home.New"),
                    style: const TextStyle(
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Avenir",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                    textAlign: TextAlign.left),
              ),
              decoration: BoxDecoration(
                  color: const Color(0xffff4646), shape: BoxShape.circle)),
        ],
      );
    }
    return SizedBox.shrink();
  }

  //display image selected from camera
//display image selected from camera
  // imageSelectorCamera(_ViewModel snapshot) async {
  //   snapshot.getLocation();
  //   var orderProgress = await UserManager.getOrderProgressStatus();
  //   final pickedFile =
  //       await picker.getImage(source: ImageSource.camera, imageQuality: 50);
  //   setState(() {
  //     orderProgress != null
  //         ? orderProgress
  //             ? _endImage = File(pickedFile.path)
  //             : snapshot.selectedOrder.status == "PICKED"
  //                 ? _endImage = File(pickedFile.path)
  //                 : _startImage = File(pickedFile.path)
  //         : snapshot.selectedOrder.status == "PICKED"
  //             ? _endImage = File(pickedFile.path)
  //             : _startImage = File(pickedFile.path);
  //   });
  //   snapshot.uploadImage(
  //       orderProgress != null
  //           ? orderProgress
  //               ? _endImage
  //               : snapshot.selectedOrder.status == "PICKED"
  //                   ? _endImage
  //                   : _startImage
  //           : snapshot.selectedOrder.status == "PICKED"
  //               ? _endImage
  //               : _startImage,
  //       orderProgress != null
  //           ? orderProgress
  //               ? snapshot.selectedOrder.status == "PICKED"
  //                   ? false
  //                   : true
  //               : snapshot.selectedOrder.status == "PICKED"
  //                   ? false
  //                   : true
  //           : snapshot.selectedOrder.status == "PICKED"
  //               ? false
  //               : true);
  // }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

_launchMaps(String lat, String lon) async {
  String googleMapUrl = "https://www.google.com/maps/dir/?api=1&destination=" +
      lat +
      "," +
      lon +
      "&travelmode=driving&dir_action=navigate";
  String googleUrl = 'comgooglemaps://?center=$lat,$lon';
  String appleUrl = 'https://maps.apple.com/?sll=$lat,$lon';
  if (await canLaunch("comgooglemaps://")) {
    print('launching com googleUrl');
    await launch(googleMapUrl);
  } else if (await canLaunch(appleUrl)) {
    print('launching apple url');
    await launch(googleMapUrl);
  } else {
    throw 'Could not launch url';
  }
}

_makePhoneCall({String mobile}) async {
  if (await canLaunch(mobile)) {
    await launch(mobile);
  } else {
    Fluttertoast.showToast(msg: tr('screen_support.No_contact_details_found'));
  }
}

class _ViewModel extends BaseModel<AppState> {
  // Function(File, bool) uploadImage;
  TransitDetails transitDetails;
  OrderRequest orderRequest;
  TransitDetails selectedOrder;
  Function() acceptOrder;
  Function() dropOrder;
  Placemark locationDetails;
  VoidCallback getLocation;
  LoadingStatus loadingStatus;
  _ViewModel();
  _ViewModel.build({
    this.acceptOrder,
    this.dropOrder,
    this.getLocation,
    this.transitDetails,
    this.loadingStatus,
    this.locationDetails,
    this.selectedOrder,
    // this.uploadImage,
  }) : super(equals: [selectedOrder, loadingStatus, locationDetails]);
  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
      acceptOrder: () {
        dispatch(AcceptOrderAction());
      },
      dropOrder: () {
        dispatch(DropOrderAction());
      },
      loadingStatus: state.authState.loadingStatus,
      selectedOrder: state.homePageState.selectedOrder,
      transitDetails: state.homePageState.transitDetails,
      locationDetails: state.homePageState.currentLocation,
      getLocation: () {
        dispatch(GetLocationAction());
      },
//       uploadImage: (file, isPickup) {
//         dispatch(UploadImageAction(imageFile: file, isPickUp: isPickup));
// //          dispatch(AcceptOrderAction());
//       },
    );
  }
}

class ImageUploadWidget extends StatelessWidget {
  final TransitDetails transitDetails;
  const ImageUploadWidget(this.transitDetails, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (transitDetails.pickupImages != null &&
              transitDetails.pickupImages.isNotEmpty) ...[
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                transitDetails.pickupImages.length,
                (index) => InkWell(
                  onTap: () => showGeneralDialog(
                    barrierDismissible: false,
                    context: context,
                    pageBuilder: (context, _, __) => ImageDisplay(
                      imageUrl: transitDetails.pickupImages[index].photoUrl,
                    ),
                  ),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: CachedNetworkImage(
                      height: double.infinity,
                      width: double.infinity,
                      imageUrl: transitDetails.pickupImages[index].photoUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, _) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (transitDetails.status == "PICKED") ...[
            InkWell(
              onTap: () {},
              child: Container(
                color: Colors.grey[400],
                width: 100,
                height: 100,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline),
                    Text(tr('screen_support.Upload_Pick_Up_Images')),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: 20),
          if (transitDetails.dropImages != null &&
              transitDetails.dropImages.isNotEmpty) ...[
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                transitDetails.pickupImages.length,
                (index) => InkWell(
                  onTap: () => showGeneralDialog(
                    barrierDismissible: false,
                    context: context,
                    pageBuilder: (context, _, __) => ImageDisplay(
                      imageUrl: transitDetails.pickupImages[index].photoUrl,
                    ),
                  ),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: CachedNetworkImage(
                      height: double.infinity,
                      width: double.infinity,
                      imageUrl: transitDetails.pickupImages[index].photoUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, _) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (transitDetails.status == "DROPPED") ...[
            InkWell(
              onTap: () {},
              child: Container(
                color: Colors.grey[400],
                width: 100,
                height: 100,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline),
                    Text(tr('screen_support.Upload_Drop_Images')),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
