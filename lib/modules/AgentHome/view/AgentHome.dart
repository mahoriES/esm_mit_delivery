import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/AgentHome/action/AgentAction.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AgentHome extends StatefulWidget {
  @override
  _AgentHomeState createState() => _AgentHomeState();
}

class _AgentHomeState extends State<AgentHome> {
  @override
  Widget build(BuildContext context) {
    return UserExceptionDialog<AppState>(
      child: Scaffold(
        body: StoreConnector<AppState, _ViewModel>(
            model: _ViewModel(),
            builder: (context, snapshot) {
              return ModalProgressHUD(
                inAsyncCall: snapshot.loadingStatus == LoadingStatus.loading &&
                    snapshot.orders.isEmpty,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        expandedHeight: 150,
                        floating: false,
                        pinned: true,
                        backgroundColor: Color(0xff5091cd),
                        flexibleSpace: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
// Rectangle 2
                            Container(
                                width: 360,
                                height: 50,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: // Sign Out
                                      Padding(
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
                                decoration: BoxDecoration(
                                    color: const Color(0xff4982b7))),
                            Spacer(),
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                    width: 51,
                                    height: 51,
                                    clipBehavior: Clip.antiAlias,
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
                                      Row(
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
                                )
                              ],
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 16.0),
                                padding:
                                    EdgeInsets.only(left: 32.0, right: 32.0),
                                child: Text(
                                  'Agent Name',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PlayfairDisplay',
                                      fontSize: 16.0),
                                )),
                            Spacer(),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: ListView.separated(
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            snapshot
                                .updateSelectedOrder(snapshot.orders[index]);
                            snapshot.navigateToStoreDetailsPage();
                          },
                          child: StoresListView(
                            orderId:
                                snapshot.orders[index].order.orderShortNumber,
                            date: UserManager().convertDateFromString(
                                snapshot.orders[index].order.created),
                            amount: snapshot.orders[index].order.orderTotal
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
                    itemCount: 1, // snapshot.orders.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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

  const StoresListView({
    Key key,
    this.orderId,
    this.date,
    this.amount,
    this.address,
    this.orderStatus,
    this.completed,
    this.distance,
    this.agentStatus,
  }) : super(key: key);
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
    if (agentStatus == "ACCEPTED" && orderStatus == "COMPLETED") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
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
          Icon(
            Icons.remove_circle,
            color: Colors.red,
          ),
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
    } else if (agentStatus == "ACCEPTED" && orderStatus != "COMPLETED") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.refresh,
            color: Colors.orange,
          ),
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
    } else {
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

  Function navigateToStoreDetailsPage;

  VoidCallback navigateToCart;
  Function(OrderRequest) updateSelectedOrder;
  int currentIndex;
  List<OrderRequest> orders;

  LoadingStatus loadingStatus;

  _ViewModel.build(
      {this.navigateToStoreDetailsPage,
      this.currentIndex,
      this.loadingStatus,
      this.orders,
      this.updateSelectedOrder})
      : super(equals: [
          currentIndex,
          orders,
          loadingStatus,
        ]);

  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        loadingStatus: state.authState.loadingStatus,
        orders: state.homePageState.orders,
        updateSelectedOrder: (order) {
          dispatch(UpdateSelectedOrder(selectedOrder: order));
        },
        navigateToStoreDetailsPage: () {
          dispatch(NavigateAction.pushNamed('/StoreDetailsView'));
        },
        currentIndex: state.homePageState.currentIndex);
  }
}