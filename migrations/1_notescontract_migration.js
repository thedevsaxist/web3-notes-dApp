const NotesContract = artifacts.require("NotesContract"); // this is similar to [Node.js]'s [require] only that this imports a class not a file, and it specifically returns a contract abstraction.

// always use [CommonJS]. Migrations will fail otherwise
module.exports = async function (deployer) {
    await deployer.deploy(NotesContract);
    const contract = await NotesContract.at(NotesContract.address);
    console.log("✅ Contract deployed at:", contract.address);
};
