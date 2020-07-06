import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/models/User.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/AgentHome/action/AgentAction.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/transit_models.dart';
import 'package:esamudaayapp/modules/accounts/action/account_action.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/store.dart';
import 'package:esamudaayapp/utilities/colors.dart';
import 'package:esamudaayapp/utilities/custom_widgets.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AgentHome extends StatefulWidget {
  final bool isNewOrder;
  final String withFilter;
  final Function callAPI;

  const AgentHome({Key key, this.isNewOrder, this.withFilter, this.callAPI})
      : super(key: key);
  @override
  _AgentHomeState createState() => _AgentHomeState();
}

class _AgentHomeState extends State<AgentHome> {
  @override
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh(_ViewModel snapshot, store) async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    widget.isNewOrder
        ? store.dispatch(GetAgentOrderList(filter: widget.withFilter))
        : store.dispatch(GetAgentTransitOrderList(filter: widget.withFilter));
    _refreshController.refreshCompleted();
  }

  void _onLoading(_ViewModel snapshot) async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
//    items.add((items.length + 1).toString());

    if (snapshot.response.next != null) {
      widget.isNewOrder
          ? store.dispatch(GetAgentOrderList(
              filter: widget.withFilter, url: snapshot.response.next))
          : store.dispatch(GetAgentTransitOrderList(
              filter: widget.withFilter, url: snapshot.response.next));
    }

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return UserExceptionDialog<AppState>(
      child: Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: Color(0xff5091cd),
              flexibleSpace: StoreConnector<AppState, _ViewModel>(
                  model: _ViewModel(),
                  builder: (context, snapshot) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: // Sign Out
                                  InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      child: AlertDialog(
                                        title: Text("E-samudaay"),
                                        content:
                                            Text('screen_account.alert_data')
                                                .tr(),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                                tr('screen_account.cancel')),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(tr(
                                                'screen_account.logout'
                                                    .toLowerCase())),
                                            onPressed: () async {
                                              snapshot.logout();
                                            },
                                          )
                                        ],
                                      ));
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 10, bottom: 8),
                                  child: Text("Sign Out",
                                      style: const TextStyle(
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "CircularStd-Book",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0),
                                      textAlign: TextAlign.left),
                                ),
                              ),
                            ),
                            decoration:
                                BoxDecoration(color: const Color(0xff4982b7))),
                        Spacer(),
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                                width: 51,
                                height: 51,
                                // clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  'assets/images/path5.png',
                                  color: Colors.white,
                                ),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color(0xffffffff),
                                        width: 2))),
                            Positioned(
                              top: 0,
                              right: 10,
                              child: // Edit
                                  InkWell(
                                onTap: () {
                                  snapshot.navigateToProfile();
                                },
                                child: Row(
                                  children: <Widget>[
                                    ImageIcon(
                                      AssetImage('assets/images/pen2.png'),
                                      color: Colors.white,
                                    ),
                                    Text("Edit",
                                        style: const TextStyle(
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "CircularStd-Book",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                        textAlign: TextAlign.left),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 16.0),
                            padding: EdgeInsets.only(left: 32.0, right: 32.0),
                            child: Text(
                              snapshot.user?.firstName ?? "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'PlayfairDisplay',
                                  fontSize: 16.0),
                            )),
                        Spacer(),
                      ],
                    );
                  }),
            ),
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.25)),
        body: StoreConnector<AppState, _ViewModel>(
            onInit: (store) async {
              widget.isNewOrder
                  ? store.dispatch(GetAgentOrderList(filter: widget.withFilter))
                  : store.dispatch(
                      GetAgentTransitOrderList(filter: widget.withFilter));
            },
            model: _ViewModel(),
            builder: (context, snapshot) {
              return ModalProgressHUD(
                progressIndicator: Card(
                  child: Image.asset(
                    'assets/images/indicator.gif',
                    height: 75,
                    width: 75,
                  ),
                ),
                inAsyncCall: snapshot.loadingStatus == LoadingStatus.loading &&
                    snapshot.orders.isEmpty,
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(
                    refresh: Image.asset(
                      'assets/images/indicator.gif',
                      height: 75,
                      width: 75,
                    ),
                    complete: Image.asset(
                      'assets/images/indicator.gif',
                      height: 75,
                      width: 75,
                    ),
                    waterDropColor: AppColors.icColors,
                  ),
                  footer: CustomFooter(
                    loadStyle: LoadStyle.ShowWhenLoading,
                    builder: (BuildContext context, LoadStatus mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = Text("");
                      } else if (mode == LoadStatus.loading) {
                        body = CupertinoActivityIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = Text("Load Failed!Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = Text("release to load more");
                      } else {
                        body = Text("No more Data");
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: () {
                    _onRefresh(snapshot, store);
                  },
                  onLoading: () {
                    _onLoading(snapshot);
                  },
                  child: snapshot.orders.isEmpty
                      ? snapshot.loadingStatus != LoadingStatus.loading
                          ? EmptyView()
                          : Container()
                      : ListView.separated(
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  UserManager.saveCurrentOrderId(
                                      orderId:
                                          snapshot.orders[index].order.orderId);
                                  snapshot.updateSelectedOrder(
                                      snapshot.orders[index]);
                                  snapshot.navigateToStoreDetailsPage(
                                      widget.withFilter,
                                      widget.isNewOrder
                                          ? snapshot.orders[index].requestId
                                              .toString()
                                          : snapshot.orders[index].transitId
                                              .toString());
                                },
                                child: StoresListView(
                                  orderId: snapshot
                                      .orders[index].order.orderShortNumber,
                                  date: UserManager().convertDateFromString(
                                      snapshot.orders[index].order.created),
                                  amount: snapshot
                                      .orders[index].order.orderTotal
                                      .toString(),
                                  address: snapshot.orders[index].order
                                      .deliveryAddress.prettyAddress,
                                  completed: "completed date",
                                  distance: "Distance",
                                  orderStatus:
                                      snapshot.orders[index].order.orderStatus,
                                  agentStatus: snapshot.orders[index].status,
                                ));
                          },
                          itemCount: snapshot.orders.length,
                          shrinkWrap: true,
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 10,
                            );
                          },
                        ),
                ),
              );
            }),
      ),
    );
  }
}

