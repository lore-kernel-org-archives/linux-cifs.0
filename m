Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458825;
	b=J5uPchKXi/YKdzTT8JEO1Okc/yKPYwRFJBFwJegw2tAfuMRTDGDSFB/3ctKaKVqK43Sw
	 ty1mofOm6ApjczxL+I2ljbpNG715jDLpfzRQv5+DkjyzhmNOH+lHsZe1PV2K4Gj3EvVs9
	 gXkSpeLA2sQ5W4gjsi0JwTvqnzJ8Q/gNVz+qWl+/gLk2zCigF3RSBtDhK6TQnHaJ8XM7U
	 ydC0VyYTnz4V5to/Ojomld6gJLrLk59elF+mhD+9vcx9HGZZNUtVWTfAw0NLUsCsPw5uu
	 dLMkTbN+nXPFAb8Laft/QwgWTw1ROQb0YF/g8j+u4Bg0Jq0SJQBCffsqqlybSeLzSnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458825;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q8c3UeDDZ2Cohlo9S9hkBasRTsR/4XAGU8lAirWb5h0=;
	b=S1floDu51V3w34uwuI/GxahYImKg0IWzn4QTyvrAzpyRh2BIRK78zHwHaJx2E5wxRXhJ
	 fc+bacK0Udua0puyrlhgefZtWMDUMFVh+Rh5MuYBOtCiSPjdmJi8hUUZo8owkTMaiTGwb
	 GzTTjD16peymPHiLJ7jF+ZtW4aJQV8LoFeGmJsKwZkLvxeZgJCC38rTd84Q1pkNGNaPoo
	 c7LLpBmFSIvBEuNAz36W20YLsMjPWvFNqaB5QAG+7gKUsZXP6PSZ8TniEy5XDabHks1kz
	 1DcZKDrDN/XxZWvf5YSWJgwEpznNHo8Q/nz8vvPtg7m9MytPxoCHyXbmBBO5dZZ9P0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L1TZdHpe;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681ED606A339
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 04:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 681ED606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L1TZdHpe
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-15ea896ddc8so5910353c88.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 20:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794458824; x=1795063624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q8c3UeDDZ2Cohlo9S9hkBasRTsR/4XAGU8lAirWb5h0=;
        b=L1TZdHpecSQ1CfCrPBwQFR3O+wjOmUrSRj+SGSI9kyrG44nLpKV2598297RC5/kJk6
         AUKMG2I7DHkLejdca8HvWhUZuWKPr1o/MK2c2B3swu0GVOfUnjxqauqqbmsab23cr3u4
         aAaxGWzBhNFx9I/6OHLy+aDE9i18DCxolaBJTzoDxAE/4asRoLM3zMcPreQXmjgK64Kp
         lyvkqLbXS8ijrr+uCYxoRt+QAkKTO+0uP71gneFxUxSVpkl/gJKRV5OIMEuAlhuklcy6
         +oTVnZKcvGO4vqQisFJSIkZWDciS6OYDoit7kONBBl833ThXw2Zof/WYrHoUbImxTaOs
         ha8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794458824; x=1795063624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q8c3UeDDZ2Cohlo9S9hkBasRTsR/4XAGU8lAirWb5h0=;
        b=Bj8QqD54XMKepln2KwSnmBhslRqttN1Y4pvGGp3tLqh0PYgQu7PuSQCtAYDsEXgKat
         UDyAtY2YpHmXcqwXRfxQ9hFaDOl/+uNYMH+CIBvVB5VLT1wTxqjD19d7BMRg9Ox1GuYD
         aWbgMcTkM7cjUF6DVTs9zKsbmjO04Ujyjz/PXFESVmsCxhO3n+auu9pPX5QouKCgyl8B
         4lznVWJlXeD07TQXZb2oOvOhxaiU4cCOa9cct7/JAYm341HcnfBU/WEBKUaEUMsisAdz
         VUKdaiFCHo2YZ9Glg8Lkle4yekHl5YGvPHyuaISUZDtka0m2BHjBz13FOHQg1hqWGf6r
         VBcw==
