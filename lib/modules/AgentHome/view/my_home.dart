import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaay_themes/esamudaay_themes.dart';
import 'package:esamudaayapp/models/User.dart';
import 'package:esamudaayapp/modules/AgentHome/action/AgentAction.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/AgentHome/view/AgentHome.dart';
import 'package:esamudaayapp/modules/accounts/views/accounts_view.dart';
import 'package:esamudaay_app_update/app_update_banner.dart';
import 'package:esamudaay_app_update/esamudaay_app_update.dart';
import 'package:esamudaayapp/modules/login/actions/login_actions.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/colors.dart';
import 'package:esamudaayapp/utilities/sizeconfig.dart';
import 'package:esamudaayapp/utilities/stringConstants.dart';
import 'package:flutter/material.dart';

import 'custom_appbar.dart';

class MyHomeView extends StatelessWidget {
  final List<String> tabTitles = [
    "new_order",
    "accepted",
    "in_progress",
    "completed"
  ];

  final List<String> tabType = [
    OrderStatusStrings.pending,
    OrderStatusStrings.accepted,
    OrderStatusStrings.picked,
    OrderStatusStrings.dropped,
  ];

  @override
  Widget build(BuildContext context) {
    Locale locale = EasyLocalization.of(context).locale;
    debugPrint("************************ build => ${locale.languageCode}");

    // SizeConfig service needs to be initialized only once before being used anywhere throughout the app.
    SizeConfig().init(context);
    return StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        onInit: (store) async {
          // to get the user name displayed in bottom app bar.
          store.dispatch(GetUserFromLocalStorageAction());
          // get the order list data for initally selected tab.
          store.dispatch(GetAgentOrderList(
              filter: tabType[store.state.homePageState.currentIndex]));
        },
        onInitialBuild: (snapshot) {
          snapshot.checkForAppUpdate(context);
        },
        builder: (context, snapshot) {
          return Scaffold(
            drawer: Drawer(
              child: AccountsView(),
            ),
            appBar: CustomAppbar(
              name: snapshot.user?.firstName ?? "",
            ),
            bottomNavigationBar: BottomAppBar(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  snapshot.showAppUpdateBanner
                      ? AppUpdateBanner(
                          updateMessage: tr('app_update.banner_msg'),
                          updateButtonText:
                              tr('app_update.update').toUpperCase(),
                          customThemeData: EsamudaayTheme.of(context),
                          packageName: StringConstants.packageName,
                        )
                      : SizedBox.shrink(),
                  Container(
                    height: 60.toHeight,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(
                        tabTitles.length,
                        (index) => Expanded(
                          child: Container(
                            height: 60.toHeight,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: snapshot.currentIndex == index
                                      ? AppColors.icColors
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(top: 10.toHeight),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: Colors.grey[300], width: 1),
                                ),
                              ),
                              child: FlatButton(
                                padding: EdgeInsets.all(10.toWidth),
                                onPressed: () {
                                  snapshot.updateCurrentIndex(index);

                                  if (snapshot.orders[tabType[index]] == null) {
                                    (tabType[index] ==
                                                OrderStatusStrings.pending ||
                                            tabType[index] ==
                                                OrderStatusStrings.accepted)
                                        ? snapshot.getOrderList(tabType[index])
                                        : snapshot
                                            .getTransitList(tabType[index]);
                                  }
                                },
                                child: FittedBox(
                                  child: new Text(
                                    tr('screen_home.tab_bar.${tabTitles[index]}'),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontFamily: "Avenir",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 13.toFont,
                                      color: snapshot.currentIndex == index
                                          ? AppColors.icColors
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: AgentHome(orderType: tabType[snapshot.currentIndex]),
          );
        });
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  Function updateCurrentIndex;
  Function(String) getTransitList;
  Function(String) getOrderList;
  Map<String, OrderResponse> orders;
  int currentIndex;
  Function navigateToProfile;
  User user;
  bool showAppUpdateBanner;
  Function(BuildContext) checkForAppUpdate;

  _ViewModel.build({
    this.getTransitList,
    this.getOrderList,
    this.orders,
    this.updateCurrentIndex,
    this.user,
    this.currentIndex,
    this.showAppUpdateBanner,
    this.checkForAppUpdate,
  }) : super(equals: [currentIndex, orders, showAppUpdateBanner]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      getTransitList: (filter) {
        dispatch(GetAgentTransitOrderList(filter: filter));
      },
      orders: state.homePageState.ordersList,
      getOrderList: (filter) {
        dispatch(GetAgentOrderList(filter: filter));
      },
      user: state.authState.user,
      updateCurrentIndex: (index) {
        dispatch(UpdateSelectedTabAction(index));
      },
      currentIndex: state.homePageState.currentIndex,
      checkForAppUpdate: (context) => dispatch(CheckAppUpdateAction(context)),
      showAppUpdateBanner: state.isSelectedAppUpdateLater,
    );
  }
}
