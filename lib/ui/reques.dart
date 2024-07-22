import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../otp_verification_screen.dart';

class EnterMobileScreen extends StatefulWidget {
  const EnterMobileScreen({Key? key}) : super(key: key);

  @override
  _EnterMobileScreenState createState() => _EnterMobileScreenState();
}

class _EnterMobileScreenState extends State<EnterMobileScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  String verificationId = '';

  Future<void> verifyPhone() async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      FirebaseAuth.instance.signInWithCredential(authResult);
      // Handle success, navigate to home or next screen
      print('Phone number automatically verified and user signed in: $authResult');
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      // Handle verification failure
      print('Phone number verification failed: ${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, int? forceResend) {
      verificationId = verId;
      // Navigate to OTP verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(verificationId),
        ),
      );
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      verificationId = verId;
    };

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout,
      );
    } catch (e) {
      print('Failed to Verify Phone Number: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Mobile Number'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  hintText: 'Enter your phone number',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: verifyPhone,
                child: const Text('Verify Phone Number'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
