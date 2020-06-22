import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/cart/actions/cart_actions.dart';
import 'package:esamudaayapp/modules/cart/models/cart_model.dart';
import 'package:esamudaayapp/modules/home/actions/home_page_actions.dart';
import 'package:esamudaayapp/modules/orders/actions/actions.dart';
import 'package:esamudaayapp/modules/orders/models/order_models.dart';
import 'package:esamudaayapp/modules/orders/views/expandable_view.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/colors.dart';
import 'package:esamudaayapp/utilities/custom_widgets.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class OrdersView extends StatefulWidget {
  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: false,
          titleSpacing: 30.0,
          title: // Orders
              Text("screen_order.title",
                      style: const TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Avenir",
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0),
                      textAlign: TextAlign.left)
                  .tr(),
        ),
        body: StoreConnector<AppState, _ViewModel>(
            model: _ViewModel(),
            onInit: (store) {
              store.dispatch(GetOrderListAPIAction());
            },
            builder: (context, snapshot) {
              return ModalProgressHUD(
                inAsyncCall: snapshot.loadingStatus == LoadingStatus.loading,
                child: (snapshot.getOrderListResponse == null ||
                        snapshot.getOrderListResponse.orders == null ||
                        snapshot.getOrderListResponse.orders.isEmpty)
                    ? Container(
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.45,
                                      color: const Color(0xfff0f0f0),
                                    ),
                                    clipper: CustomClipPath(),
                                  ),
                                ),
                                Positioned(
                                    bottom: 20,
                                    right: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Image.asset(
                                      'assets/images/clipart.png',
                                      fit: BoxFit.cover,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Text('screen_order.not_found',
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
                              padding:
                                  const EdgeInsets.only(left: 30.0, right: 30),
                              child: Text('screen_order.empty_content',
                                      maxLines: 2,
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
                                snapshot.viewStore();
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                      )
                    : Container(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder:
                              (BuildContext context, int merchantIndex) {
                            return NewWidget(
                              orderId: snapshot.getOrderListResponse
                                  .orders[merchantIndex].transactionID,
                              snapshot: snapshot,
                              merchantIndex: merchantIndex,
                              orderStatus: snapshot.getOrderListResponse
                                  .orders[merchantIndex].status,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 20,
                              color: Color(0xfff2f2f2),
                            );
                          },
                          itemCount:
                              snapshot.getOrderListResponse.orders.length,
                        ),
                      ),
              );
            }));
  }
}

class NewWidget extends StatefulWidget {
  final _ViewModel snapshot;
  final String orderId;
  final merchantIndex;
  final String orderStatus;
  const NewWidget(
      {Key key,
      this.merchantIndex,
      this.orderStatus,
      this.orderId,
      this.snapshot})
      : super(key: key);

  @override
  _NewWidgetState createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ExpandableListView(
            merchantIndex: widget.merchantIndex,
            didExpand: (status) {
              setState(() {
                expanded = !status;
              });
            },
          ),
          OrderItemBottomView(
            snapshot: widget.snapshot,
            orderId: widget.orderId,
            index: widget.merchantIndex,
            expanded: expanded,
            orderStatus: widget.orderStatus,
          )
        ],
      ),
    );
  }
}