class StoresListView extends StatelessWidget {
  final String orderId;
  final String date;
  final String amount;
  final String address;
  final String orderStatus;
  final String agentStatus;
  final String completed;
  final String distance;
  final bool taskDetailsPage;

  const StoresListView(
      {Key key,
      this.orderId,
      this.date,
      this.amount,
      this.address,
      this.orderStatus,
      this.completed,
      this.distance,
      this.agentStatus,
      this.taskDetailsPage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return // Rectangle 8
        Container(
      height: 129,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 79,
              height: 79,
              margin: new EdgeInsets.all(10.0),
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
              ),
              child: Center(child: buildStatusIcon()),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Order ID $orderId',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  Text(
                    'Amount : Rs.$amount',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  Text(
                    '$address',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  orderStatus == "COMPLETED" && agentStatus == "ACCEPTED"
                      ? RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Completed',
                                style: TextStyle(
                                  color: Color(0xff505050),
                                  fontSize: 12,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              TextSpan(
                                text: ': $completed',
                                style: TextStyle(
                                  color: Color(0xff959595),
                                  fontSize: 12,
                                  fontFamily: 'CircularStd-Book',
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  orderStatus == "COMPLETED" && agentStatus == "ACCEPTED"
                      ? RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Distance ',
                                style: TextStyle(
                                  color: Color(0xff505050),
                                  fontSize: 12,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              TextSpan(
                                text: ': $distance',
                                style: TextStyle(
                                  color: Color(0xff959595),
                                  fontSize: 12,
                                  fontFamily: 'CircularStd-Book',
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
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column buildStatusIcon() {
    if (agentStatus == "DROPPED" && orderStatus == "COMPLETED") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          SizedBox(
            height: 10,
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
    } else if (agentStatus == "REJECTED") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          SizedBox(
            height: 10,
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
    } else if (agentStatus == "PICKED") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  color: const Color(0xffdd8126), shape: BoxShape.circle)),
          SizedBox(
            height: 10,
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
    } else if (agentStatus == "PENDING") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Ellipse 2
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
          SizedBox(
            height: 10,
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
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Function(String, String) navigateToStoreDetailsPage;

  VoidCallback navigateToCart;
  Function(TransitDetails) updateSelectedOrder;
  int currentIndex;
  List<TransitDetails> orders;
  Function logout;
  LoadingStatus loadingStatus;
  Function navigateToProfile;
  User user;
  OrderResponse response;
  _ViewModel.build(
      {this.navigateToStoreDetailsPage,
      this.currentIndex,
      this.loadingStatus,
      this.orders,
      this.navigateToProfile,
      this.logout,
      this.user,
      this.updateSelectedOrder,
      this.response})
      : super(equals: [currentIndex, user, orders, loadingStatus, response]);

  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        loadingStatus: state.authState.loadingStatus,
        orders: state.homePageState.orders,
        user: state.authState.user,
        logout: () {
          dispatch(LogoutAction());
        },
        navigateToProfile: () {
          dispatch(NavigateAction.pushNamed("/profile"));
        },
        updateSelectedOrder: (order) {
          dispatch(UpdateSelectedOrder(selectedOrder: order));
        },
        navigateToStoreDetailsPage: (type, id) {
          dispatch(NavigateAction.pushNamed('/orderDetail',
              arguments: {'TYPE': type, 'id': id}));
        },
        response: state.homePageState.response,
        currentIndex: state.homePageState.currentIndex);
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
          Text('',
                  style: const TextStyle(
                      color: const Color(0xff1f1f1f),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Avenir",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                  textAlign: TextAlign.left)
              .tr(),
        ],
      ),
    );
  }
}
