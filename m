Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794498140;
	b=YYCBo1EYKH0RiU6MIPwlxLpqWlqqAO+7WEnTKCPul5IzWn+l6vdjz0TUL5OYNj8fO1yl
	 u9QPRn36GWmy3U59mZYZq43gUSL1TXB4UdtLH9AFw2L+kaLK7W6JglkngJU+omBdtyh1T
	 tucTKxoUWUkpzgwQSXerckFHSfGU7eS/7qNTJJyLcn7neB7KzLpkvawuMY7N4y8ZEJ1wb
	 cqZ92ZQIgT7EmyPvA+CknkC3LPC3nfSY0Tne039KCRX7M82+48Qr8PYBjZ3pBaoDnECgy
	 bIvcqioTXg2O7Uer73MeJJNL7lb8b+bB2o3vf3gqalmqbFiyabYOfMFXBaUYIf3Ml3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794498140;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=855fiIg4e6YXSIjRPXsYqD7OMLnpOYefM2X9BYQkaHU=;
	b=po+fxdDqOEBzuqqEs5Yu8dtM9c7wCDiS2QMw4rGyGcxrmxr25DCPYbmbvg8wLxtbUlsr
	 0KdTSot7G4gTJRdXi0kmt4QNibHu3RvOsvsghYMsRwQGkpvLZgJvbnzev5qXN8fyJkUuR
	 hsYexH59oc182xcGSxEpJuxuWqA7vHDtkc9M7o4RNnGsuHSTWQzQ0WNVVStWKYq656TDE
	 9IPK5IU+4Dpt57i7yYO0J0Xot2nwVYpj2qK2B5low4s39Vk6KJG1gia36iFczXpuSIRGV
	 rx0NYMYPPVN02GWY9NHioAA+keIP5mPQY7N7gbYu7X+KLXpikdAU0KuH3z1Gmh2DKSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rALsZa0L;
	arc=none smtp.remote-ip=209.85.210.178
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D88606A327
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 15:42:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35D88606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rALsZa0L
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8b58d6f67a5so2660718b3a.2
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 07:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794498139; x=1795102939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=855fiIg4e6YXSIjRPXsYqD7OMLnpOYefM2X9BYQkaHU=;
        b=rALsZa0Ljocyf0h2Tnrx/Gblkk5OASMjB1h16Z3WzxiJhVveeMI4KptOXEfQFoNda2
         R3XQO8nE4Ec8z/ESVLdLKrycdshtGqIzN50lS7Cs5ZIir9mIlr4QK8ZzrDxDMtSvUFVS
         BEHJUg+/AXZDQVTv43pNWbqTn2A5RVW9/YptC32vDeGFeZxyEMY3xEI0scykEVRCO0Ko
         1gLK+r1xdttya0BdKe2J91xd2AoZe/jBhd3nM6DR9h+F/jXlBU10OxBNRl2V1ru6pU39
         X9g/hQhVC4vdmZYPoJnMRFiyBhHGi3mLMlgAuvhIOELou3A2xw+ls9+D9OmisHyEAgmc
         FEfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794498139; x=1795102939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=855fiIg4e6YXSIjRPXsYqD7OMLnpOYefM2X9BYQkaHU=;
        b=ns1yDf6yYVLtQIMt0OoU73RvKjq8zbaKgN6LevP0OU73XnEgQqvRHPTxHIhfA0xuyV
         M/pShDlIcuOR7kePu1dfHMAsPRkv07x1+K8tMplVLyd2jRfBc7G+vYwRJ17y5OgCFDXv
         kJxD/MHnjbQwi0tEw5/UYUwY7G/AcTjWMHewbnWYoOtfPDOdeCv5JGmqeJJ1DC0l5/bw
         0OCLzZOwRrQsvb1oS9HgwXLfwk4bq94P+pezGHxG6trs+JLrlnZoKckvZsFoIHNcfJRg
         ABjL7DhTlXvZm/rbmPJjVethz5RMrmmVHp9q/8ovisQyN/geysYp6WBUEGzpspznWQzt
         dunA==
X-Forwarded-Encrypted: i=1; AL+hErHZervZMjRX8F4tKESExX97kOu07f+e5Z8WTb3ush64xPPieVqwcPcA3ztWO+duX/TVjYd8xG4YBUu1@vger.kernel.org
X-Gm-Message-State: APuU4Z8W1bf6wAcLzcTpWZUeFpdKJw7HTsjxxo968YGKRXbZW9otre5D
	TTJHavsQQU/1ZJjwej9YaHsJCK/0oVh/nm7qNCYcIVLL+ervoOFPLbYq
