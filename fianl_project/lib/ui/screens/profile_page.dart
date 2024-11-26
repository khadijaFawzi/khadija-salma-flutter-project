import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fianl_project/constants.dart';
import 'package:fianl_project/ui/screens/widgets/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String name;
  late String email;
  String? imagePath; // متغير لتخزين مسار الصورة
  bool isEditingName = false;
  bool isEditingEmail = false;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // تعيين قيم افتراضية
    name = 'أحمد محمد';
    email = 'ahmed.mohamed@example.com';
    nameController.text = name;
    emailController.text = email;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path; // تحديث مسار الصورة
      });
    }
  }

  void saveChanges() {
    setState(() {
      name = nameController.text; // تحديث الاسم
      email = emailController.text; // تحديث البريد الإلكتروني
      isEditingName = false;
      isEditingEmail = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage, // استدعاء الدالة عند الضغط على الصورة
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Constants.primaryColor.withOpacity(.5),
                      width: 5.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: imagePath != null
                        ? FileImage(File(imagePath!)) // استخدام الصورة الجديدة
                        : ExactAssetImage('assets/images/profile.jpg'), // الصورة الافتراضية
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: isEditingName
                        ? TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: 'أدخل الاسم',
                              border: OutlineInputBorder(),
                            ),
                          )
                        : Text(
                            name,
                            style: TextStyle(
                              color: Constants.blackColor,
                              fontSize: 20,
                            ),
                          ),
                  ),
                  IconButton(
                    icon: Icon(
                      isEditingName ? Icons.check : Icons.edit,
                      color: Constants.primaryColor,
                    ),
                    onPressed: () {
                      if (isEditingName) {
                        saveChanges(); // حفظ التغييرات عند الضغط على علامة الصح
                      } else {
                        setState(() {
                          isEditingName = true; // تفعيل وضع التحرير
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: isEditingEmail
                        ? TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'أدخل البريد الإلكتروني',
                              border: OutlineInputBorder(),
                            ),
                          )
                        : Text(
                            email,
                            style: TextStyle(
                              color: Constants.blackColor.withOpacity(.3),
                            ),
                          ),
                  ),
                  IconButton(
                    icon: Icon(
                      isEditingEmail ? Icons.check : Icons.edit,
                      color: Constants.primaryColor,
                    ),
                    onPressed: () {
                      if (isEditingEmail) {
                        saveChanges(); // حفظ التغييرات عند الضغط على علامة الصح
                      } else {
                        setState(() {
                          isEditingEmail = true; // تفعيل وضع التحرير
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // بقية المحتوى مثل الأزرار أو الخيارات الأخرى
              SizedBox(
                height: size.height * .7,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    ProfileWidget(
                      icon: Icons.person,
                      title: 'My Profile',
                    ),
                    ProfileWidget(
                      icon: Icons.settings,
                      title: 'Settings',
                    ),
                    ProfileWidget(
                      icon: Icons.notifications,
                      title: 'Notifications',
                    ),
                    ProfileWidget(
                      icon: Icons.chat,
                      title: 'FAQs',
                    ),
                    ProfileWidget(
                      icon: Icons.share,
                      title: 'Share',
                    ),
                    ProfileWidget(
                      icon: Icons.logout,
                      title: 'Log Out',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}