Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704519;
	b=GNp+2ZQUP+Mbytjj8Q6pZmG6A5BP+oSILbwdAwC/sjUDZuzN1bIOKWvbf0+r3HE0jphQ
	 44lDySma6VmpHFU4SnrG4KFToAUQ/EIi3cja4a90fPMKa23flLrqwEU7qtyoRNW0+v/SP
	 EpexV/SMxVRaJDhCt37F7KuJMCmH7budl4BoNHIQkr+kEhZ/RLcVMVGMZJNiM03/DqZG5
	 LNGiLPduWF/EMI3798cssOIfF8Qe4Arg6tQHVxhn95S98hHTu/Gy9XFhYOxyTTLb4RdV3
	 nHkz7Fu0l1kXjMAN6WFU8dMbmZ1nTyYJBgyO0w6GnNJ+dwFikgyLD/3mzDkm3H2bWqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704519;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IBW9D69aFqHjrawI35qiH9K2kv8Ihto8nmMTZG22Dxg=;
	b=hvhOFeW+knFTk/E8MTLmBcBdqPgP9QEru+N+c99NtxdTJ7tf40oIvnwqPmx/aarl2H7i
	 u2abt+G+1eYpKC6g3uZkKWFI2FS0me6oYfbblvIaLfBwfiLK5lqoZUxZQdd1Pp7OuWE44
	 c7+Fc3KPsVW6fEEP79nAFYCuaGbNLXXm41L8gjVK727teZAGkMBR+p8hj+RlPfy6gOa5m
	 eCNbXuk+b/rKNucHax8m565OL9xZtJjPiD7u/Se4N4Oe9ERqjA/D8QM0MWcpiZ3VeEuqy
	 QMwzfMj91rzJ0XviplErfFuhPSTi3YmPaEunKFcKcKE9gIXnh7doWt/YpZ1Sbo687Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=syT1QSve;
	arc=none smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11178606B111
	for <linux-cifs@vger.kernel.org>; Tue,  3 Nov 2026 11:15:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11178606B111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=syT1QSve
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b4bd3d98bfso4777899a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 03 Nov 2026 03:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793704517; x=1794309317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IBW9D69aFqHjrawI35qiH9K2kv8Ihto8nmMTZG22Dxg=;
        b=syT1QSveYUG1sQM9eKrqoZde4GlvKv9AAPiFz7OAbwjoLGNeggyFypdWa+T6d/7zsi
         obd8+JprjHrgyMhh4IxMuBAAgeZNPYQTe17aaoKiFD1a60bJA7san74YLox0s5H03kDA
         96VQTGEX6LvxOulbVVlszSUsfdk7uebeROw2Q5qBuvcxJr9YyYo9QwKsH9B42AkVpcIB
         wCLva73alWv1ORC5RM6PcKiNXWh2hhnaHb5Frlc3YQ/11xSN0pU7llcCMtBu0TLYiVzo
         El/0SV1CJr1Odh62YTEmBwkLXaj9Umzvg/4Rlx11nCSzxpeuO/E4mIlO/cxbRkK1rIrp
         wQgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793704517; x=1794309317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IBW9D69aFqHjrawI35qiH9K2kv8Ihto8nmMTZG22Dxg=;
        b=1RmrUvjMYS6a+KycQditebtAbM9tCveaPLGLDmgMWEAmxUSH07JFVOkPej/uU8tKrD
         Dk7/VENF8UlbbuFTVMos3S8bzfa+YuNkC4/MRoLxpc4lyPwwO4HZgohDEjCXVlwHRG+Z
         MafXTqygbY6aKq9USU413FpwvFK9Lcz3WLXO/BN2ZCqy3G5QmomPd9nVBiC62VBl1YRF
         vqV4NjhYJC5ynbYZmiaTXyF7Uh00N0+guE+Z3pF+0Wc+f8xgJLKQhyuqVTrzBAZR5Gfr
         HZL2divSgPGPJm+DLuugZkOlO9bWZxY1h88FVzayZv8oAooupDKoQzTCcaGx4UdNKlHy
         lY1A==
X-Forwarded-Encrypted: i=1; AKwUvByABhUUn0fQDoLNcMCKWTAUBaDvd/XUHQv/XT9N2SpkSa0NcaHWi2wKjp8+VYZYHr0OXCb1xHxzI51e@vger.kernel.org
X-Gm-Message-State: APuU4Z/G+JYqKaDPy0uH/jw3zLWujusMQ/B3iBp1HdE54Drv46x+CHZU
	ykdf8A3NbJgUuKQXRcnDQBCK8+nR7+sqSdjsgvLKMktI4kolYGMH5egA
