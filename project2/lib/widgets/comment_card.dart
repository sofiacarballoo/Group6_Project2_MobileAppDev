import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap['profilePic'] ?? 'https://example.com/default-profile-pic.png', // Provide a default URL in case of null
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'] ?? 'Unknown User', // Provide a default text in case of null
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Ensure text color is set
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['text'] ?? ''}', // Provide a default text in case of null
                          style: const TextStyle(
                            color: Colors.black, // Ensure text color is set
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      widget.snap['datePublished'] != null
                          ? DateFormat.yMMMd().format(widget.snap['datePublished'].toDate())
                          : 'Date unknown', // Provide a default text in case of null
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey, // Ensure text color is set
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.favorite,
              size: 16,
              color: Colors.grey, // Ensure icon color is set
            ),
          ),
        ],
      ),
    );
  }
}
