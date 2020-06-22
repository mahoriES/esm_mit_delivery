import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/AgentHome/action/AgentAction.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
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
                        expandedHeight: MediaQuery.of(context).size.height / 3,
                        floating: false,
                        pinned: true,
                        flexibleSpace: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 16.0),
                              padding: EdgeInsets.only(left: 32.0, right: 32.0),
                              child: Image.asset('assets/images/user.jpg'),
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
                          ],
                        ),
                      ),
                    ];
                  },
                  body: Center(
                    child: ListView(
                      padding: EdgeInsets.all(15.0),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    snapshot.updateSelectedOrder(
                                        snapshot.orders[index]);
                                    snapshot.navigateToStoreDetailsPage();
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
                                    orderStatus: snapshot
                                        .orders[index].order.orderStatus,
                                    agentStatus: snapshot.orders[index].status,
                                  ));
                            },
                            itemCount: snapshot.orders.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                height: 10,
                              );
                            },
                          ),
                        )
                      ],
                    ),
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
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 79,
            height: 79,
            margin: new EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: buildStatusIcon(),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
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
