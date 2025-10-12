Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF0E2153D2;
	Sun, 12 Oct 2025 01:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760234389; cv=none; b=deETar3eQD5kzUN6zrWKJ8S42uj79BJpAbcYFeh/H+blQoaYmNHYp+b4Fa+BQTmv+NZqHkxxXyUSG109P6aJc/edJiKc7lK0SfJvd5fE5Bsmx4QQzWPb6HAARq2Jk8eRTlveXR2EUBrRpmQaIjYknjXyE7LnsnI/Mkuuzc3E4yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760234389; c=relaxed/simple;
	bh=HHm6pOVf3sXBU3OQBSM5qr/7AHVRHIgZ/gieJ/a5ZQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8HaENpLJevaonIFa01OMYCABY44TE9mCri0daA+sFCdlm+WBkXM93yvKL3gk0YViTw7bRvopyTBRfwIUYHePHsHfyS9c0nIdNaXfvlITi4/XcHpvsTUAQSLrOdUL/px0MyW2r0zEXQ5hoIcgu+h4uSJOd4KSaMxH7/V+XrGOuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aqhjxUsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aqhjxUsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89E8C4AF0B;
	Sun, 12 Oct 2025 01:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760234388;
	bh=HHm6pOVf3sXBU3OQBSM5qr/7AHVRHIgZ/gieJ/a5ZQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqhjxUsc4ywtaQlokdKDqKbCRA5CyYQm1lk/0pTxq/nIpBi+mwzgy3Y6jNeXHi+3y
	 R05NLQYxEcZL34GbgR9WR4jmvXWDuCn1TCmsovkVweYiSfchAVj2eJN6ZeyTHJ6+xr
	 Nixkr9LHao9w/RLuZjErdz3jExn6wTh0LeusFucQezfCgk5Z5L+QVmzuOzx/dYjuT+
	 +jVCW3bqMSy2WgTIFG5T9CEfp/lnihyjgsrw9xW1E9QQ4rIwfgdQjjhzUQ5Fq8dM2S
	 Xbh843sXNlUHPkVrxOUWFAHJdWlD1E72vRvRTKIUFvYhCaP018ICZUtayILJy+W/52
	 8MA9HG46EHj6w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: samba-technical@lists.samba.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7/8] smb: client: Remove obsolete crypto_shash allocations
Date: Sat, 11 Oct 2025 18:57:37 -0700
Message-ID: <20251012015738.244315-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251012015738.244315-1-ebiggers@kernel.org>
References: <20251012015738.244315-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the SMB client accesses MD5, HMAC-MD5, HMAC-SHA256, and SHA-512
only via the library API and not via crypto_shash, allocating
crypto_shash objects for these algorithms is no longer necessary.
Remove all these allocations, their corresponding kconfig selections,
and their corresponding module soft dependencies.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/Kconfig         |  4 ----
 fs/smb/client/cifsencrypt.c   |  3 ---
 fs/smb/client/cifsfs.c        |  4 ----
 fs/smb/client/cifsglob.h      |  3 ---
 fs/smb/client/smb2transport.c | 35 ++---------------------------------
 5 files changed, 2 insertions(+), 47 deletions(-)

diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index f5a980bdfc939..17bd368574e94 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -3,15 +3,11 @@ config CIFS
 	tristate "SMB3 and CIFS support (advanced network filesystem)"
 	depends on INET
 	select NLS
 	select NLS_UCS2_UTILS
 	select CRYPTO
-	select CRYPTO_MD5
-	select CRYPTO_SHA256
-	select CRYPTO_SHA512
 	select CRYPTO_CMAC
-	select CRYPTO_HMAC
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select CRYPTO_ECB
 	select CRYPTO_AES
diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index bbcf3b05c19ab..801824825ecf2 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -691,13 +691,10 @@ calc_seckey(struct cifs_ses *ses)
 
 void
 cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 {
 	cifs_free_hash(&server->secmech.aes_cmac);
-	cifs_free_hash(&server->secmech.hmacsha256);
-	cifs_free_hash(&server->secmech.md5);
-	cifs_free_hash(&server->secmech.sha512);
 
 	if (server->secmech.enc) {
 		crypto_free_aead(server->secmech.enc);
 		server->secmech.enc = NULL;
 	}
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 05b1fa76e8ccf..4f959f1e08d23 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -2137,17 +2137,13 @@ MODULE_LICENSE("GPL");	/* combination of LGPL + GPL source behaves as GPL */
 MODULE_DESCRIPTION
 	("VFS to access SMB3 servers e.g. Samba, Macs, Azure and Windows (and "
 	"also older servers complying with the SNIA CIFS Specification)");
 MODULE_VERSION(CIFS_VERSION);
 MODULE_SOFTDEP("ecb");
-MODULE_SOFTDEP("hmac");
-MODULE_SOFTDEP("md5");
 MODULE_SOFTDEP("nls");
 MODULE_SOFTDEP("aes");
 MODULE_SOFTDEP("cmac");
-MODULE_SOFTDEP("sha256");
-MODULE_SOFTDEP("sha512");
 MODULE_SOFTDEP("aead2");
 MODULE_SOFTDEP("ccm");
 MODULE_SOFTDEP("gcm");
 module_init(init_cifs)
 module_exit(exit_cifs)
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 8f6f567d7474f..8932aa612db4a 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -219,13 +219,10 @@ struct session_key {
 	char *response;
 };
 
 /* crypto hashing related structure/fields, not specific to a sec mech */
 struct cifs_secmech {
-	struct shash_desc *md5; /* md5 hash function, for CIFS/SMB1 signatures */
-	struct shash_desc *hmacsha256; /* hmac-sha256 hash function, for SMB2 signatures */
-	struct shash_desc *sha512; /* sha512 hash function, for SMB3.1.1 preauth hash */
 	struct shash_desc *aes_cmac; /* block-cipher based MAC function, for SMB3 signatures */
 
 	struct crypto_aead *enc; /* smb3 encryption AEAD TFM (AES-CCM and AES-GCM) */
 	struct crypto_aead *dec; /* smb3 decryption AEAD TFM (AES-CCM and AES-GCM) */
 };
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 89258accc2203..cd689bc27bfdc 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -29,53 +29,22 @@
 
 static int
 smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
 {
 	struct cifs_secmech *p = &server->secmech;
-	int rc;
-
-	rc = cifs_alloc_hash("hmac(sha256)", &p->hmacsha256);
-	if (rc)
-		goto err;
-
-	rc = cifs_alloc_hash("cmac(aes)", &p->aes_cmac);
-	if (rc)
-		goto err;
 
-	return 0;
-err:
-	cifs_free_hash(&p->hmacsha256);
-	return rc;
+	return cifs_alloc_hash("cmac(aes)", &p->aes_cmac);
 }
 
 int
 smb311_crypto_shash_allocate(struct TCP_Server_Info *server)
 {
 	struct cifs_secmech *p = &server->secmech;
-	int rc = 0;
 
-	rc = cifs_alloc_hash("hmac(sha256)", &p->hmacsha256);
-	if (rc)
-		return rc;
-
-	rc = cifs_alloc_hash("cmac(aes)", &p->aes_cmac);
-	if (rc)
-		goto err;
-
-	rc = cifs_alloc_hash("sha512", &p->sha512);
-	if (rc)
-		goto err;
-
-	return 0;
-
-err:
-	cifs_free_hash(&p->aes_cmac);
-	cifs_free_hash(&p->hmacsha256);
-	return rc;
+	return cifs_alloc_hash("cmac(aes)", &p->aes_cmac);
 }
 
-
 static
 int smb3_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 {
 	struct cifs_chan *chan;
 	struct TCP_Server_Info *pserver;
-- 
2.51.0

