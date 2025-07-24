// SPDX-License-Identifier: MIT 
pragma solidity >=0.4.22<=0.9.0;

// this is like a class
contract NotesContract{
	uint256 public noteCount = 0;  // this is just like a regular variable

	// this is like a model 
	struct Note {
		uint256 id;
		string title;
		string description;
	}

	// this is like a dictionary or map. The key is of type uint256 and the value is of type [Note]
	// so essentially, it stores [Note] values that can be accessed using the id of type uint256
	mapping(uint256 => Note) public notes;

	// this is basically [state]. Just like events in [bloc].
	// they don't hold the logic for events. That happens in functions/methods.
	event NoteCreated(uint256 id, string title, string description);
	event NoteDeleted(uint256 id);

	/* 
		This is a a function that takes in parameters [_title] and [_description].
		The [memory] keyword is used to temporarily store variables and their values.
		We can use the [calldata] for function that have parameters marked as external--used in external functions.

		The [emit] keyword here basically acts as the return statement emiting a [state] that the client can read, which is basically the data. In this case, it's the [NoteCreated] state which has the [id], [title], and [description] of the [Note].
	*/
	function createNote(string memory _title, string memory _description) public {
		notes[noteCount] = Note(noteCount, _title, _description);
		emit NoteCreated(noteCount, _title, _description);
		noteCount++;
	}

	/*
		Data on the blockchain can never be deleted, so this doesn't delete the data entirely.
		It just resets the value of that variable holding the data so that it can be reallocated to hold a different piece of data.

		For [Arrays], we change the value at that index to 0. 
		The length of the array remaind the same, that's why need need to decrease the length of the [Array] manually.
		Then of course, we emit the [NoteDeleted] state.
	*/
	function deleteNote(uint256 _id) public {
		delete notes[_id];
		emit NoteDeleted(_id);
		noteCount--;
	}
}