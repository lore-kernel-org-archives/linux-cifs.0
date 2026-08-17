Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9CE40A921
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 12:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786968959; cv=none; b=OJCAw2LmnhkXOwF0YjlvtvDgTZLfNNCTDhxILT0QQfRECM5QnJtzVEyBLYnF/hCI0CNREUG4yTRW8XTJaeLZvL9b1z4k1DHvHArObkxRa06EPFz1AuLb1Jv+qPLE8QidTTXVgW6h6Sk0iXyL8OrV8Xj2J1KSyKhq6vqp/jXVzrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786968959; c=relaxed/simple;
	bh=5L6R0sVwT+zppLfLofu18O0C3DmZxg6zJuaVKnah360=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BFREHpKBXOXfJQE9NU7qaRP5iDkxUUbb84HDHX8PyCGsYn6MLc+tiZMkDH0iq/zyMOHBirrOPSRHCCOOzzchKcwa6DILUDCerFes7AlSIUoloyXI9B6A4mJneVnqWXRt1txdMAPwHChjuyHtGQQ8UYQL3loOMLJRl0goo+a+td8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f5wVOAhF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5wVOAhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7761F000E9;
	Mon, 17 Aug 2026 12:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786968958;
	bh=8crObOzNNxTYsdjn2mjbhAkFFsVUie5MrY9fU/QuVoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f5wVOAhFS03tCR/keYwMimdGeV7f7IVKDIhDKxJIIBIbEG3iTV9akb7Xqvz9jxIbL
	 JvbqOotuEW0tUBAxQh53AfDwM5IYlqpM6wrZQCbsw7izcFENIoHH6mopk4/SNferny
	 ALfZPtcm6pTwg0AWH8sk/HPuzwPJ2ucIZEz4AIxmlgC2Dv318V/gHbtjv0Xo5Lht7A
	 Mu/6ju753dSNP8YMHzfo+yxSdZjFfeV7/3RTzvV59Y9qEBjlUjLMy4Dh7UPgbgKC8o
	 ss64+BkIFVdD+aCxnhBEDcODndOz3pNDf7ziCFWZq+SrgYTwqK990RIBY0R36SqOTS
	 rbdCAD5aZQl7A==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: make RDMA encryption diagnostics conditional
Date: Mon, 17 Aug 2026 21:15:24 +0900
Message-Id: <20260817121524.8812-12-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260817121524.8812-1-linkinjeon@kernel.org>
References: <20260817121524.8812-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The temporary RDMA encryption diagnostics logged every SMB3 request
and successful payload operation with pr_err(), which made normal
traffic too noisy.

Keep only negotiation, RDMA READ preparation, RDMA WRITE transform
metadata, crypto completion, and final transfer completion messages as
KSMBD_DEBUG_RDMA diagnostics. Keep error reports for malformed metadata,
crypto, RDMA transfer, and file write failures at error level.

