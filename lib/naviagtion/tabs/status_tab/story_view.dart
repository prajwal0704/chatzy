import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
class MoreStories extends StatefulWidget {
  final Map<String, List<String>> story;
  const MoreStories({super.key, required this.story});

  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyItems = <StoryItem>[];
    if (widget.story != null) {
      final captionList = widget.story['caption'];
      final typeList = widget.story['type'];
      final urlList = widget.story['url'];
      final count = typeList?.length??0;
      for (var i = 0; i < count; i++) {
        final type = typeList?[i] ?? "";
        final url = urlList?[i] ?? "";
        final caption = captionList?[i] ?? "";
        if (type == 'text') {
          print(url);
          storyItems.add(
            StoryItem.text(
              title: url,
              backgroundColor: Colors.blue,
            ),
          );
        } else if (type == 'image') {
          print(url);
          storyItems.add(
            StoryItem.pageImage(
              url: url,
              caption: caption,
              controller: storyController,
            ),
          );
        }
      }
    }
    return Scaffold(
      body: StoryView(
        storyItems: storyItems,
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}