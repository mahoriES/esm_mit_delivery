import 'dart:io';

import 'package:async_redux/async_redux.dart';
import 'package:date_format/date_format.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/action/order_action.dart';
import 'package:esamudaayapp/modules/home/models/category_response.dart';
import 'package:esamudaayapp/modules/home/models/merchant_response.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OrderDetailScreen extends StatefulWidget {
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  File _image;
  final picker = ImagePicker();
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
                    : ListView(
                        children: <Widget>[
                          Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 79,
                                  height: 79,
                                  margin: new EdgeInsets.all(10.0),
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: buildStatusIcon(snapshot),
                                ),
                                Flexible(
                                  child: Padding(
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
                                                snapshot.selectedOrder.status ==
                                                    "ACCEPTED"
                                            ? RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Completed',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff505050),
                                                        fontSize: 12,
                                                        fontFamily: 'Avenir',
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          convertDateFromString(
                                                              snapshot
                                                                  .selectedOrder
                                                                  .order
                                                                  .created),
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff959595),
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
                                                snapshot.selectedOrder.status ==
                                                    "ACCEPTED"
                                            ? RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Distance ',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff505050),
                                                        fontSize: 12,
                                                        fontFamily: 'Avenir',
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: ': 2 km',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff959595),
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
                                ),
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
                                      snapshot.selectedOrder.order.orderItems !=
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
                          Row(
                            children: <Widget>[
                              Text(
                                'Jobin Thomas',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'No.638, DD Golden Gate, Demon Kochi, Kerala -  6789098',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '+91 67879898',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Ordered Products',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                            ],
                          ),
                          Card(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset('name'),
                                      Text(
                                        'Faux Sued Ankle Mango',
                                        style: TextStyle(
                                          color: Color(0xff515c6f),
                                          fontSize: 15,
                                          fontFamily: 'Avenir',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '500 gm x 5',
                                        style: TextStyle(
                                          color: Color(0xff626262),
                                          fontSize: 16,
                                          fontFamily: 'HelveticaNeue',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset('name'),
                                      Text(
                                        'Faux Sued Ankle Mango',
                                        style: TextStyle(
                                          color: Color(0xff515c6f),
                                          fontSize: 15,
                                          fontFamily: 'Avenir',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '500 gm x 5',
                                        style: TextStyle(
                                          color: Color(0xff626262),
                                          fontSize: 16,
                                          fontFamily: 'HelveticaNeue',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset('name'),
                                      Text(
                                        'Total Cost',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'HelveticaNeue',
                                        ),
                                      ),
                                      Text(
                                        '₹ 175.00',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'HelveticaNeue',
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            'Take the product picture before you start',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.w500,
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
                                children: <Widget>[
                                  new Text("Start",
                                      style: TextStyle(
                                        fontFamily: 'HelveticaNeue',
                                        color: Color(0xffffffff),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                      )),
                                  Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            ),
                          )
                        ],
                      );
              })),
    );
  }

  Column buildStatusIcon(_ViewModel snapshot) {
    if (snapshot.selectedOrder.status == "ACCEPTED" &&
        snapshot.selectedOrder.order.orderStatus == "COMPLETED") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          Text(
            'Completed',
            style: TextStyle(
              color: Color(0xff5f5959),
              fontSize: 12,
              fontFamily: 'Avenir',
            ),
          ),
        ],
      );
    } else if (snapshot.selectedOrder.status == "REJECTED") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.remove_circle,
            color: Colors.red,
          ),
          Text(
            'Rejected',
            style: TextStyle(
              color: Color(0xff5f5959),
              fontSize: 12,
              fontFamily: 'Avenir',
            ),
          ),
        ],
      );
    } else if (snapshot.selectedOrder.status == "ACCEPTED" &&
        snapshot.selectedOrder.order.orderStatus != "COMPLETED") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.refresh,
            color: Colors.orange,
          ),
          Text(
            'In progress',
            style: TextStyle(
              color: Color(0xff5f5959),
              fontSize: 12,
              fontFamily: 'Avenir',
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.fiber_new,
            color: Colors.green,
          ),
          Text(
            'Not Started',
            style: TextStyle(
              color: Color(0xff5f5959),
              fontSize: 12,
              fontFamily: 'Avenir',
            ),
          ),
        ],
      );
    }
  }

  //display image selected from camera
//display image selected from camera
  imageSelectorCamera(_ViewModel snapshot) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
      snapshot.uploadImage(_image, true);
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
          dispatch(AcceptOrderAction());
        });
  }
}