X-Forwarded-Encrypted: i=1; AL+hErF2LO5eahLe9loRTCuad5CJbhIKLmBwZkygRhjLpE7hRuI/BSHrBCkq5sD/ighk1JrePOimzJpXdArm@vger.kernel.org
X-Gm-Message-State: APuU4Z95HtK9xhxIyZ6EAVrqG38ECIuLa5ShNzW6iLH2tCKtL+xplp4s
	aP6TPTeo09/rH3Pdj5L5t5SmwBxQDplsPfcwOmt1OYqTgt6BOJZMtOMaGPcRqGq2QPb6ZgNV
X-Gm-Gg: AYBFou0XBw1Gk7tKKMQLG8O5dDsS1S64u2IcikuTY/2oAk5F1xE47R6zl8uKxEB82Eu
	DNB+mrzHOl0Q4wFgQ6g6DeLHNFWUR1kxrn2sGW8Xye5ILO1iXfUg9PCohW+pfQKED7Pqj+fh5u7
	BeSlx+DWBt1e/3fK3Xl4ECcBzck4+bNCFR1CVbLNDzRFXi9R0zV1MfSbTIr8FThMo+QJa/ZxAdS
	Z6UbAbpNVg6wmUU0HKx8vfYXZqxtxFIi26544udFmwbSdwiYJSmJFd6Qw3iSwdZmUuEZVxeUzgJ
	WAaeQhqaTqlnIz3Ma+J9pAzkgeZ4r2NKRQEkGEhHcEr7ww0vAs2AqbSuAySvDAcSR/YwZa1rniV
	xXy41uhr9dxV1BZBNLNBQwcG54EAjtFqCCoVMb8eAcGrx6g7S29vdPQVtvt6v/9I/MWlrRgvsPN
	LHKApKBYvnaHGw3K01ivON2q3aECP6kdyqTm0z6bq4HP8fOryZT4ATBvR8gXNf5/Tl5/SlI5M2Y
	fwimWatVOh4J531uulGs9p47qIFuBnfKbQmULUhUXlHh9GEvZF8hzLwNdNrlPWhp8tGbI8s288S
	RJN//wYIRbRVRUM7QbU197roGTbNOW8VhoIYVJD8xOFYS+yptTAvOOutkpJzQlHqA2nMtBf1/Ls
	QipkfRN2R/IkgW4zLCkr71RIrn0RKGOsQacVJDXSbcwO2Vw==
X-Received: by 2002:a05:701b:4207:10b0:1b3:a05f:892d with SMTP id a92af1059eb24-1b3c0353254mr4103959c88.40.1794458824432;
        Wed, 11 Nov 2026 20:47:04 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:5d51:6f:e2db:335d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2fc14sm21024827c88.12.2026.11.11.20.46.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 20:47:04 -0800 (PST)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: linkinjeon@kernel.org,
	stfrench@microsoft.com
Cc: icb@fastmail.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	ematsumiya@suse.de,
	lsahlber@redhat.com,
	hyc.lee@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v5 2/8] ksmbd: sign with the negotiated SMB 3.1.1 signing algorithm
Date: Thu, 12 Nov 2026 11:46:39 +0700
Message-ID: <20261112044645.4074-3-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112044645.4074-1-mike.michalo@gmail.com>
References: <20261112044645.4074-1-mike.michalo@gmail.com>
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

decode_sign_cap_ctxt() stores the algorithm picked from the client's
SMB2_SIGNING_CAPABILITIES context in conn->signing_algorithm, but it
runs before init_smb3_11_server(), which then overwrites it with
AES-CMAC. As a result the negotiate response always selects AES-CMAC,
even for a client that only offered HMAC-SHA256, and every SMB 3.1.1
connection is signed with AES-CMAC.

Keep the negotiated algorithm and sign with HMAC-SHA256 when that is
what was negotiated.

