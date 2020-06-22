import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/orders/actions/actions.dart';
import 'package:esamudaayapp/modules/orders/models/support_request_model.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  TextEditingController issueController = TextEditingController();
  String selectedIssue = tr('screen_support.issue');
  List<String> locations = [
    tr('screen_support.issue'),
    tr('screen_support.the_order'),
    tr('screen_support.my_order'),
    tr('screen_support.delayed?'),
    tr('screen_support.Leakage'),
    tr('screen_support.Items_are'),
    tr('screen_support.Wrong_order'),
    tr('screen_support.spoilt'),
    tr('screen_support.not_received')
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: // Cart
            Text('screen_support.title',
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Avenir",
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0),
                    textAlign: TextAlign.left)
                .tr(),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: StoreConnector<AppState, _ViewModel>(
          model: _ViewModel(),
          onInit: (store) {},
          builder: (context, snapshot) {
            return snapshot.loadingStatus == LoadingStatus.loading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  border: Border.all(
                                      color: const Color(0xffededed), width: 1),
                                  color: const Color(0xfff5f5f5)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Text("ID : ${snapshot.orderId}",
                                          style: const TextStyle(
                                              color: const Color(0xff6f6d6d),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Avenir",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14.0),
                                          textAlign: TextAlign.left),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  border: Border.all(
                                      color: const Color(0xffededed), width: 1),
                                  color: const Color(0xfff5f5f5)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Text(snapshot.userName,
                                          style: const TextStyle(
                                              color: const Color(0xff6f6d6d),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Avenir",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14.0),
                                          textAlign: TextAlign.left),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  border: Border.all(
                                      color: const Color(0xffededed), width: 1),
                                  color: const Color(0xfff5f5f5)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Text(snapshot.userPhone,
                                          style: const TextStyle(
                                              color: const Color(0xff6f6d6d),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Avenir",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14.0),
                                          textAlign: TextAlign.left),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  border: Border.all(
                                      color: const Color(0xffdddddd), width: 1),
                                  color: const Color(0xffffffff)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: DropdownButton<String>(
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    value: selectedIssue,
                                    items: locations.map((String val) {
                                      return new DropdownMenuItem<String>(
                                        value: val,
                                        child: new Text(val,
                                            style: const TextStyle(
                                                color: const Color(0xff000000),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Avenir",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 14.0),
                                            textAlign: TextAlign.left),
                                      );
                                    }).toList(),
                                    hint: Text(""),
                                    onChanged: (newVal) {
                                      selectedIssue = newVal;
                                      this.setState(() {});
                                    }),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: new TextField(
                                controller: issueController,
                                maxLines: 5,
                                decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 2.0),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle:
                                      new TextStyle(color: Colors.grey[800]),
                                  hintText: tr('screen_support.type_hint'),
                                  fillColor: Colors.white70,
                                ),
                                style: const TextStyle(
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Avenir",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                              )),
                          InkWell(
                            onTap: () {
                              if (selectedIssue == tr('screen_support.issue')) {
                                Fluttertoast.showToast(
                                    msg: tr(
                                        'screen_support.select_issue_error'));
                              } else {
                                snapshot.sendSupportRequest(SupportRequest(
                                  ticketTemplate:
                                      selectedIssue == tr("not_received")
                                          ? "ORDER_NOT_RECEIVED"
                                          : (selectedIssue == tr("Items_are")
                                              ? "ORDER_ITEMS_MISSING"
                                              : "OTHER"),
                                  supportForEntityID: snapshot.orderId,
                                  raisedBy: 'CUSTOMER',
                                  raisedByEntityID: snapshot.userId,
                                  raisedByEntityEmail: snapshot.userEmail ?? "",
                                  raisedByEntityPhone: snapshot.userPhone,
                                  supportComment: issueController.text,
                                ));
                              }
                            },
                            child: Container(
                              width: 145.9659423828125,
                              height: 34.40576171875,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(23)),
                                  color: const Color(0xff5091cd)),
                              child: // Submit
                                  Center(
                                child: Text("screen_support.submit",
                                        style: const TextStyle(
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Avenir",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16.0),
                                        textAlign: TextAlign.left)
                                    .tr(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                          )
                        ],
                      ),
                    ),
                  );
          }),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  LoadingStatus loadingStatus;
  String orderId;
  String userName;
  String userEmail;
  String userPhone;
  String userId;
  Function(SupportRequest request) sendSupportRequest;
  _ViewModel();
  _ViewModel.build(
      {this.loadingStatus,
      this.orderId,
      this.userName,
      this.userPhone,
      this.sendSupportRequest,
      this.userId,
      this.userEmail})
      : super(equals: [
          loadingStatus,
          orderId,
          userName,
          userPhone,
          userId,
          userEmail
        ]);
  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        loadingStatus: state.authState.loadingStatus,
        userName: state.authState.user.firstName,
        userPhone: state.authState.user.phone,
        orderId: state.productState.supportOrder,
        userId: state.authState.user.id,
        userEmail: state.authState.user.email,
        sendSupportRequest: (request) {
          dispatch(SupportAPIAction(request: request));
        });
  }
}
