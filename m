Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AB51EBA1D;
	Fri,  4 Oct 2024 18:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066065; cv=none; b=rh+tBDfDbkzhVahpBNCc4l7Rw9jggp0HulyOCPULawDBPIQ3F1yvej681d9lc7URTpJOQBVEEo9n4yn3rztD9lom/pKSAODS0NXCa7dwqQrBh9XizXq+8TTkM6ILJVjVOYTiopxyjziOkeeUvxSLAmBhRK6sP6wSdS0uHfxdiQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066065; c=relaxed/simple;
	bh=468hs4PKrN3wNSxx3AMsT5kP2GlURAAESYI2RRCCy9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1hXZpZkvmt5SZtFsshef/QZnD+NWoJaiHvcLMXFVad60kiDVjDBp3hUdIXRpLVWU5RtFBzW+ErjUzs2NznfGeHLoi1yk3Owd+IX8ZD01yUEyI11uNSh/joHkPIkAJ8FwsQHhsbpOXLlykZfuufpfBKQkgY871RRSoLQMcERrxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLkXBM+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLkXBM+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCB7C4CECC;
	Fri,  4 Oct 2024 18:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066065;
	bh=468hs4PKrN3wNSxx3AMsT5kP2GlURAAESYI2RRCCy9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLkXBM+IOYO+aMZrpPQgbEVXIu/JV1wkdfG1xBWyXT4LtWk6MPyTz4+mSIDxYLBep
	 o8qsHI6Wv3/VJDOsierbt04UQ1/uzjNFPqDDCAHWVltviNNXQ6Pv52N6twk0kFAvFg
	 2wjObNkgEkiHIIInBiVHdAf7M+hLu026tBftZflES9prw9cJVtI5GzTQ5/567u0EDd
	 QFW/kXB4kh2e63vRz+3XYc/m42pqp9h4N49A9L59SLwrFM09530/4SoWt+28413oAb
	 mi4NNAdA1xkQmtvKkprMfx94Z/LXgwgZYdgj9qrx6+a/wFL2LW+c2Od8tTsvkf8n6V
	 fkf1SWXj1F98w==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.11 75/76] smb: client: fix UAF in async decryption
Date: Fri,  4 Oct 2024 14:17:32 -0400
Message-ID: <20241004181828.3669209-75-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004181828.3669209-1-sashal@kernel.org>
References: <20241004181828.3669209-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.2
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
index e6540072ffb0e..614a7bbdb007d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4307,7 +4307,7 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
  */
 static int
 crypt_message(struct TCP_Server_Info *server, int num_rqst,
-	      struct smb_rqst *rqst, int enc)
+	      struct smb_rqst *rqst, int enc, struct crypto_aead *tfm)
 {
 	struct smb2_transform_hdr *tr_hdr =
 		(struct smb2_transform_hdr *)rqst[0].rq_iov[0].iov_base;
@@ -4318,8 +4318,6 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	u8 key[SMB3_ENC_DEC_KEY_SIZE];
 	struct aead_request *req;
 	u8 *iv;
-	DECLARE_CRYPTO_WAIT(wait);
-	struct crypto_aead *tfm;
 	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 	void *creq;
 	size_t sensitive_size;
@@ -4331,14 +4329,6 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
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
@@ -4378,11 +4368,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
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
@@ -4488,7 +4474,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 	/* fill the 1st iov with a transform header */
 	fill_transform_hdr(tr_hdr, orig_len, old_rq, server->cipher_type);
 
-	rc = crypt_message(server, num_rqst, new_rq, 1);
+	rc = crypt_message(server, num_rqst, new_rq, 1, server->secmech.enc);
 	cifs_dbg(FYI, "Encrypt message returned %d\n", rc);
 	if (rc)
 		goto err_free;
@@ -4513,8 +4499,9 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 		 unsigned int buf_data_size, struct iov_iter *iter,
 		 bool is_offloaded)
 {
-	struct kvec iov[2];
+	struct crypto_aead *tfm;
 	struct smb_rqst rqst = {NULL};
+	struct kvec iov[2];
 	size_t iter_size = 0;
 	int rc;
 
@@ -4530,9 +4517,31 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
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
index 88dc49d670371..3d9e6e15dd900 100644
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