Connections of the same session can now have negotiated different
algorithms. MS-SMB2 takes the algorithm from the connection a message
travels on (3.1.4.1, 3.1.5.1), and a client that follows 3.2.4.2.2.2
offers only the already negotiated algorithm on further connections, so
for it nothing differs. A client that offers another list on a new
connection, as the Samba client can, signs the binding request with the
session signing key and the algorithm of the connection that set up the
session. smbd verifies it that way, and smbtorture's
smb2.session.bind_negative_smb3signCtoH and HtoC tests expect such a
bind to succeed. Do the same: store that connection's algorithm in the
session and use it together with the session key, while channel keys
keep using their own connection's algorithm.

An AI assistant was used to draft the patch and as an independent
reviewer. Testing is described in the cover letter.

Fixes: 378087cd17ee ("ksmbd: add support for negotiating signing algorithm")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/auth.c              | 14 ++++++++++++--
 fs/smb/server/auth.h              |  4 ++--
 fs/smb/server/mgmt/user_session.c |  1 +
 fs/smb/server/mgmt/user_session.h |  2 ++
 fs/smb/server/smb2ops.c           |  4 +++-
 fs/smb/server/smb2pdu.c           | 20 ++++++++++++++++++--
 6 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 0c51ca0cb14db..fc6ace49584b1 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -504,19 +504,29 @@ void ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
 /**
  * ksmbd_sign_smb3_pdu() - function to generate packet signing
  * @conn:	connection
+ * @signing_algorithm:	signing algorithm the key was generated for
  * @key:	signing key
  * @iov:        buffer iov array
  * @n_vec:	number of iovecs
  * @sig:	signature value generated for client request packet
  *
  */
-void ksmbd_sign_smb3_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
-			 int n_vec, char *sig)
+void ksmbd_sign_smb3_pdu(struct ksmbd_conn *conn, __le16 signing_algorithm,
+			 char *key, struct kvec *iov, int n_vec, char *sig)
 {
 	struct aes_cmac_key cmac_key __cleanup(aes_cmac_zeroize_key);
 	struct aes_cmac_ctx cmac_ctx;
 	int i;
 
+	if (signing_algorithm == SIGNING_ALG_HMAC_SHA256_LE) {
+		u8 mac[SMB2_HMACSHA256_SIZE];
+
+		ksmbd_sign_smb2_pdu(conn, key, iov, n_vec, mac);
+		memcpy(sig, mac, SMB2_SIGNATURE_SIZE);
+		memzero_explicit(mac, sizeof(mac));
+		return;
+	}
+
 	/* This cannot fail, since we always pass a valid key length. */
 	static_assert(SMB2_CMACAES_SIZE == AES_KEYSIZE_128);
 	aes_cmac_preparekey(&cmac_key, key, SMB2_CMACAES_SIZE);
diff --git a/fs/smb/server/auth.h b/fs/smb/server/auth.h
index 7ce9c42d58f1e..5a10482678ee4 100644
--- a/fs/smb/server/auth.h
+++ b/fs/smb/server/auth.h
@@ -59,8 +59,8 @@ int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
 			    char *sess_key);
 void ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
 			 int n_vec, char *sig);
