import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse(
    {required http.Response response, // Http response from the request
    required BuildContext context, // context is to show snack bar
    required VoidCallback onSuccess}) {
  // Switch statement to handle different http status codes
  switch (response.statusCode) {
    case 200: // 200 indicates that successful request
      onSuccess();
      break;
    case 400: // 400 indicates bad request
      showSnackBar(context, json.decode(response.body)['msg']);
      break;
    case 500: // 500 indicates the sever error
      showSnackBar(context, json.decode(response.body)['error']);
      break;
    case 201: // 201 indicates that the resource was created successfully
      onSuccess();
      break;
  }
}

void showSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: const EdgeInsets.all(25),
      behavior: SnackBarBehavior.floating,
      content: Text(title)));
}
