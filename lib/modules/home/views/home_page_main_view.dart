// import 'package:async_redux/async_redux.dart';
// import 'package:date_format/date_format.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:esamudaayapp/models/loading_status.dart';
// import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
// import 'package:esamudaayapp/modules/home/actions/home_page_actions.dart';
// import 'package:esamudaayapp/modules/home/models/cluster.dart';
// import 'package:esamudaayapp/modules/register/model/register_request_model.dart';
// import 'package:esamudaayapp/redux/states/app_state.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';

// class HomePageMainView extends StatefulWidget {
//   @override
//   _HomePageMainViewState createState() => _HomePageMainViewState();
// }

// class _HomePageMainViewState extends State<HomePageMainView> {
//   @override
//   Widget build(BuildContext context) {
//     return UserExceptionDialog<AppState>(
//       child: Scaffold(
//         body: StoreConnector<AppState, _ViewModel>(
//             model: _ViewModel(),
//             builder: (context, snapshot) {
//               return ModalProgressHUD(
//                 progressIndicator: Card(
//                   child: Image.asset(
//                     'assets/images/indicator.gif',
//                     height: 75,
//                     width: 75,
//                   ),
//                 ),
//                 inAsyncCall: snapshot.loadingStatus == LoadingStatus.loading &&
//                     snapshot.orders.isEmpty,
//                 child: NestedScrollView(
//                   headerSliverBuilder:
//                       (BuildContext context, bool innerBoxIsScrolled) {
//                     return <Widget>[
//                       SliverAppBar(
//                         expandedHeight: MediaQuery.of(context).size.height / 3,
//                         floating: false,
//                         pinned: true,
//                         flexibleSpace: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             Container(
//                               margin: EdgeInsets.only(top: 16.0),
//                               padding: EdgeInsets.only(left: 32.0, right: 32.0),
//                               child: Image.asset('assets/images/user.jpg'),
//                             ),
//                             Container(
//                                 margin: EdgeInsets.only(top: 16.0),
//                                 padding:
//                                     EdgeInsets.only(left: 32.0, right: 32.0),
//                                 child: Text(
//                                   tr("screen_home.Agent_Name"),
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontFamily: 'PlayfairDisplay',
//                                       fontSize: 16.0),
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ];
//                   },
//                   body: Center(
//                     child: ListView(
//                       padding: EdgeInsets.all(15.0),
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: ListView.separated(
//                             itemBuilder: (context, index) {
//                               return InkWell(
//                                   onTap: () {
//                                     snapshot.updateSelectedOrder(
//                                         snapshot.orders[index]);
//                                     snapshot.navigateToStoreDetailsPage();
//                                   },
//                                   child: StoresListView(
//                                     orderId: snapshot
//                                         .orders[index].order.orderShortNumber,
//                                     date: convertDateFromString(
//                                         snapshot.orders[index].order.created),
//                                     amount: snapshot
//                                         .orders[index].order.orderTotal
//                                         .toString(),
//                                     address: snapshot.orders[index].order
//                                         .deliveryAddress.prettyAddress,
//                                     completed: "completed date",
//                                     distance: "Distance",
//                                     orderStatus: snapshot
//                                         .orders[index].order.orderStatus,
//                                     agentStatus: snapshot.orders[index].status,
//                                   ));
//                             },
//                             itemCount: snapshot.orders.length,
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             separatorBuilder:
//                                 (BuildContext context, int index) {
//                               return Container(
//                                 height: 10,
//                               );
//                             },
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }),
//       ),
//     );
//   }

//   String convertDateFromString(String strDate) {
//     DateTime todayDate = DateTime.parse(strDate);

//     return formatDate(
//         todayDate, [dd, ' ', M, ' ', yyyy, ' ', hh, ':', nn, ' ', am]);
//   }
// }

// class StoresListView extends StatelessWidget {
//   final String orderId;
//   final String date;
//   final String amount;
//   final String address;
//   final String orderStatus;
//   final String agentStatus;
//   final String completed;
//   final String distance;

