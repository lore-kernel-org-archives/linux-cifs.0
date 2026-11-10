Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794329947;
	b=JZsKLrDKJal2eTT9O8Ioz2PhSGIqubFkqoG6jyK0LX1G0Md+8EvyRhth8gjdo81VPU/k
	 cAVVWzFQ8qm1zTSbCnjh0RFcFi0HiSTTQ/1YYaBO9ciHIA1Bb4DocjlTX8oDJGCmTp6wo
	 0wqSIw/vW9KC77CfcAdZcsCwEcAPL4FALaaWZCIsQ8489oYKeLb1DQLCcsqCIHpRyGAGw
	 RYjBgNg7/GDJJc838M44HotiuXbx/nPuF0dwjpW77oIYSr7N2wN5VNWHRBMULz43YG1Pa
	 +BcDx7HPAplyRcFA6fuvwbpfI8+Lo+7qTLXbCEYqlTvBAj+JykMUVOJ/PcN50JhMMOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329947;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HSJDtlxxU5AymERfW2Cy3U9zIe+dDeyGFDpPwf1pdgw=;
	b=WOzRGLkF3w8GL5fHBxiqFTbH2FvkMAF+SrlqsqP8xpLyjcYY+saF9NUkwIfw7jsMmX4f
	 TlMiNmSXjFYJOD6O8IQuYiKSwsQmPcHxRA6948PZg99e//9brL/0l3/FUCoOiWcF1Gvwb
	 FkmzY8kpk95aBmiWxElhYxrP0Iwsqc05gWbl3qcYZtl3Jej/FkPwG6VLIwsgVENIMX53K
	 PEfHSSrIMqe+S2k68J07pjQ8sa1nzOXtzN6UNE3xNZrJ/E+jq/whMCYCQBeq/rJqy9KAb
	 1REXK8epE7ehSjuNQ5EATxl/lHlWXBzfiZLGdDG7N+sCZJx3uVF0CapvGcxfXMgf5OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h6CxURf4;
	arc=none smtp.remote-ip=209.85.210.179
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC55606A81C
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 16:59:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FC55606A81C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h6CxURf4
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8b5efadd183so1068251b3a.1
        for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 08:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794329946; x=1794934746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HSJDtlxxU5AymERfW2Cy3U9zIe+dDeyGFDpPwf1pdgw=;
        b=h6CxURf4YkVwrHf+X2Q3Pm2HztBSdQETM0CcN12wz76RjnNXAVc9Mxa3FXkl1LKKcS
         DiBrlJtZlA8HxHWafB3EFpxyXfEeYN0DZ1PAFTa2Hz6E8DKuGPZKHjrsCQWm5R2jaMup
         5xGXKaLCQLu2VMaRE1azzs5dWKOvX6s95qBMr1DPpzfX8ku4K+b2PhIm4lmMh3YajkQn
         oa0ZtcF9AL1/EOCc/OVMV+5JIKqr+omcp5vayxp8G4zd7TNZdqVy0jPyXKT6tASAuJxE
         dFAo7n8+Ej8CjCCwawOKHQ4o/FD8YkNILjqs7MOaonyltUtkGHxYERU7yB1l00DwTe4S
         BaSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794329946; x=1794934746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HSJDtlxxU5AymERfW2Cy3U9zIe+dDeyGFDpPwf1pdgw=;
        b=eKshCOj3rWCkC6G5g/Muq4UQhMQFv1GwefldUQ+SQERRTFauQ8cSghDk8de2oXC5BG
         csvaO4aBidiV2mPNVsuqQNXeh/xGNLgHH6IawtfIUwvjmhEj6hPgczV9Y1L0aCvLXTwU
         VMT5F00JrI/OdEjxsQ6kUpcQFHShlBn2chCnZ96FVbHRhk4shL0z7n29dXAWui6ZYkrZ
         mVC7x0xNHLogqteBOPEah/kP1Yvq20P1rZH09kdKFlXcBmUriHUGlUksSM9ZKjDj/69/
         rAHkHwixDEkHIHDIYcEMw6CJ2+0nDkUiNGnDWajlLSRh7bzwLCegh/bQXb/uwAA5S6ir
         /TfQ==
