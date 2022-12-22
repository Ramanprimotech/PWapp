import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pwlp/widgets/utility/Utility.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _desController = TextEditingController();

  FocusNode _nameNode = FocusNode();
  FocusNode _phoneNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _desNode = FocusNode();

  @override
  void initState() {
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _desController = TextEditingController();

    _nameNode = FocusNode();
    _phoneNode = FocusNode();
    _emailNode = FocusNode();
    _desNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff4725a3),
        title: const Text('Physicians Weekly',
            style: TextStyle(fontSize: 22, color: Colors.white)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('Assets/dashboard-bg.png'),
        //     fit: BoxFit.fill,
        //     alignment: Alignment.topCenter,
        //   ),
        // ),
        child: ListView(
          padding: const EdgeInsets.only(top: 30),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 32, bottom: 32),
                  child: const Text('Contact Us',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  // Image.asset("Assets/pw_logo.png"),
                ),
                InputTextField(
                  controller: _nameController,
                  focusNode: _nameNode,
                  textCapitalization: TextCapitalization.words,
                  label: 'Name',
                  hint: 'Enter Name',
                  textInputAction: TextInputAction.next,
                  validation: (value) {
                    value!.isEmpty ? 'Please Enter Name' : null;
                  },
                ),
                InputTextField(
                  controller: _emailController,
                  focusNode: _emailNode,
                  label: "Email",
                  hint: 'Enter Email',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp('[a-zA-Z0-9\.\-\@\_]')),
                    FilteringTextInputFormatter.deny(
                        RegExp('[\<\>\?\\\/\|\=\;\:]')),
                  ],
                  validation: (value) {
                    value!.isEmpty ? 'Please Enter Email' : null;
                  },
                ),
                InputTextField(
                  controller: _phoneController,
                  focusNode: _phoneNode,
                  label: "Phone",
                  hint: 'Enter Phone',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validation: (value) {
                    value!.isEmpty ? 'Please Enter Email' : null;
                  },
                ),
                InputTextField(
                  controller: _desController,
                  focusNode: _desNode,
                  label: "Message",
                  hint: 'Enter Message',
                  maxlines: 10,
                  maxlength: 1000,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validation: (value) {
                    value!.isEmpty ? 'Please Enter Message' : null;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff4725a3),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  validation() {
    FocusScope.of(context);
    equestFocus(FocusNode());
    // if (_nameController == "") {
    //   Utility.toast("Please Enter Name");
    // } else if (_phoneController == "") {
    //   Utility.toast("Please select category");
    // } else if (_emailController.text.trim().isEmpty) {
    //   Utility.toast("Please enter the description");
    // } else {}
  }

  void equestFocus(FocusNode focusNode) {}
}

class InputTextField extends StatelessWidget {
  const InputTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.label,
    this.hint,
    this.maxlines,
    this.validation,
    this.maxlength,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final textCapitalization;
  final String? label;
  final String? hint;
  final int? maxlines;
  final validation;
  final int? maxlength;
  final textInputAction;
  final keyboardType;
  final inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: TextFormField(
        autofocus: false,
        focusNode: focusNode,
        controller: controller,
        autocorrect: false,
        maxLength: maxlength ?? 50,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1),
            borderSide: const BorderSide(
              color: Color(0xff4725a3),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          counterText: "",
          labelText: label,
          labelStyle: TextStyle(
              fontSize: 16,
              color:
                  focusNode!.hasFocus ? const Color(0xff4725a3) : Colors.black),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 18, color: Colors.black),
          isDense: true,
        ),
        textInputAction: textInputAction,
        // minLines: 1,
        textAlign: TextAlign.start,
        keyboardType: keyboardType,
        maxLines: maxlines ?? 1,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validation,
        inputFormatters: inputFormatters,
      ),
    );
  }
}
