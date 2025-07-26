module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            port: 8545,
            network_id: "31337",
        },
    },

    contracts_directory: "./contracts",

    mocha: {},

    compilers: {
        solc: {
            version: "0.8.21",
        },
    },
};