//   const StoresListView({
//     Key key,
//     this.orderId,
//     this.date,
//     this.amount,
//     this.address,
//     this.orderStatus,
//     this.completed,
//     this.distance,
//     this.agentStatus,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             width: 79,
//             height: 79,
//             margin: new EdgeInsets.all(10.0),
//             decoration: new BoxDecoration(
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.all(Radius.circular(20.0)),
//             ),
//             child: buildStatusIcon(),
//           ),
//           Flexible(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8, right: 8),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     "${tr('screen_home.Order_ID')} $orderId",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontFamily: 'Avenir',
//                     ),
//                   ),
//                   Text(
//                     date,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 12,
//                       fontFamily: 'Avenir',
//                     ),
//                   ),
//                   Text(
//                     "${tr('screen_home.Amount')} : Rs.$amount",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 12,
//                       fontFamily: 'Avenir',
//                     ),
//                   ),
//                   Text(
//                     '$address',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 12,
//                       fontFamily: 'Avenir',
//                     ),
//                   ),
//                   orderStatus == "COMPLETED" && agentStatus == "ACCEPTED"
//                       ? RichText(
//                           text: TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: tr('screen_home.Completed'),
//                                 style: TextStyle(
//                                   color: Color(0xff505050),
//                                   fontSize: 12,
//                                   fontFamily: 'Avenir',
//                                   fontWeight: FontWeight.w900,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: ': $completed',
//                                 style: TextStyle(
//                                   color: Color(0xff959595),
//                                   fontSize: 12,
//                                   fontFamily: 'CircularStd-Book',
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : Container(),
//                   orderStatus == "COMPLETED" && agentStatus == "ACCEPTED"
//                       ? RichText(
//                           text: TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: '${tr('screen_home.Distance')} ',
//                                 style: TextStyle(
//                                   color: Color(0xff505050),
//                                   fontSize: 12,
//                                   fontFamily: 'Avenir',
//                                   fontWeight: FontWeight.w900,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: ': $distance',
//                                 style: TextStyle(
//                                   color: Color(0xff959595),
//                                   fontSize: 12,
//                                   fontFamily: 'CircularStd-Book',
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : Container(),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 10.0),
//             child: Icon(
//               Icons.arrow_forward_ios,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Column buildStatusIcon() {
//     if (agentStatus == "ACCEPTED" && orderStatus == "COMPLETED") {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Icon(
//             Icons.check_circle,
//             color: Colors.green,
//           ),
//           Text(
//             tr('screen_home.Completed'),
//             style: TextStyle(
//               color: Color(0xff5f5959),
//               fontSize: 12,
//               fontFamily: 'Avenir',
//             ),
//           ),
//         ],
//       );
//     } else if (agentStatus == "REJECTED") {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Icon(
//             Icons.remove_circle,
//             color: Colors.red,
//           ),
//           Text(
//             tr('screen_home.Rejected'),
//             style: TextStyle(
//               color: Color(0xff5f5959),
//               fontSize: 12,
//               fontFamily: 'Avenir',
//             ),
//           ),
//         ],
//       );
//     } else if (agentStatus == "ACCEPTED" && orderStatus != "COMPLETED") {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Icon(
//             Icons.refresh,
//             color: Colors.orange,
//           ),
//           Text(
//             tr('screen_home.In_progress'),
//             style: TextStyle(
//               color: Color(0xff5f5959),
//               fontSize: 12,
//               fontFamily: 'Avenir',
//             ),
//           ),
//         ],
//       );
//     } else {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Icon(
//             Icons.fiber_new,
//             color: Colors.green,
//           ),
//           Text(
//             tr('screen_home.Not_Started'),
//             style: TextStyle(
//               color: Color(0xff5f5959),
//               fontSize: 12,
//               fontFamily: 'Avenir',
//             ),
//           ),
//         ],
//       );
//     }
//   }
// }

// class _ViewModel extends BaseModel<AppState> {
//   _ViewModel();
//   String userAddress;
//   Function navigateToAddAddressPage;
//   Function navigateToProductSearch;
//   Function navigateToStoreDetailsPage;
//   Function updateCurrentIndex;
//   VoidCallback navigateToCart;
//   Function(OrderRequest) updateSelectedOrder;
//   int currentIndex;
//   List<OrderRequest> orders;
//   List<Photo> banners;
//   LoadingStatus loadingStatus;
//   Cluster cluster;
//   _ViewModel.build(
//       {this.navigateToAddAddressPage,
//       this.navigateToCart,
//       this.cluster,
//       this.banners,
//       this.navigateToProductSearch,
//       this.navigateToStoreDetailsPage,
//       this.updateCurrentIndex,
//       this.currentIndex,
//       this.loadingStatus,
//       this.orders,
//       this.userAddress,
//       this.updateSelectedOrder})
//       : super(equals: [
//           currentIndex,
//           orders,
//           banners,
//           loadingStatus,
//           userAddress,
//           cluster
//         ]);

//   @override
//   BaseModel fromStore() {
//     // TODO: implement fromStore
//     return _ViewModel.build(
//         cluster: state.authState.cluster,
//         userAddress:
//             state.authState.user != null ? state.authState.user.address : "",
//         loadingStatus: state.authState.loadingStatus,
// //        orders: state.homePageState.orders,
//         banners: state.homePageState.banners,
//         navigateToCart: () {
//           dispatch(NavigateAction.pushNamed('/CartView'));
//         },
//         updateSelectedOrder: (order) {
//           dispatch(UpdateSelectedOrder(selectedOrder: order));
//         },
//         navigateToStoreDetailsPage: () {
//           dispatch(NavigateAction.pushNamed('/StoreDetailsView'));
//         },
//         navigateToAddAddressPage: () {
//           dispatch(NavigateAction.pushNamed('/AddAddressView'));
//         },
//         navigateToProductSearch: () {
//           dispatch(UpdateSelectedTabAction(1));
//         },
//         currentIndex: state.homePageState.currentIndex);
//   }
// }
