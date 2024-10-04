Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D7D1FEFD0;
	Fri,  4 Oct 2024 18:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066268; cv=none; b=F2t5gT+0K9C67nxlPEUx6u/fymM3lZ3BkD5vPp1Wrl0+4b2dt0zGhxZMkP1yx2IWpopkmJOpNr8zGLkc9C44/PCbMj34h2cxCMOIu5xIypX0Ztke0fNHG5TF+/fl0tB0LetmxloS1n33M2aEqaOw/3MMR7j7l33B3hamh/KC+FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066268; c=relaxed/simple;
	bh=QG1fWM9aIkSn4i2FD2XXkg/HO9MOmR128gXj7olPGcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsripT99KUnaouyL/FuTTnMahn1AVjQWNkMMkZHj9OpadkIAC8pgcEJ9lyYS2nFX6ObrZbR4Ui0Ss1MezLzy4mvlpFwXrn02m6KHGs/9s5IPiWgpL3fu3rv2qjwnA0wt/vynQvveT6OKm/vGtYD3QfVhbaoJaYg93tdDpancpS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qM4mf3oT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qM4mf3oT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADCFC4CECE;
	Fri,  4 Oct 2024 18:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066267;
	bh=QG1fWM9aIkSn4i2FD2XXkg/HO9MOmR128gXj7olPGcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qM4mf3oTOy37wPtNwWVsNp83FQOdXHWzmAvenEx2WJeIOSLhZM6ScBocB57zPxE+g
	 tugC5peu4o3yQhDMd8GAYcWmslf2T1zo91DLfOehZP+GE5/7q1ovJLDd96fscel5uN
	 /uhp1Gnyh9Sbfny+5PZ2/aHgSCJ7tVWxKtReZGmqdXSwz+KuzzCQTkDbjSWWIgFV+R
	 eQGakd0s6kDvHCrdMx81XTacoRW46lMX0IQdKczXBuHV0pS0C4/TfmiX1AdEq1EMgJ
	 XnY5bk1BqtgNLdN1u+PmaIYs/I07OWQCqaehjykLoy6veuEq0LzQAeK8sJYAsie4T2
	 Ms1GFOUINkxCQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.10 69/70] smb: client: fix UAF in async decryption
Date: Fri,  4 Oct 2024 14:21:07 -0400
Message-ID: <20241004182200.3670903-69-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004182200.3670903-1-sashal@kernel.org>
References: <20241004182200.3670903-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.13
Content-Transfer-Encoding: 8bit

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit b0abcd65ec545701b8793e12bc27dc98042b151a ]

Doing an async decryption (large read) crashes with a
slab-use-after-free way down in the crypto API.

Reproducer:
    # mount.cifs -o ...,seal,esize=1 //srv/share /mnt
    # dd if=/mnt/largefile of=/dev/null
    ...
    [  194.196391] ==================================================================
    [  194.196844] BUG: KASAN: slab-use-after-free in gf128mul_4k_lle+0xc1/0x110
    [  194.197269] Read of size 8 at addr ffff888112bd0448 by task kworker/u77:2/899
    [  194.197707]
    [  194.197818] CPU: 12 UID: 0 PID: 899 Comm: kworker/u77:2 Not tainted 6.11.0-lku-00028-gfca3ca14a17a-dirty #43
    [  194.198400] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.2-3-gd478f380-prebuilt.qemu.org 04/01/2014
    [  194.199046] Workqueue: smb3decryptd smb2_decrypt_offload [cifs]
    [  194.200032] Call Trace:
    [  194.200191]  <TASK>
    [  194.200327]  dump_stack_lvl+0x4e/0x70
    [  194.200558]  ? gf128mul_4k_lle+0xc1/0x110
    [  194.200809]  print_report+0x174/0x505
    [  194.201040]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
    [  194.201352]  ? srso_return_thunk+0x5/0x5f
    [  194.201604]  ? __virt_addr_valid+0xdf/0x1c0
    [  194.201868]  ? gf128mul_4k_lle+0xc1/0x110
    [  194.202128]  kasan_report+0xc8/0x150
    [  194.202361]  ? gf128mul_4k_lle+0xc1/0x110
    [  194.202616]  gf128mul_4k_lle+0xc1/0x110
    [  194.202863]  ghash_update+0x184/0x210
    [  194.203103]  shash_ahash_update+0x184/0x2a0
    [  194.203377]  ? __pfx_shash_ahash_update+0x10/0x10
    [  194.203651]  ? srso_return_thunk+0x5/0x5f
    [  194.203877]  ? crypto_gcm_init_common+0x1ba/0x340
    [  194.204142]  gcm_hash_assoc_remain_continue+0x10a/0x140
    [  194.204434]  crypt_message+0xec1/0x10a0 [cifs]
    [  194.206489]  ? __pfx_crypt_message+0x10/0x10 [cifs]
    [  194.208507]  ? srso_return_thunk+0x5/0x5f
    [  194.209205]  ? srso_return_thunk+0x5/0x5f
    [  194.209925]  ? srso_return_thunk+0x5/0x5f
    [  194.210443]  ? srso_return_thunk+0x5/0x5f
    [  194.211037]  decrypt_raw_data+0x15f/0x250 [cifs]
    [  194.212906]  ? __pfx_decrypt_raw_data+0x10/0x10 [cifs]
    [  194.214670]  ? srso_return_thunk+0x5/0x5f
    [  194.215193]  smb2_decrypt_offload+0x12a/0x6c0 [cifs]

