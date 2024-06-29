import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

Future<String> sendMessageAndGetResponse(String message) async {
  var replicateApiToken = 'r8_8e3KuAkQtqRPOKSJR4lOfXsC8cseFHd2CGYPG';
  var apiUrl = 'https://api.replicate.com/v1/models/meta/meta-llama-3-8b-instruct/predictions';

  var requestBody = jsonEncode({
    "version": "dp-a557b7387b4940df25b23f779dc534c4",
    "stream": true,
    "input": {"prompt": message}
  });

  var response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $replicateApiToken',
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
    },
    body: requestBody,
  );

  if (response.statusCode == 201) {
    var responseData = json.decode(response.body);
    var getStatusUrl = responseData['urls']['get'];
    String fullResponse = '';
    bool isComplete = false;
    int retryDelay = 1; // Kezdő várakozási idő másodpercben

    while (!isComplete) {
      var getStatusResponse = await http.get(
        Uri.parse(getStatusUrl),
        headers: {
          'Authorization': 'Bearer $replicateApiToken',
          'Connection': 'keep-alive',
        },
      );

      if (getStatusResponse.statusCode == 200) {
        var getStatusData = json.decode(getStatusResponse.body);
        var status = getStatusData['status'];
        if (status == 'succeeded') {
          var outputs = getStatusData['output'];
          if (outputs != null) {
            fullResponse += outputs.join('');
          }
          isComplete = true;  // Kilépés a ciklusból, ha a státusz 'succeeded'
        } else if (status == 'failed') {
          throw Exception('API request failed');
        } else {
          await Future.delayed(Duration(seconds: retryDelay));
          retryDelay = retryDelay * 2;  // Exponenciális visszavonulás
        }
      } else {
        throw Exception('Failed to get status');
      }
    }
    return fullResponse;  // Visszatérés az összefűzött válasszal
  } else {
    throw Exception('Failed to post request');
  }
}