X-Gm-Gg: AYBFou0OoUSQQGIJ9oY9N51N4lw7psiodxYb+5xX0a/5ixL4hddK6uEKr6HJcC4Ak/q
	XClMhtxKwM2mi7CdMZf/AyNWBKpYhxgyGb4ZjQpq+YXO9pFye1ONLBZHsnfL92Jx3hIGftm4RGj
	wHtfGz5fNBW25TALgbHtGnUAFLwFjhFcyEeAcJPQ7YEBLtt9O3yxsxG45Ikr9fULNS+iyUyijJu
	Prs6Wz6RfIpl5ahMG6z1LoHPUXRkIRaew8zDPrINO3db8IyGofIlDQ/DPuMu74Qv3BAUD2lmvxy
	ooL2heA63h6Dq/GAuUccxat4Qrhlik8Dok2Pf5o+4nUI5kRppQO/5F+tHQ8l9zYFl+cMxt2jTre
	+VKes2dEA8y2SaEUO0KXPjq5a0WuW2z+XaosY+CZtydTppGGSWmHUx59twn+WaZgfaD1MNUPno7
	iNhE+ZAQCUWcxrshhIDV3lPX+MkZvY9yaOk6G9gJjl2w6nb2alxbyQKcdhHkDRjQJhk6YTJ/Hs7
	IgN6d2sAeUjxmIJgpGNGFQvlfImyL/PTJ6qyJsmQWgsj0hnrWKoMbMzUxnl47x41moa/f15Dett
	bh5s+CkaPyVUvdrQz89y8AJekb1pYEB5Y7XaS0VpvHd4JnQKkLeK5oeGB4w25ulEjfF2guFe7wn
	s7USgZMHz5AHzHvzBYfQFphcfwxdkeR+tfBt8HaGk
X-Received: by 2002:a05:6402:1d49:b0:6b4:1037:2bb1 with SMTP id 4fb4d7f45d1cf-6b4d4d7ae69mr9249040a12.22.1793704517352;
        Tue, 03 Nov 2026 03:15:17 -0800 (PST)
Received: from wlan-199066.nbw.tue.nl (wlan-199066.nbw.tue.nl. [131.155.199.66])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4eca0f376sm4349291a12.26.2026.11.03.03.15.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Nov 2026 03:15:16 -0800 (PST)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ksmbd: sign with the negotiated SMB 3.1.1 signing algorithm
Date: Tue,  3 Nov 2026 12:14:52 +0100
Message-ID: <20261103111453.84804-2-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103111453.84804-1-mike.michalo@gmail.com>
References: <20261103111453.84804-1-mike.michalo@gmail.com>
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
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/auth.c              | 14 ++++++++++++--
 fs/smb/server/auth.h              |  4 ++--
 fs/smb/server/mgmt/user_session.c |  1 +
 fs/smb/server/mgmt/user_session.h |  2 ++
 fs/smb/server/smb2ops.c           |  4 +++-
 fs/smb/server/smb2pdu.c           | 18 ++++++++++++++++--
 6 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 0c51ca0cb14..78e35f21746 100644
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
index 7ce9c42d58f..5a10482678e 100644
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
index 3f75049be87..42419bc0cea 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -553,6 +553,7 @@ int ksmbd_session_register(struct ksmbd_conn *conn,
 	int ret;
 
 	sess->dialect = conn->dialect;
+	sess->signing_algorithm = conn->signing_algorithm;
 	memcpy(sess->ClientGUID, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 	ret = xa_err(xa_store(&conn->sessions, sess->id, sess,
 			      KSMBD_DEFAULT_GFP));
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 5f0f6276e31..931ca102b83 100644
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
index 747276b171b..c5b3cf34494 100644
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
index 2e955d272f4..11994e6b92e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -12919,6 +12919,7 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
 	char *signing_key;
+	__le16 signing_algorithm;
 	struct smb2_hdr *hdr;
 	struct channel *chann;
 	char signature_req[SMB2_SIGNATURE_SIZE];
@@ -12938,8 +12939,14 @@ int smb3_check_sign_req(struct ksmbd_work *work)
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
@@ -12947,8 +12954,10 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 			    !(hdr->Flags & SMB2_FLAGS_SIGNED))
 				return 0;
 			signing_key = work->sess->smb3signingkey;
+			signing_algorithm = work->sess->signing_algorithm;
 		} else {
 			signing_key = chann->smb3signingkey;
+			signing_algorithm = conn->signing_algorithm;
 		}
 	}
 
@@ -12962,7 +12971,8 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 	iov[0].iov_base = (char *)&hdr->ProtocolId;
 	iov[0].iov_len = len;
 
-	ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature);
+	ksmbd_sign_smb3_pdu(conn, signing_algorithm, signing_key, iov, 1,
+			    signature);
 
 	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
@@ -12987,6 +12997,7 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
 	u16 command;
 	int n_vec;
 	char *signing_key;
+	__le16 signing_algorithm;
 
 	hdr = ksmbd_resp_buf_curr(work);
 	command = le16_to_cpu(hdr->Command);
@@ -12994,12 +13005,14 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
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
@@ -13010,7 +13023,8 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
 
 	iov = smb2_get_sign_rsp_iov(work, hdr, &n_vec);
 
-	ksmbd_sign_smb3_pdu(conn, signing_key, iov, n_vec, signature);
+	ksmbd_sign_smb3_pdu(conn, signing_algorithm, signing_key, iov, n_vec,
+			    signature);
 	memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
 }
 
-- 
2.43.0

