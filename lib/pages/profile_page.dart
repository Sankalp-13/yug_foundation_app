import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yug_foundation_app/pages/home_page.dart';
import 'package:yug_foundation_app/utils/colors.dart';

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

  final _genders = ["Male", "Female", "Other"];

  File? _imgFile;

  String? _currentSelectedValue;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: width * 0.4,
                    child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          "Tell us\nabout\nyourself 👋",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ))),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: width * 0.4,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: width*0.13,
                        backgroundImage: (_imgFile == null)
                            ? const AssetImage('assets/people.png')
                            : FileImage(_imgFile!) as ImageProvider,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text("Upload Photo"),
                      ElevatedButton(
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
                          child: const Text("Select Image"))
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 40,
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
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1920),
                            lastDate: DateTime.now());
                        setState(() {
                          birthdayController.text =
                              "${picked!.day}/${picked.month}/${picked.year}";
                        });
                      },
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
                    child: FormField<String>(
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
                              onChanged: (String? newValue) {
                                setState(() {
                                  _currentSelectedValue = newValue!;
                                  state.didChange(newValue);
                                });
                              },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(elevation: 0,backgroundColor: ColorConstants.mainThemeColor,foregroundColor: Colors.white,shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                          onPressed: ()  {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomePage()),(Route<dynamic> route) => false);
                          },
                          child: const Text("Save",style: TextStyle(fontSize: 18),)),
                      const SizedBox(width: 10,),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(elevation: 0,backgroundColor: Colors.transparent,foregroundColor: Colors.grey.shade300,shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                          onPressed: ()  {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomePage()),(Route<dynamic> route) => false);
                          },
                          child: const Text("Skip",style: TextStyle(fontSize: 18))),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
