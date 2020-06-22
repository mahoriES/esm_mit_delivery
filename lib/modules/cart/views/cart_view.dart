import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/models/User.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/cart/actions/cart_actions.dart';
import 'package:esamudaayapp/modules/cart/models/cart_model.dart';
import 'package:esamudaayapp/modules/cart/views/cart_bottom_view.dart';
import 'package:esamudaayapp/modules/home/actions/home_page_actions.dart';
import 'package:esamudaayapp/modules/home/models/merchant_response.dart';
import 'package:esamudaayapp/modules/orders/models/order_models.dart';
import 'package:esamudaayapp/modules/store_details/models/catalog_search_models.dart';
import 'package:esamudaayapp/modules/store_details/views/store_categories_details_view.dart';
import 'package:esamudaayapp/modules/store_details/views/store_product_listing_view.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/store.dart';
import 'package:esamudaayapp/utilities/colors.dart';
import 'package:esamudaayapp/utilities/custom_widgets.dart';
import 'package:esamudaayapp/utilities/extensions.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  int _radioValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              store.dispatch(GetCartFromLocal());
              Navigator.pop(context);
            }),
        title: // Cart
            Text('cart.title',
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Avenir",
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0),
                    textAlign: TextAlign.left)
                .tr(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StoreConnector<AppState, _ViewModel>(
          model: _ViewModel(),
          onInit: (store) {
            if (store.state.productState.localCartItems.isNotEmpty) {
              var total = store.state.productState.localCartItems.fold(0,
                      (previous, current) {
                    double price =
                        double.parse(current.price.toString()) * current.count;

                    return double.parse(previous.toString()) + price;
                  }) ??
                  0.0;

//              var request = PlaceOrderRequest(
//                  phoneNumber: store.state.authState.user.phone,
//                  comments: "",
//                  order: Orders(
//                      merchantID:
//                          store.state.productState.selectedMerchand.merchantID,
//                      codPaymentCompleted: false,
//                      paymentType: "CASH_ON_DELIVERY",
//                      cart: Cart(
//                          service: store.state.productState.selectedMerchand
//                                          .servicesOffered !=
//                                      null &&
//                                  store.state.productState.selectedMerchand
//                                      .servicesOffered.isNotEmpty
//                              ? store.state.productState.selectedMerchand
//                                  .servicesOffered.first
//                              : "FOOD_DELIVERY",
//                          total: total.toDouble(),
//                          itemsEnhanced: store.state.productState.localCartItems
//                              .map((cart) {
//                            return ItemsEnhanced(
//                                item: cart, number: cart.count);
//                          }).toList())));
//              store.dispatch(GetOrderTaxAction(request: request));
            }
          },
          builder: (context, snapshot) {
            return ModalProgressHUD(
              inAsyncCall: snapshot.loadingStatus == LoadingStatus.loading,
              child: Container(
                child: snapshot.localCart.isEmpty
                    ? EmptyView()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.localCart.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          height: 10,
                                        );
                                      },
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                            child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                      snapshot.localCart[index]
                                                          .name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff515c6f),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Avenir",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 15.0),
                                                      textAlign:
                                                          TextAlign.left),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      CSStepper(
                                                        value: snapshot
                                                            .localCart[index]
                                                            .count
                                                            .toString(),
                                                        didPressAdd: () {
                                                          var item = snapshot
                                                              .localCart[index];
                                                          item.count =
                                                              ((item?.count ??
                                                                          0) +
                                                                      1)
                                                                  .clamp(
                                                                      0,
                                                                      double
                                                                          .nan);
                                                          snapshot.addToCart(
                                                              item, context);
                                                          snapshot
                                                              .getOrderTax();
                                                        },
                                                        didPressRemove: () {
                                                          var item = snapshot
                                                              .localCart[index];
                                                          item.count =
                                                              ((item?.count ??
                                                                          0) -
                                                                      1)
                                                                  .clamp(
                                                                      0,
                                                                      double
                                                                          .nan);
                                                          snapshot
                                                              .removeFromCart(
                                                                  item);
                                                          snapshot
                                                              .getOrderTax();
                                                        },
                                                      ),
                                                      // ₹ 55.00
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            "₹ ${snapshot.localCart[index].price}",
                                                            style: const TextStyle(
                                                                color: const Color(
                                                                    0xff5091cd),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "Avenir",
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 18.0),
                                                            textAlign:
                                                                TextAlign.left),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            // 500GMS
                                            Text(
                                                snapshot.localCart[index]
                                                        .skuSize ??
                                                    "",
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xffa7a7a7),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Avenir",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                                textAlign: TextAlign.left)
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ));
                                      },
                                    ),
                                  ),
                                  MySeparator(),
                                  Container(
                                      height: 60,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: // Delivery Available
                                          Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: snapshot
                                                        .selectedMerchant.flags
                                                        .contains('DELIVERY')
                                                    ? Image.asset(
                                                        'assets/images/delivery.png')
                                                    : Image.asset(
                                                        'assets/images/no_delivery.png'),
                                              ),
                                              Text(
                                                  snapshot.selectedMerchant
                                                          .flags
                                                          .contains('DELIVERY')
                                                      ? tr("shop.delivery_ok")
                                                      : tr("shop.delivery_no"),
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff6f6f6f),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Avenir",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0),
                                                  textAlign: TextAlign.left),
                                            ],
                                          ),
                                          Container(
                                            child: // Add more
                                                Material(
                                              type: MaterialType.transparency,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.add,
                                                      size: 12.0,
                                                      color: Color(0xff5091cd),
                                                    ),
                                                    Text("Add more",
                                                        style: const TextStyle(
                                                            color: const Color(
                                                                0xff5091cd),
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontFamily:
                                                                "Avenir",
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 12.0),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(boxShadow: [
                                        BoxShadow(
                                            color: const Color(0x29000000),
                                            offset: Offset(0, 3),
                                            blurRadius: 6,
                                            spreadRadius: 0)
                                      ], color: const Color(0xffffffff))),
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    padding: EdgeInsets.only(
                                        left: 18,
                                        top: 20,
                                        bottom: 13,
                                        right: 22),
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        // Payment Details
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text("cart.payment_details",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff000000),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Avenir",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0),
                                                  textAlign: TextAlign.center)
                                              .tr(),
                                        ),
                                        snapshot.placeOrderResponse == null
                                            ? Container()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                child: Column(
                                                  children: <Widget>[
                                                    ListView.separated(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: snapshot
                                                              .placeOrderResponse
                                                              .order
                                                              .serviceSpecificData
                                                              .length +
                                                          1,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return index == 0
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  // Item Total
                                                                  Text("screen_order.item_total",
                                                                          style: const TextStyle(
                                                                              color: const Color(0xff696666),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontFamily: "Avenir",
                                                                              fontStyle: FontStyle.normal,
                                                                              fontSize: 16.0),
                                                                          textAlign: TextAlign.left)
                                                                      .tr(), // ₹ 175.00
                                                                  Text(
                                                                      "₹ ${snapshot.getCartTotal()}",
                                                                      style: const TextStyle(
                                                                          color: const Color(
                                                                              0xff696666),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Avenir",
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          fontSize:
                                                                              16.0),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left)
                                                                ],
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  // Item Total
                                                                  Text(
                                                                      snapshot
                                                                          .placeOrderResponse
                                                                          .order
                                                                          .serviceSpecificData
                                                                          .keys
                                                                          .toList()[index -
                                                                              1]
                                                                          .toString()
                                                                          .toLowerCase()
                                                                          .replaceAll("_",
                                                                              " ")
                                                                          .capitalize(),
                                                                      style: const TextStyle(
                                                                          color: const Color(
                                                                              0xff696666),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Avenir",
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          fontSize:
                                                                              16.0),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left), // ₹ 175.00
                                                                  Text(
                                                                      "₹ ${snapshot.placeOrderResponse.order.serviceSpecificData.values.toList()[index - 1].toString()}",
                                                                      style: const TextStyle(
                                                                          color: const Color(
                                                                              0xff696666),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Avenir",
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          fontSize:
                                                                              16.0),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left)
                                                                ],
                                                              );
                                                      },
                                                      separatorBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Container(
                                                          height: 13,
                                                        );
                                                      },
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10, bottom: 10),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            height: 0.5,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 10),
                                                            color: Colors.grey,
                                                          ),
                                                          // Amount to be paid
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Text("cart.total_amount",
                                                                      style: const TextStyle(
                                                                          color: const Color(
                                                                              0xff696666),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Avenir",
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          fontSize:
                                                                              16.0),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left)
                                                                  .tr(),
                                                              // ₹ 195.00
                                                              // ₹ 195.00
                                                              Text(
                                                                  "₹ ${snapshot.getCartTotal() + snapshot.placeOrderResponse.order.serviceSpecificData.values.toList().fold(0, (previous, current) {
                                                                        return double.parse(previous.toString()) +
                                                                            double.parse(current.toString());
                                                                      }) ?? 0.0}",
                                                                  style: const TextStyle(
                                                                      color: const Color(
                                                                          0xff5091cd),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          "Avenir",
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      fontSize:
                                                                          16.0),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left)
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 82,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Radio(
                                            value: 1,
                                            groupValue: snapshot
                                                    .selectedMerchant.flags
                                                    .contains('DELIVERY')
                                                ? _radioValue
                                                : null,
                                            onChanged: ((value) {
                                              if (snapshot
                                                  .selectedMerchant.flags
                                                  .contains('DELIVERY')) {
                                                setState(() {
                                                  _radioValue = value;
                                                });
                                              }
                                            })),
                                        // Delivery
                                        Text('cart.delivery',
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff2f2e2e),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Avenir",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                                textAlign: TextAlign.left)
                                            .tr(),
                                        Radio(
                                            value: 2,
                                            groupValue: _radioValue,
                                            onChanged: ((value) {
                                              setState(() {
                                                _radioValue = value;
                                              });
                                            })),
                                        // Pickup
                                        Text('cart.pickup',
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff2f2e2e),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Avenir",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                                textAlign: TextAlign.left)
                                            .tr()
                                      ],
                                    ),
                                  ),
                                  snapshot.selectedMerchant.flags
                                          .contains('DELIVERY')
                                      ? _radioValue != 1
                                          ? Container()
                                          : Container(
                                              color: Colors.white,
                                              padding: EdgeInsets.only(
                                                  top: 15, bottom: 15),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: ImageIcon(AssetImage(
                                                          'assets/images/home41.png')),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text("Deliver to:",
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff000000),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "Avenir",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      16.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                          // NJRA135, Second cross road,  Indiranagar- 6987452
                                                          Text(
                                                              snapshot
                                                                  .user.address,
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff4b4b4b),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "Avenir",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      14.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left)
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                      : Container(
                                          color: Colors.white,
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: ImageIcon(AssetImage(
                                                      'assets/images/pen2.png')),
                                                ),
                                                // Door number 1244 ,  Indiranagar, 2nd cross road
                                                // Delivering to:
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text("cart.note",
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff000000),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "Avenir",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      16.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)
                                                          .tr(),
                                                      // NJRA135, Second cross road,  Indiranagar- 6987452
                                                      Text("cart.please_collect",
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff4b4b4b),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "Avenir",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      14.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left)
                                                          .tr()
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                  snapshot.selectedMerchant.flags
                                              .contains('DELIVERY') &&
                                          _radioValue == 1
                                      ? Container()
                                      : Container(
                                          color: Colors.white,
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: ImageIcon(
                                                    AssetImage(
                                                      'assets/images/path330.png',
                                                    ),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                // Door number 1244 ,  Indiranagar, 2nd cross road
                                                // Delivering to:
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text("cart.store_address",
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff000000),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "Avenir",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      16.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)
                                                          .tr(),
                                                      // NJRA135, Second cross road,  Indiranagar- 6987452
                                                      Text(
                                                          snapshot
                                                                  .selectedMerchant
                                                                  .address
                                                                  .addressLine1 +
                                                              "," +
                                                              snapshot
                                                                  .selectedMerchant
                                                                  .address
                                                                  .addressLine2,
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff4b4b4b),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "Avenir",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 14.0),
                                                          textAlign:
                                                              TextAlign.left)
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: Icon(
                                                Icons.error_outline,
                                                color: AppColors.mainColor,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                      "cart.confirm_order_detail",
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff000000),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Avenir",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14.0),
                                                      textAlign: TextAlign.left)
                                                  .tr(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          BottomView(
                            storeName: snapshot.selectedMerchant.shopName,
                            buttonTitle: tr('cart.confirm_order'),
                            height: 80,
                            didPressButton: () async {
                              if (_radioValue == 0) {
                                Fluttertoast.showToast(
                                    msg: "please select Delivery / Pickup");
//                                return;
                              } else {
                                var user = await UserManager.userDetails();

                                var request = PlaceOrderRequest(
                                    phoneNumber: snapshot.user.phone,
                                    comments: "",
                                    order: Orders(
                                        merchantID: snapshot
                                            .selectedMerchant.merchantID,
                                        codPaymentCompleted: false,
                                        paymentType: "CASH_ON_DELIVERY",
                                        address: _radioValue == 1
                                            ? Address(
                                                addressLine1: user.address)
                                            : null,
                                        cart: Cart(
                                            service: snapshot.selectedMerchant
                                                            .servicesOffered !=
                                                        null &&
                                                    snapshot
                                                        .selectedMerchant
                                                        .servicesOffered
                                                        .isNotEmpty
                                                ? snapshot.selectedMerchant
                                                    .servicesOffered.first
                                                : "FOOD_DELIVERY",
                                            total: snapshot.getCartTotal(),
                                            itemsEnhanced:
                                                snapshot.localCart.map((cart) {
                                              return ItemsEnhanced(
                                                  item: cart,
                                                  number: cart.count);
                                            }).toList())));
                                snapshot.placeOrder(request);
                              }
                            },
                          )
                        ],
                      ),
              ),
            );
          }),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipPath(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.45,
                    color: const Color(0xfff0f0f0),
                  ),
                  clipper: CustomClipPath(),
                ),
              ),
              Positioned(
                  bottom: 20,
                  right: MediaQuery.of(context).size.width * 0.15,
                  child: Image.asset(
                    'assets/images/clipart.png',
                    fit: BoxFit.cover,
                  )),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Text('cart.empty_cart',
                  style: const TextStyle(
                      color: const Color(0xff1f1f1f),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Avenir",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                  textAlign: TextAlign.left)
              .tr(),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30),
            child: Text('cart.empty_hint',
                    style: const TextStyle(
                        color: const Color(0xff6f6d6d),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Avenir",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.center)
                .tr(),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                height: 46,
                width: 160,
                decoration: BoxDecoration(
                  color: Color(0xff5091cd),
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'common.view_store',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ).tr(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  List<Product> localCart;
  Function(Product, BuildContext) addToCart;
  Function(Product) removeFromCart;
  VoidCallback navigateToCart;
  Merchants selectedMerchant;
  PlaceOrderResponse placeOrderResponse;
  Function getCartTotal;
  Function(PlaceOrderRequest) placeOrder;
  Function(PlaceOrderRequest) getTaxOfOrder;
  Function getOrderTax;
  LoadingStatus loadingStatus;
  Function(Business) updateSelectedMerchant;

  User user;
  _ViewModel();
  _ViewModel.build(
      {this.localCart,
      this.updateSelectedMerchant,
      this.placeOrder,
      this.user,
      this.getCartTotal,
      this.addToCart,
      this.removeFromCart,
      this.navigateToCart,
      this.selectedMerchant,
      this.getTaxOfOrder,
      this.placeOrderResponse,
      this.loadingStatus,
      this.getOrderTax})
      : super(equals: [
          localCart,
          selectedMerchant,
          user,
          placeOrderResponse,
          loadingStatus
        ]);
  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
//        selectedMerchant: state.productState.selectedMerchand,
        localCart: state.productState.localCartItems,
        user: state.authState.user,
        placeOrderResponse: state.productState.placeOrderResponse,
        loadingStatus: state.authState.loadingStatus,
        getCartTotal: () {
          if (state.productState.localCartItems.isNotEmpty) {
            var total =
                state.productState.localCartItems.fold(0, (previous, current) {
                      double price = double.parse(current.price.toString()) *
                          current.count;

                      return double.parse(previous.toString()) + price;
                    }) ??
                    0.0;

            return total.toDouble(); //formatCurrency.format(total.toDouble());
          } else {
            return 0.0;
          }
        },
        updateSelectedMerchant: (merchant) {
//          dispatch(UpdateSelectedMerchantAction(selectedMerchant: merchant));
        },
        placeOrder: (request) {
          dispatch(PlaceOrderAction(request: request));
        },
        getTaxOfOrder: (request) {
          dispatch(GetOrderTaxAction(request: request));
        },
        addToCart: (item, context) {
          dispatch(AddToCartLocalAction(product: item, context: context));
        },
        removeFromCart: (item) {
          dispatch(RemoveFromCartLocalAction(product: item));
        },
        navigateToCart: () {
          dispatch(NavigateAction.pushNamed('/CartView'));
        },
        getOrderTax: () {
          if (store.state.productState.localCartItems.isNotEmpty) {
            var total = store.state.productState.localCartItems.fold(0,
                    (previous, current) {
                  double price =
                      double.parse(current.price.toString()) * current.count;

                  return double.parse(previous.toString()) + price;
                }) ??
                0.0;

//            var request = PlaceOrderRequest(
//                phoneNumber: state.authState.user.phone,
//                comments: "",
//                order: Orders(
//                    merchantID: state.productState.selectedMerchand.merchantID,
//                    codPaymentCompleted: false,
//                    paymentType: "CASH_ON_DELIVERY",
//                    cart: Cart(
//                        service: state.productState.selectedMerchand
//                                        .servicesOffered !=
//                                    null &&
//                                state.productState.selectedMerchand
//                                    .servicesOffered.isNotEmpty
//                            ? state.productState.selectedMerchand
//                                .servicesOffered.first
//                            : "FOOD_DELIVERY",
//                        total: total.toDouble(),
//                        itemsEnhanced:
//                            state.productState.localCartItems.map((cart) {
//                          return ItemsEnhanced(item: cart, number: cart.count);
//                        }).toList())));
//            dispatch(GetOrderTaxAction(request: request));
          }
        });
  }
}
