import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pinput/pinput.dart';
import 'package:yug_foundation_app/pages/home_page.dart';
import 'package:yug_foundation_app/utils/colors.dart';

import '../../providers/login_signup/login_signup_cubit.dart';
import '../../providers/login_signup/login_signup_state.dart';

class OtpPage extends StatefulWidget {
  String otpId;
  OtpPage({Key? key,required this.otpId}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController otpController = TextEditingController();


  String otp="";
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
                // Navigator.of(context).popUntil((route) => route.isFirst);
              }
              if (state is OtpVerifiedState) {
                context.loaderOverlay.hide();
                Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context)=> HomePage(profileResponseModel: state.profileResponseModel)),(route) => false);
              }
              if (state is InvalidEmailState) {
                context.loaderOverlay.hide();
                SnackBar snackBar = SnackBar(
                  content: Text(state.errorMsg),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              if (state is LoginLoadingState){
                context.loaderOverlay.show();
              }
            },
            builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "Verify your Email,",
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
                        "Please verify email with otp",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Akshar',
                            fontSize: 17),
                      ),
                    ),
                    Center(child: buildOtp()),
                    const SizedBox(
                      height: 32,
                    ),
                    Center(
                      child: SizedBox(
                        width: width * 0.9,
                        child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<LoginCubit>(context).verifyOtp(widget.otpId, int.parse(otp));
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
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Widget buildOtp() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: ColorConstants.mainThemeColor),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      // border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: ColorConstants.lightWidgetColor,
      ),
    );

    return Pinput(
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      length: 6,

      showCursor: true,
      onCompleted: (pin) => otp = pin,
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 9),
            width: 22,
            height: 1,
            color: ColorConstants.mainThemeColor,
          ),
        ],
      ),
    );
  }
}