X-Forwarded-Encrypted: i=1; AL+hErEPqiP+6fP1DJE3myP39GLNt7UqDZ07ZWd8lH9IZ8+pNtVzph8fKfLKJRCZlWMPAUkd9DJhlpDWn1yT@vger.kernel.org
X-Gm-Message-State: APuU4Z/K8esnqjmFcZkKl5wdHqfmOqkNNj1ANaDDCCMCiZlcT/7/AhRO
	ebGopzmpNTY2dWtomvs3nAIiTkh3T/ET9zqolT7MPsSrgYZnxYbANNkV
X-Gm-Gg: AYBFou2py+k+G6fctEdbSOt3QWAgy/k6jlzVDenBg6l3ix7r+ouP3hkVFHWsmJ8vwsI
	8+hHIVZdQXgQt8MBchSpLl5HIh12B+rqbxqaZYPDhN7uJ0TCrorDs5FCzMZfOos33GfKjLA//8Q
	TNCtk9pCaqaSfRhLshmUoPbeTYpnxB59/is8icT0z4YsVetoBdvlnCUIuvLs5PE/BTDP2CZTkC7
	UQSF0uFpOA148znJdCegggijkFxkx/NLiMGg1CIiDShCEsACKGQ4JNIEKHNHSnYv6IrPhAInAiM
	T09TTwh8xKnZpL200QAvR1DBYj96YIP3eX8rPhZfW7PdjI7Akk8IKZ5FKQMO0ffRIxY+OTl1S/m
	KI8nAIvEc702b3TdJr6MS+PSGfy0nY69DR+YPhFyIZi9wz2Z/+H3/jpWJzVPZoU8LptaAQDiH8V
	i34PoK72EreQwPBK2eT+eHc7ubhIm9M0zXCK5Zw+VgXDJsrrLGrWw+PEsD/34YzLXQ7VTX3Zppw
	Y2pZF2Tk6ItEFrJ/hOGTrY5mMTA1FT4xHZI4Nc/Ep2CzzCD18RRKhtZz7O4lSKKNx1vZu2G0poO
	jD/aqqW0/5XhNlo6Ckk7E9eJvTfRTMkQQhoGzHRXc46G+xP69aoLiyvDsiQtamJPxQ6KsjvxE3v
	t0vxABMbNzUbrZInVDTt1uCQEHXtQ16gHXgSNJgDB2VID4T9OW7WOuY0=
X-Received: by 2002:a05:6a21:9d95:b0:3e2:2b76:bf17 with SMTP id adf61e73a8af0-3f18fb82239mr2313026637.35.1794329946342;
        Tue, 10 Nov 2026 08:59:06 -0800 (PST)
Received: from localhost.localdomain (mx-ll-183.88.2-201.dynamic.3bb.co.th. [183.88.2.201])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab4fd5c6sm1157154b3a.46.2026.11.10.08.59.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 08:59:05 -0800 (PST)
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
Subject: [PATCH v4 3/6] ksmbd: use the channel signing key for session setup on a bound channel
Date: Tue, 10 Nov 2026 23:58:31 +0700
Message-ID: <20261110165834.28162-4-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110165834.28162-1-mike.michalo@gmail.com>
References: <20261110165834.28162-1-mike.michalo@gmail.com>
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

smb3_check_sign_req() and smb3_set_sign_rsp() always use the session
signing key for SESSION_SETUP. That is right for a binding request and
its non-final responses (MS-SMB2 3.3.5.2.4, 3.3.5.5.3), but a
reauthentication sent on a channel that is already bound is then also
verified and signed with the session key instead of that channel's
key.

