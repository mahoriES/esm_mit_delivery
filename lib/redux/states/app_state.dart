import 'package:esamudaayapp/redux/states/home_page_state.dart';
import 'package:esamudaayapp/redux/states/product_state.dart';

import 'auth_state.dart';

class AppState {
  final bool isLoading;
  final AuthState authState;
  final HomePageState homePageState;
  final ProductState productState;
  const AppState(
      {this.authState, this.isLoading, this.homePageState, this.productState});

  static AppState fromJson(dynamic json) => AppState(
        isLoading: json == null ? false : json["isLoading"],
        authState: json == null ? AuthState.initial() : json['authState'],
      );

  dynamic toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isLoading'] = this.isLoading;
    data['authState'] = this.authState;
    return data;
  }

  factory AppState.initial() => AppState(
      authState: AuthState.initial(),
      isLoading: false,
      productState: ProductState.initial(),
      homePageState: HomePageState.initial());

  AppState copyWith(
      {AuthState authState,
      bool isLoading,
      HomePageState homePageState,
      ProductState productState}) {
    return AppState(
      productState: productState ?? this.productState,
      authState: authState ?? this.authState,
      isLoading: isLoading ?? this.isLoading,
      homePageState: homePageState ?? this.homePageState,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          authState == other.authState &&
          homePageState == other.homePageState &&
          productState == other.productState &&
          isLoading == other.isLoading;

  @override
  int get hashCode => authState.hashCode;
  @override
  String toString() {
    return '';
  }
}
