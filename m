From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH v3 00/28] simplify crypto wait for async op
Date: Sun,  2 Jul 2017 17:41:42 +0300
Message-ID: <1499006535-19760-1-git-send-email-gilad__26858.227272942$1499006556$gmane$org@benyossef.com>
Cc: Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
        David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>,
        Gary Hook <gary.hook-5C7GfCeVMHo@public.gmane.org>,
        Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
        Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
        Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>,
        Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Dmitry Kasatkin <dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-crypto@v
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Many users of kernel async. crypto services have a pattern of
starting an async. crypto op and than using a completion
to wait for it to end.

This patch set simplifies this common use case in two ways:

First, by giving the case where a request was queued to the
backlog a separate return code (-EIOCBQUEUED) of its own
rather than sharing the -EBUSY return code with the fatal
error of a busy provider when backlog is not enabled.

Next, this change is than built on to create a generic way
to wait for a async. crypto operation to complete.

The end result is that after replacing all the call sites
I could find, the code is smaller by ~340 lines, a branch
is saved in some cases in run-time and the code is more
straightforward to follow.

Please note that patches 1-13 should be squashed together
when applied in order to function correctly. They are
only separated out to ease review.

The patch set was boot tested on x86_64 and arm64 which
at the very least tests the crypto users via testmgr and
tcrypt but I do note that I do not have access to some
of the HW whose drivers are modified nor do I claim I was
able to test all of the corner cases.

Last but not least, I do apologize for the size of this
patch set and number of recipients, but I did have to
touch every crypto async API user in the kernel. May the
340 deleted lines serve as penance for my sin :-)

Changes from v2:
- Patch title changed from "introduce crypto wait for
  async op" to better reflect the current state.
- Rebase on top of latest linux-next.
- Add a new return code of -EIOCBQUEUED for backlog
  queueing, as suggested by Herbert Xu.
- Transform more users to the new API.
- Update the drbg change to account for new init as
  indicated by Stephan Muller.

Changes from v1:
- Address review comments from Eric Biggers.
- Separated out bug fixes of existing code and rebase
  on top of that patch set.
- Rename 'ecr' to 'wait' in fscrypto code.
- Split patch introducing the new API from the change
  moving over the algif code which it originated from
  to the new API.
- Inline crypto_wait_req().
- Some code indentation fixes.

Gilad Ben-Yossef (28):
  crypto: change backlog return code to -EIOCBQUEUED
  crypto: atmel: use -EIOCBQUEUED for backlog indication
  crypto: ccm: use -EIOCBQUEUED for backlog indication
  crypto: marvell/cesa: use -EIOCBQUEUED for backlog indication
  crypto: mediatek: use -EIOCBQUEUED for backlog indication
  crypto: omap: use -EIOCBQUEUED for backlog indication
  crypto: qce: use -EIOCBQUEUED for backlog indication
  crypto: talitos: use -EIOCBQUEUED for backlog indication
  dm: verity: use -EIOCBQUEUED for backlog indication
  fscrypt: use -EIOCBQUEUED for backlog indication
  cifs: use -EIOCBQUEUED for backlog indication
  ima: use -EIOCBQUEUED for backlog indication
  crypto: adapt api sample to -EIOCBQUEUED as backlog indication
  crypto: introduce crypto wait for async op
  crypto: move algif to generic async completion
  crypto: move pub key to generic async completion
  crypto: move drbg to generic async completion
  crypto: move gcm to generic async completion
  crypto: move testmgr to generic async completion
  dm: move dm-verity to generic async completion
  fscrypt: move to generic async completion
  cifs: move to generic async completion
  ima: move to generic async completion
  crypto: tcrypt: move to generic async completion
  crypto: talitos: move to generic async completion
  crypto: qce: move to generic async completion
  crypto: mediatek: move to generic async completion
  crypto: adapt api sample to use async. op wait

 Documentation/crypto/api-samples.rst |  52 ++-------
 crypto/af_alg.c                      |  27 -----
 crypto/ahash.c                       |  12 +--
 crypto/algapi.c                      |   6 +-
 crypto/algif_aead.c                  |  14 +--
 crypto/algif_hash.c                  |  29 +++--
 crypto/algif_skcipher.c              |  15 ++-
 crypto/api.c                         |  13 +++
 crypto/asymmetric_keys/public_key.c  |  28 +----
 crypto/chacha20poly1305.c            |   2 +-
 crypto/cryptd.c                      |   4 +-
 crypto/cts.c                         |   6 +-
 crypto/drbg.c                        |  36 ++-----
 crypto/gcm.c                         |  32 ++----
 crypto/lrw.c                         |   8 +-
 crypto/rsa-pkcs1pad.c                |  16 +--
 crypto/tcrypt.c                      |  84 +++++----------
 crypto/testmgr.c                     | 204 ++++++++++++-----------------------
 crypto/xts.c                         |   8 +-
 drivers/crypto/atmel-sha.c           |   2 +-
 drivers/crypto/ccp/ccp-crypto-main.c |  10 +-
 drivers/crypto/ccp/ccp-dev.c         |   8 +-
 drivers/crypto/ccp/ccp-dmaengine.c   |   2 +-
 drivers/crypto/marvell/cesa.c        |   2 +-
 drivers/crypto/marvell/cesa.h        |   2 +-
 drivers/crypto/mediatek/mtk-aes.c    |  31 +-----
 drivers/crypto/mediatek/mtk-sha.c    |   2 +-
 drivers/crypto/omap-sham.c           |   2 +-
 drivers/crypto/qce/sha.c             |  30 +-----
 drivers/crypto/talitos.c             |  39 +------
 drivers/md/dm-verity-target.c        |  81 ++++----------
 drivers/md/dm-verity.h               |   5 -
 fs/cifs/smb2ops.c                    |  30 +-----
 fs/crypto/crypto.c                   |  29 +----
 fs/crypto/fname.c                    |  36 ++-----
 fs/crypto/fscrypt_private.h          |  10 --
 fs/crypto/keyinfo.c                  |  21 +---
 include/crypto/drbg.h                |   3 +-
 include/crypto/if_alg.h              |  14 ---
 include/linux/crypto.h               |  40 +++++++
 security/integrity/ima/ima_crypto.c  |  56 +++-------
 41 files changed, 305 insertions(+), 746 deletions(-)

-- 
2.1.4
