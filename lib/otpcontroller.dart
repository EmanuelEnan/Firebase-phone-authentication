import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_authentication/home_screen.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTPControllerScreen extends StatefulWidget {
  final String phoneNo;
  final String digits;

  const OTPControllerScreen(
      {Key? key, required this.phoneNo, required this.digits})
      : super(key: key);

  @override
  _OTPControllerScreenState createState() => _OTPControllerScreenState();
}

class _OTPControllerScreenState extends State<OTPControllerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPCode = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? varificationCode;

  @override
  void initState() {
    super.initState();

    verifyNumber();
  }

  verifyNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.digits + widget.phoneNo,
      verificationCompleted: (PhoneAuthCredential credintial) async {
        await FirebaseAuth.instance
            .signInWithCredential(credintial)
            .then((value) {
          if (value.user != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ),
            );
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid Data'),
            duration: Duration(seconds: 3),
          ),
        );
      },
      codeSent: (String vId, int? resendToken) {
        setState(() {
          varificationCode = vId;
        });
      },
      codeAutoRetrievalTimeout: (String vId) {
        setState(() {
          varificationCode = vId;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('OTP verification'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/login1.jpg'),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  verifyNumber();
                },
                child: Text('Verifying: ${widget.digits}-${widget.phoneNo}'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: PinPut(
              fieldsCount: 6,
              eachFieldWidth: 45,
              submittedFieldDecoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(
                    color: Colors.grey,
                  )),
              followingFieldDecoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(
                    color: Colors.grey,
                  )),
              selectedFieldDecoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(
                    color: Colors.grey,
                  )),
              eachFieldHeight: 55,
              focusNode: _focusNode,
              controller: _pinOTPCode,
              pinAnimationType: PinAnimationType.rotation,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(
                    PhoneAuthProvider.credential(
                        verificationId: varificationCode!, smsCode: pin),
                  )
                      .then((value) {
                    if (value.user != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    }
                  });
                } catch (e) {
                  FocusScope.of(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Invalid Data'),
                    duration: Duration(seconds: 3),
                  ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
