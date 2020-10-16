# Ethereum Contract - Hello World

## Creating your first ethereum contract

### 1. Basic tools

#### 1.1. Node JS
Use the LTS version that is more stable. 

For this POC purpose I'm using v12.19.0

```
$ nvm install 12
```

#### 1.2. Solidity
Solidity is an object-oriented, high-level language for implementing smart contracts.
This tool will compile our ETH contract.
You can find different versions of solidity. 

For this POC you should use 0.7.x. I've installed 0.7.3

The API should change in other releases.

```
$ npm install -g solc
$ npm link solc
```

#### 1.3. testrpc

testrpc is a Node.js based Ethereum client for testing and development

```
npm install -g ethereumjs-testrpc
```


#### 1.4. web3.js

Collection of libraries that allow you to interact with a local or remote ethereum node using HTTP, IPC or WebSocket.

```
$ npm install -g web3
$ npm link web3
```

### 2. Compile the ETH contract

HelloWorld.sol is our contract. 

To ge more info about ETH contract take a look here: https://solidity.readthedocs.io/en/v0.7.3/layout-of-source-files.html


```
solcjs HelloWorld.sol --bin --abi
```

After compilation you will find 2 new files.


### 3. Start the test rpc client

Open a new terminal and execute:

```
$ testrpc
```

Let this terminal open. You will get something like this:

```
EthereumJS TestRPC v6.0.3 (ganache-core: 2.0.2)

Available Accounts
==================
(0) 0xf453ac731ccabb802115a6654063d8f7c2c868ae
(1) 0x107d57f87a6c856553745d4a278bf7d68984ef81
(2) 0xcd5bda77117fe657eaa0654e772e60235cd3f4e2
(3) 0xa5bc87a5b6db80b4a9374a3d741f473b00eb440b
(4) 0x07de470434f96ef9ed7475ed37d755b592ff1d7f
(5) 0x5dadb68f678b2e646ffcc29c70ee30de7ec93e9b
(6) 0x017226de486ddaf8ad42ba21d9a6c5987aadbdc0
(7) 0xd66fc19dfaee340dc873c4fb45dbb7f19d6a78c4
(8) 0xcd5e9d3a5822bfb0a08ba69637deb8027ab22fed
(9) 0x0d45bcb118e8191f8cf9010e979a92e8370dd34c

Private Keys
==================
(0) 441e3436173d216b3ec245de131b81aa460325e57d09aac0139ee83d8c8134b2
(1) 4ef2cc87a4d51d5e3ad21ed78ce3f2f890e509a24c053da70a8be52ab0cba917
(2) 0bacba69de2b2f8a41b4f65d3d7ddc5e077cdadc4399788fce125522338a4fe7
(3) 08aee5e5072f8ee197743dbfe8ceaab2c76a157b1c9a90206a161b000f745e11
(4) f160f8223436f593dd1ff47e5c82ad2cd66e134a84047d29320e6eb310cae661
(5) e644777260477542a4c78fc41ef1ea52cb766d88ca88076b0134412049416bb5
(6) 66f198efc60120adb0667587ee7fa0cd2e2e05ced36ad0fb2d18a37dc2d44fbb
(7) 50166784607f2e899539040731cf875e4d62f50f5a54f5fa4b8354e8cbac2b0b
(8) 34482dee0345a4e76ce4bf6ea4b02f90fb2cec2a367f42a47cd5b0d9945616ca
(9) 27c8cd433f901552b6f6ce7af389fc9d43b51ef185cd968acd695709552c58d9

HD Wallet
==================
Mnemonic:      hunt gaze input bomb fit arena peanut bless call bid soup violin
Base HD Path:  m/44'/60'/0'/0/{account_index}

Listening on localhost:8545

```

Take a note of any hash of the available account like the first one: `0xf453ac731ccabb802115a6654063d8f7c2c868ae`

We will use this address in the next topic.


### 3. Deploy the Contract

Open a node cli session in other terminal window:

```
$ node
```

And paste the commands bellow:

```
   > var Web3 = require('web3');
   > var solc = require('solc');
   > var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
   > var source = fs.readFileSync('./HelloWorld.sol', 'utf8').toString();
   > var solcInput = {
        language: "Solidity",
        sources: { 
            contract: {
                content: source
            }
        },
        settings: {
            outputSelection: {
            '*': {
                '*': ['*']
            }
            }
        }
    }

```

We have to wrap the source contract into a JSON structure `solcInput`.

Add more few lines:

```
   > solcInput = JSON.stringify(solcInput);
   > var compiledContract = JSON.parse(solc.compile(solcInput));
   > var abi = compiledContract.contracts.contract.HelloWorld.abi;
   > var evm = compiledContract.contracts.contract.HelloWorld.evm;
   > var HelloWorld = new web3.eth.Contract(abi);
   > var HelloWorldTx = HelloWorld.deploy({data: "0x" + evm['bytecode'].object, arguments: [web3.utils.asciiToHex('Hello')]});

```

If you take a look at our contract (HelloWorld.sol) the constructor expect a message (bytes32) that is a Hex string

```
...
    constructor(bytes32 theMessage) {
        message = theMessage;
    }
...

```

web3 has a function to transform ascii to Hex and we pass as `arguments` 

```
arguments: [web3.utils.asciiToHex('Hello')]
```

So far soo good. You can inspect HelloWorld and HelloWorldTx to get more familiar with the available functions of those objects.

Now is time to send you contract.

Replace the account hash `0xf453ac731ccabb802115a6654063d8f7c2c868ae` with one of your available accounts printed in the console.

```
   > HelloWorldTx.send({from: '0xf453ac731ccabb802115a6654063d8f7c2c868ae', gas: 500000}).then(console.log)
```

After this your contract will be registered and deployed

Take a look at your testrpc terminal:

```
eth_gasPrice
eth_sendTransaction

  Transaction: 0xf40775cc23fcdc947da801dbb14eeff7f8849b5e0a76d190a26a55ef92527cf3
  Contract created: 0xc9105da79305be8a8b182aae4855875b2d924023
  Gas usage: 115204
  Block Number: 1
  Block Time: Fri Oct 16 2020 15:19:57 GMT-0300 (Brasilia Standard Time)

eth_getTransactionReceipt
eth_getCode

```

Now you can call getMessage.

This is a simple contract that does not change the state. 

You can move forward now and implement other methods that can do this.

Have Fun!