class OrderItemBottomView extends StatelessWidget {
  final int index;
  final String orderId;
  final _ViewModel snapshot;
  final String orderStatus;
  final bool expanded;
  const OrderItemBottomView(
      {Key key,
      this.index,
      this.orderStatus,
      this.expanded,
      this.orderId,
      this.snapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 10),
                    child: orderStatus == "PENDING_CUSTOMER_REVIEW"
                        ? ImageIcon(
                            AssetImage('assets/images/align2.png'),
                            color: Colors.red,
                          )
                        : Icon(
                            orderStatus == "CANCELLED"
                                ? Icons.close
                                : orderStatus == "COMPLETED"
                                    ? Icons.check_circle_outline
                                    : orderStatus == "UNCONFIRMED"
                                        ? Icons.autorenew
                                        : orderStatus == "CONFIRMED"
                                            ? Icons.check_circle_outline
                                            : Icons.help_outline,
                            color: orderStatus == "CANCELLED"
                                ? Colors.red
                                : orderStatus == "COMPLETED"
                                    ? AppColors.green
                                    : orderStatus == "UNCONFIRMED"
                                        ? Color(0xffeb730c)
                                        : orderStatus == "CONFIRMED"
                                            ? Color(0xffa4c73f)
                                            : orderStatus ==
                                                    "PENDING_CUSTOMER_REVIEW"
                                                ? Colors.red
                                                : Colors.white,
                            size: 18,
                          ),
                  ), // Processing
                  Text(
                      orderStatus == "CANCELLED"
                          ? tr('screen_order.cancelled')
                          : orderStatus == "COMPLETED"
                              ? tr('screen_order.completed')
                              : orderStatus == "UNCONFIRMED"
                                  ? tr('screen_order.pending')
                                  : orderStatus == "CONFIRMED"
                                      ? tr('screen_order.confirmed')
                                      : orderStatus == "PENDING_CUSTOMER_REVIEW"
                                          ? tr('screen_order.not_available')
                                          : "",
                      style: const TextStyle(
                          color: const Color(0xff958d8d),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Avenir",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left)
                ],
              ),
              orderStatus == "CANCELLED" || orderStatus == "CONFIRMED"
                  ? Container(
                      height: 40,
                    )
                  : StoreConnector<AppState, _ViewModel>(
                      model: _ViewModel(),
                      builder: (context, snapshot) {
                        return CustomButton(
                          title: orderStatus == "CANCELLED"
                              ? tr('screen_order.cancel_order')
                              : orderStatus == "COMPLETED"
                                  ? tr('screen_order.re_order')
                                  : orderStatus == "UNCONFIRMED"
                                      ? tr('screen_order.cancel_order')
                                      : orderStatus == "CONFIRMED"
                                          ? tr('screen_order.payment')
                                          : orderStatus ==
                                                  "PENDING_CUSTOMER_REVIEW"
                                              ? tr('screen_order.update_order')
                                              : "",
                          backgroundColor: orderStatus == "COMPLETED"
                              ? AppColors.mainColor
                              : orderStatus == "UNCONFIRMED"
                                  ? AppColors.orange
                                  : AppColors.mainColor,
                          didPresButton: () async {
                            if (orderStatus == "COMPLETED") {
                              //reorder api
                              var user = await UserManager.userDetails();
                              var request = PlaceOrderRequest();
                              request.phoneNumber = user.phone;
                              var order =
                                  snapshot.getOrderListResponse.orders[index];
                              // order.status = null;
                              request.order = order;
                              snapshot.placeOrder(request);
                            } else if (orderStatus == "UNCONFIRMED") {
                              //cancel order api
                              var user = await UserManager.userDetails();
                              var request = UpdateOrderRequest();
                              request.oldStatus = orderStatus;
                              request.phoneNumber = user.phone;
                              var order =
                                  snapshot.getOrderListResponse.orders[index];
                              order.status = "CANCELLED";
                              request.orders = [order];

                              snapshot.updateOrder(request);
                            } else if (orderStatus ==
                                "PENDING_CUSTOMER_REVIEW") {
                              //update order action
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      color: Colors.white,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: <Widget>[
                                          Container(
                                            height: 50,
                                            margin: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                // Missing Items
                                                Text('screen_order.missing',
                                                        style: const TextStyle(
                                                            color: const Color(
                                                                0xff1f1f1f),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                "Avenir",
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 16.0),
                                                        textAlign:
                                                            TextAlign.left)
                                                    .tr(),
                                                IconButton(
                                                    icon: Icon(Icons.close),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 0.5,
                                            color: Colors.grey,
                                          ),
                                          ListView.separated(
                                            padding: EdgeInsets.all(10),
                                            shrinkWrap: true,
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return Container(
                                                height: 10,
                                              );
                                            },
                                            itemBuilder: (BuildContext context,
                                                int itemIndex) {
                                              var item = snapshot
                                                  .getOrderListResponse
                                                  .orders[index]
                                                  .itemsNotAvailable[itemIndex];
                                              return Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                        item.item.name +
                                                            " " +
                                                            item.item.skuSize +
                                                            " x " +
                                                            item.number
                                                                .toString(),
                                                        style: const TextStyle(
                                                            color: const Color(
                                                                0xff414141),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                "Avenir",
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 14.0),
                                                        textAlign:
                                                            TextAlign.left),
                                                  ],
                                                ),
                                              );
                                            },
                                            itemCount: snapshot
                                                .getOrderListResponse
                                                .orders[index]
                                                .itemsNotAvailable
                                                .length,
                                          ),
                                          // base
                                          Container(
                                            height: 96,
                                            margin: EdgeInsets.all(15),
                                            decoration:
                                                BoxDecoration(boxShadow: [
                                              BoxShadow(
                                                  color:
                                                      const Color(0x65e7eaf0),
                                                  offset: Offset(0, -8),
                                                  blurRadius: 15,
                                                  spreadRadius: 0)
                                            ], color: const Color(0xffffffff)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      'cart.total',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff515c6f),
                                                        fontSize: 10,
                                                        fontFamily:
                                                            'JosefinSans',
                                                      ),
                                                    ).tr(),
                                                    // ₹ 167.00
                                                    Text(
                                                        "₹ ${snapshot.getOrderListResponse.orders[index].totalOrderCost}",
                                                        style: const TextStyle(
                                                            color: const Color(
                                                                0xff515c6f),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontFamily:
                                                                "JosefinSans",
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 20.0),
                                                        textAlign:
                                                            TextAlign.left),
                                                    // Organic Store
                                                    Text(
                                                        snapshot
                                                            .getOrderListResponse
                                                            .orders[index]
                                                            .shopName,
                                                        style: const TextStyle(
                                                            color: const Color(
                                                                0xff727c8e),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                "Avenir",
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 12.0),
                                                        textAlign:
                                                            TextAlign.left)
                                                  ],
                                                ),
                                                // Cancel order
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: () async {
                                                        Navigator.pop(context);

                                                        var user =
                                                            await UserManager
                                                                .userDetails();
                                                        var request =
                                                            UpdateOrderRequest();
                                                        request.oldStatus = snapshot
                                                            .getOrderListResponse
                                                            .orders[index]
                                                            .status;
                                                        request.phoneNumber =
                                                            user.phone;
                                                        var order = snapshot
                                                            .getOrderListResponse
                                                            .orders[index];
                                                        order.status =
                                                            "CANCELLED";
                                                        request.orders = [
                                                          order
                                                        ];

                                                        snapshot.updateOrder(
                                                            request);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 11),
                                                        child: Text(
                                                                'screen_order.cancel_order',
                                                                style: const TextStyle(
                                                                    color: const Color(
                                                                        0xffe33a3a),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
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
                                                            .tr(),
                                                      ),
                                                    ),
                                                    CustomButton(
                                                      didPresButton: () async {
                                                        Navigator.pop(context);

                                                        var user =
                                                            await UserManager
                                                                .userDetails();
                                                        var request =
                                                            UpdateOrderRequest();
                                                        request.oldStatus = snapshot
                                                            .getOrderListResponse
                                                            .orders[index]
                                                            .status;
                                                        request.phoneNumber =
                                                            user.phone;
                                                        var order = snapshot
                                                            .getOrderListResponse
                                                            .orders[index];
                                                        order.status =
                                                            "CONFIRMED";
                                                        request.orders = [
                                                          order
                                                        ];

                                                        snapshot.updateOrder(
                                                            request);
                                                      },
                                                      backgroundColor:
                                                          AppColors.mainColor,
                                                      title:
                                                          tr('screen_order.update_order')
                                                              .toUpperCase(),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            }
                          },
                        );
                      }),
              // Support
            ],
          ),
          (orderStatus != "COMPLETED" && orderStatus != "CANCELLED") && expanded
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      snapshot.updateOrderId(orderId);
                      Navigator.of(context).pushNamed('/Support');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.help_outline,
                          size: 15,
                          color: Color(0xff3b3939),
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        // Support
                        Text("screen_support.title",
                                style: const TextStyle(
                                    color: const Color(0xff3b3939),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Avenir",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left)
                            .tr()
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final didPresButton;
  final Color backgroundColor;
  final String title;
  const CustomButton({
    Key key,
    this.didPresButton,
    this.backgroundColor,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        didPresButton();
      },
      child: Container(
        height: 39,
//        width: 160,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(23),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 12,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrdersListView extends StatefulWidget {
  final String shopImage;
  final String name;
  final String date;
  final String price;
  final String orderId;
  final _ViewModel snapshot;
  final bool deliveryStatus;
  final String items;
  final bool isExpanded;

  const OrdersListView(
      {Key key,
      this.shopImage,
      this.orderId,
      this.isExpanded,
      this.items,
      this.name,
      this.deliveryStatus,
      this.date,
      this.price,
      this.snapshot})
      : super(key: key);

  @override
  _OrdersListViewState createState() => _OrdersListViewState();
}

class _OrdersListViewState extends State<OrdersListView>
    with SingleTickerProviderStateMixin {
  AnimationController rotationController;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 79,
            height: 79,
            margin: new EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 5.0, // has the effect of extending the shadow
                  offset: Offset(
                    5.0, // horizontal, move right 10
                    5.0, // vertical, move down 10
                  ),
                )
              ],
            ),
            child: widget.shopImage == null
                ? Image.asset(
                    "assets/images/shop1.png",
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.shopImage,
                    placeholder: (context, url) => Icon(
                          Icons.image,
                          size: 30,
                        ),
                    errorWidget: (context, url, error) => Center(
                          child: Icon(Icons.error),
                        )),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.name,
                      style: const TextStyle(
                          color: const Color(0xff2c2c2c),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Avenir",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.left),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(widget.date,
                        style: const TextStyle(
                            color: const Color(0xff7c7c7c),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Avenir",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text("Order Id : " + widget.orderId ?? "",
                        style: const TextStyle(
                            color: const Color(0xff7c7c7c),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Avenir",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                              widget.items ?? "Milk, Egg, Bread, Etc ….",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: const Color(0xff7c7c7c),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Avenir",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0),
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: widget.deliveryStatus
                            ? Image.asset('assets/images/delivery.png')
                            : Image.asset('assets/images/no_delivery.png'),
                      ),
                      Flexible(
                        child: Text(
                            widget.deliveryStatus
                                ? tr("shop.delivery_ok")
                                : tr("shop.pickup_order"),
                            style: const TextStyle(
                                color: const Color(0xff7c7c7c),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Avenir",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            textAlign: TextAlign.left),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              RotatedBox(
                quarterTurns: widget.isExpanded ? 0 : 3,
                child: Icon(
                  Icons.expand_more,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(widget.price,
                  style: const TextStyle(
                      color: const Color(0xff5091cd),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Avenir",
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0),
                  textAlign: TextAlign.left)
            ],
          )
        ],
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  GetOrderListResponse getOrderListResponse;
  Function(String orderId) updateOrderId;
  Function viewStore;
  Function(PlaceOrderRequest) placeOrder;
  Function(UpdateOrderRequest) updateOrder;
  LoadingStatus loadingStatus;
  _ViewModel();
  _ViewModel.build(
      {this.getOrderListResponse,
      this.placeOrder,
      this.updateOrderId,
      this.updateOrder,
      this.loadingStatus,
      this.viewStore})
      : super(equals: [getOrderListResponse, loadingStatus]);
  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        updateOrderId: (value) {
          dispatch(OrderSupportAction(orderId: value));
        },
        loadingStatus: state.authState.loadingStatus,
        getOrderListResponse: state.productState.getOrderListResponse,
        placeOrder: (request) {
          dispatch(PlaceOrderAction(request: request));
        },
        viewStore: () {
          dispatch(UpdateSelectedTabAction(0));
        },
        updateOrder: (request) {
          dispatch(UpdateOrderAction(request: request));
        });
  }
}
