import 'package:flutter/material.dart';

import '../../../firebase_services/apis.dart';

class AboutSection extends StatefulWidget {
  final String about;
  const AboutSection({Key? key, required this.about}) : super(key: key);

  @override
  _AboutSectionState createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  final _controller = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // TODO: load the saved about text from storage
    _controller.text = widget.about;
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

  void _saveAboutText() {
    Apis.userSelfData.about = _controller.text;
    Apis.updateUserInfo({'about':Apis.userSelfData.about});
    _toggleEditing();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'About',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            IconButton(
              icon: Icon(_isEditing ? Icons.done : Icons.edit),
              onPressed: _isEditing ? _saveAboutText : _toggleEditing,
            ),
          ],
        ),
        const SizedBox(height:4),
        if (_isEditing)
          TextFormField(
            cursorColor: Colors.black,
            controller: _controller,
            maxLength: 150,
            decoration: const InputDecoration(
              hintText: 'About',
              counterText: '',
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          )
        else
          Text(
            _controller.text,
            style: TextStyle(fontSize: isPortrait ? 16 : 20),
          ),
      ],
    );
  }
}
