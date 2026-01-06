// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class showSnackBar {
  static show_error(String mess, dynamic context) {
    showTopSnackBar(
      Overlay.of(context),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
        child: CustomSnackBar.success(
          message: mess,
          borderRadius: const BorderRadius.all(Radius.elliptical(50, 50)),
          backgroundColor: const Color.fromARGB(255, 235, 111, 111),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 168, 34, 34),
          ),
          messagePadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 0,
          ),
          maxLines: 1,
        ),
      ),
      animationDuration: const Duration(milliseconds: 1000),
      reverseAnimationDuration: const Duration(milliseconds: 300),
      displayDuration: const Duration(milliseconds: 1000),
    );
  }

  static show_success(String mess, dynamic context) {
    showTopSnackBar(
      Overlay.of(context),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
        child: CustomSnackBar.success(
          message: mess,
          borderRadius: const BorderRadius.all(Radius.elliptical(50, 50)),
          backgroundColor: const Color.fromARGB(255, 98, 243, 142),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 4, 125, 26),
          ),
          messagePadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 0,
          ),
          maxLines: 1,
        ),
      ),
      animationDuration: const Duration(milliseconds: 1000),
      reverseAnimationDuration: const Duration(milliseconds: 300),
      displayDuration: const Duration(milliseconds: 1000),
    );
  }
}
