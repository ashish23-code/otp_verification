import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_verification/main.dart';
import 'package:otp_verification/otpscreen.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Auth"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Enter Your Number",
                suffixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(34),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              String phoneNumber = phoneController.text.trim();
              if (phoneNumber.isEmpty || !phoneNumber.startsWith('+')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter a valid phone number.')),
                );
                return;
              }

              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: phoneNumber,
                verificationCompleted: (PhoneAuthCredential credential) async {
                  await FirebaseAuth.instance.signInWithCredential(credential);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(title: "MyHomePage"),
                    ),
                  );
                },
                verificationFailed: (FirebaseAuthException ex) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to verify phone number: ${ex.message}')),
                  );
                },
                codeSent: (String verificationId, int? resendToken) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpScreen(verificationId: verificationId),
                    ),
                  );
                },
                codeAutoRetrievalTimeout: (String verificationId) {
                  // Handle timeout scenario
                },
              );
            },
            child: const Text("Verify Phone Number"),
          ),
        ],
      ),
    );
  }
}
