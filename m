Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694D134A3C5;
	Sat, 18 Apr 2026 22:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776550418; cv=none; b=P7yZ3rSku5BShgE8KBKL2i3tHb9TCXV5bQXNKNFP4Xbbgwv4G5FHDY+arEAwy2nVzrqiZjDKmLRKd4gr2TQtddTPsWj7ENlCuyX5ngWuy6xmr5c3W7v1WOC6blV8b7JcON6r4oVkYEoVdeggttt/MZq756DguZJKCutvF5YknR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776550418; c=relaxed/simple;
	bh=UFsMGQzwpj1CXCSj3DEfbmfeZG6YW47JjvEPrORMglU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ajk27hiB0HrvNsAIjzwpCvhTPgGCCTy7BJadD2Fo/rEG4GNliWlyyjGzyQlqRn5w7g4od3gElS/+rjHTgSR4e/9A8bnUf1pcakm92xv/kok8zir8gm2ET8O0jMGv0ulncWzvp9qMUlpg0/2TCF8gCrboa+whqt7lN5/56KulVRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eiOlULXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eiOlULXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AEFC2BCB7;
	Sat, 18 Apr 2026 22:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776550418;
	bh=UFsMGQzwpj1CXCSj3DEfbmfeZG6YW47JjvEPrORMglU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eiOlULXlt9qjKe2gF3ERAxoD+xbN1xgkBNYud6wbFQePl56pEYVVSBKNBALqgJgcM
	 qCabjhqWbvPolDSzqInKUROtv0MZHLweglXSshwy2zCO+UaCNzxKvpYKGyT6i8tVHQ
	 gxlZ5UVsD45OJCXJasoVPo3Hhw0yLYw9MsAtg9U2t40cZKjDCYs9y2+etHkaC2ElWW
	 ExwMLML4NPlL/1DVlJmybv9lF85nQz5h4vVsjLNb+RfLKwYLlWbNxtxIW7GPuFaouz
	 vErJBs3Qdk7nitPuJdku7nv6wVdKNItfSHpyoapKYxKywPAFTaZ1GfOn91PdtUsoof
	 Ed9weAF2sz2nA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: linux-crypto@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 2/4] smb: client: Remove obsolete cmac(aes) allocation
Date: Sat, 18 Apr 2026 15:13:09 -0700
Message-ID: <20260418221311.67583-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418221311.67583-1-ebiggers@kernel.org>
References: <20260418221311.67583-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the crypto library API is now being used instead of crypto_shash,
the "cmac(aes)" crypto_shash that is being allocated and stored in
'struct cifs_secmech' is no longer used.  Remove it.

That makes the kconfig selection of CRYPTO_CMAC and the module softdep
on "cmac" unnecessary.  So remove those too.

Finally, since this removes the last use of crypto_shash from the smb
client, also remove the remaining crypto_shash-related helper functions.

Note: cifs_unicode.c was relying on <linux/unaligned.h> being included
transitively via <crypto/internal/hash.h>.  Since the latter include is
removed, make cifs_unicode.c include <linux/unaligned.h> explicitly.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/Kconfig         |  1 -
 fs/smb/client/cifs_unicode.c  |  1 +
 fs/smb/client/cifsencrypt.c   |  2 --
 fs/smb/client/cifsfs.c        |  1 -
 fs/smb/client/cifsglob.h      |  5 +--
 fs/smb/client/cifsproto.h     |  3 --
 fs/smb/client/misc.c          | 57 -----------------------------------
 fs/smb/client/sess.c          | 11 -------
 fs/smb/client/smb2proto.h     |  1 -
 fs/smb/client/smb2transport.c | 15 ---------
 10 files changed, 2 insertions(+), 95 deletions(-)

diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index 029bbe595d5fa..a1c6ad4d574a0 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -3,11 +3,10 @@ config CIFS
 	tristate "SMB3 and CIFS support (advanced network filesystem)"
 	depends on INET
 	select NLS
 	select NLS_UCS2_UTILS
 	select CRYPTO
-	select CRYPTO_CMAC
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select CRYPTO_AES
 	select CRYPTO_LIB_AES_CBC_MACS
diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.c
index e2edc207cef25..4a8a591f4bcac 100644
--- a/fs/smb/client/cifs_unicode.c
+++ b/fs/smb/client/cifs_unicode.c
@@ -4,10 +4,11 @@
  *   Copyright (c) International Business Machines  Corp., 2000,2009
  *   Modified by Steve French (sfrench@us.ibm.com)
  */
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/unaligned.h>
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 #include "cifsglob.h"
 #include "cifs_debug.h"
 
diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index d092bca2df62d..34804e9842a80 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -501,12 +501,10 @@ calc_seckey(struct cifs_ses *ses)
 }
 
 void
 cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 {
-	cifs_free_hash(&server->secmech.aes_cmac);
-
 	if (server->secmech.enc) {
 		crypto_free_aead(server->secmech.enc);
 		server->secmech.enc = NULL;
 	}
 	if (server->secmech.dec) {
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 2025739f070ac..081fc1f9447da 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -2158,11 +2158,10 @@ MODULE_DESCRIPTION
 	("VFS to access SMB3 servers e.g. Samba, Macs, Azure and Windows (and "
 	"also older servers complying with the SNIA CIFS Specification)");
 MODULE_VERSION(CIFS_VERSION);
 MODULE_SOFTDEP("nls");
 MODULE_SOFTDEP("aes");
-MODULE_SOFTDEP("cmac");
 MODULE_SOFTDEP("aead2");
 MODULE_SOFTDEP("ccm");
 MODULE_SOFTDEP("gcm");
 module_init(init_cifs)
 module_exit(exit_cifs)
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 74265d055c265..82e0adc1dabd0 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -21,11 +21,10 @@
 #include <linux/sched/mm.h>
 #include <linux/netfs.h>
 #include <linux/fcntl.h>
 #include "cifs_fs_sb.h"
 #include "cifsacl.h"
-#include <crypto/internal/hash.h>
 #include <uapi/linux/cifs/cifs_mount.h>
 #include "../common/smbglob.h"
 #include "../common/smb2pdu.h"
 #include "../common/fscc.h"
 #include "smb2pdu.h"
@@ -219,14 +218,12 @@ static inline const char *cifs_symlink_type_str(enum cifs_symlink_type type)
 struct session_key {
 	unsigned int len;
 	char *response;
 };
 
-/* crypto hashing related structure/fields, not specific to a sec mech */
+/* encryption related structure/fields, not specific to a sec mech */
 struct cifs_secmech {
-	struct shash_desc *aes_cmac; /* block-cipher based MAC function, for SMB3 signatures */
-
 	struct crypto_aead *enc; /* smb3 encryption AEAD TFM (AES-CCM and AES-GCM) */
 	struct crypto_aead *dec; /* smb3 decryption AEAD TFM (AES-CCM and AES-GCM) */
 };
 
 /* per smb session structure/fields */
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c24c50d732e64..4a25afda9448a 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -349,13 +349,10 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
 			  struct TCP_Server_Info *server, char *signature,
 			  struct cifs_calc_sig_ctx *ctx);
 enum securityEnum cifs_select_sectype(struct TCP_Server_Info *server,
 				      enum securityEnum requested);
 
-int cifs_alloc_hash(const char *name, struct shash_desc **sdesc);
-void cifs_free_hash(struct shash_desc **sdesc);
-
 int cifs_try_adding_channels(struct cifs_ses *ses);
 int smb3_update_ses_channels(struct cifs_ses *ses,
 			     struct TCP_Server_Info *server,
 			     bool from_reconnect, bool disable_mchan);
 bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface);
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 2aff1cab6c31e..0c54b9b79a2ce 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -783,67 +783,10 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		*num_of_nodes = 0;
 	}
 	return rc;
 }
 
