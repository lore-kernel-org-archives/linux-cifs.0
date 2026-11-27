Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798158;
	b=4GwDTEDbOWa5Bn4OIF3MApiGhC7HBmlq5goW2QWzs+oKd9scan3wl4Kgoi1p0KCF/xJU
	 2lRQOFszsGUtU16PDpHfbRz+9xq910Eg4/lj0XLGgy+C2PVgVM5yLG6giguhDxmKzWn4Y
	 Csz6pZzg1U/IjlDrZuM9AuN2S75meojL0jB2EJOjDloZ5x2R0uU2tYo/kKrT5wp+/+qXk
	 VlLqTWrFQ/p8dvzYfaX350nvEbYRj5gLJ5gYX/Qs/YXeEW7f72K37Khyyzp0WvSITGeH7
	 9Fir6a5rrg20Q9Z8HdoSxlc5wN601YflB36uPd4bEwLzlst9P2fSjJPMYtcDMTFYZpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798158;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wII9UiZ+wnzLtUF1zF7bvr1NYoYOEjyLn6jgYW+A26g=;
	b=h1oWq68uX1vbWaDqe7ln7QV9uvhEeIlSw1idREy5PKfoWKVuskVQp/ZM1bZ4+h47y9X8
	 3E4X+8bO5Io4wvoyQX8dzuq4KeHVdoEvSyOFkVMQmfqCuhsQj5KbJ2afgl1D7nyp+m0bc
	 4MMDiM9miHtfEKdjEqVnO/pFoK+r4/qDG8zdDv/NHNGrWuKKp+tGNBAIWp50EyT3FXgcY
	 2+TRDHFSPOBmoNbKKItXcCHpR0tliLXukVeF4jCZQOtwIpHwnqsHkIaY2D5NwM9ZcaNPT
	 QRNLfJk07Ui4XTkDFh41sf/9lCN5bcvVzF6AZfTZVRhAPok0fXIv2Fu7pgxuw8k/syw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b="cP/FdWyD";
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592BA606A31E;
	Fri, 27 Nov 2026 16:49:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 592BA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=cP/FdWyD
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=wII9UiZ+wnzLtUF1zF7bvr1NYoYOEjyLn6jgYW+A26g=; b=cP/FdWyDcG2kwGMk6fIpZGn9r3
	ZnZGnNtgPOQqGA3rb9J5xx9wwbXsQ9FeR5gT131xNUqwl/qkbLTHqTME7MYVE74F5TAr+338zCnyy
	NWYQvHcq1JaPWcqfSb6W7vS2IyaxSd2tM2pNC8CvmPuOLzKJT3c0jFbTB4O+bFcAzznUvzobrBnlb
	1w0cR4PIs47AXZDmkHZOy1Q1f4eEDAcKg/sQOkRwQvhHBfS5rUZ2xh/wGOjahsUVm1uM8X64Nz+Qk
	yoR2KTz69+ak5fvZR/itMvHCl4HB1ORxgYrTi21qMo8KFDEzIb520+AkxH31B2S4YXwQDgfmCbX15
	SEngAvoxwSDG7PcekCIcfDZry5bX4kw0mU0HZM+E6HEsaouw/CMjrTZuhfTDM7aUXdS19z7MRT729
	pYm8YWww1b4eIsK/CXiR8lI5Apfr1n99SxF1Ia4I61Pl3UE0WYg8yOjwbxooXLwlD7lqPQrfN3LcB
	+XCq9TOxJaigzcjcFQUtiaw5;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWz8H-00000001QXv-0Mnc;
	Fri, 27 Nov 2026 16:49:09 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: [PATCH 1/2] smb: server: use a counter for the nonce of encrypted responses
Date: Fri, 27 Nov 2026 17:48:58 +0100
Message-ID: <f8e60e33c424c1efe397e94bee170a45823e3d95.1795797772.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795797772.git.metze@samba.org>
References: <cover.1795797772.git.metze@samba.org>
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
encrypted message within the session (MS-SMB2 3.1.4.3). This also
covers the payload of RDMA reads with an
SMB2_RDMA_TRANSFORM_TYPE_ENCRYPTION transform, which is encrypted with
the same key. fill_transform_hdr() and smb2_prep_rdma_read() filled it
with random bytes, which only makes a collision unlikely: with 11
random bytes for AES-CCM and 12 for AES-GCM the probability of a
collision after n messages is about n^2 / 2^89 or n^2 / 2^97. But with
AES-CCM and AES-GCM a reused nonce reveals the XOR of the two
plaintexts and, for AES-GCM, the authentication key, which allows
forging messages.

