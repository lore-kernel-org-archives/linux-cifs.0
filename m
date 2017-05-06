From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [RFC 00/10] introduce crypto wait for async op function
Date: Sat,  6 May 2017 15:59:49 +0300
Message-ID: <1494075602-5061-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-fsdevel@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, Steve French <sfrench@samba.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Many users of kernel async. crypto services have a pattern of
starting an async. crypto op and than using a completion
to wait for it to end, resulting of the same code repeating
itself in multiple places, sometime with errors.

This patch aims to introduce a generic "wait for async. 
crypto op to complete" functions and move all the users
I could find to use it.  This gets rid of almost 300 
lines of code and fixes at least one bug (hopefully
without adding new ones).

In some cases (indicated in the specific patch description)
the move to the generic function changes the semantics
slightly (such as dropping interruptible when waiting).
I am especially interested in feedback whether people
think this is OK or I should an interruptible variant.

The patch set was boot tested on x86_64 and arm64 which
at the very least tests the crypto users via testmgr
but I am less confident regarding some of the other
users and would love feedback.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad Ben-Yossef (10):
  crypto: factor async completion for general use
  crypto: move pub key to generic async completion
  crypto: move drbg to generic async completion
  crypto: move gcm to generic async completion
  crypto: move testmgr to generic async completion
  dm: move dm-verity to generic async completion
  fscrypt: move to generic async completion
  cifs: move to generic async completion
  ima: move to generic async completion
  crypto: adapt api sample to use async. op wait

 Documentation/crypto/api-samples.rst |  52 ++--------
 crypto/af_alg.c                      |  27 -----
 crypto/algif_aead.c                  |  14 +--
 crypto/algif_hash.c                  |  30 +++---
 crypto/algif_skcipher.c              |  10 +-
 crypto/api.c                         |  28 ++++++
 crypto/asymmetric_keys/public_key.c  |  28 +-----
 crypto/drbg.c                        |  35 ++-----
 crypto/gcm.c                         |  34 ++-----
 crypto/testmgr.c                     | 184 +++++++++++------------------------
 drivers/md/dm-verity-target.c        |  81 ++++-----------
 drivers/md/dm-verity.h               |   5 -
 fs/cifs/smb2ops.c                    |  30 +-----
 fs/crypto/crypto.c                   |  28 +-----
 fs/crypto/fname.c                    |  36 ++-----
 fs/crypto/fscrypt_private.h          |  10 --
 fs/crypto/keyinfo.c                  |  21 +---
 include/crypto/drbg.h                |   3 +-
 include/crypto/if_alg.h              |  14 ---
 include/linux/crypto.h               |  28 ++++++
 security/integrity/ima/ima_crypto.c  |  56 ++++-------
 21 files changed, 222 insertions(+), 532 deletions(-)

-- 
2.1.4
