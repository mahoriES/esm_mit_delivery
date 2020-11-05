import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/AgentHome/action/AgentAction.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/transit_models.dart';
import 'package:esamudaayapp/presentations/empty_view.dart';
import 'package:esamudaayapp/presentations/loading_widget.dart';
import 'package:esamudaayapp/presentations/status_icon.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/colors.dart';
import 'package:esamudaayapp/utilities/sizeconfig.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AgentHome extends StatefulWidget {
  final String orderType;

  const AgentHome({@required this.orderType});
  @override
  _AgentHomeState createState() => _AgentHomeState();
}

class _AgentHomeState extends State<AgentHome> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool isNewOrder;

  void _onRefresh(_ViewModel snapshot) async {
    isNewOrder
        ? snapshot.getOrderList(widget.orderType)
        : snapshot.getTransitList(widget.orderType);
    _refreshController.refreshCompleted();
  }

  void _onLoading(_ViewModel snapshot) async {
    if (snapshot.orders[widget.orderType].next != null) {
      isNewOrder
          ? snapshot.getOrderList(
              widget.orderType,
              url: snapshot.orders[widget.orderType].next,
            )
          : snapshot.getTransitList(
              widget.orderType,
              url: snapshot.orders[widget.orderType].next,
            );
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    isNewOrder = (widget.orderType == OrderStatusStrings.pending ||
        widget.orderType == OrderStatusStrings.accepted);

    return UserExceptionDialog<AppState>(
      child: StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        builder: (context, snapshot) {
          return ModalProgressHUD(
            progressIndicator: Card(child: LoadingWidget()),
            inAsyncCall: snapshot.loadingStatus == LoadingStatus.loading &&
                snapshot.orders.isEmpty,
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(
                refresh: LoadingWidget(),
                complete: LoadingWidget(),
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
                    height: 55.toHeight,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: () => _onRefresh(snapshot),
              onLoading: () => _onLoading(snapshot),
              child: (snapshot.orders[widget.orderType]?.results?.isEmpty ??
                      true)
                  ? snapshot.loadingStatus != LoadingStatus.loading
                      ? EmptyView()
                      : LoadingWidget()
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        TransitDetails _details =
                            snapshot.orders[widget.orderType].results[index];
                        return InkWell(
                          onTap: () {
                            snapshot.updateSelectedOrder(_details);
                            snapshot.navigateToStoreDetailsPage();
                          },
                          child: _OrdersListView(
                            orderId: _details.order.orderShortNumber,
                            date: UserManager()
                                .convertDateFromString(_details.order.created),
                            amount: _details.order.orderTotal.toString(),
                            address: _details.status ==
                                        OrderStatusStrings.pending ||
                                    _details.status ==
                                        OrderStatusStrings.accepted
                                ? _details.order.pickupAddress.prettyAddress
                                : _details.order.deliveryAddress.prettyAddress,
                            distance: "Distance",
                            orderStatus: _details.order.orderStatus,
                            agentStatus: _details.status,
                          ),
                        );
                      },
                      itemCount:
                          snapshot.orders[widget.orderType].results.length,
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, int index) =>
                          Container(
                        height: 5.toHeight,
                        color: Colors.grey[300],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _OrdersListView extends StatelessWidget {
  final String orderId;
  final String date;
  final String amount;
  final String address;
  final String orderStatus;
  final String agentStatus;
  final String distance;

  const _OrdersListView({
    Key key,
    this.orderId,
    this.date,
    this.amount,
    this.address,
    this.orderStatus,
    this.distance,
    this.agentStatus,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.toHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 80.toWidth,
              height: 80.toHeight,
              margin: EdgeInsets.all(10.toFont),
              child: Center(child: StatusIcon(agentStatus, orderStatus)),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.toWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    '${tr('screen_home.Order_ID')} $orderId',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.toFont,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.toFont,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  Text(
                    '${tr('screen_home.Amount')} : Rs.$amount',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.toFont,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  Text(
                    '$address',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.toFont,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: tr('screen_home.Distance') + " ",
                          style: TextStyle(
                            color: Color(0xff505050),
                            fontSize: 12.toFont,
                            fontFamily: 'Avenir',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(
                          text: ': $distance',
                          style: TextStyle(
                            color: Color(0xff959595),
                            fontSize: 12.toFont,
                            fontFamily: 'CircularStd-Book',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 10.toWidth),
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
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Function() navigateToStoreDetailsPage;
  Function(TransitDetails) updateSelectedOrder;
  Map<String, OrderResponse> orders;
  LoadingStatus loadingStatus;
  Function(String, {String url}) getTransitList;
  Function(String, {String url}) getOrderList;
  _ViewModel.build({
    this.navigateToStoreDetailsPage,
    this.loadingStatus,
    this.getTransitList,
    this.getOrderList,
    this.orders,
    this.updateSelectedOrder,
  }) : super(equals: [
          orders,
          loadingStatus,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      loadingStatus: state.authState.loadingStatus,
      orders: state.homePageState.ordersList,
      updateSelectedOrder: (order) {
        dispatch(UpdateSelectedOrder(selectedOrder: order));
      },
      navigateToStoreDetailsPage: () {
        dispatch(NavigateAction.pushNamed('/orderDetail'));
      },
      getTransitList: (filter, {url}) {
        dispatch(GetAgentTransitOrderList(filter: filter, url: url));
      },
      getOrderList: (filter, {url}) {
        dispatch(GetAgentOrderList(filter: filter, url: url));
      },
    );
  }
}
