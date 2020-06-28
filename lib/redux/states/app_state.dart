import 'package:esamudaayapp/redux/states/home_page_state.dart';

import 'auth_state.dart';

class AppState {
  final bool isLoading;
  final AuthState authState;
  final HomePageState homePageState;

  const AppState({this.authState, this.isLoading, this.homePageState});

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
      homePageState: HomePageState.initial());

  AppState copyWith({
    AuthState authState,
    bool isLoading,
    HomePageState homePageState,
  }) {
    return AppState(
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
          isLoading == other.isLoading;

  @override
  int get hashCode => authState.hashCode;
  @override
  String toString() {
    return '';
  }
}
