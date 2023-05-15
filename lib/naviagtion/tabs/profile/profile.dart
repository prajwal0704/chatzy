import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatzy/firebase_services/apis.dart';
import 'package:chatzy/homepage.dart';
import 'package:chatzy/naviagtion/tabs/profile%20/image_croper.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../login/sign_in_page.dart';
import 'about_section.dart';
import 'nmaesection.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}
final imageHelper = ImageHelper();
class _ProfileTabState extends State<ProfileTab> {
  File? _image;
  String value = Apis.userSelfData.phone;
  bool isEmailFocused = false;
  bool isPhoneFocused = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const HomePage(selectedIndex: 0),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_back_ios)),
                      const Text(
                        "Profile",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const NewWidget();
                            },
                          );
                        },
                        icon: const Icon(Icons.logout),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 15,
                        ),
                        borderRadius: BorderRadius.circular(300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            spreadRadius: 10,
                            blurRadius: 20,
                            offset: const Offset(5, 4),
                          ),
                          const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-5, -5),
                              blurRadius: 20,
                              spreadRadius: 10),
                        ],
                      ),
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(30 * 4),
                              child: Image.file(
                              _image!,
                                width: MediaQuery.of(context).size.height *
                                    .077 *
                                    2.7,
                                height: MediaQuery.of(context).size.height *
                                    .077 *
                                    2.7,
                                fit: BoxFit.cover,
                              ),
                            )
                          : GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 400,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: InteractiveViewer(
                                      maxScale: 5,
                                      child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          imageUrl: Apis.userSelfData.image,
                                          //placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                          const Icon(Icons.image,size: 70,)
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(30 * 4),
                                child: InteractiveViewer(
                                  maxScale: 5,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.height *
                                        .077 *
                                        2.7,
                                    height: MediaQuery.of(context).size.height *
                                        .077 *
                                        2.7,
                                    imageUrl: Apis.userSelfData.image,
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Center(
                                          child: Icon(
                                        Icons.person,
                                        color: Colors.black,
                                        size: 50,
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                          ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 35,
                      child: MaterialButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  color: const Color(0xff737373),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20)),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Center(
                                          child: Container(
                                            height: 5,
                                            width: 50,
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Center(
                                          child: Text(
                                            'Edit Profile Photo',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey.shade400,
                                                        spreadRadius: 1,
                                                        blurRadius: 15,
                                                        offset: const Offset(5, 4),
                                                      ),
                                                      const BoxShadow(
                                                        color: Colors.white,
                                                        offset: Offset(-5, -5),
                                                        blurRadius: 15,
                                                        spreadRadius: 1,
                                                      ),
                                                    ]
                                                ),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 60,
                                                  child: ClipOval(
                                                    child: SizedBox(
                                                      width: 100,
                                                      height: 100,
                                                      child: IconButton(
                                                        onPressed: () async {
                                                          final files = await imageHelper.pickImage();
                                                          if(files.isNotEmpty){
                                                            final croppedFile = await imageHelper.crop(file: files.first,cropStyle: CropStyle.circle);
                                                            if(croppedFile != null){
                                                              setState(() {
                                                                _image = File(croppedFile.path);
                                                              });
                                                              Apis.updateProfilePic(_image!);
                                                              // ignore: use_build_context_synchronously
                                                              Navigator.pop(context);
                                                            }
                                                          }
                                                        },
                                                        icon: const Icon(
                                                          Icons.image,
                                                          color: Colors
                                                              .black,
                                                          size: 70,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey.shade400,
                                                        spreadRadius: 1,
                                                        blurRadius: 15,
                                                        offset: const Offset(5, 4),
                                                      ),
                                                      const BoxShadow(
                                                        color: Colors.white,
                                                        offset: Offset(-5, -5),
                                                        blurRadius: 15,
                                                        spreadRadius: 1,
                                                      ),
                                                    ]
                                                ),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 60,
                                                  child: ClipOval(
                                                    child: SizedBox(
                                                      width: 100,
                                                      height: 100,
                                                      child: IconButton(
                                                        onPressed: () async {
                                                         final files = await imageHelper.pickImage(
                                                           source: ImageSource.camera
                                                         );
                                                         if(files.isNotEmpty){
                                                           final croppedFile = await imageHelper.crop(file: files.first,cropStyle: CropStyle.circle);
                                                           if(croppedFile != null){
                                                             setState(() {
                                                               _image = File(croppedFile.path);
                                                             });
                                                             Apis.updateProfilePic(_image!);
                                                             // ignore: use_build_context_synchronously
                                                             Navigator.pop(context);
                                                           }
                                                         }
                                                        },
                                                        icon: const Icon(
                                                          Icons.camera_alt,
                                                          color:
                                                              Colors.black,
                                                          size: 70,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        minWidth: 35,
                        shape: const CircleBorder(),
                        color: Colors.black,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
                const NameSection(),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          spreadRadius: 1,
                          blurRadius: 15,
                          offset: const Offset(5, 4),
                        ),
                        const BoxShadow(
                          color: Colors.white,
                          offset: Offset(-5, -5),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            enabled: false,
                            initialValue: Apis.userSelfData.email,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Phone',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            cursorColor: Colors.black,
                            maxLength: 10,
                            onChanged: (val) {
                              setState(() {
                                value = val;
                                // update isPhoneFocused based on whether the phone field is currently focused or not
                                isPhoneFocused = val.isNotEmpty;
                              });
                            },
                            keyboardType: TextInputType.number,
                            initialValue: Apis.userSelfData.phone,
                            onFieldSubmitted: (String value) {
                              if (value.length == 10) {
                                Apis.userSelfData.phone = value;
                                Apis.updateUserInfo(
                                    {'phone': Apis.userSelfData.phone});
                                // remove focus from the phone field
                                isPhoneFocused = false;
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Please enter 10 digit phone number '),
                                ));
                              }
                            },
                            decoration: InputDecoration(
                              counterText: '',
                              prefix: const Text('+91 '),
                              suffixIcon: isPhoneFocused && value.length == 10
                                  ? IconButton(
                                      onPressed: () {
                                        if (value.length == 10) {
                                          Apis.userSelfData.phone = value;
                                          Apis.updateUserInfo({
                                            'phone': Apis.userSelfData.phone
                                          });
                                          // remove focus from the phone field
                                          isPhoneFocused = false;
                                          FocusScope.of(context).unfocus();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                'Please enter 10 digit phone number '),
                                          ));
                                        }
                                      },
                                      icon: const Icon(Icons.done,
                                          color: Colors.black),
                                    )
                                  : null, // hide the suffix icon button when the phone field is focused
                              hintText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          AboutSection(
                            about: Apis.userSelfData.about,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm exit'),
      content: const Text(
          'Are you sure you want to exit?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Exit'),
          onPressed: () {
            Apis.auth.signOut().then(
                  (value) => {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SignInPage()),
                        ModalRoute.withName('/'))
                  },
                );
          },
        ),
      ],
    );
  }
}