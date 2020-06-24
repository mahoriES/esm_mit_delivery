import 'dart:io';

import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/action/order_action.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';

class OrderDetailScreen extends StatefulWidget {
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  File _startImage;
  File _endImage;
  final picker = ImagePicker();
  String convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);

    return formatDate(
        todayDate, [dd, ' ', M, ' ', yyyy, ' ', hh, ':', nn, ' ', am]);
  }

//  openMapsSheet(context, _ViewModel snapshot) async {
//    try {
//      final title = snapshot.selectedOrder.order.customerName;
//      final description =
//          snapshot.selectedOrder.order.deliveryAddress.prettyAddress;
//      final coords = Coords(31.233568, 121.505504);
//      final availableMaps = await MapLauncher.installedMaps;
//
//      showModalBottomSheet(
//        context: context,
//        builder: (BuildContext context) {
//          return SafeArea(
//            child: SingleChildScrollView(
//              child: Container(
//                child: Wrap(
//                  children: <Widget>[
//                    for (var map in availableMaps)
//                      ListTile(
//                        onTap: () => map.showMarker(
//                          coords: coords,
//                          title: title,
//                          description: description,
//                        ),
//                        title: Text(map.mapName),
//                        leading: Image(
//                          image: map.icon,
//                          height: 30.0,
//                          width: 30.0,
//                        ),
//                      ),
//                  ],
//                ),
//              ),
//            ),
//          );
//        },
//      );
//    } catch (e) {
//      print(e);
//    }
//  }

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
                  color: Colors.black,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                }),
          ),
          body: StoreConnector<AppState, _ViewModel>(
              model: _ViewModel(),
              onInit: (store) {
                store.dispatch(GetOrderDetailsAction());
              },
              builder: (context, snapshot) {
                return snapshot.loadingStatus == LoadingStatus.loading
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
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
                                              'Order ID ${snapshot.selectedOrder.order.orderShortNumber},',
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
                                                          text: 'Completed',
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
                                                          text: 'Distance ',
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
                                                    .toString()
                                                : "0" + " items",
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
                                        onPressed: () {
                                          // Add your onPressed code here!
                                        },
                                        child: Icon(Icons.account_circle),
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
                                        onPressed: () {
                                          // Add your onPressed code here!
//                                          openMapsSheet(context, snapshot);
                                        },
                                        child: Image.asset(
                                            'assets/images/naviagtion.png'),
                                        backgroundColor:
                                            const Color(0xff5091cd),
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
                                        onPressed: () {
                                          // Add your onPressed code here!
                                        },
                                        child: Icon(Icons.phone),
                                        backgroundColor:
                                            const Color(0xff5091cd),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child:
                                          Image.asset('assets/images/path.png'),
                                    ),
                                    Flexible(
                                      child: Text(
                                        'Ordered Products',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'Avenir',
                                        ),
                                      ),
                                    ),
                                  ],
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
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Image.asset(
                                        'assets/images/exclamation_cr.png'),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Take the product picture before you start',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Avenir',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              imageSelectorCamera(snapshot);
                            },
                            child: new Container(
                              height: 65,
                              decoration: new BoxDecoration(
                                  gradient: LinearGradient(
                                colors: [Color(0xff5091cd), Color(0xff36628b)],
                                stops: [0, 1],
                                begin: Alignment(1.00, -0.00),
                                end: Alignment(-1.00, 0.00),
                                // angle: 270,
                                // scale: undefined,
                              )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Spacer(),
                                  new Text("Start",
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
                        ],
                      );
              })),
    );
  }

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
                            .first.photoUrl
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
        Text('Total Coast',
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
    if (snapshot.selectedOrder.status == "ACCEPTED" &&
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
    } else if (snapshot.selectedOrder.status == "ACCEPTED" &&
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
    } else {
      return Column(
        children: <Widget>[
          Container(
              width: 40,
              height: 40,
              child: // New
                  Center(
                child: Text("New",
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
  }

  //display image selected from camera
//display image selected from camera
  imageSelectorCamera(_ViewModel snapshot) async {
    var orderProgress = await UserManager.getOrderProgressStatus();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      orderProgress != null
          ? orderProgress
              ? _endImage = File(pickedFile.path)
              : _startImage = File(pickedFile.path)
          : _startImage = File(pickedFile.path);

      snapshot.uploadImage(
          orderProgress != null
              ? orderProgress ? _endImage : _startImage
              : _startImage,
          orderProgress != null ? orderProgress ? false : true : true);
    });
  }
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

class _ViewModel extends BaseModel<AppState> {
  Function(File, bool) uploadImage;

  OrderRequest orderRequest;
  OrderRequest selectedOrder;
  Function() acceptOrder;

  LoadingStatus loadingStatus;
  _ViewModel();
  _ViewModel.build(
      {this.acceptOrder,
      this.loadingStatus,
      this.selectedOrder,
      this.uploadImage})
      : super(equals: [
          selectedOrder,
          loadingStatus,
        ]);
  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        acceptOrder: () {
          dispatch(AcceptOrderAction());
        },
        loadingStatus: state.authState.loadingStatus,
        selectedOrder: state.homePageState.selectedOrder,
        uploadImage: (file, isPickup) {
          dispatch(UploadImageAction(imageFile: file, isPickUp: isPickup));
//          dispatch(AcceptOrderAction());
        });
  }
}