Use the session key for binding requests, for their non-final
responses, and for SESSION_SETUP on a connection that is not yet a
channel of the session. Use the channel key for everything else on a
channel. Samba does the same. MS-SMB2 is ambiguous here: 3.2.4.1.1
has the client sign any session setup with Session.SigningKey, while
3.3.5.2.4 has the server verify non-binding requests with
Channel.SigningKey.

The signature of a reauthentication was not checked at all, because
SESSION_SETUP is exempt from the check in __process_request(). A
reauthentication of a live session with a forged signature therefore
got STATUS_MORE_PROCESSING_REQUIRED signed with the session key, with or
without multichannel: the same kind of signing oracle as an unverified
binding request. Verify it with the same helper as binding requests.
Also refuse an unsigned reauthentication of a session that requires
signing, as smbtorture's bind_negative tests expect from Windows,
unless the request is encrypted. A session that negotiated encryption
has sess->sign cleared even when the connection required signing, so
take that and enforced encryption into account too; merely having
negotiated encryption is not enough, since clients such as the Linux
one always offer it and then send unsigned, unencrypted requests. Do
not expire the session when a check fails, since the request did not
come from its owner.

An AI assistant was used to draft the patch and as an independent
reviewer.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/smb2pdu.c | 112 ++++++++++++++++++++++++++++++----------
 1 file changed, 86 insertions(+), 26 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ddaa98055154a..293e660265c95 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2561,23 +2561,51 @@ static int krb5_authenticate(struct ksmbd_work *work,
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
-					struct smb2_hdr *hdr,
-					struct ksmbd_session *sess)
+static bool smb2_check_sess_setup_sign_req(struct ksmbd_work *work,
+					   struct smb2_hdr *hdr,
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
+ * required on the connection, while encryption itself is only enforced when
+ * configured, so check what the session actually requires. Merely having
+ * negotiated encryption does not count: clients such as the Linux one always
+ * offer it, and then legitimately send unsigned, unencrypted requests.
+ */
+static bool smb2_sess_needs_protection(struct ksmbd_conn *conn,
+				       struct ksmbd_session *sess)
+{
+	if (sess->sign)
+		return true;
+	if (!sess->enc)
+		return false;
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION)
+		return true;
+	return sess->user && !user_guest(sess->user) &&
+	       (conn->sign || server_conf.enforced_signing);
+}
+
 int smb2_sess_setup(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
@@ -2660,7 +2688,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
-		if (!smb2_check_binding_sign_req(work, &req->hdr, sess)) {
+		if (!smb2_check_sess_setup_sign_req(work, &req->hdr, sess)) {
 			rc = -EKEYREJECTED;
 			goto out_err;
 		}
@@ -2754,6 +2782,29 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
+		/*
+		 * A reauthentication of a session that has keys must prove it
+		 * comes from the session's owner: a signed request must verify,
+		 * and a session that requires signing or encryption must not
+		 * accept an unsigned request unless it is encrypted, since
+		 * encryption has already authenticated it. The session has
+		 * keys once this connection is one of its channels, including
+		 * while a reauthentication is in progress. Do not expire the
+		 * session if the check fails: the request did not come from
+		 * its owner.
+		 */
+		if ((READ_ONCE(sess->state) != SMB2_SESSION_IN_PROGRESS ||
+		     lookup_chann_list(sess, conn)) &&
+		    ((req->hdr.Flags & SMB2_FLAGS_SIGNED) ?
+		     !smb2_check_sess_setup_sign_req(work, &req->hdr, sess) :
+		     (!work->encrypted &&
+		      smb2_sess_needs_protection(conn, sess)))) {
+			rc = -EKEYREJECTED;
+			ksmbd_user_session_put(sess);
+			sess = NULL;
+			goto out_err;
+		}
+
 		if (work->session_setup_reauth)
 			WRITE_ONCE(sess->state, SMB2_SESSION_IN_PROGRESS);
 
@@ -12979,22 +13030,24 @@ int smb3_check_sign_req(struct ksmbd_work *work)
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
@@ -13040,17 +13093,24 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
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

