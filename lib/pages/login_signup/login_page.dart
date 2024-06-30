import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:yug_foundation_app/pages/login_signup/signup_page.dart';
import 'package:yug_foundation_app/utils/colors.dart';

import '../../providers/login_signup/login_signup_cubit.dart';
import '../../providers/login_signup/login_signup_state.dart';
import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  bool showCheck= false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark
      ),
      body: SafeArea(
        child:
        BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginErrorState) {

                context.loaderOverlay.hide();
                SnackBar snackBar = SnackBar(
                  content: Text(state.error),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
              if (state is OtpSentState) {

                context.loaderOverlay.hide();
                Navigator.push(context, MaterialPageRoute(builder: (context)=> OtpPage(otpId: state.otpId,)));
              }
              if (state is InvalidEmailState) {

                context.loaderOverlay.hide();
                SnackBar snackBar = SnackBar(
                  content: Text(state.errorMsg.message![0]),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

              if (state is LoginLoadingState){
                // showDialog(
                //   context: context,
                //   barrierDismissible: false,
                //   builder: (context) {
                //     return const Center(
                //       child: CircularProgressIndicator(
                //         strokeWidth: 3,
                //       ),
                //     );
                //   },
                // );

                context.loaderOverlay.show();

              }

            }, builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    const Text(
                      "Welcome,",
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
                        "Please sign in to your account",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Akshar',
                            fontSize: 17),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 20),
                      height: 56,
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration:  InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.grey),
                          suffixIcon: SizedBox(
                            height: 18,
                            width: 18,
                            child: showCheck==true?Lottie.asset("assets/email_check.json",repeat: false):Container(),
                          ),
                        ),

                        onChanged: (email){
                          print(email);
                          if ( RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(emailController.text)) {
                            setState(() {
                              showCheck=true;
                            });
                            print(showCheck);

                          }else{
                            setState(() {
                              showCheck=false;
                            });
                          }
                        },

                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Center(
                      child: SizedBox(
                        width: width * 0.9,
                        child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<LoginCubit>(context).login(emailController.text);
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
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Don't have an account?",style: TextStyle(fontSize: 16),),
                            SizedBox(width: 12,),
                            GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                                },
                                child: Text("Sign Up",style: TextStyle(color: Colors.blue,fontSize: 16),)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
