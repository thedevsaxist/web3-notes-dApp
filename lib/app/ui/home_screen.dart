import 'package:default_ui_components/default_ui_components.dart';
import 'package:default_ui_components/primary_button.dart';
import 'package:default_ui_components/text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web3demo/app/service/notes_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _buttonFocusNode = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesServiceProvider = context.watch<INotesService>();

    final black = Color(0xFF121212);
    final white = Color(0xFFF5F5F5);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(title: Text("dApp")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(minHeight: 200),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.builder(
                      itemCount: notesServiceProvider.notes.length,
                      itemBuilder: (context, index) {
                        final note = notesServiceProvider.notes[index];
                        print(
                          "The list should be showing. Title: ${note.title}. Description: ${note.description}",
                        );
                        return ListTile(
                          title: Text(note.title),
                          subtitle: Text(note.description),
                          trailing: IconButton(
                            onPressed: null,
                            icon: Icon(CupertinoIcons.delete, color: Colors.red),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                TextInput(
                  label: "Title",
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  focusNode: _titleFocusNode,
                  nextFocusNode: _buttonFocusNode,
                ),

                const SizedBox(height: 10),

                TextInput(
                  label: "Description",
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  focusNode: _descriptionFocusNode,
                  nextFocusNode: _buttonFocusNode,
                ),

                const SizedBox(height: 40),

                PrimaryButton(
                  onPressed: () {
                    // showCircularProgressIndicator(context: context, valueColor: black);

                    notesServiceProvider.addNote(
                      _titleController.text.trim(),
                      _descriptionController.text.trim(),
                    );

                    _titleController.clear();
                    _descriptionController.clear();

                    // Navigator.pop(context);
                  },
                  label: "Post",
                  buttonColor: black,
                  labelColor: white,
                  focusNode: _buttonFocusNode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
