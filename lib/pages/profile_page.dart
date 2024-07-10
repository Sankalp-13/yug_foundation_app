import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:yug_foundation_app/pages/login_signup/login_page.dart';
import 'package:yug_foundation_app/utils/colors.dart';

import '../providers/profile/profile_cubit.dart';
import '../providers/profile/profile_states.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  final _genders = ["MALE", "FEMALE", "OTHER"];

  @override
  void initState() {
    super.initState();

    BlocProvider.of<ProfileCubit>(context).getProfile();

  }

  File? _imgFile;

  String? _currentSelectedValue;

  bool update = false;
  DateTime? birthdayPicked;

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
        child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (BuildContext context, ProfileState state) {
              if(state is ProfileLoadingState){
                context.loaderOverlay.show();
              }
              if (state is ProfileErrorState) {
                context.loaderOverlay.hide();
                SnackBar snackBar = SnackBar(
                  content: Text(state.error),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }if (state is ProfileDefaultState) {
                context.loaderOverlay.hide();
                emailController.text = state.profileResponseModel.email!;
                DateTime savedDate = DateTime.parse(state.profileResponseModel.birthday!);
                birthdayPicked = savedDate;
                birthdayController.text ="${savedDate.day}/${savedDate.month}/${savedDate.year}";
                contactController.text = state.profileResponseModel.contact!;
                locationController.text = state.profileResponseModel.location!;
                ageController.text = state.profileResponseModel.age!.toString();
                nameController.text = state.profileResponseModel.name!;
                _currentSelectedValue = state.profileResponseModel.gender;
                genderController.text  = state.profileResponseModel.gender!;
              }
              if(state is ProfileUpdateState){
                context.loaderOverlay.hide();
                setState(() {
                  update = true;
                });
              }
            },
            builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: SizedBox(
                      width: width * 0.4,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: width*0.13,
                            backgroundImage: (_imgFile == null)
                                ? const AssetImage('assets/people.png')
                                : FileImage(_imgFile!) as ImageProvider,
                          ),
                          Visibility(
                            visible: update,
                            child: const SizedBox(
                              height: 8,
                            ),
                          ),
                          Visibility(
                              visible: update,child: const Text("Upload Photo")),
                          Visibility(
                            visible: update,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(elevation: 0,backgroundColor: ColorConstants.mainThemeColor,foregroundColor: Colors.white,shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? img = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    // alternatively, use ImageSource.gallery
                                  );
                                  if (img == null) return;
                                  setState(() {
                                    _imgFile = File(
                                        img.path); // convert it to a Dart:io file
                                  });
                                },
                                child: const Text("Select Image")),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Name",
                              style: TextStyle(fontSize: 16),
                            )),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            readOnly: !update,
                            controller: nameController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8),
                                filled: true,
                                fillColor: Colors.grey.shade300,
                                border:
                                    const OutlineInputBorder(borderSide: BorderSide.none)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Age",
                              style: TextStyle(fontSize: 16),
                            )),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            readOnly: !update,
                            controller: ageController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8),
                                filled: true,
                                fillColor: Colors.grey.shade300,
                                border:
                                    const OutlineInputBorder(borderSide: BorderSide.none)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Birthday",
                              style: TextStyle(fontSize: 16),
                            )),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            onTap: update?() async {
                             birthdayPicked = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1920),
                                  lastDate: DateTime.now());
                              setState(() {
                                birthdayController.text =
                                    "${birthdayPicked!.day}/${birthdayPicked?.month}/${birthdayPicked?.year}";
                              });
                            }:(){},
                            controller: birthdayController,
                            readOnly: true,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8),
                                filled: true,
                                fillColor: Colors.grey.shade300,
                                border:
                                    const OutlineInputBorder(borderSide: BorderSide.none)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Location",
                              style: TextStyle(fontSize: 16),
                            )),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            readOnly: !update,
                            controller: locationController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8),
                                filled: true,
                                fillColor: Colors.grey.shade300,
                                border:
                                    const OutlineInputBorder(borderSide: BorderSide.none)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Gender",
                              style: TextStyle(fontSize: 16),
                            )),
                        SizedBox(
                          height: 40,
                          child: update?FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey.shade300,
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 10),
                                    hintText: 'Select an option',
                                    hintStyle: const TextStyle(fontSize: 16.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide.none)),
                                isEmpty: _currentSelectedValue == '',
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    borderRadius: BorderRadius.circular(5),
                                    dropdownColor: Colors.grey.shade300,
                                    value: _currentSelectedValue,
                                    onChanged: update?(String? newValue) {
                                      setState(() {
                                        _currentSelectedValue = newValue!;
                                        state.didChange(newValue);
                                      });
                                    }:null,
                                    items: _genders.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ):TextField(
                            readOnly: !update,
                            controller: genderController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8),
                                filled: true,
                                fillColor: Colors.grey.shade300,
                                border:
                                const OutlineInputBorder(borderSide: BorderSide.none)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Email",
                              style: TextStyle(fontSize: 16),
                            )),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            readOnly: !update,
                            controller: emailController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8),
                                filled: true,
                                fillColor: Colors.grey.shade300,
                                border:
                                    const OutlineInputBorder(borderSide: BorderSide.none)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Contact Number",
                              style: TextStyle(fontSize: 16),
                            )),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            readOnly: !update,
                            controller: contactController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8),
                                filled: true,
                                fillColor: Colors.grey.shade300,
                                border:
                                    const OutlineInputBorder(borderSide: BorderSide.none)),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Visibility(
                          visible: !update,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SizedBox(
                              //   width: width*0.3,
                              //   child: ElevatedButton(
                              //       style: ElevatedButton.styleFrom(elevation: 0,backgroundColor: ColorConstants.mainThemeColor,foregroundColor: Colors.white,shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                              //       onPressed: ()  {
                              //         // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomePage()),(Route<dynamic> route) => false);
                              //         BlocProvider.of<ProfileCubit>(context).updateProfileState();
                              //       },
                              //       child: const Text("Update",style: TextStyle(fontSize: 18),)),
                              // ),
                              // SizedBox(width: 18,),
                              SizedBox(
                                width: width*0.3,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(elevation: 0,backgroundColor: ColorConstants.mainThemeColor,foregroundColor: Colors.white,shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                                    onPressed: ()  {
                                      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomePage()),(Route<dynamic> route) => false);
                                      _logoutDialog(width);
                                    },
                                    child: const Text("Logout",style: TextStyle(fontSize: 18),)),
                              ),
                            ],
                          ),
                        ),

                        Visibility(
                          visible: update,
                          child: SizedBox(
                            width: width*0.3,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(elevation: 0,backgroundColor: ColorConstants.mainThemeColor,foregroundColor: Colors.white,shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                                onPressed: ()  {
                                  // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomePage()),(Route<dynamic> route) => false);
                                  // BlocProvider.of<ProfileCubit>(context).updateProfileState();
                                  String formattedDate =
                                      "${DateFormat('yyyy-MM-ddThh:mm:ss.SSS').format(birthdayPicked!)}Z";
                                  print(formattedDate);
                                  BlocProvider.of<ProfileCubit>(context).sendUpdatedProfile(
                                      emailController.text,
                                      int.parse(ageController.text),
                                      formattedDate,
                                      locationController.text,
                                      _currentSelectedValue!,
                                      contactController.text,
                                      "",
                                      nameController.text);
                                },
                                child: const Text("Save",style: TextStyle(fontSize: 18),)),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }


  void _logoutDialog(double screenWidth) {
    double w = screenWidth / 390.11;
    showGeneralDialog(
        // barrierColor: ColorConstants.lightWidgetColor.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                // backgroundColor: ColorConstants.lightWidgetColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text(
                  'Are you sure you want to log out?',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(16))),
                        side:
                        BorderSide(color: ColorConstants.mainThemeColor),
                        foregroundColor: ColorConstants.mainThemeColor),
                    onPressed: () {
                      FlutterSecureStorage().deleteAll();
                      Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context)=> const LoginPage()),(route) => false);

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Logout",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 17 * w, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.mainThemeColor,
                      foregroundColor: Colors.white,
                      // Background color
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(16))),
                    ),
                    onPressed: () {
                      Navigator.pop(context);

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Cancel",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 17 * w, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }
}
