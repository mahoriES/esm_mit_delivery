import 'package:esamudaayapp/utilities/environment_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class CrashlyticsDelegate {
  static void recordError(dynamic exception, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(exception, stack);
  }

  // Define an async function to initialize Crashlytics

  static Future<void> initializeCrashlytics() async {
    // Wait for Firebase to initialize

    await Firebase.initializeApp();

    // You could additionally extend this to allow users to opt-in.

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        EnvironmentConfig.isProductionEnvironment);

    // Pass all uncaught errors to Crashlytics.

    Function originalOnError = FlutterError.onError;

    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);

      // Forward to original handler.

      originalOnError(errorDetails);
    };
  }
}
