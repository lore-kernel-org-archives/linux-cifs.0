Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793992009;
	b=ifHjle9/y8Ub4kX8rJIH2oZmuCX7VcZlmDHsXtUxfg6xdR18RYP4FYnCJ8lj8bFZYDWE
	 lFwpaW8qPMH3QuUjtbHmnPzYFX0/5y1+5devrcaMoxVPudQN029lTlf9rHAPJAN5mD/yw
	 OGsZtasHRBh128EM0Nnm3H6/C++Zn5FYldZsdgbvIj/ELnSg011iXrkucieLZkIRPx/M1
	 hOXJyp1IORZ59WGtHwxnO/d7vw2wK8wR+HVR4hVN+XY3rFaulcFixpQGdYSi8reB/k7lJ
	 jIYBRpX9uUMxb2tnzDWifE3oPmdkYA2BDugARogseV71hQm7ONu4tL67y7HiGsxq3hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793992009;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G4wcGSPywizuz6WLt/V7VZ01SqjkzmSa+pj8d+IMRtw=;
	b=UnGO/A9f+1hSnYmb8joLS6qSTpX+glXzxQFtpTHQoGm4T9fRCsR1+9B/6zH6YrkSPjSB
	 /2LhByRnOrjUo0sY3mEa2NUtHeQWbD5B7jF/awnbO4TObbelhyS4pDNlSgLfZ0pPM/LpH
	 KF/JRe87mtJcSA8/r00Rbin6DVMLfyyBrqekLZ1+5bfJ49BTCsZS9Mz6o4dJysThqfQQ9
	 uh7mR7fj/LRGAt/ewGT2Fs0C7YkO+vIyBqzrX3zWFev8rw4Rz3tyDuiRm9yT+AkIk15B6
	 G+ouTt6Pvy2U0jKdixjktspTd+nqXSSnNqcXifPSLbJgB7RuaqwMpxXLWyFD0mRwxUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FhxyT6U5;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BC9606A32F
	for <linux-cifs@vger.kernel.org>; Fri,  6 Nov 2026 19:06:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6BC9606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FhxyT6U5
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a2167bd087so9393085e9.3
        for <linux-cifs@vger.kernel.org>; Fri, 06 Nov 2026 11:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793992007; x=1794596807; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G4wcGSPywizuz6WLt/V7VZ01SqjkzmSa+pj8d+IMRtw=;
        b=FhxyT6U50q3+NokQYZI7WRKNv4ikUUUPI0tfIt1uGZiEUMm4MHLZa31Oucy+UXUnkE
         z160CEsAMMNUPUz3yQejUeEexY7NEIYhPiI50JvlSPMpFruTdat+MB/FFrlr2OemFdip
         AhCKaF7sVicsjT/GaKGCgY4abmdLCzgg+8EqMeN9MVYoaksuCaOQbh4DLtQFUQG8l9UL
         xiIKWjlhoyGF1C0msXw3tGoywfG1DhsCqDVz4JeNJQd1NQ5+1LFL2jD5TsJ5Du9QleFy
         Qi0sAeF6LV0deLvEhjynk3tRW/Atf3u965NmxlWeokcZMQ89j8zvE4u8FLvAvjiGM4jf
         FlsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793992007; x=1794596807;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G4wcGSPywizuz6WLt/V7VZ01SqjkzmSa+pj8d+IMRtw=;
        b=ofQ2UumBOczpGKoch+TVPcJLauhqB3PKb+Pq6KsQe7HBSieEldBQy9e3M+TaBZCR6H
         ecJUCrGqcHSUwqmH8nhxSItYJSE6EZv/OrnRxfBLjwM/BIYdJQPuGZkll7GqhF30sZ95
         oJ9dHiT8GxEjoI+JpRCRgRmJUevgKhwb1Ee0ePO9qN031GiHaKFpwElPN4J+5jQmEouy
         cGwgdlnrR92kgEPuMlK6nRPoC4CDTAMD+K0pqg0ZbtI39bXGmgx8JvQFoNwoBw728dB3
         8uu6RsOWYP+/zOrw05SYHoHJZeW8E1JsvrbG/ipGMU/q+wYPfmKDTC024Uf7Q8GF9ifK
         yZbw==
X-Forwarded-Encrypted: i=1; AKwUvBywo3JuCPjiNZxeUROll0tTVqN17yrO0kFrdL2TXO4lZj7Z0E1RJWBfrk737Nn9nFeAbrdaVmTeKjN3@vger.kernel.org
X-Gm-Message-State: APuU4Z8EbSbPSMY2m+uK+oB6jGSMTO6XL1FOAPPWNLJYP+NoenaOi1tR
	IutsTbluYicZphK6t7kh6Kxwz958D6mzgvHZOOxDVVDeFIpHdZtcvj5t