-/**
- * cifs_alloc_hash - allocate hash and hash context together
- * @name: The name of the crypto hash algo
- * @sdesc: SHASH descriptor where to put the pointer to the hash TFM
- *
- * The caller has to make sure @sdesc is initialized to either NULL or
- * a valid context. It can be freed via cifs_free_hash().
- */
-int
-cifs_alloc_hash(const char *name, struct shash_desc **sdesc)
-{
-	int rc = 0;
-	struct crypto_shash *alg = NULL;
-
-	if (*sdesc)
-		return 0;
-
-	alg = crypto_alloc_shash(name, 0, 0);
-	if (IS_ERR(alg)) {
-		cifs_dbg(VFS, "Could not allocate shash TFM '%s'\n", name);
-		rc = PTR_ERR(alg);
-		*sdesc = NULL;
-		return rc;
-	}
-
-	*sdesc = kmalloc(sizeof(struct shash_desc) + crypto_shash_descsize(alg), GFP_KERNEL);
-	if (*sdesc == NULL) {
-		cifs_dbg(VFS, "no memory left to allocate shash TFM '%s'\n", name);
-		crypto_free_shash(alg);
-		return -ENOMEM;
-	}
-
-	(*sdesc)->tfm = alg;
-	return 0;
-}
-
-/**
- * cifs_free_hash - free hash and hash context together
- * @sdesc: Where to find the pointer to the hash TFM
- *
- * Freeing a NULL descriptor is safe.
- */
-void
-cifs_free_hash(struct shash_desc **sdesc)
-{
-	if (unlikely(!sdesc) || !*sdesc)
-		return;
-
-	if ((*sdesc)->tfm) {
-		crypto_free_shash((*sdesc)->tfm);
-		(*sdesc)->tfm = NULL;
-	}
-
-	kfree_sensitive(*sdesc);
-	*sdesc = NULL;
-}
-
 void extract_unc_hostname(const char *unc, const char **h, size_t *len)
 {
 	const char *end;
 
 	/* skip initial slashes */
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 698bd27119ae0..de2012cc9cf3e 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -593,21 +593,10 @@ cifs_ses_add_channel(struct cifs_ses *ses,
 	cifs_chan_set_need_reconnect(ses, chan->server);
 
 	spin_unlock(&ses->chan_lock);
 
 	mutex_lock(&ses->session_mutex);
-	/*
-	 * We need to allocate the server crypto now as we will need
-	 * to sign packets before we generate the channel signing key
-	 * (we sign with the session key)
-	 */
-	rc = smb3_crypto_shash_allocate(chan->server);
-	if (rc) {
-		cifs_dbg(VFS, "%s: crypto alloc failed\n", __func__);
-		mutex_unlock(&ses->session_mutex);
-		goto out;
-	}
 
 	rc = cifs_negotiate_protocol(xid, ses, chan->server);
 	if (!rc)
 		rc = cifs_setup_session(xid, ses, chan->server, ses->local_nls);
 
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 5f74475ba9d19..1ceb95b907e6b 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -255,11 +255,10 @@ int smb2_validate_iov(unsigned int offset, unsigned int buffer_length,
 int smb2_validate_and_copy_iov(unsigned int offset, unsigned int buffer_length,
 			       struct kvec *iov, unsigned int minbufsize,
 			       char *data);
 void smb2_copy_fs_info_to_kstatfs(struct smb2_fs_full_size_info *pfs_inf,
 				  struct kstatfs *kst);
-int smb3_crypto_shash_allocate(struct TCP_Server_Info *server);
 void smb311_update_preauth_hash(struct cifs_ses *ses,
 				struct TCP_Server_Info *server,
 				struct kvec *iov, int nvec);
 int smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 			     const char *path, u32 desired_access, u32 class,
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index b233e0cd91529..716e58d1b1c92 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -27,18 +27,10 @@
 #include "smb2proto.h"
 #include "cifs_debug.h"
 #include "../common/smb2status.h"
 #include "smb2glob.h"
 
-int
-smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
-{
-	struct cifs_secmech *p = &server->secmech;
-
-	return cifs_alloc_hash("cmac(aes)", &p->aes_cmac);
-}
-
 static
 int smb3_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 {
 	struct cifs_chan *chan;
 	struct TCP_Server_Info *pserver;
@@ -264,24 +256,17 @@ static int generate_key(struct cifs_ses *ses, struct kvec label,
 {
 	unsigned char zero = 0x0;
 	__u8 i[4] = {0, 0, 0, 1};
 	__u8 L128[4] = {0, 0, 0, 128};
 	__u8 L256[4] = {0, 0, 1, 0};
-	int rc = 0;
 	unsigned char prfhash[SMB2_HMACSHA256_SIZE];
 	struct TCP_Server_Info *server = ses->server;
 	struct hmac_sha256_ctx hmac_ctx;
 
 	memset(prfhash, 0x0, SMB2_HMACSHA256_SIZE);
 	memset(key, 0x0, key_size);
 
-	rc = smb3_crypto_shash_allocate(server);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: crypto alloc failed\n", __func__);
-		return rc;
-	}
-
 	hmac_sha256_init_usingrawkey(&hmac_ctx, ses->auth_key.response,
 				     SMB2_NTLMV2_SESSKEY_SIZE);
 	hmac_sha256_update(&hmac_ctx, i, 4);
 	hmac_sha256_update(&hmac_ctx, label.iov_base, label.iov_len);
 	hmac_sha256_update(&hmac_ctx, &zero, 1);
-- 
2.53.0

