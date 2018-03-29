var ECVerify = artifacts.require('./ECVerify.sol')

contract('ECVerify', (accounts) => {
  it('should return signing address from signature', async () => {
    var account = accounts[0]

    try {
      var instance = await ECVerify.deployed()

      var msg = 'some data'

      var hash = web3.sha3(msg)
      var sig = web3.eth.sign(account, hash)

      var signer = await instance.ecrecovery(hash, sig)
      assert.ok(signer)
    } catch(error) {
      console.error(error)
      assert.equal(error, undefined)
    }
  })

  it('should verify signature is from address', async () => {
    var account = accounts[0]

    try {
      var instance = await ECVerify.deployed()
      var msg = 'some data'

      var hash = web3.sha3(msg)
      var sig = web3.eth.sign(account, hash)

      var verified = await instance.ecverify.call(hash, sig, account)
      assert.ok(verified)
    } catch(error) {
      console.error(error)
      assert.equal(error, undefined)
    }
  })
})