Like Samba, use a 64-bit counter of the session for the first 8 bytes
of the nonce, followed by random bits chosen when the session is
created, 32 bits for AES-GCM and 24 bits for AES-CCM. This makes the
nonce unique for the session, also
when several channels encrypt in parallel, see ksmbd_new_enc_nonce().

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Fixes: 05c978948ea5 ("ksmbd: add SMB Direct RDMA encryption transform")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/auth.c              | 43 +++++++++++++++++++++++++++++++
 fs/smb/server/auth.h              |  4 +++
 fs/smb/server/mgmt/user_session.c |  1 +
 fs/smb/server/mgmt/user_session.h |  3 +++
 fs/smb/server/smb2pdu.c           | 25 +++++++++++-------
 5 files changed, 66 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 0c51ca0cb14d..51b33cf139d4 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -18,6 +18,7 @@
 #include <crypto/utils.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
+#include <linux/unaligned.h>
 
 #include "auth.h"
 #include "glob.h"
@@ -713,6 +714,48 @@ int ksmbd_gen_preauth_integrity_hash(struct ksmbd_conn *conn, char *buf,
 	return 0;
 }
 
+/**
+ * ksmbd_new_enc_nonce() - generate the nonce for an encrypted response
+ * @sess: session whose encryption key is used
+ * @cipher_type: cipher of the connection
+ * @nonce: nonce output, 11 bytes for AES-CCM, 12 bytes for AES-GCM
+ *
+ * The nonce must not be used for any other encrypted message within the
+ * session (MS-SMB2 3.1.4.3), this also covers the payload of RDMA reads with
+ * an SMB2_RDMA_TRANSFORM_TYPE_ENCRYPTION transform, which uses the same key.
+ * A random nonce only makes a collision unlikely, but with AES-GCM and
+ * AES-CCM a reused nonce reveals the XOR of the plaintexts and allows
+ * forgeries.
+ *
+ * So, like Samba, the nonce is a 64-bit counter of the session followed by
+ * random bits chosen when the session is created, 32 bits for AES-GCM and
+ * 24 bits for AES-CCM.
+ *
+ * Return: 0 on success, otherwise a negative errno
+ */
+int ksmbd_new_enc_nonce(struct ksmbd_session *sess, __le16 cipher_type,
+			u8 *nonce)
+{
+	u64 low = atomic64_inc_return(&sess->enc_nonce_low);
+	u32 high = sess->enc_nonce_high;
+
+	/* the counter can't wrap in practice, but never reuse a nonce */
+	if (WARN_ON_ONCE(low == 0))
+		return -EIO;
+
+	put_unaligned_le64(low, nonce);
+	if (cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
+	    cipher_type == SMB2_ENCRYPTION_AES256_GCM) {
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
 static int ksmbd_get_encryption_key(struct ksmbd_work *work, __u64 ses_id,
 				    int enc, u8 *key)
 {
diff --git a/fs/smb/server/auth.h b/fs/smb/server/auth.h
index 7ce9c42d58f1..38613ed025ae 100644
--- a/fs/smb/server/auth.h
+++ b/fs/smb/server/auth.h
@@ -36,6 +36,10 @@ struct ksmbd_conn;
 struct ksmbd_work;
 struct kvec;
 
+struct ksmbd_session;
+
+int ksmbd_new_enc_nonce(struct ksmbd_session *sess, __le16 cipher_type,
+			u8 *nonce);
 int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 			unsigned int nvec, int enc);
 int ksmbd_crypt_rdma(struct ksmbd_conn *conn, const u8 *key,
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 15662fd745ab..3f0546d1c573 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -1042,6 +1042,7 @@ static struct ksmbd_session *__session_create(struct ksmbd_conn *conn, int proto
 	xa_init(&sess->rpc_handle_list);
 	INIT_LIST_HEAD(&sess->dispose_entry);
 	sess->sequence_number = 1;
+	get_random_bytes(&sess->enc_nonce_high, sizeof(sess->enc_nonce_high));
 	atomic_set(&sess->refcnt, 2);
 	init_rwsem(&sess->tree_conns_lock);
 	init_rwsem(&sess->rpc_lock);
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 5f0f6276e316..fd455c52ce1a 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -75,6 +75,9 @@ struct ksmbd_session {
 	struct xarray			rpc_handle_list;
 
 	__u8				smb3encryptionkey[SMB3_ENC_DEC_KEY_SIZE];
+	/* see ksmbd_new_enc_nonce() */
+	atomic64_t			enc_nonce_low;
+	u32				enc_nonce_high;
 	__u8				smb3decryptionkey[SMB3_ENC_DEC_KEY_SIZE];
 	__u8				smb3signingkey[SMB3_SIGN_KEY_SIZE];
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index fe17d4061237..332f9bb963e1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9631,7 +9631,9 @@ static int smb2_prep_rdma_read(struct ksmbd_work *work,
 	crypto->NonceLength = cpu_to_le16(nonce_len);
 	nonce = crypto->Signature + SMB2_SIGNATURE_SIZE;
 
-	get_random_bytes(nonce, nonce_len);
+	err = ksmbd_new_enc_nonce(work->sess, conn->cipher_type, nonce);
+	if (err)
+		return err;
 	err = ksmbd_crypt_rdma(conn,
 			       work->sess->smb3encryptionkey,
 			       data, datalen, nonce, nonce_len,
@@ -13118,24 +13120,23 @@ void smb3_preauth_hash_rsp(struct ksmbd_work *work)
 	}
 }
 
-static void fill_transform_hdr(void *tr_buf, char *old_buf, __le16 cipher_type)
+static int fill_transform_hdr(struct ksmbd_work *work, void *tr_buf)
 {
 	struct smb2_transform_hdr *tr_hdr = tr_buf + 4;
-	struct smb2_hdr *hdr = smb_get_msg(old_buf);
-	unsigned int orig_len = get_rfc1002_len(old_buf);
+	struct smb2_hdr *hdr = smb_get_msg(work->response_buf);
+	unsigned int orig_len = get_rfc1002_len(work->response_buf);
 
 	/* tr_buf must be cleared by the caller */
 	tr_hdr->ProtocolId = SMB2_TRANSFORM_PROTO_NUM;
 	tr_hdr->OriginalMessageSize = cpu_to_le32(orig_len);
 	tr_hdr->Flags = cpu_to_le16(TRANSFORM_FLAG_ENCRYPTED);
-	if (cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
-	    cipher_type == SMB2_ENCRYPTION_AES256_GCM)
-		get_random_bytes(&tr_hdr->Nonce, SMB3_AES_GCM_NONCE);
-	else
-		get_random_bytes(&tr_hdr->Nonce, SMB3_AES_CCM_NONCE);
 	memcpy(&tr_hdr->SessionId, &hdr->SessionId, 8);
 	inc_rfc1001_len(tr_buf, sizeof(struct smb2_transform_hdr));
 	inc_rfc1001_len(tr_buf, orig_len);
+
+	/* the same session as in ksmbd_get_encryption_key() */
+	return ksmbd_new_enc_nonce(work->sess, work->conn->cipher_type,
+				   tr_hdr->Nonce);
 }
 
 int smb3_encrypt_resp(struct ksmbd_work *work)
@@ -13149,7 +13150,11 @@ int smb3_encrypt_resp(struct ksmbd_work *work)
 		return rc;
 
 	/* fill transform header */
-	fill_transform_hdr(tr_buf, work->response_buf, work->conn->cipher_type);
+	rc = fill_transform_hdr(work, tr_buf);
+	if (rc) {
+		kfree(tr_buf);
+		return rc;
+	}
 
 	iov[0].iov_base = tr_buf;
 	iov[0].iov_len = sizeof(struct smb2_transform_hdr) + 4;
-- 
2.43.0

