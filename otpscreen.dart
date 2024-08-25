import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_verification/main.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.verificationId});

  final String verificationId;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Screen"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: otpController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Enter the OTP",
                suffixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: otpController.text.trim(),
                );
                await FirebaseAuth.instance.signInWithCredential(credential);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: "MyHomePage"),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to verify OTP: ${e.toString()}')),
                );
              }
            },
            child: const Text("Verify OTP"),
          ),
        ],
      ),
    );
  }
}