This is because TFM is being used in parallel.

Fix this by allocating a new AEAD TFM for async decryption, but keep
the existing one for synchronous READ cases (similar to what is done
in smb3_calc_signature()).

Also remove the calls to aead_request_set_callback() and
crypto_wait_req() since it's always going to be a synchronous operation.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 47 ++++++++++++++++++++++++-----------------
 fs/smb/client/smb2pdu.c |  6 ++++++
 2 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1d6e8eacdd742..a8ebf3333c6cc 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4287,7 +4287,7 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
  */
 static int
 crypt_message(struct TCP_Server_Info *server, int num_rqst,
-	      struct smb_rqst *rqst, int enc)
+	      struct smb_rqst *rqst, int enc, struct crypto_aead *tfm)
 {
 	struct smb2_transform_hdr *tr_hdr =
 		(struct smb2_transform_hdr *)rqst[0].rq_iov[0].iov_base;
@@ -4298,8 +4298,6 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	u8 key[SMB3_ENC_DEC_KEY_SIZE];
 	struct aead_request *req;
 	u8 *iv;
-	DECLARE_CRYPTO_WAIT(wait);
-	struct crypto_aead *tfm;
 	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 	void *creq;
 	size_t sensitive_size;
@@ -4311,14 +4309,6 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 		return rc;
 	}
 
-	rc = smb3_crypto_aead_allocate(server);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: crypto alloc failed\n", __func__);
-		return rc;
-	}
-
-	tfm = enc ? server->secmech.enc : server->secmech.dec;
-
 	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
 		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
 		rc = crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_SIZE);
@@ -4358,11 +4348,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
 	aead_request_set_ad(req, assoc_data_len);
 
-	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  crypto_req_done, &wait);
-
-	rc = crypto_wait_req(enc ? crypto_aead_encrypt(req)
-				: crypto_aead_decrypt(req), &wait);
+	rc = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
 
 	if (!rc && enc)
 		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
@@ -4468,7 +4454,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 	/* fill the 1st iov with a transform header */
 	fill_transform_hdr(tr_hdr, orig_len, old_rq, server->cipher_type);
 
-	rc = crypt_message(server, num_rqst, new_rq, 1);
+	rc = crypt_message(server, num_rqst, new_rq, 1, server->secmech.enc);
 	cifs_dbg(FYI, "Encrypt message returned %d\n", rc);
 	if (rc)
 		goto err_free;
@@ -4493,8 +4479,9 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 		 unsigned int buf_data_size, struct iov_iter *iter,
 		 bool is_offloaded)
 {
-	struct kvec iov[2];
+	struct crypto_aead *tfm;
 	struct smb_rqst rqst = {NULL};
+	struct kvec iov[2];
 	size_t iter_size = 0;
 	int rc;
 
@@ -4510,9 +4497,31 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 		iter_size = iov_iter_count(iter);
 	}
 
-	rc = crypt_message(server, 1, &rqst, 0);
+	if (is_offloaded) {
+		if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
+		    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
+			tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
+		else
+			tfm = crypto_alloc_aead("ccm(aes)", 0, 0);
+		if (IS_ERR(tfm)) {
+			rc = PTR_ERR(tfm);
+			cifs_server_dbg(VFS, "%s: Failed alloc decrypt TFM, rc=%d\n", __func__, rc);
+
+			return rc;
+		}
+	} else {
+		if (unlikely(!server->secmech.dec))
+			return -EIO;
+
+		tfm = server->secmech.dec;
+	}
+
+	rc = crypt_message(server, 1, &rqst, 0, tfm);
 	cifs_dbg(FYI, "Decrypt message returned %d\n", rc);
 
+	if (is_offloaded)
+		crypto_free_aead(tfm);
+
 	if (rc)
 		return rc;
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 8e02e9f45e0e1..3a4ac6694161e 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1265,6 +1265,12 @@ SMB2_negotiate(const unsigned int xid,
 		else
 			cifs_server_dbg(VFS, "Missing expected negotiate contexts\n");
 	}
+
+	if (server->cipher_type && !rc) {
+		rc = smb3_crypto_aead_allocate(server);
+		if (rc)
+			cifs_server_dbg(VFS, "%s: crypto alloc failed, rc=%d\n", __func__, rc);
+	}
 neg_exit:
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
-- 
2.43.0

