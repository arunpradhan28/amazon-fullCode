import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/constatnts/error_handling.dart';
import 'package:flutter_application_1/features/auth/models/product.dart';
import 'package:flutter_application_1/features/auth/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../constatnts/global_variables.dart';
import '../../../constatnts/utils.dart';

class SearchService{
  Future<List<Product>> fetchSearchProducts({
    required BuildContext context,
    required String query,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/products/search/$query'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

}