Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794253326;
	b=J2aBTI0PYb5SYGGZYhLLZAU4nJttK1QUzfYpnL2a4YnfFTdcCOOzrAofQJ70vhrbMryB
	 C2JwkXzcybx82sN4HcXa4FjTECDKdKieDRJ9F02UkgygjlTfe899lQrHWDeDDCq3jMa+6
	 rwjb0vnaIZJ+OdYn+ehHMlXAsIPPp3ttKWa50UcHyAawf9G8W7vi/f0E6npA4kRYvrPMU
	 otpjMnDE1fiyyVD2gT7LLSH5FGcBwGZdwxVJ4OH+CyALxfwWi9YlRHLHByeuEi0inT0FI
	 F1rZ4nHZ3rS7W4RNM3t1y+3BjxcI56Bxx60+rn3Bfmh9LnQ/cdPTm2Ik4PqrUw2jCpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794253326;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TgBUS/DQ/xz4w+M5djBfi/qc8Y4BNVRQioLu9MZffZY=;
	b=pdcUebtS2XFF6uqSh93duawmLQ1o3kbqVq2SRUdDxDJc8jRzIgiWZvq4V/LuvYgUdwDe
	 wZUfNHUEmF9333s1uHPaZM0IXtEqWHrSbmcq50QKoh009Z6IiqvgF/VQyTOZPmf62yyJm
	 ktaaVXsnpE2QAnYAAhNx3MtIAwnXEiJx3UEUayUQXnYcJtAWnK0B1S0Ezn/5dAqX0zuok
	 59ny1IvAj5cCzeVqlHk2In3abRwG0xnMcMfdJfE8SNOGFCbh3W2clJmaCvHyl1x12mUku
	 1C6akDYxuJ4cmJeq65hIUnIDpejqQDTedelYnKYgAovOu3jSiw2vKLhsJPdpbQ5lvdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=N95TO9ZW;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADAF606A321
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 19:42:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6ADAF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=N95TO9ZW
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e987a2ba0cso7208545ad.3
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 11:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794253326; x=1794858126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TgBUS/DQ/xz4w+M5djBfi/qc8Y4BNVRQioLu9MZffZY=;
        b=N95TO9ZW6w/Ki0cdwvvyuBW9Ql0PqB223WLUwTmK6vCqdpYt2TINSRNYAa8+Z68VYn
         LwFm3rWj+y71CkOJXCMKSDlUsUwKNnzGvDWnFPEWur2Ow6HLxurcKiWG8eqBFyRXF3C/
         7NcwJpCjZyGfCxhFB7MO8/FTS91f3Bq/ucgkYT+R4t2AQREMz6ithJtIN1QRvAtOf1MS
         UlDvOCmumkOXvpzNRQdtQlpddUBsodanqcY+1x8FcU+dJ4jDviAmo5hEGMlVGHLoXpUU
         8SIrLHcpi0nfOn7mk53MrX3prHblUwUNaUrIc1gPpWahNfkDz7Gc0kzipAnQOBMhsD1y
         OtbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794253326; x=1794858126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TgBUS/DQ/xz4w+M5djBfi/qc8Y4BNVRQioLu9MZffZY=;
        b=UGHCVRgaADCdj0paRg6XhHQPgQVlMWm/4naxNhggdoXicOGkV4Y354CbNEOKlczNG9
         4X36RBnTsX39KVsWdwUC0DFHaFovAl79xc7tL4U9O0ksTyn8BAqSheXsAQwguu9RRd3B
         s2KwCGIXsh5LPiKjkSO8clqZf3O26bO2D38cw9FF6A3kD+JOymhXRxgCoel+5sDZwhq2
         N1Tq3JHlnp9ZiaSxCt4lyEEfRSUb7HvWlySyMlf0tGc6bC+QZBg6ZuhPvQcv/zf9x6kC
         CrBBNa5wzmNYFsGf1nCEh/aNaw7HwE7ZyWMM6862rdfherFvs5uLIFKrYLh2bENQHit+
         BmpQ==
X-Forwarded-Encrypted: i=1; AL+hErGIICO8R+OcZAx8xCwxAebox8DnDlGJSVAUkPDJeEunca8WjFgcIVZo+3YsiF32CHdoM0fwPWhCZUgJ@vger.kernel.org
X-Gm-Message-State: APuU4Z/8xWw2Zmiye9j0Zt8lfFkSELRgSHbg+3jytN1BB/eYrWBjf9qf
	mNwofrRaWqXEIp5gg6kDfUvnAOmlCRpcgLDMk/Yavp63v8NglafYGcF9
X-Gm-Gg: AYBFou2STIWQSVzLh7xsHWnpjXYN09odsLPV+0MrMUTHkyklySuL/2aFVTnvHZIh9pu
	MRpiyCig5BPuqizgKh+JosOJFdrbPyoafpyQJEfdS8EpJmqvQUEaUP3gK65G1YbkScEDF++cwep
	CpiK5h2FXrWWKQBfV9F46j8RNHiumHDVzlCEc9d18jlrPe/5WYAFJS/+tcx2b/AsTbe0acrfoH/
	YMVswlVXjNAq0fbOITSkKQ3QWKK5bCHO9xkd47qA8mCKFKQRyPzhPzgAAnBwZ1PaaTM382pxlTG
	d2j7+WVtocuUkafHezgvmHhQ0UfoqUq/zQ1eCGFfgbs5SgWOJI7qMjLpZmQRkYQGESnSfmjv802
	DWjfagIhAnLpSga3cLp/xwy18xatJhESqVwo6HWsRRbRoYyNqDFAFesEYa8zvd9BCWLycX19Dqg
	PUb2b/ydPmcfFsIV0aHyWtOFMBtzMf921MlK11nQj74bc8E2l3qKZrJ18PUezZow66IxSBfdaPH
	XRH7jCUsHeh8PeDIR7KW1t8sDIqrXUE2+qk03NWu15ROMYoPTj9yfFU4oQkl7jhdzRV3CtTfp2/
	KhcLVaSrfxMZrSoF8Pm8ves6DQ6QLaL5ZOajV5qNrYyhWH/Jhv/5p2pL/1/ccUkNjsuraXwixMv
	NC5dLs8EZ63tA+IK/umD0k0lOOslgvVelZb2gIEvaxSCupOimxhfkrIk=
X-Received: by 2002:a17:903:2f45:b0:2ed:1c15:ffc0 with SMTP id d9443c01a7336-2edb91be092mr1607515ad.30.1794253325888;
        Mon, 09 Nov 2026 11:42:05 -0800 (PST)
Received: from localhost.localdomain (mx-ll-183.88.2-201.dynamic.3bb.co.th. [183.88.2.201])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d4b950sm1388585ad.13.2026.11.09.11.42.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 11:42:05 -0800 (PST)
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
Subject: [PATCH v3 2/6] ksmbd: sign with the negotiated SMB 3.1.1 signing algorithm
Date: Tue, 10 Nov 2026 02:41:40 +0700
Message-ID: <20261109194144.22814-3-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109194144.22814-1-mike.michalo@gmail.com>
References: <CAKYAXd-Jo-ObBDs-AdGfaM+QmDsot3gj1g0oJiyDKczoUDg2TA@mail.gmail.com>
 <20261109194144.22814-1-mike.michalo@gmail.com>
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
index 0c51ca0cb14db..78e35f2174603 100644
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
index 129a4c5c74f44..af1e7aac4ded1 100644
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

