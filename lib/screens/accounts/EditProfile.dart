import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../Components/appbar_text.dart';
import '../../Config/api_helper.dart';

class ChangeProfile extends StatefulWidget {
  const ChangeProfile({Key? key}) : super(key: key);

  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  String? uID;
  bool isLoading = false;
  List<String> base64Images = [];
  File? _pickedImage;

  String? data;
  Map? responseData;
  List? dataList;

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailIdController = TextEditingController();

  String? date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  DateTime _dateTime = DateTime.now();

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    ).then((value) {
      if (value != null) {
        setState(() {
          _dateTime = value;
          date = DateFormat('yyyy-MM-dd').format(_dateTime).toString();
        });
      }
    });
  }

  int index = 0;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");
    apiForProfile();
  }

  void convertImageToBase64() async {
    if (_pickedImage != null) {
      final bytes = await _pickedImage!.readAsBytes();
      final String base64Image = base64Encode(bytes);
      setState(() {
        base64Images.add(base64Image);
      });
    }
  }

  void selectImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
      convertImageToBase64();
    }
  }

  Future<void> apiForProfile() async {
    try {
      var response = await ApiHelper().post(endpoint: "common/profile", body: {
        "id": uID,
      });
      if (response != null) {
        setState(() {
          debugPrint('profile api successful:');
          data = response.toString();
          responseData = jsonDecode(response);
          dataList = responseData?["data"];
          if (kDebugMode) {
            print(responseData.toString());
          }

          firstnameController.text = dataList![0]["first_name"];
          lastnameController.text = dataList![0]["last_name"];
          emailIdController.text = dataList![0]["email"];
        });
      } else {
        debugPrint('api failed:');
      }
    } catch (err) {
      debugPrint('An error occurred: $err');
    }
  }

  editProfile() async {
    if (base64Images.isNotEmpty) {
      var response = await ApiHelper().post(
        endpoint: "common/updateProfile",
        body: {
          "first_name": firstnameController.text,
          "last_name": lastnameController.text,
          "email": emailIdController.text,
          "dob": date.toString(),
          "id": uID,
          "imageUrl": base64Images[0],
        },
      ).catchError((err) {});

      if (response != null) {
        setState(() {
          debugPrint('edit profile api successful:');

          Fluttertoast.showToast(
            msg: "Profile Edited Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          // Navigate back to the settings page
          Navigator.pop(context);
        });
      } else {
        debugPrint('edit profile failed:');
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please select an image",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "Edit Profile",
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
              Colors.grey.shade400,
              Colors.grey.shade200,
              Colors.grey.shade50,
              Colors.grey.shade200,
              Colors.grey.shade400,
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                _pickedImage != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(_pickedImage!),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/contactavatar.png"),
                      ),
                IconButton(
                  onPressed: () {
                    selectImage();
                  },
                  icon: Icon(Icons.add_a_photo, color: Colors.teal[900]),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35, right: 35, top: 20, bottom: 20),
              child: TextFormField(
                controller: firstnameController,
                decoration: InputDecoration(
                  labelText: "First Name",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter a valid name';
                  } else {
                    return null;
                  }
                },
                textInputAction: TextInputAction.done,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35, right: 35, top: 20, bottom: 20),
              child: TextFormField(
                controller: lastnameController,
                decoration: InputDecoration(
                  labelText: "Last Name",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter a valid name';
                  } else {
                    return null;
                  }
                },
                textInputAction: TextInputAction.done,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35, right: 35, top: 20, bottom: 40),
              child: TextFormField(
                controller: emailIdController,
                decoration: InputDecoration(
                  labelText: "Email Id ",
                ),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Enter a valid Email ID';
                  } else {
                    return null;
                  }
                },
                textInputAction: TextInputAction.done,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 35,
                right: 35,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date of Birth",
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 10),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(date!),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        _showDatePicker();
                      },
                      icon: Icon(
                        Iconsax.calendar,
                        size: 30,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, bottom: 20),
              child: Divider(
                thickness: 2,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    editProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[900],
                    shadowColor: Colors.teal[300],
                  ),
                  child: Text("Submit"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
