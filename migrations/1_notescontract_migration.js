const NotesContract = artifacts.require("NotesContract"); // this is similar to [Node.js]'s [require] only that this imports a class not a file, and it specifically returns a contract abstraction.

export default function (deployer) {
    deployer.deploy(NotesContract);
};
