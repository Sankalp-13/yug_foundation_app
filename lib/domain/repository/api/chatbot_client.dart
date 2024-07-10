// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:googleapis/dialogflow/v3.dart' as df;
// import 'package:http/http.dart' as http;
//
// class AuthClient {
//   static const _scopes = [df.DialogflowApi.cloudPlatformScope];
//
//   static Future<df.DialogflowApi> getDialogflowApi() async {
//     // Load the service account JSON file from assets
//     final serviceAccountJson = await rootBundle.loadString('assets/dialogflow_key/key.json');
//     final credentials = ServiceAccountCredentials.fromJson(json.decode(serviceAccountJson));
//     final client = await clientViaServiceAccount(credentials, _scopes);
//
//     // Specify the base URL for the correct region
//     final endpoint = 'https://global-dialogflow.googleapis.com/'; // {us-central1}
//
//     return df.DialogflowApi(client, rootUrl: endpoint);
//   }
// }
//
// class ChatbotClient {
//   final String projectId;
//   final String agentId;
//   final String location;
//
//   ChatbotClient({required this.projectId, required this.agentId, required this.location});
//
//   Future<String> sendMessage(String sessionId, String message) async {
//     final dialogflow = await AuthClient.getDialogflowApi();
//     final sessionPath = 'projects/$projectId/locations/$location/agents/$agentId/sessions/$sessionId';
//     final queryInput = df.GoogleCloudDialogflowCxV3QueryInput(languageCode: 'en',
//       text: df.GoogleCloudDialogflowCxV3TextInput(text: message),
//     );
//
//     final response = await dialogflow.projects.locations.agents.sessions.detectIntent(
//       df.GoogleCloudDialogflowCxV3DetectIntentRequest(queryInput: queryInput),
//       sessionPath,
//     );
//
//     final queryResult = response.queryResult;
//     if (queryResult != null && queryResult.responseMessages != null && queryResult.responseMessages!.isNotEmpty) {
//       return queryResult.responseMessages!.first.text!.text!.first;
//     } else {
//       return 'No response from chatbot';
//     }
//   }
// }