X-Gm-Gg: AYBFou2PRqh7qATqf4l9dQF1BIZaEXhMXujd3rJ8RceNVW9OA/p9Qjr3hjpAAuQYok7
	rbpJjx2/PJdLz8moNhoCPCGE5JR2sKqvPKqx1Xmv5JlgSGNahPyAwgLRY0LtGZE5aSlmsk6k9J6
	15WDIxwiM556uz/sm2/8YKlnoJpnKxPHIJlMstysf/Wit+kDqVuiukdcqpVbC2yxO7huBr1fQEx
	zejX+4Hym/T0BOLAqF7WUQwXbQV1jLuUnDIOynszVMgdLDcnZ3MxJv041JMe+0mxAch1JYWfq6F
	YKggGLMI9b+zlOCGwIH5J4JZ4fQwJU/WJDAbd4noTlmw7AgR8wIzNQsGtKXweowh4gYqb38ihj8
	e7O9/+G9EktDdTgx5uON/H/zw+X6JT/mJtZC86uguilDjsuzcC5b3nBtsa3XANY1kUnTqOoAPqs
	6CAFpGk1AeZHqiLlD0cPMUGKAwdyOpnpTqFrS0H2zVsVKJ85YMsqowcApoDyKIONUAq+37ZtgD6
	naHukVli1JJXgaIopRi0PE4Xg8ogyWQNTwn5fGJRDs+uAWkIoI5Js5OBTdc9m7DVW8yvyQ1nKYg
	5NLrgGWsX2ZrOC7obNPkazBoe8wr2++jICKsZ6RDyA0WGEOTbQ/SwkammAFmSRwhkfky3L2gIy5
	5krx0cbq1uMYReGTjRy6Zn8oRAg9K1FZdbb6b
X-Received: by 2002:a05:600c:34cc:b0:4a5:dc5d:20f7 with SMTP id 5b1f17b1804b1-4b6df4f3d3fmr59748865e9.14.1793992006920;
        Fri, 06 Nov 2026 11:06:46 -0800 (PST)
Received: from localhost.localdomain ([74.244.226.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4930a5a91dbsm3960533f8f.35.2026.11.06.11.06.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 11:06:46 -0800 (PST)
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
Subject: [PATCH v2 2/4] ksmbd: sign with the negotiated SMB 3.1.1 signing algorithm
Date: Fri,  6 Nov 2026 20:06:20 +0100
Message-ID: <20261106190622.20990-3-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106190622.20990-1-mike.michalo@gmail.com>
References: <20261103171742.18816-1-icb@fastmail.org>
 <20261106190622.20990-1-mike.michalo@gmail.com>
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

Since connections of the same session can now use different
algorithms, each signing key also has to be used with the algorithm it
was created for. The session signing key belongs to the connection
that set up the session, and MS-SMB2 3.3.5.5 requires a binding
request on a new channel to be verified with it. Store that
connection's algorithm in the session and use it together with the
session key, while channel keys keep using their own connection's
algorithm.

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
index 0c51ca0cb14d..78e35f217460 100644
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
+		u8 mac[SHA256_DIGEST_SIZE];
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
index 7ce9c42d58f1..5a10482678ee 100644
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
index 15662fd745ab..87aba04a8cbd 100644
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
index 5f0f6276e316..931ca102b839 100644
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
index 747276b171bd..c5b3cf34494e 100644
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
index 211dbcdca8df..f587a76971e9 100644
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
@@ -12956,6 +12958,7 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
 	char *signing_key;
+	__le16 signing_algorithm;
 	struct smb2_hdr *hdr;
 	struct channel *chann;
 	char signature_req[SMB2_SIGNATURE_SIZE];
@@ -12975,8 +12978,14 @@ int smb3_check_sign_req(struct ksmbd_work *work)
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
@@ -12984,8 +12993,10 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 			    !(hdr->Flags & SMB2_FLAGS_SIGNED))
 				return 0;
 			signing_key = work->sess->smb3signingkey;
+			signing_algorithm = work->sess->signing_algorithm;
 		} else {
 			signing_key = chann->smb3signingkey;
+			signing_algorithm = conn->signing_algorithm;
 		}
 	}
 
@@ -12999,7 +13010,8 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 	iov[0].iov_base = (char *)&hdr->ProtocolId;
 	iov[0].iov_len = len;
 
-	ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature);
+	ksmbd_sign_smb3_pdu(conn, signing_algorithm, signing_key, iov, 1,
+			    signature);
 
 	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
@@ -13024,6 +13036,7 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
 	u16 command;
 	int n_vec;
 	char *signing_key;
+	__le16 signing_algorithm;
 
 	hdr = ksmbd_resp_buf_curr(work);
 	command = le16_to_cpu(hdr->Command);
@@ -13031,12 +13044,14 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
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
@@ -13047,7 +13062,8 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
 
 	iov = smb2_get_sign_rsp_iov(work, hdr, &n_vec);
 
-	ksmbd_sign_smb3_pdu(conn, signing_key, iov, n_vec, signature);
+	ksmbd_sign_smb3_pdu(conn, signing_algorithm, signing_key, iov, n_vec,
+			    signature);
 	memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
 }
 
-- 
2.43.0