This preserves the diagnostics needed to verify RDMA transform
operation without flooding the kernel error log during normal I/O.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/auth.c    | 33 +++++++++++++++---
 fs/smb/server/smb2pdu.c | 75 +++++++++++++++++++++++++++++++++--------
 2 files changed, 90 insertions(+), 18 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index db362c64af8d..9f3151a9f379 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -911,26 +911,42 @@ int ksmbd_crypt_rdma(struct ksmbd_conn *conn, const u8 *key,
 	unsigned int iv_len, crypt_len;
 	u8 auth_tag[SMB2_SIGNATURE_SIZE] = {};
 	u8 *iv = NULL;
+	u16 cipher = le16_to_cpu(conn->cipher_type);
 	int rc;
 	DECLARE_CRYPTO_WAIT(wait);
 
-	if (!buflen || !tag_len || tag_len > SMB2_SIGNATURE_SIZE)
+	if (!buflen || !tag_len || tag_len > SMB2_SIGNATURE_SIZE) {
+		pr_err("RDMA %s rejected: cipher=0x%04x payload=%u nonce=%u tag=%u\n",
+		       enc ? "encryption" : "decryption", cipher, buflen,
+		       nonce_len, tag_len);
 		return -EINVAL;
+	}
 	if (!enc)
 		memcpy(auth_tag, tag, tag_len);
 
 	if (conn->cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
 	    conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM) {
-		if (nonce_len != SMB3_AES_GCM_NONCE)
+		if (nonce_len != SMB3_AES_GCM_NONCE) {
+			pr_err("RDMA %s rejected: cipher=0x%04x invalid nonce=%u expected=%u\n",
+			       enc ? "encryption" : "decryption", cipher,
+			       nonce_len, SMB3_AES_GCM_NONCE);
 			return -EINVAL;
+		}
 		ctx = ksmbd_crypto_ctx_find_gcm();
 	} else {
-		if (nonce_len != SMB3_AES_CCM_NONCE)
+		if (nonce_len != SMB3_AES_CCM_NONCE) {
+			pr_err("RDMA %s rejected: cipher=0x%04x invalid nonce=%u expected=%u\n",
+			       enc ? "encryption" : "decryption", cipher,
+			       nonce_len, SMB3_AES_CCM_NONCE);
 			return -EINVAL;
+		}
 		ctx = ksmbd_crypto_ctx_find_ccm();
 	}
-	if (!ctx)
+	if (!ctx) {
+		pr_err("RDMA %s failed: cipher=0x%04x crypto context unavailable\n",
+		       enc ? "encryption" : "decryption", cipher);
 		return -ENOMEM;
+	}
 
 	tfm = (conn->cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
 	       conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM) ?
@@ -988,6 +1004,15 @@ int ksmbd_crypt_rdma(struct ksmbd_conn *conn, const u8 *key,
 	kfree(sg);
 	aead_request_free(req);
 	ksmbd_release_crypto_ctx(ctx);
+	if (rc)
+		pr_err("RDMA %s failed: cipher=0x%04x payload=%u nonce=%u tag=%u rc=%d\n",
+		       enc ? "encryption" : "decryption", cipher, buflen,
+		       nonce_len, tag_len, rc);
+	else
+		ksmbd_debug(RDMA,
+			    "RDMA %s completed: cipher=0x%04x payload=%u nonce=%u tag=%u\n",
+			    enc ? "encryption" : "decryption", cipher, buflen,
+			    nonce_len, tag_len);
 	return rc;
 }
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b48eff02dbf8..bd74b45ce0e7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1904,6 +1904,13 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 		if (!conn->cipher_type)
 			conn->rdma_transform_ids &=
 				~BIT(SMB2_RDMA_TRANSFORM_ENCRYPTION);
+		ksmbd_debug(RDMA,
+			    "RDMA transform negotiation: transport=%s context=%s encryption=%s cipher=0x%04x\n",
+			    conn->transport->ops->rdma_read ? "rdma" : "tcp",
+			    conn->rdma_transform_negotiated ? "present" : "absent",
+			    conn->rdma_transform_ids &
+			    BIT(SMB2_RDMA_TRANSFORM_ENCRYPTION) ? "enabled" : "disabled",
+			    le16_to_cpu(conn->cipher_type));
 
 		rc = init_smb3_11_server(conn);
 		if (rc < 0) {
@@ -8719,15 +8726,14 @@ static int smb2_prep_rdma_read(struct ksmbd_work *work,
 	u16 transform_type;
 	int err;
 
-	if (work->encrypted &&
-	    (conn->rdma_transform_ids & BIT(SMB2_RDMA_TRANSFORM_ENCRYPTION))) {
-		transform_type = SMB2_RDMA_TRANSFORM_TYPE_ENCRYPTION;
-		nonce_len = (conn->cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
-			     conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM) ?
-			SMB3_AES_GCM_NONCE : SMB3_AES_CCM_NONCE;
-	} else {
+	if (!work->encrypted ||
+	    !(conn->rdma_transform_ids & BIT(SMB2_RDMA_TRANSFORM_ENCRYPTION)))
 		return 0;
-	}
+
+	transform_type = SMB2_RDMA_TRANSFORM_TYPE_ENCRYPTION;
+	nonce_len = (conn->cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
+		     conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM) ?
+		SMB3_AES_GCM_NONCE : SMB3_AES_CCM_NONCE;
 
 	transform = (struct smb2_rdma_transform *)rsp->Buffer;
 	crypto = (struct smb2_rdma_crypto_transform *)(transform + 1);
@@ -8747,13 +8753,20 @@ static int smb2_prep_rdma_read(struct ksmbd_work *work,
 			       data, datalen, nonce, nonce_len,
 			       crypto->Signature,
 			       SMB2_SIGNATURE_SIZE, true);
-	if (err)
+	if (err) {
+		pr_err("RDMA READ encryption failed: session=%llu payload=%u rc=%d\n",
+		       work->sess->id, datalen, err);
 		return err;
+	}
 
 	transform_len = sizeof(*transform) + sizeof(*crypto) +
 		SMB2_SIGNATURE_SIZE + nonce_len;
 	rsp->Flags = SMB2_READFLAG_RESPONSE_RDMA_TRANSFORM;
 	rsp->DataLength = cpu_to_le32(transform_len);
+	ksmbd_debug(RDMA,
+		    "RDMA READ encryption prepared: session=%llu cipher=0x%04x payload=%u transform=%u nonce=%u tag=%u\n",
+		    work->sess->id, le16_to_cpu(conn->cipher_type), datalen,
+		    transform_len, nonce_len, SMB2_SIGNATURE_SIZE);
 	return transform_len;
 }
 
@@ -8830,6 +8843,7 @@ static int smb2_parse_rdma_write_transform(struct ksmbd_work *work,
 	unsigned int offset = le16_to_cpu(req->WriteChannelInfoOffset);
 	unsigned int length = le16_to_cpu(req->WriteChannelInfoLength);
 	unsigned int desc_offset, desc_len, crypto_len, expected_desc_offset;
+	int err;
 
 	if (!work->conn->rdma_transform_ids ||
 	    offset < offsetof(struct smb2_write_req, Buffer) ||
@@ -8894,8 +8908,18 @@ static int smb2_parse_rdma_write_transform(struct ksmbd_work *work,
 	info->crypto = crypto;
 	info->nonce = crypto->Signature + info->signature_len;
 	info->channel = transform->Channel;
-	return check_rdma_desc(info->desc, info->desc_len,
-			       le32_to_cpu(req->RemainingBytes));
+	err = check_rdma_desc(info->desc, info->desc_len,
+			      le32_to_cpu(req->RemainingBytes));
+	if (err)
+		return err;
+
+	ksmbd_debug(RDMA,
+		    "RDMA WRITE encryption metadata: session=%llu cipher=0x%04x payload=%u channel=0x%x descriptors=%zu nonce=%u tag=%u\n",
+		    work->sess->id, le16_to_cpu(work->conn->cipher_type),
+		    le32_to_cpu(req->RemainingBytes), le32_to_cpu(info->channel),
+		    info->desc_len / sizeof(*info->desc), info->nonce_len,
+		    info->signature_len);
+	return 0;
 }
 
 /**
@@ -9105,6 +9129,15 @@ int smb2_read(struct ksmbd_work *work)
 		remain_bytes = smb2_read_rdma(work, req,
 					      aux_payload_buf,
 					      nbytes);
+		if (remain_bytes < 0)
+			pr_err("RDMA READ transfer failed: session=%llu payload=%zu transform=%d rc=%zd\n",
+			       work->sess ? work->sess->id : 0, nbytes,
+			       rdma_transform_len, remain_bytes);
+		else
+			ksmbd_debug(RDMA,
+				    "RDMA READ transfer completed: session=%llu payload=%zu transform=%d\n",
+				    work->sess ? work->sess->id : 0, nbytes,
+				    rdma_transform_len);
 		kvfree(aux_payload_buf);
 		aux_payload_buf = NULL;
 		nbytes = 0;
@@ -9269,10 +9302,12 @@ static ssize_t smb2_write_rdma(struct ksmbd_work *work,
 	ret = ksmbd_conn_rdma_read(work->conn, data_buf, length, desc,
 				   desc_len);
 	if (ret < 0) {
+		if (transform)
+			pr_err("RDMA WRITE encrypted transfer failed: session=%llu payload=%zu rdma_read_rc=%d\n",
+			       work->sess->id, length, ret);
 		kvfree(data_buf);
 		return ret;
 	}
-
 	if (transform &&
 	    transform->type == SMB2_RDMA_TRANSFORM_TYPE_ENCRYPTION) {
 		ret = ksmbd_crypt_rdma(work->conn,
@@ -9282,6 +9317,8 @@ static ssize_t smb2_write_rdma(struct ksmbd_work *work,
 				       transform->crypto->Signature,
 				       transform->signature_len, false);
 		if (ret) {
+			pr_err("RDMA WRITE decryption failed: session=%llu payload=%zu rc=%d\n",
+			       work->sess->id, length, ret);
 			kvfree(data_buf);
 			return ret == -ENOMEM ? ret : -EBADMSG;
 		}
@@ -9289,8 +9326,15 @@ static ssize_t smb2_write_rdma(struct ksmbd_work *work,
 
 	ret = ksmbd_vfs_write(work, fp, data_buf, length, &offset, sync, &nbytes);
 	kvfree(data_buf);
-	if (ret < 0)
+	if (ret < 0) {
+		if (transform)
+			pr_err("RDMA WRITE encrypted file write failed: session=%llu payload=%zu rc=%d\n",
+			       work->sess->id, length, ret);
 		return ret;
+	}
+	ksmbd_debug(RDMA,
+		    "RDMA WRITE transfer completed: session=%llu payload=%zu transformed=%u written=%zd\n",
+		    work->sess ? work->sess->id : 0, length, !!transform, nbytes);
 
 	return nbytes;
 }
@@ -9404,8 +9448,11 @@ int smb2_write(struct ksmbd_work *work)
 		if (req->Channel == SMB2_CHANNEL_RDMA_TRANSFORM) {
 			err = smb2_parse_rdma_write_transform(work, req,
 							      &rdma_transform);
-			if (err)
+			if (err) {
+				pr_err("RDMA WRITE encryption metadata rejected: session=%llu rc=%d\n",
+				       work->sess ? work->sess->id : 0, err);
 				goto out;
+			}
 			rdma_desc = rdma_transform.desc;
 			rdma_desc_len = rdma_transform.desc_len;
 			rdma_info = &rdma_transform;
-- 
2.25.1