X-Gm-Gg: AYBFou3eU+ww/z8y0cO8i3LJKCU132Rj6UA8/A/RY0KjM0VB4CO/Vb59mH/is0LTOeu
	GVYk3nKE4ec+kPSr+pyAxYhHlBKnS53oefT5tEFyxWYgjOLCQAQ3oOYagSALj2Vd1Q9UV3KP4F9
	X/UaPqodd7Zedlos1q7tk5OAHZAe8KXPs5k5+64NW208/6A0aInwyu/xromou2tnhXwb7zm7KNB
	afeeeA6kia1TMzZIm33GpJqFjePDThkhhlplUCX8spHGEtL/tRyJl36iPq9sTvv+47tXyg9OhN1
	w/+IRL3/4Vj+/4d3yaEQrzDbOFrzBeGRvlFbEKOeWHdC+EyHJ7mRxsgfSOatD14C58/BW8aft3+
	yRfbPOaIUbdVfNSdL9mcahXbAhMGR9wwyQrTO6rZkxMnINZHkMOhToXKoYV949gxxoaanMaRf0n
	rafL75qCRdPIApCxwUbm8uRXnofpjfqSuuslqeIVmoduIuHmkb5Gfk0FhvLDTdxa7QhQIx5B5a6
	eXYf71nzWjkbFqZ/yTOQERSKAPB12ZnS7KJidPiMJLstGl3HGf7knse5xodmVoVqVbz684abcbi
	TWilPSZirlj6r9FgDhMETdbFHajrTYP6YNnVLTL788kfAltkBuLUJMGvhcPitykMCvMXJhc95pu
	YBPxTslF6QC6onAUscTb6YD7zB+nvOYi28BgIGT41ReDHBQYO
X-Received: by 2002:a05:6300:483:b0:3e1:af52:6d06 with SMTP id adf61e73a8af0-3f2fe6cd55emr5712678637.52.1794498139317;
        Thu, 12 Nov 2026 07:42:19 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:21c4:c32f:67c1:d87c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baa7de3619sm3790596b3a.5.2026.11.12.07.42.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 07:42:19 -0800 (PST)
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
Subject: [PATCH v6 3/8] ksmbd: use the channel signing key for session setup on a bound channel
Date: Thu, 12 Nov 2026 22:41:50 +0700
Message-ID: <20261112154155.20255-4-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112154155.20255-1-mike.michalo@gmail.com>
References: <20261112154155.20255-1-mike.michalo@gmail.com>
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

smb3_check_sign_req() always uses the session signing key for
SESSION_SETUP, and smb3_set_sign_rsp() does for every SESSION_SETUP
response but the final one of a binding. That is right for a binding
request and its non-final responses (MS-SMB2 3.3.5.2.4, 3.3.5.5.3), but
a reauthentication sent on a channel that is already bound is then also
verified and signed with the session key instead of that channel's
key.

Use the session key for binding requests, for their non-final
responses, and for SESSION_SETUP on a connection that is not yet a
channel of the session. Use the channel key for everything else on a
channel, as the Samba client and smbd do. MS-SMB2 does not give one key
for a reauthentication on such a channel: 3.3.5.2.4 has the server
verify the request with Channel.SigningKey, while 3.2.4.1.1 has the
client sign it with Session.SigningKey. 3.3.4.1.1 has the server sign a
SESSION_SETUP response with Session.SigningKey unless its status is
STATUS_SUCCESS, and 3.3.5.5.3 the final response of a non-binding
session setup too. The two keys only differ on a channel that was bound
to the session, and that case has not been tested against Windows.

The signature of a reauthentication was not checked at all, because
SESSION_SETUP is exempt from the check in __process_request(). A
reauthentication of a live session with a forged signature therefore got
STATUS_MORE_PROCESSING_REQUIRED signed with the session key, with or
without multichannel: the same kind of signing oracle as an unverified
binding request. Verify it with the same helper as binding requests.
Also refuse an unsigned reauthentication of a session that requires
signing, as smbtorture's bind_negative tests expect from Windows, unless
the request arrived encrypted with that session's key. A related
operation in an encrypted compound may name another session than the one
whose key encrypted it, so compare the session of the transform header
too. A session that negotiated encryption has sess->sign cleared even
when signing was required when it was set up, so remember that in
sess->sign_required and take it and enforced encryption into account
too; merely having negotiated encryption is not enough, since clients
such as the Linux one always offer it and then send unsigned,
unencrypted requests. Do not expire the session when a check fails,
since the request did not come from its owner.

The checks apply to every session that has been authenticated before,
which is one that has a user, including while a reauthentication of an
expired session is in progress.

smb2_sess_setup() copied conn->binding into
work->session_setup_binding after its error path had cleared it, so the
response to a failed binding request was signed and added to the
preauth integrity hash as if the request had not been a binding one.
conn->binding is also not yet set when a binding request fails early,
and is left set after a binding has completed on the connection. Take
the value from the request instead.

