import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:phone_authentication/otpcontroller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String countryCode = '+00';
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone(OTP) authentication'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/login1.jpg'),
          ),
          SizedBox(
            width: 400,
            height: 60,
            child: CountryCodePicker(
              onChanged: (country) {
                setState(() {
                  countryCode = country.dialCode!;
                });
              },
              initialSelection: 'BAN',
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
              top: 10,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Phone number',
                prefix: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(countryCode),
                ),
              ),
              maxLength: 12,
              keyboardType: TextInputType.number,
              controller: _controller,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OTPControllerScreen(
                      phoneNo: _controller.text,
                      digits: countryCode,
                    ),
                  ),
                );
              },
              child: const Text('NEXT'),
            ),
          )
        ],
      ),
    );
  }
}
