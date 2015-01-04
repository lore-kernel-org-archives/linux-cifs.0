From: Giel van Schijndel <me@mortis.eu>
Subject: [PATCH] Use memzero_explicit to clear local buffers
Date: Sun,  4 Jan 2015 19:05:40 +0100
Message-ID: <1420394744-20268-1-git-send-email-me@mortis.eu>
Cc: Giel van Schijndel <me@mortis.eu>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE...),
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Steve French <sfrench@samba.org>,
	Rahul Bedarkar <rahulbedarkar89@gmail.com>,
	Thomas Pugliese <thomas.pugliese@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-usb@vger.kernel.org (open list:CERTIFIED WIRELES...),
	linux-cifs@vger.kernel.org (open list:COMMON INTERNET F...),
	samba-technical@lists.samba.org (moderated list:COMMON INTERNET F...)
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

When leaving a function use memzero_explicit instead of memset(0) to
clear locally allocated/owned buffers. memset(0) may be optimized away.

All of the affected buffers contain sensitive data, key material or
derivatives of one of those two.
---
 arch/x86/crypto/sha256_ssse3_glue.c | 2 +-
 drivers/usb/wusbcore/security.c     | 2 +-
 fs/cifs/smbencrypt.c                | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 8fad72f..b616e63 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -164,7 +164,7 @@ static int sha256_ssse3_final(struct shash_desc *desc, u8 *out)
 		dst[i] = cpu_to_be32(sctx->state[i]);
 
 	/* Wipe context */
-	memset(sctx, 0, sizeof(*sctx));
+	memzero_explicit(sctx, sizeof(*sctx));
 
 	return 0;
 }
diff --git a/drivers/usb/wusbcore/security.c b/drivers/usb/wusbcore/security.c
index b66faaf..a25f4fe 100644
--- a/drivers/usb/wusbcore/security.c
+++ b/drivers/usb/wusbcore/security.c
@@ -521,7 +521,7 @@ error_wusbhc_set_ptk:
 error_hs3:
 error_hs2:
 error_hs1:
-	memset(hs, 0, 3*sizeof(hs[0]));
+	memzero_explicit(hs, 3*sizeof(hs[0]));
 	memzero_explicit(&keydvt_out, sizeof(keydvt_out));
 	memzero_explicit(&keydvt_in, sizeof(keydvt_in));
 	memzero_explicit(&ccm_n, sizeof(ccm_n));
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 6c15663..a4232ec 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -221,7 +221,7 @@ E_md4hash(const unsigned char *passwd, unsigned char *p16,
 	}
 
 	rc = mdfour(p16, (unsigned char *) wpwd, len * sizeof(__le16));
-	memset(wpwd, 0, 129 * sizeof(__le16));
+	memzero_explicit(wpwd, sizeof(wpwd));
 
 	return rc;
 }
-- 
2.1.4
