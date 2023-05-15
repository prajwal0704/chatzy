import 'package:flutter/material.dart';

import '../../../firebase_services/apis.dart';

class NameSection extends StatefulWidget {
  const NameSection({Key? key}) : super(key: key);

  @override
  _NameSectionState createState() => _NameSectionState();
}

class _NameSectionState extends State<NameSection> {
  final _controller = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // TODO: load the saved about text from storage
    _controller.text = Apis.userSelfData.name;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveName() {
    Apis.userSelfData.name = _controller.text;
    Apis.updateUserInfo({'name':Apis.userSelfData.name});
    _toggleEditing();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 10,),
        if (_isEditing)
          Expanded(
            child: Container(
              width: 200,
              child: TextFormField(
                maxLength: 17,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                cursorHeight: 40,
                cursorColor: Colors.black,
                textAlign: TextAlign.center,
                controller: _controller,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 40),
                  hintText: 'Name',
                  counterText: '',
                  border: InputBorder.none,
                ),
                maxLines: null,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Name field cannot be empty';
                  }
                  return null;
                },
              ),
            ),
          )
        else
          Text(
            Apis.userSelfData.name,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        IconButton(
          icon: Icon(_isEditing ? Icons.done : Icons.edit),
          onPressed: () {
            if (_isEditing) {
              if (_controller.text.trim().isNotEmpty) {
                _saveName();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Name field cannot be empty'),
                ));
              }
            } else {
              _toggleEditing();
            }
          },
        ),
      ],
    );
  }
}


