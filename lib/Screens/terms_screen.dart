import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white, // First color
              Color(0xFF07abb8), // Second color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'termsTitle'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      fontFamily: 'Sora'
                    ),
                  ),
                  const SizedBox(height: 16.0),
                    _buildSubheading('termsText1'.tr),
                    _buildText('termsText2'.tr),
                    _buildHeading('termsText3'.tr),
                    _buildSubheading('termsText4'.tr),
                    _buildText('termsText5'.tr),
                    _buildSubheading('termsText6'.tr),
                    _buildText('termsText7'.tr),
                    _buildHeading('termsText8'.tr),
                    _buildSubheading('termsText9'.tr),
                    _buildText('termsText10'.tr),
                    _buildHeading('termsText11'.tr),
                    _buildSubheading('termsText12'.tr),
                    _buildText('termsText13'.tr),
                    _buildSubheading('termsText14'.tr),
                    _buildText('termsText15'.tr),
                    _buildHeading('termsText16'.tr),
                    _buildSubheading('termsText17'.tr),
                    _buildText('termsText18'.tr),
                    _buildHeading('termsText19'.tr),
                    _buildText('termsText20'.tr),
                ],
              ),
            ),
          ),
        ),
      );
  }


  Widget _buildHeading(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        fontFamily: 'Sora'
      ),
    );
  }

  Widget _buildSubheading(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
          fontFamily: 'Sora'
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
          fontFamily: 'Sora'
      ),
    );
  }
}
