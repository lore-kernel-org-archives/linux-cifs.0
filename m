Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795783370;
	b=rYSv+mXZsDNrOuighaizCuYLw2oOf7gTBVQdTJ7iBeoikWxqKE/6oFohWE7n0l0BlvMR
	 Sd6Dvez2yfy8u24KfC+kRP97LzFULH8c2Qn25RcDw/txK7o2a5sh3kTTLAmCVY0Ne/xS+
	 dy6BBUXcOhZ5W+tL/bRY/pflP2Z7O3uHApytxrYX4IXJnNctpALZVou9Wxiu0ByxaeZyq
	 I0CEjtatkv21ASpn2cC1ov2/kLsw+4VTlGHIxUNB+a8CFPk+XB9jWbgBgNBH3ByG98E5c
	 teiKfafUIDt6WElHvwf32veEO26FN25ZbQ2h99xU2VsaJxooQWNHoBUrUwRcFBQwDcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795783370;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=03JmSX6sI3RNKde6B5WgCq8SZTe81/LSF+p5iVblNtM=;
	b=T94W4k+XwcmALOhs5lMUBqyZ5ycSQd3Uq3OLEG0VNeA1H++jNELZKN9gUXOOpLkPDJGQ
	 5LT2nMYKciybatQ9DuiDsujviOanKz8AcCXhTgNPwfOhsJN5ZO+vIGvY/I84tgTm61WcM
	 PoHdVQpAjGHERqVnkLzY/D5LuQKgmPtrJJaPbSWWz5YsDPJSxUjX3YkESPXvwPB3MstsV
	 XMyLo1eFHylFhOWK/gRak/QyJeruqglXgzcisDLV+9EelzVNLrEbwdJZsfG4kVdtH/ens
	 pufLhWbANjT0hyyzAbxj92dl7+NOV1+BYZ6+cwC3/x0MaVy7j7r54az3AuQRs8Ghy1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=DzE1wHTt;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A209606A31F;
	Fri, 27 Nov 2026 12:42:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A209606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=DzE1wHTt
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=03JmSX6sI3RNKde6B5WgCq8SZTe81/LSF+p5iVblNtM=; b=DzE1wHTtMazhirZiEbogKGcFl/
	u+WTSjW3ZNwDMhxDXP3SZVtyQNuFpn06KGJKra5+FZmvHQRcJzFvbvd6NzMKWIrqQAafExVRKwBbY
	ywFcYRxAoU/ZXbT51BE/IvqOQsQ1nI+IYmFco4YULL8LiBGO3qjeogS6kUt5W9xotS9JGf1GU3Xxw
	pjgpGRgLfNzw24jR9a8Z/oYwPREHAtDEmdeKcERLTt+OI6j9eH4ROresT8e5+nU+pRkeM/A3NNXcG
	j42bSW8xLlEZoyP7BoUvjSVGvj66CpTsCF8etQcvQCLF/GnuJYw7ewS2PV0povaqw+yKuheje8MvY
	t8v4cDpgMCVrOMWsAF3Ypv+4Vei5chIXaMw5KIIXjlPW1w7wY2P8E2rmE0DOvV2dZjBlfkbuOhrxp
	1WEUjxX1RwJcr+nl4Mz/l+fEMESeOXQ9V9TGTDsO7Ngcdf18rxzIT+9nL7X2aUCHo2wtyAHU4pYxl
	0oM0UdQqiHKwp+1QIhXIv1F3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWvHo-00000001MEd-14yo;
	Fri, 27 Nov 2026 12:42:44 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 8/8] smb: client: use a counter for the nonce of encrypted messages
Date: Fri, 27 Nov 2026 13:41:41 +0100
Message-ID: <0631e4011e68763c1e4523c9275642410e9f7bb5.1795782695.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795782695.git.metze@samba.org>
References: <cover.1795782695.git.metze@samba.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nonce of an encrypted message must not be used for any other
encrypted message within the session (MS-SMB2 3.1.4.3).
fill_transform_hdr() filled it with random bytes, which only makes a
collision unlikely: with 11 random bytes for AES-CCM and 12 for AES-GCM
the probability of a collision after n messages is about n^2 / 2^89 or
n^2 / 2^97. But with AES-CCM and AES-GCM a reused nonce reveals the XOR
of the two plaintexts and, for AES-GCM, the authentication key, which
allows forging messages.

Like Samba, use a 64-bit counter of the session for the first 8 bytes
of the nonce, followed by random bits chosen when the session is
allocated, 32 bits for AES-GCM and 24 bits for AES-CCM. This makes the
nonce unique for the session, also
when several channels encrypt in parallel, see smb3_new_enc_nonce().

fill_transform_hdr() now fails if the session isn't found, like
crypt_message() does when it looks up the encryption key.