-void ksmbd_sign_smb3_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
-			 int n_vec, char *sig);
+void ksmbd_sign_smb3_pdu(struct ksmbd_conn *conn, __le16 signing_algorithm,
+			 char *key, struct kvec *iov, int n_vec, char *sig);
 int ksmbd_gen_smb30_signingkey(struct ksmbd_session *sess,
 			       struct ksmbd_conn *conn);
 int ksmbd_gen_smb311_signingkey(struct ksmbd_session *sess,
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 15662fd745abb..87aba04a8cbdd 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -557,6 +557,7 @@ int ksmbd_session_register(struct ksmbd_conn *conn,
 	int ret;
 
 	sess->dialect = conn->dialect;
+	sess->signing_algorithm = conn->signing_algorithm;
 	memcpy(sess->ClientGUID, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 	ret = xa_err(xa_store(&conn->sessions, sess->id, sess,
 			      KSMBD_DEFAULT_GFP));
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 5f0f6276e3168..931ca102b8392 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -48,6 +48,8 @@ struct ksmbd_session {
 	u64				id;
 
 	__u16				dialect;
+	/* Signing algorithm of the connection that created the session */
+	__le16				signing_algorithm;
 	char				ClientGUID[SMB2_CLIENT_GUID_SIZE];
 
 	struct ksmbd_user		*user;
diff --git a/fs/smb/server/smb2ops.c b/fs/smb/server/smb2ops.c
index 747276b171bd1..c5b3cf34494e7 100644
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -320,7 +320,9 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
 	conn->ops = &smb3_11_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
-	conn->signing_algorithm = SIGNING_ALG_AES_CMAC_LE;
+	/* Keep the algorithm chosen from the client's signing capabilities */
+	if (!conn->signing_negotiated)
+		conn->signing_algorithm = SIGNING_ALG_AES_CMAC_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
 		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_LEASING |
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 3d9b966235dbb..d15024d34f3d6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1858,6 +1858,8 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 	bool posix_ctxt_seen = false;
 
 	ksmbd_debug(SMB, "decoding %d negotiate contexts\n", neg_ctxt_cnt);
+	/* A previous, failed NEGOTIATE must not leave its algorithm behind */
+	conn->signing_negotiated = false;
 	if (len_of_smb <= offset) {
 		ksmbd_debug(SMB, "Invalid response: negotiate context offset\n");
 		return status;
@@ -12965,6 +12967,7 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
 	char *signing_key;
+	__le16 signing_algorithm;
 	struct smb2_hdr *hdr;
 	struct channel *chann;
 	char signature_req[SMB2_SIGNATURE_SIZE];
@@ -12984,8 +12987,14 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 		len = get_rfc1002_len(work->request_buf) -
 			work->next_smb2_rcv_hdr_off;
 
+	/*
+	 * A key must be used with the algorithm it was generated for: the
+	 * session key with the one of the connection that created the
+	 * session, which can differ from this connection's when binding.
+	 */
 	if (le16_to_cpu(hdr->Command) == SMB2_SESSION_SETUP_HE) {
 		signing_key = work->sess->smb3signingkey;
+		signing_algorithm = work->sess->signing_algorithm;
 	} else {
 		chann = lookup_chann_list(work->sess, conn);
 		if (!chann) {
@@ -12993,8 +13002,10 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 			    !(hdr->Flags & SMB2_FLAGS_SIGNED))
 				return 0;
 			signing_key = work->sess->smb3signingkey;
+			signing_algorithm = work->sess->signing_algorithm;
 		} else {
 			signing_key = chann->smb3signingkey;
+			signing_algorithm = conn->signing_algorithm;
 		}
 	}
 
@@ -13008,7 +13019,8 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 	iov[0].iov_base = (char *)&hdr->ProtocolId;
 	iov[0].iov_len = len;
 
-	ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature);
+	ksmbd_sign_smb3_pdu(conn, signing_algorithm, signing_key, iov, 1,
+			    signature);
 	/* Restore the request as received, for the SMB 3.1.1 preauth hash */
 	memcpy(hdr->Signature, signature_req, SMB2_SIGNATURE_SIZE);
 
@@ -13035,6 +13047,7 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
 	u16 command;
 	int n_vec;
 	char *signing_key;
+	__le16 signing_algorithm;
 
 	hdr = ksmbd_resp_buf_curr(work);
 	command = le16_to_cpu(hdr->Command);
@@ -13042,12 +13055,14 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
 	if (command == SMB2_SESSION_SETUP_HE &&
 	    (!work->session_setup_binding || hdr->Status != STATUS_SUCCESS)) {
 		signing_key = work->sess->smb3signingkey;
+		signing_algorithm = work->sess->signing_algorithm;
 	} else {
 		chann = lookup_chann_list(work->sess, work->conn);
 		if (!chann) {
 			return;
 		}
 		signing_key = chann->smb3signingkey;
+		signing_algorithm = conn->signing_algorithm;
 	}
 
 	if (!signing_key)
@@ -13058,7 +13073,8 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
 
 	iov = smb2_get_sign_rsp_iov(work, hdr, &n_vec);
 
-	ksmbd_sign_smb3_pdu(conn, signing_key, iov, n_vec, signature);
+	ksmbd_sign_smb3_pdu(conn, signing_algorithm, signing_key, iov, n_vec,
+			    signature);
 	memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
 }
 
-- 
2.43.0

