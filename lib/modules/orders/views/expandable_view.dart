import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/orders/actions/actions.dart';
import 'package:esamudaayapp/modules/orders/models/order_models.dart';
import 'package:esamudaayapp/modules/orders/views/orders_View.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/customAlert.dart';
import 'package:esamudaayapp/utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ExpandableListView extends StatefulWidget {
  final int merchantIndex;
  final Function(bool) didExpand;
  const ExpandableListView({Key key, this.merchantIndex, this.didExpand})
      : super(key: key);
  @override
  _ExpandableListViewState createState() => new _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController reviewController = TextEditingController();
  int rating = 0;
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        builder: (context, snapshot) {
          var orderStatus =
              snapshot.getOrderListResponse.orders[widget.merchantIndex].status;
          return new Column(
            children: <Widget>[
              InkWell(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, top: 15, right: 15),
                      child: OrdersListView(
                        isExpanded: expandFlag,
                        orderId: snapshot.getOrderListResponse
                            .orders[widget.merchantIndex].transactionID,
                        shopImage: snapshot.getOrderListResponse
                            .orders[widget.merchantIndex].displayPicture,
                        name: snapshot.getOrderListResponse
                            .orders[widget.merchantIndex].shopName,
                        deliveryStatus: snapshot.getOrderListResponse
                                .orders[widget.merchantIndex].address !=
                            null,
                        items: snapshot.getOrderListResponse
                            .orders[widget.merchantIndex].cardViewLine2,
                        date: DateFormat('dd MMMM, hh:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(int.parse(
                                snapshot
                                    .getOrderListResponse
                                    .orders[widget.merchantIndex]
                                    .placedAt))), //"20 -April, 07.45 PM ",
                        price:
                            "₹ ${snapshot.getOrderListResponse.orders[widget.merchantIndex].totalOrderCost}",
                      ),
                    ),
                    AnimatedContainer(
                      margin: EdgeInsets.only(top: 10),
                      height: expandFlag ? 0 : 0.5,
                      color: Colors.grey,
                      duration: Duration(milliseconds: 200),
                    )
                  ],
                ),
                onTap: () {
                  widget.didExpand(expandFlag);
                  setState(() {
                    expandFlag = !expandFlag;
                  });
                },
              ),
              ExpandableContainer(
                  expanded: expandFlag,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          padding:
                              EdgeInsets.only(top: 16, left: 15, right: 15),
                          shrinkWrap: true,
                          itemCount: snapshot
                              .getOrderListResponse
                              .orders[widget.merchantIndex]
                              .cart
                              .itemsEnhanced
                              .length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 7,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  // Faux Sued Ankle Mango - 500 GM x 3
                                  Text(
                                      snapshot
                                          .getOrderListResponse
                                          .orders[widget.merchantIndex]
                                          .cart
                                          .itemsEnhanced[index]
                                          .item
                                          .name,
                                      style: const TextStyle(
                                          color: const Color(0xff7c7c7c),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Avenir",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      textAlign: TextAlign.left),
                                  // ₹ 55.00
                                  Text(
                                      "₹ ${snapshot.getOrderListResponse.orders[widget.merchantIndex].cart.itemsEnhanced[index].item.price}",
                                      style: const TextStyle(
                                          color: const Color(0xff6f6f6f),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Avenir",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      textAlign: TextAlign.left)
                                ],
                              ),
                            );
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Payment Details
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 15, right: 15),
                              child: Text('screen_order.payment_details',
                                      style: const TextStyle(
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Avenir",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16.0),
                                      textAlign: TextAlign.center)
                                  .tr()
                                  .tr(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: Column(
                                children: <Widget>[
                                  ListView.separated(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 15),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot
                                            .getOrderListResponse
                                            .orders[widget.merchantIndex]
                                            .serviceSpecificData
                                            .length +
                                        1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return index == 0
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                // Item Total
                                                Text('screen_order.item_total',
                                                        style: const TextStyle(
                                                            color: const Color(
                                                                0xff696666),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                "Avenir",
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 16.0),
                                                        textAlign:
                                                            TextAlign.left)
                                                    .tr(), // ₹ 175.00
                                                Text(
                                                    "₹ ${snapshot.getOrderListResponse.orders[widget.merchantIndex].cart.itemsEnhanced.fold(0, (previous, current) {
                                                          return double.parse(
                                                                  previous
                                                                      .toString()) +
                                                              double.parse(current
                                                                      .item
                                                                      .price
                                                                      .toString()) *
                                                                  current
                                                                      .number;
                                                        }) ?? 0.0}",
                                                    style: const TextStyle(
                                                        color: const Color(
                                                            0xff696666),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: "Avenir",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 16.0),
                                                    textAlign: TextAlign.left)
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                // Item Total
                                                Text(
                                                    snapshot
                                                        .getOrderListResponse
                                                        .orders[widget
                                                            .merchantIndex]
                                                        .serviceSpecificData
                                                        .keys
                                                        .toList()[index - 1]
                                                        .toString()
                                                        .toLowerCase()
                                                        .replaceAll("_", " ")
                                                        .capitalize(),
                                                    style: const TextStyle(
                                                        color: const Color(
                                                            0xff696666),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: "Avenir",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 16.0),
                                                    textAlign: TextAlign
                                                        .left), // ₹ 175.00
                                                Text(
                                                    "₹ ${snapshot.getOrderListResponse.orders[widget.merchantIndex].serviceSpecificData.values.toList()[index - 1].toString()}",
                                                    style: const TextStyle(
                                                        color: const Color(
                                                            0xff696666),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: "Avenir",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 16.0),
                                                    textAlign: TextAlign.left)
                                              ],
                                            );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        height: 13,
                                      );
                                    },
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 0.5,
                                          margin: EdgeInsets.only(bottom: 10),
                                          color: Colors.grey,
                                        ),
                                        // Amount to be paid
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text('screen_order.total',
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff696666),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Avenir",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 16.0),
                                                      textAlign: TextAlign.left)
                                                  .tr(),
                                              // ₹ 195.00
                                              // ₹ 195.00
                                              Text(
                                                  "₹ ${snapshot.getOrderListResponse.orders[widget.merchantIndex].totalOrderCost}",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff5091cd),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Avenir",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0),
                                                  textAlign: TextAlign.left)
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),

                        // Please pay your bill amount to the  merchant directly using Cash, Card or UPI
                        orderStatus == "CONFIRMED"
                            ? Container(
                                color: Color(0xfff2f2f2),
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ImageIcon(
                                          AssetImage('assets/images/pen2.png')),
                                    ),
                                    Expanded(
                                      child: Text('screen_order.please_pay',
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff4b4b4b),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Avenir",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0),
                                              textAlign: TextAlign.left)
                                          .tr(),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        orderStatus == "COMPLETED"
                            ? Container(
                                color: Colors.white,
                                padding: EdgeInsets.only(left: 15, right: 15),
                                height: 55,
                                child: Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        // Rate us
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Text('screen_order.rate',
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff6c6c6c),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: "Avenir",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 18.0),
                                                  textAlign: TextAlign.left)
                                              .tr(),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            await showDialog<String>(
                                              context: context,
                                              builder: (builder) {
                                                return StoreConnector<AppState,
                                                        _ViewModel>(
                                                    model: _ViewModel(),
                                                    builder:
                                                        (context, snapshot) {
                                                      return CustomAlertDialog(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        content: Container(
                                                          height: 250,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration:
                                                              new BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            color: const Color(
                                                                0xFFFFFF),
                                                            borderRadius:
                                                                new BorderRadius
                                                                    .all(new Radius
                                                                        .circular(
                                                                    32.0)),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              // Rate our service
                                                              snapshot.loadingStatus ==
                                                                      LoadingStatus
                                                                          .submitted
                                                                  ? Container(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .check_circle,
                                                                        color: Colors
                                                                            .green,
                                                                        size:
                                                                            100,
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                              Text(
                                                                  snapshot.loadingStatus ==
                                                                          LoadingStatus
                                                                              .submitted
                                                                      ? tr(
                                                                          'screen_order.rate_ok')
                                                                      : tr(
                                                                          'screen_order.rate_our'),
                                                                  style: const TextStyle(
                                                                      color: const Color(
                                                                          0xff222222),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontFamily:
                                                                          "Avenir",
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      fontSize:
                                                                          20.0),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left),
                                                              snapshot.loadingStatus ==
                                                                      LoadingStatus
                                                                          .submitted
                                                                  ? Container()
                                                                  : Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              11,
                                                                          bottom:
                                                                              15),
                                                                      child:
                                                                          IgnorePointer(
                                                                        ignoring:
                                                                            snapshot.loadingStatus ==
                                                                                LoadingStatus.loading,
                                                                        child:
                                                                            RatingBar(
                                                                          initialRating:
                                                                              0,
                                                                          minRating:
                                                                              1,
                                                                          itemSize:
                                                                              27,
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          allowHalfRating:
                                                                              false,
                                                                          itemCount:
                                                                              5,
                                                                          itemPadding:
                                                                              EdgeInsets.symmetric(horizontal: 2.0),
                                                                          itemBuilder: (context, _) =>
                                                                              Icon(
                                                                            Icons.star,
                                                                            color:
                                                                                Colors.amber,
                                                                          ),
                                                                          onRatingUpdate:
                                                                              (rate) {
                                                                            rating =
                                                                                rate.toInt();
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                              snapshot.loadingStatus ==
                                                                      LoadingStatus
                                                                          .submitted
                                                                  ? Container()
                                                                  : Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              15),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            80,
                                                                        child:
                                                                            Form(
                                                                          key:
                                                                              _formKey,
                                                                          child:
                                                                              IgnorePointer(
                                                                            ignoring:
                                                                                snapshot.loadingStatus == LoadingStatus.loading,
                                                                            child:
                                                                                TextFormField(
//                                                            expands: true,
                                                                              maxLines: null,
                                                                              controller: reviewController,
                                                                              validator: (value) {
                                                                                return value.isEmpty ? tr('screen_order.feedback') : null;
                                                                              },
                                                                              decoration: new InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                  hintStyle: TextStyle(color: const Color(0xffb7b7b7), fontWeight: FontWeight.w400, fontFamily: "Avenir", fontStyle: FontStyle.normal, fontSize: 14.0),
                                                                                  hintText: tr('screen_order.write_feedback')),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                              // Rectangle 2088
                                                              snapshot.loadingStatus ==
                                                                      LoadingStatus
                                                                          .submitted
                                                                  ? Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10))
                                                                  : Container(),
                                                              IgnorePointer(
                                                                ignoring: snapshot
                                                                        .loadingStatus ==
                                                                    LoadingStatus
                                                                        .loading,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    if (snapshot
                                                                            .loadingStatus ==
                                                                        LoadingStatus
                                                                            .submitted) {
                                                                      snapshot.updateLoadingStatus(
                                                                          LoadingStatus
                                                                              .success);
                                                                      Navigator.pop(
                                                                          context);
                                                                    } else {
                                                                      if (_formKey
                                                                          .currentState
                                                                          .validate()) {
                                                                        // call feedback api
                                                                        FocusScope.of(context)
                                                                            .requestFocus(FocusNode());

                                                                        snapshot.rateOrder(AddReviewRequest(
                                                                            reviewCandidate:
                                                                                "ORDER",
                                                                            reviewCandidateID:
                                                                                snapshot.getOrderListResponse.orders[widget.merchantIndex].transactionID,
                                                                            reviewerTye: "CUSTOMER",
                                                                            reviewerID: snapshot.getOrderListResponse.orders[widget.merchantIndex].customerID,
                                                                            comments: reviewController.text,
                                                                            rating: rating));
                                                                        reviewController.text =
                                                                            "";
                                                                      }
                                                                    }
                                                                  },
                                                                  child:
                                                                      AnimatedContainer(
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            200),
                                                                    width: snapshot.loadingStatus ==
                                                                            LoadingStatus.loading
                                                                        ? 40
                                                                        : 141,
                                                                    height: 38,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(
                                                                                22)),
                                                                        color: const Color(
                                                                            0xff5091cd)),
                                                                    child: // Submit
                                                                        Center(
                                                                      child: snapshot.loadingStatus ==
                                                                              LoadingStatus
                                                                                  .loading
                                                                          ? Container(
                                                                              height: 30,
                                                                              width: 30,
                                                                              child: CircularProgressIndicator(
//                                                                              valueColor: AlwaysStoppedAnimation<Color>(Colors
//                                                                                  .white),
                                                                                  backgroundColor: Colors.white),
                                                                            )
                                                                          : Text(
                                                                              snapshot.loadingStatus == LoadingStatus.submitted || true ? tr('screen_order.ok') : tr('screen_order.submit'),
                                                                              style: const TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontFamily: "Avenir", fontStyle: FontStyle.normal, fontSize: 16.0),
                                                                              textAlign: TextAlign.left),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                            );
                                          },
                                          child: RatingBar(
                                            initialRating: 0,
                                            minRating: 0,
                                            itemSize: 25,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 1.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            tapOnlyMode: true,
                                            ignoreGestures: true,
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        snapshot.updateOrderId(
                                          snapshot
                                              .getOrderListResponse
                                              .orders[widget.merchantIndex]
                                              .transactionID,
                                        );
                                        Navigator.of(context)
                                            .pushNamed('/Support');
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.help_outline,
                                            size: 15,
                                            color: Color(0xff5091cd),
                                          ),
                                          Padding(padding: EdgeInsets.all(5)),
                                          // Support
                                          Text('screen_support.title',
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff5091cd),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Avenir",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 14.0),
                                                  textAlign: TextAlign.left)
                                              .tr()
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        Container(
                          height: 0.5,
                          color: Color(0xffe6e6e6),
                        )
                      ],
                    ),
                  ))
            ],
          );
        });
  }
}

class ExpandableContainer extends StatefulWidget {
  bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Container(
        height: widget.expanded ? null : widget.collapsedHeight,
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            widget.child,
          ],
        ),
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function(String orderId) updateOrderId;
  GetOrderListResponse getOrderListResponse;
  Function(AddReviewRequest) rateOrder;
  Function(LoadingStatus) updateLoadingStatus;
  LoadingStatus loadingStatus;
  _ViewModel();
  _ViewModel.build(
      {this.getOrderListResponse,
      this.rateOrder,
      this.loadingStatus,
      this.updateLoadingStatus,
      this.updateOrderId})
      : super(equals: [getOrderListResponse, loadingStatus]);
  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        rateOrder: (request) {
          dispatch(AddRatingAPIAction(request: request));
        },
        updateLoadingStatus: (loadingStatus) {
          dispatch(ChangeLoadingStatusAction(loadingStatus));
        },
        updateOrderId: (value) {
          dispatch(OrderSupportAction(orderId: value));
        },
        loadingStatus: state.authState.loadingStatus,
        getOrderListResponse: state.productState.getOrderListResponse);
  }
}