Fixes: 026e93dc0a3e ("CIFS: Encrypt SMB3 requests before sending")
Cc: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/cifsglob.h |  3 ++
 fs/smb/client/misc.c     |  2 ++
 fs/smb/client/smb2ops.c  | 75 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 71 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 4e16347886ed..3bfa9b1bacf5 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1100,6 +1100,9 @@ struct cifs_ses {
 	__u16 session_flags;
 	__u8 smb3signingkey[SMB3_SIGN_KEY_SIZE];
 	__u8 smb3encryptionkey[SMB3_ENC_DEC_KEY_SIZE];
+	/* see smb3_new_enc_nonce() */
+	atomic64_t enc_nonce_low;
+	u32 enc_nonce_high;
 	__u8 smb3decryptionkey[SMB3_ENC_DEC_KEY_SIZE];
 	__u8 preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
 
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index a8f4c8644562..355b35f5fc63 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -84,6 +84,8 @@ sesInfoAlloc(void)
 		spin_lock_init(&ret_buf->iface_lock);
 		INIT_LIST_HEAD(&ret_buf->iface_list);
 		spin_lock_init(&ret_buf->chan_lock);
+		get_random_bytes(&ret_buf->enc_nonce_high,
+				 sizeof(ret_buf->enc_nonce_high));
 	}
 	return ret_buf;
 }
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 0f82fba40b64..15f559787068 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4720,9 +4720,66 @@ smb2_dir_needs_close(struct cifsFileInfo *cfile)
 	return !cfile->invalidHandle;
 }
 
-static void
-fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
-		   struct smb_rqst *old_rq, __le16 cipher_type)
+/*
+ * The nonce of an encrypted message must not be used for any other encrypted
+ * message within the session (MS-SMB2 3.1.4.3), a random nonce only makes a
+ * collision unlikely, but with AES-GCM and AES-CCM a reused nonce reveals the
+ * XOR of the plaintexts and allows forgeries.
+ *
+ * So, like Samba, the nonce is a 64-bit counter of the session followed by
+ * random bits chosen when the session is allocated, 32 bits for AES-GCM and
+ * 24 bits for AES-CCM.
+ */
+static int
+smb3_new_enc_nonce(struct TCP_Server_Info *server, __u64 ses_id,
+		   __le16 cipher_type, u8 *nonce)
+{
+	struct TCP_Server_Info *pserver;
+	struct cifs_ses *ses;
+	bool found = false;
+	u64 low = 0;
+	u32 high = 0;
+
+	/* If server is a channel, select the primary channel */
+	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (ses->Suid == ses_id) {
+			low = atomic64_inc_return(&ses->enc_nonce_low);
+			high = ses->enc_nonce_high;
+			found = true;
+			break;
+		}
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	if (!found) {
+		trace_smb3_ses_not_found(ses_id);
+		return -EAGAIN;
+	}
+
+	/* the counter can't wrap in practice, but never reuse a nonce */
+	if (WARN_ON_ONCE(low == 0))
+		return -EIO;
+
+	put_unaligned_le64(low, nonce);
+	if ((cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
+	    (cipher_type == SMB2_ENCRYPTION_AES256_GCM)) {
+		put_unaligned_le32(high, nonce + 8);
+	} else {
+		nonce[8] = high;
+		nonce[9] = high >> 8;
+		nonce[10] = high >> 16;
+	}
+
+	return 0;
+}
+
+static int
+fill_transform_hdr(struct TCP_Server_Info *server,
+		   struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
+		   struct smb_rqst *old_rq)
 {
 	struct smb2_hdr *shdr =
 			(struct smb2_hdr *)old_rq->rq_iov[0].iov_base;
@@ -4731,12 +4788,10 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
 	tr_hdr->ProtocolId = SMB2_TRANSFORM_PROTO_NUM;
 	tr_hdr->OriginalMessageSize = cpu_to_le32(orig_len);
 	tr_hdr->Flags = cpu_to_le16(0x01);
-	if ((cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
-	    (cipher_type == SMB2_ENCRYPTION_AES256_GCM))
-		get_random_bytes(&tr_hdr->Nonce, SMB3_AES_GCM_NONCE);
-	else
-		get_random_bytes(&tr_hdr->Nonce, SMB3_AES_CCM_NONCE);
 	memcpy(&tr_hdr->SessionId, &shdr->SessionId, 8);
+
+	return smb3_new_enc_nonce(server, le64_to_cpu(shdr->SessionId),
+				  server->cipher_type, tr_hdr->Nonce);
 }
 
 static void *smb2_aead_req_alloc(struct crypto_aead *tfm, const struct smb_rqst *rqst,
@@ -5009,7 +5064,9 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 	}
 
 	/* fill the 1st iov with a transform header */
-	fill_transform_hdr(tr_hdr, orig_len, old_rq, server->cipher_type);
+	rc = fill_transform_hdr(server, tr_hdr, orig_len, old_rq);
+	if (rc)
+		goto err_free;
 
 	rc = crypt_message(server, num_rqst, new_rq, 1, server->secmech.enc);
 	cifs_dbg(FYI, "Encrypt message returned %d\n", rc);
-- 
2.43.0

