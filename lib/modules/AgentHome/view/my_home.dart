import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/modules/AgentHome/action/AgentAction.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/AgentHome/view/AgentHome.dart';
import 'package:esamudaayapp/modules/accounts/views/accounts_view.dart';
import 'package:esamudaayapp/modules/home/actions/home_page_actions.dart';
import 'package:esamudaayapp/modules/login/actions/login_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyHomeView extends StatefulWidget {
  MyHomeView({
    Key key,
  }) : super(key: key);
  @override
  _MyHomeViewState createState() => _MyHomeViewState();
}

class _MyHomeViewState extends State<MyHomeView> with TickerProviderStateMixin {
  final PageStorageBucket bucket = PageStorageBucket();

  final Key keyOne = PageStorageKey('dailyLog');

  final Key keyTwo = PageStorageKey('projects');

  final Key keyThree = PageStorageKey('queue');

  GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');

  Widget currentPage({index: int}) {
    if (index == 0) {
      return new AgentHome(
        isNewOrder: true,
        withFilter: "PENDING",
      );
    } else if (index == 1) {
      return new AgentHome(
        isNewOrder: false,
        withFilter: "PICKED",
      );
    } else if (index == 2) {
      return new AgentHome(
        isNewOrder: false,
        withFilter: "DROPPED",
      );
//      return ProfileView(
//        key: keyThree,
//      );
    } else {
      return AccountsView();
//      return ProductDetailsView();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StoreConnector<AppState, _ViewModel>(
          model: _ViewModel(),
          onInit: (store) async {
            //  store.dispatch(GetAgentOrderList());
            store.dispatch(GetUserFromLocalStorageAction());
          },
          builder: (context, snapshot) {
            return BottomAppBar(
                child: Container(
              height: 60,
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.all(10.0),
                      onPressed: () {
                        snapshot.getOrderList("PENDING");
                        snapshot.updateCurrentIndex(0);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            tr('screen_home.tab_bar.all_order'),
                            style: TextStyle(
                                color: snapshot.currentIndex == 0
                                    ? AppColors.icColors
                                    : Colors.black),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Color(0xfff8f8f8),
                      width: 2,
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(10.0),
                      onPressed: () {
                        snapshot.getTransitList("PICKED");
                        snapshot.updateCurrentIndex(1);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(tr('screen_home.tab_bar.in_progress'),
                              style: TextStyle(
                                color: snapshot.currentIndex == 1
                                    ? AppColors.icColors
                                    : Colors.black,
                              ))
                        ],
                      ),
                    ),
                    Container(
                      color: Color(0xfff8f8f8),
                      width: 2,
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(10.0),
                      onPressed: () {
                        snapshot.getTransitList("DROPPED");

                        snapshot.updateCurrentIndex(2);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(tr('screen_home.tab_bar.completed'),
                              style: TextStyle(
                                color: snapshot.currentIndex == 2
                                    ? AppColors.icColors
                                    : Colors.black,
                              ))
                        ],
                      ),
                    ),
                  ]),
            ));
            return BottomNavigationBar(
              currentIndex: snapshot.currentIndex,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Container(),
                  title: new Text(
                    tr('screen_home.tab_bar.all_order'),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Container(),
                  title: new Text(
                    tr('screen_home.tab_bar.in_progress'),
                  ),
                ),
//                BottomNavigationBarItem(
//                    icon: ImageIcon(
//                      AssetImage('assets/images/path338.png'),
//                      color: Colors.black,
//                    ),
//                    activeIcon: ImageIcon(
//                      AssetImage('assets/images/path338.png'),
//                      color: AppColors.mainColor,
//                    ),
//                    title: Text(
//                      tr('screen_home.tab_bar.orders'),
//                    )),
//                BottomNavigationBarItem(
//                    icon: ImageIcon(
//                      AssetImage('assets/images/path5.png'),
//                      color: Colors.black,
//                    ),
//                    activeIcon: ImageIcon(
//                      AssetImage('assets/images/path5.png'),
//                      color: AppColors.mainColor,
//                    ),
//                    title: Text(
//                      'screen_home.tab_bar.account',
//                    ).tr())
              ],
              onTap: (index) {
                snapshot.updateCurrentIndex(index);
              },
            );
          }),
      body: StoreConnector<AppState, _ViewModel>(
          model: _ViewModel(),
          builder: (context, snapshot) {
            return PageStorage(
                bucket: bucket,
                child: currentPage(index: snapshot.currentIndex));
          }),
    );
  }

  double height(BuildContext context, int totalItemCount) {
    var totalHeight = MediaQuery.of(context).size.height;
    var emptySpace = totalHeight - 250 + 150;
    var numberOfItemsInEmptySpace = (emptySpace ~/ 150).toInt();
    var remainingItemCount = totalItemCount - numberOfItemsInEmptySpace;
    return emptySpace + (130 * remainingItemCount);
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  Function navigateToAddAddressPage;
  Function navigateToProductSearch;
  Function updateCurrentIndex;
  VoidCallback getMerchants;
  Function(OrderRequest) updateSelectedOrder;
  Function(String) getTransitList;
  Function(String) getOrderList;
  int currentIndex;
  _ViewModel.build(
      {this.navigateToAddAddressPage,
      this.getTransitList,
      this.getOrderList,
      this.getMerchants,
      this.navigateToProductSearch,
      this.updateCurrentIndex,
      this.updateSelectedOrder,
      this.currentIndex})
      : super(equals: [currentIndex]);

  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        getTransitList: (filter) {
          dispatch(GetAgentTransitOrderList(filter: filter));
        },
        getOrderList: (filter) {
          dispatch(GetAgentOrderList(filter: filter));
        },
        navigateToAddAddressPage: () {
          dispatch(NavigateAction.pushNamed('/AddAddressView'));
        },
        navigateToProductSearch: () {
          dispatch(NavigateAction.pushNamed('/ProductSearchView'));
        },
        updateCurrentIndex: (index) {
          dispatch(UpdateSelectedTabAction(index));
        },
        currentIndex: state.homePageState.currentIndex);
  }
}
