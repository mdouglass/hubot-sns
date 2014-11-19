https = require('https')
crypto = require('crypto')
# url = require('url')

certificateCache = { }

downloadCertificate = (url, cb) ->
  if url in certificateCache
    cb certificateCache[url]

  https.get(url) (err, res, body) ->
    chunks = []

    res.on 'data', (chunk) -> chunks.push(chunk)
    res.on 'end', () ->
      certificateCache[url] = chunks.join('')
      cb certificateCache[url]

signatureStringOrder =
  'Notification': [ 'Message', 'MessageId', 'Subject', 'Timestamp', 'TopicArn', 'Type'],
  'SubscriptionConfirmation': [ 'Message', 'MessageId', 'SubscribeURL', 'Timestamp', 'Token', 'TopicArn', 'Type' ],
  'UnsubscribeConfirmation': [ 'Message', 'MessageId', 'SubscribeURL', 'Timestamp', 'Token', 'TopicArn', 'Type' ]

createSignatureString = (msg) ->
  chunks = []
  for field in signatureStringOrder[msg.Type]
    if field in msg
      chunks.push field
      chunks.push msg[field]
  return chunks.join('\n') + '\n'

verifySignature = (msg, success, failure) ->
  if msg.SignatureVersion isnt 1
    return failure()

  downloadCertificate msg.SigningCertURL, (pem) ->
    signatureString = createSignatureString(msg);

    verifier = crypto.createVerify('RSA-SHA1');
    verifier.update(signatureString, 'utf8');
    if verifier.verify(pem, msg.Signature, 'base64')
      return success()
    else
      return failure()

module.exports = { verifySignature: verifySignature }
