import 'package:flutter/material.dart';
import 'package:yug_foundation_app/pages/profile_page.dart';
import 'package:yug_foundation_app/utils/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 32,
            ),
            const Text(
              "Create an account",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Akshar',
                  fontSize: 30),
            ),
            const SizedBox(
              height: 42,
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Enter your mobile number:",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Akshar',
                    fontSize: 17),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: 60,
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(color: Colors.black, width: 4)))),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 20),
                    height: 56,
                    child: TextField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          labelText: 'Mobile Number',
                          labelStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Center(
              child: SizedBox(
                width: width * 0.9,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ProfilePage()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.mainThemeColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        )),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Continue",
                        style: TextStyle(fontSize: 16),
                      ),
                    )),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(
                  child: Text(
                "or",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              )),
            ),
            Center(
              child: SizedBox(
                width: width * 0.9,
                child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    )),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_2_outlined),
                          Text(
                            "Login as Guest",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Center(
              child: SizedBox(
                width: width * 0.9,
                child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        )),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.g_mobiledata),
                          Text(
                            "Continue with Google",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            Center(
                child: SizedBox(
                    width: width * 0.4,
                    child: const Text(
                      "By signing up, you agree to our Terms of Service and Privacy Policy",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          fontSize: 12),
                      textAlign: TextAlign.center,
                    ))),
            const Expanded(child: SizedBox()),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Already have an account?",style: TextStyle(fontSize: 16),),
                  Text("Log in",style: TextStyle(color: Colors.blue,fontSize: 16),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