An AI assistant was used to draft the patch and as an independent
reviewer.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/mgmt/user_session.h |   2 +
 fs/smb/server/smb2pdu.c           | 139 ++++++++++++++++++++++++------
 2 files changed, 113 insertions(+), 28 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 931ca102b8392..423f0a10315af 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -59,6 +59,8 @@ struct ksmbd_session {
 	unsigned int			flags;
 
 	bool				sign;
+	/* signing was required at setup; sign is cleared with encryption */
+	bool				sign_required;
 	bool				enc;
 	bool				tearing_down;
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 79c03420d1226..a15dd200645bb 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2417,8 +2417,10 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 
 	if ((rsp->SessionFlags != SMB2_SESSION_FLAG_IS_GUEST_LE &&
 	     (conn->sign || server_conf.enforced_signing)) ||
-	    (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED))
+	    (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED)) {
 		sess->sign = true;
+		sess->sign_required = true;
+	}
 
 	if (smb3_encryption_negotiated(conn) &&
 			!(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
@@ -2521,8 +2523,10 @@ static int krb5_authenticate(struct ksmbd_work *work,
 
 	if ((rsp->SessionFlags != SMB2_SESSION_FLAG_IS_GUEST_LE &&
 	    (conn->sign || server_conf.enforced_signing)) ||
-	    (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED))
+	    (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED)) {
 		sess->sign = true;
+		sess->sign_required = true;
+	}
 
 	if (smb3_encryption_negotiated(conn) &&
 	    !(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
@@ -2572,22 +2576,62 @@ static int krb5_authenticate(struct ksmbd_work *work,
 #endif
 
 /*
- * A binding request must be signed with the signing key of the session it
- * binds to (MS-SMB2 3.3.5.2.4). Check it before the request is processed
- * and before any response is signed with that key.
+ * SESSION_SETUP is not covered by the signature check in __process_request(),
+ * because work->sess is not set for it. A binding request must be signed
+ * with the signing key of the session it binds to (MS-SMB2 3.3.5.2.4), and a
+ * signed reauthentication with the key of the channel it arrives on. Check
+ * them before the request is processed and before any response is signed
+ * with that key.
  */
-static bool smb2_check_binding_sign_req(struct ksmbd_work *work,
-					struct ksmbd_session *sess)
+static bool smb2_check_sess_setup_sign_req(struct ksmbd_work *work,
+					   struct ksmbd_session *sess)
 {
 	struct ksmbd_session *prev_sess = work->sess;
 	int ret;
 
 	work->sess = sess;
-	ret = smb3_check_sign_req(work);
+	/* The key, and so the way it signs, belongs to the session */
+	if (sess->dialect >= SMB30_PROT_ID)
+		ret = smb3_check_sign_req(work);
+	else
+		ret = smb2_check_sign_req(work);
 	work->sess = prev_sess;
 	return ret;
 }
 
+/*
+ * Whether a reauthentication of @sess must be signed or encrypted. A session
+ * that negotiated encryption has sess->sign cleared even when signing was
+ * required when it was set up, which sess->sign_required remembers, while
+ * encryption itself is only enforced when configured. Merely having
+ * negotiated encryption does not count: clients such as the Linux one always
+ * offer it, and then legitimately send unsigned, unencrypted requests.
+ */
+static bool smb2_sess_needs_protection(struct ksmbd_session *sess)
+{
+	if (sess->sign)
+		return true;
+	if (!sess->enc)
+		return false;
+	return sess->sign_required ||
+	       (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION);
+}
+
+/*
+ * Was the request encrypted with this session's key? It was decrypted
+ * with the key of the session in the transform header, which
+ * ksmbd_check_transform_session() matched with the first header. A
+ * related operation later in the compound may name another session.
+ */
+static bool smb2_sess_encrypted_req(struct ksmbd_work *work,
+				    struct ksmbd_session *sess)
+{
+	struct smb2_hdr *hdr = smb_get_msg(work->request_buf);
+
+	return work->encrypted && sess->enc &&
+	       le64_to_cpu(hdr->SessionId) == sess->id;
+}
+
 int smb2_sess_setup(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
@@ -2698,7 +2742,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 		}
 
 		/* As part of receiving the request (MS-SMB2 3.3.5.2.4) */
-		if (!smb2_check_binding_sign_req(work, sess)) {
+		if (!smb2_check_sess_setup_sign_req(work, sess)) {
 			rc = -EKEYREJECTED;
 			goto out_err;
 		}
@@ -2789,6 +2833,29 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
+		/*
+		 * A reauthentication of a session that has keys must prove it
+		 * comes from the session's owner: a signed request must verify,
+		 * and a session that requires signing or encryption must not
+		 * accept an unsigned request unless it arrived encrypted with
+		 * this session's key, which has already authenticated it. The
+		 * session has keys once it has been authenticated and
+		 * so has a user, including while a reauthentication is in
+		 * progress. Do not expire the session if the check fails: the
+		 * request did not come from its owner.
+		 */
+		if ((READ_ONCE(sess->state) != SMB2_SESSION_IN_PROGRESS ||
+		     sess->user) &&
+		    ((req->hdr.Flags & SMB2_FLAGS_SIGNED) ?
+		     !smb2_check_sess_setup_sign_req(work, sess) :
+		     (!smb2_sess_encrypted_req(work, sess) &&
+		      smb2_sess_needs_protection(sess)))) {
+			rc = -EKEYREJECTED;
+			ksmbd_user_session_put(sess);
+			sess = NULL;
+			goto out_err;
+		}
+
 		if (work->session_setup_reauth)
 			WRITE_ONCE(sess->state, SMB2_SESSION_IN_PROGRESS);
 
@@ -2871,6 +2938,14 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	}
 
 out_err:
+	/*
+	 * Response processing needs to know whether this request was a
+	 * binding one. conn->binding does not say: it is not set yet if the
+	 * request failed early, it can be left over from an earlier binding
+	 * on this connection, and the error path clears it.
+	 */
+	work->session_setup_binding = req->hdr.SessionId &&
+		(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING);
 	if (rc == -EINVAL)
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
 	else if (rc == -ENOENT)
@@ -2977,7 +3052,6 @@ out_err:
 			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 	}
 
-	work->session_setup_binding = conn->binding;
 	if (authenticated) {
 		/*
 		 * Draining the previous session drops srv_mutex. Finish using the
@@ -13066,22 +13140,24 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 	 * A key must be used with the algorithm it was generated for: the
 	 * session key with the one of the connection that created the
 	 * session, which can differ from this connection's when binding.
+	 *
+	 * A binding request, or a SESSION_SETUP on a connection that is not
+	 * yet a channel of the session, is verified with the session key. A
+	 * request on an existing channel, including a reauthentication, is
+	 * verified with that channel's key, so that the session key is not
+	 * used at the MessageIds of another connection.
 	 */
-	if (le16_to_cpu(hdr->Command) == SMB2_SESSION_SETUP_HE) {
+	chann = lookup_chann_list(work->sess, conn);
+	if (le16_to_cpu(hdr->Command) == SMB2_SESSION_SETUP_HE &&
+	    (!chann || (((struct smb2_sess_setup_req *)hdr)->Flags &
+			SMB2_SESSION_REQ_FLAG_BINDING))) {
 		signing_key = work->sess->smb3signingkey;
 		signing_algorithm = work->sess->signing_algorithm;
+	} else if (chann) {
+		signing_key = chann->smb3signingkey;
+		signing_algorithm = conn->signing_algorithm;
 	} else {
-		chann = lookup_chann_list(work->sess, conn);
-		if (!chann) {
-			if (le16_to_cpu(hdr->Command) != SMB2_SESSION_SETUP_HE ||
-			    !(hdr->Flags & SMB2_FLAGS_SIGNED))
-				return 0;
-			signing_key = work->sess->smb3signingkey;
-			signing_algorithm = work->sess->signing_algorithm;
-		} else {
-			signing_key = chann->smb3signingkey;
-			signing_algorithm = conn->signing_algorithm;
-		}
+		return 0;
 	}
 
 	if (!signing_key) {
@@ -13127,17 +13203,24 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
 	hdr = ksmbd_resp_buf_curr(work);
 	command = le16_to_cpu(hdr->Command);
 
+	/*
+	 * Responses to binding requests, other than the final one, are signed
+	 * with the session key (MS-SMB2 3.3.5.5.3), as is any SESSION_SETUP
+	 * response on a connection that is not yet a channel. Everything else
+	 * on a channel, including a reauthentication on a secondary channel,
+	 * is signed with that channel's key.
+	 */
+	chann = lookup_chann_list(work->sess, work->conn);
 	if (command == SMB2_SESSION_SETUP_HE &&
-	    (!work->session_setup_binding || hdr->Status != STATUS_SUCCESS)) {
+	    (!chann || (work->session_setup_binding &&
+			hdr->Status != STATUS_SUCCESS))) {
 		signing_key = work->sess->smb3signingkey;
 		signing_algorithm = work->sess->signing_algorithm;
-	} else {
-		chann = lookup_chann_list(work->sess, work->conn);
-		if (!chann) {
-			return;
-		}
+	} else if (chann) {
 		signing_key = chann->smb3signingkey;
 		signing_algorithm = conn->signing_algorithm;
+	} else {
+		return;
 	}
 
 	if (!signing_key)
-- 
2.43.0

