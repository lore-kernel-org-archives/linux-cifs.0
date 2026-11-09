Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794253333;
	b=ei4Sx80Bvq6+6d5gvBbQBGVNS2mxbAGX3HnMMcv3o2dv5f2Bw4VkMuHL07Rm2cuOLBNH
	 bmtH6q6mHO5SmHiwd1RiVNWtR40y+tY2C6GjguFntMm4n279Q/94m9ZpalhKzLFf2rDVY
	 bhUDYEO8FBGBubHnlxpQs50flwgQSNeeXcMR6h99bsQwKBqU/e117N0I5ioisDpshAaVm
	 FTqN28+8aN0xbML8lmfBnKhd5MB50DU5cS6mjhkvBAAzHLgUWFdOvqhOc3F6E2TcDlLC4
	 FyhcJB+hJRH7P2QjBTvdcAtNpynLoalDDpsMSdJs+sBaJ//NM/QV+7GtdEdqVwCU08Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794253333;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PUPl+ApB+9u+qzt/i8jIifMeFEhVOmG0DXWj1SviarY=;
	b=KFJaKDo65D8C5oXnGie69pugg1Dgq0/XqEDQf0zZytSg3wmYYzMdpSdbnKGeBdn+1UN9
	 NsyePWEXIZ9nMDO/OOIm3zDFRR6TYfPwe6+68cdAD+u+2NxeyXOio5sL0BfhgQq1myPrZ
	 DJSbVLd41do2ri49SGl1Dtdh/XAVAYEnvi5GdNPyM8o4tYJTu4aH6jxtbUTs8LnA3pesE
	 wErCW9Ulz+5Ra0RBVQ+TZAchCX5s3bCy81xgtA9t5u0S8udvcPs0dfZd8kPmtV3XqM/ib
	 4XjM1mULNl71thuNzBax3CS7PjiiLepSeEA9jzw7W6nLi3OqwJTMRfuYmaa0QLwQp+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dEVCFL4+;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E22760A261E
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 19:42:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E22760A261E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dEVCFL4+
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e98798cbddso5944565ad.0
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 11:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794253332; x=1794858132; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PUPl+ApB+9u+qzt/i8jIifMeFEhVOmG0DXWj1SviarY=;
        b=dEVCFL4+3tO2YlMLJynyvigzSYs/Fb+ZFdqJUQqskUFWU77fPvBBNuXFD2d7DK21Om
         2tkoYd3KpzG5u5LpXm/Khp2jNiJAdaNbqlgaH37U6HQX9fVKc9+lwK05TFZ2revLSdUi
         YPh7AAUE6CW+058Lo31F9YaET89BW2gvWw66mvtl7GIZp4mLVyDWxTU6369CVSb48hrD
         humlF5YQRAtoxbR8oRVOT7dYk7E947eKMWzCZiIaFDOrAEWujiPSqrVD/OKVIOzTGsg1
         7iDtYueD93EjuQcAG6AQ9SMTBTt8uTUMmwCDm1tjaCJMp6n6kkItdUotqV5zlhLIJmGG
         ojiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794253332; x=1794858132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PUPl+ApB+9u+qzt/i8jIifMeFEhVOmG0DXWj1SviarY=;
        b=FUrOmqmO8jDFB0wNfcvRopKjsSufpJhJLkea5SP0a60BZeG00RgTRgrSAqSRvDAeU9
         iYnmYb8wN6fGO7Hq5KF6vMO0UXyv4GV2CKaBwlQwKWp360lArjPR9Icj22bUV9dQt1pj
         y00hDrNjKfG4op2eyl/4QH0iYk32YmjuAvsl4RZapItOxhJk+iYIUskZZjFk7asm2dfs
         VewW7n2o0N2yldiI74fCD9pz84WEpLXpxA4UV4TleNaAfpVXdoCmcCtZ8GSbmqKbRrey
         ZyY7I3O4tk6L+/4B0SB4cMairCLIyegM7npHM75SEJWvbDEade/KR4pdO0/6Ku1J0Gm5
         X6Mw==
X-Forwarded-Encrypted: i=1; AL+hErGyn7Rg8Ydj8JGZFmo2r41Dn31C7MtXiq3yhQb0MjWsUSuJBZ8Vh5G561o9nct5dg6GHSSpCAfhLzhQ@vger.kernel.org
X-Gm-Message-State: APuU4Z8jF25NqG0f9m93qfDwbJZD2c5VGgUGF5RzL7Q4sMSJkXT3DP5k
	q36RAzB8H/PhnjJV0dRTpz9ePxoDZuWTZZCtnUlxEWlAUcm+Phhi3Hmx
X-Gm-Gg: AYBFou0i3uKxcpHcflgtNPrJ1V6cCqoOtwsHaYMDrAQpITSKgHS2xvpv4geQmZIyifX
	Awfws1mqBOJFLDJHxiSf+yLgC+h64U1BAwa7ECdG51TeNYfJuIc52qfjB/6Tulen6W3Keb21QKP
	Hkih5aSpQnXtunQJ4LOtur+ftLF5yy74IGV6EtgMAn4nyZJrkjm3GTnucB5v/wAb6YlfVLOs4kI
	cDjNEiQeA4mObr4OaKzGHA1Mv69ei+hhwieSODDfWNruJB6UG1rjlOzDxBY7V1Du+p1RRvC/+Ks
	A7VNW6TVNQKB6amgkDrnwzymamoIGdQV7440jYSUKAS54esMKfo2pXzKsodTxdff8SqZsVctuAl
	Li4qU+xeYwUBHVjCA/0YsjLT0t8RRmQIqe4O3ID4gTO3CHadyTGb5HEDCld/OKjTF/r4mGLyNOt
	Yx6joRUJcKKaBWNK+ntCd8XzfL0LP20cPYSiBwY0XpRaJDPoL8ga8LBrrQPK2goRkyXaJFq3oRm
	Qmcl3UXUGGXF1Yuank9YiGp193+19EwcixXPXAtqxR4Dn16xkisE1LSk7uLdTV/4qf9p5Ema+aV
	hZX9laXKXxGUl6DnvsdaNVKUi6qoT/1jbMHafRYbCLa50ETAyYDN5AGKNN2bm8KQxF64zggI8zR
	hmMlyscIMzVXF9nlaiPZx9zl0Fj7Do5jkQdxh63OEo2ir7qeVLacA540=
X-Received: by 2002:a17:902:cec1:b0:2ed:18cc:d3b3 with SMTP id d9443c01a7336-2edb8d6f270mr1644585ad.6.1794253331652;
        Mon, 09 Nov 2026 11:42:11 -0800 (PST)
Received: from localhost.localdomain (mx-ll-183.88.2-201.dynamic.3bb.co.th. [183.88.2.201])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d4b950sm1388585ad.13.2026.11.09.11.42.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 11:42:11 -0800 (PST)
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
Subject: [PATCH v3 3/6] ksmbd: use the channel signing key for session setup on a bound channel
Date: Tue, 10 Nov 2026 02:41:41 +0700
Message-ID: <20261109194144.22814-4-mike.michalo@gmail.com>
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

For a SESSION_SETUP that is not the first command of a compound,
__process_request() already checks the signature and zeroes the
Signature field, so the new reauthentication check then failed. Restore
the field after that check.

An AI assistant was used to draft the patch and as an independent
reviewer.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/server.c  |  11 ++++
 fs/smb/server/smb2pdu.c | 115 ++++++++++++++++++++++++++++++----------
 2 files changed, 98 insertions(+), 28 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 064f99427ca6f..4430c8d6393e9 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -150,7 +150,18 @@ static int __process_request(struct ksmbd_work *work, struct ksmbd_conn *conn,
 	}
 
 	if (work->sess && signed_req) {
+		struct smb2_hdr *hdr = ksmbd_req_buf_next(work);
+		char signature[SMB2_SIGNATURE_SIZE];
+
+		/*
+		 * check_sign_req() zeroes the Signature field. Restore it:
+		 * smb2_sess_setup() checks the signature of a SESSION_SETUP
+		 * again and adds the request as received to the preauth
+		 * integrity hash.
+		 */
+		memcpy(signature, hdr->Signature, SMB2_SIGNATURE_SIZE);
 		ret = conn->ops->check_sign_req(work);
+		memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
 		if (!ret) {
 			conn->ops->set_rsp_status(work, STATUS_ACCESS_DENIED);
 			return SERVER_HANDLER_ABORT;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index af1e7aac4ded1..7d107a61626ad 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2561,15 +2561,17 @@ static int krb5_authenticate(struct ksmbd_work *work,
 #endif
 
 /*
- * A binding request must be signed with the signing key of the session it
- * binds to (MS-SMB2 3.3.5.2.4). Check it before the request is processed
- * and before any response is signed with that key. The Signature field is
- * restored afterwards, because SMB 3.1.1 adds the request as received to
- * the channel's preauth integrity hash.
+ * SESSION_SETUP is not covered by the signature check in __process_request(),
+ * because work->sess is not set for it. A binding request must be signed
+ * with the signing key of the session it binds to (MS-SMB2 3.3.5.2.4), and a
+ * signed reauthentication with the key of the channel it arrives on. Check
+ * them before the request is processed and before any response is signed
+ * with that key. The Signature field is restored afterwards, because SMB
+ * 3.1.1 adds the request as received to the preauth integrity hash.
  */
-static bool smb2_check_binding_sign_req(struct ksmbd_work *work,
-					struct smb2_hdr *hdr,
-					struct ksmbd_session *sess)
+static bool smb2_check_sess_setup_sign_req(struct ksmbd_work *work,
+					   struct smb2_hdr *hdr,
+					   struct ksmbd_session *sess)
 {
 	struct ksmbd_session *prev_sess = work->sess;
 	char signature[SMB2_SIGNATURE_SIZE];
@@ -2577,12 +2579,37 @@ static bool smb2_check_binding_sign_req(struct ksmbd_work *work,
 
 	memcpy(signature, hdr->Signature, SMB2_SIGNATURE_SIZE);
 	work->sess = sess;
-	ret = smb3_check_sign_req(work);
+	/* The key, and so the way it signs, belongs to the session */
+	if (sess->dialect >= SMB30_PROT_ID)
+		ret = smb3_check_sign_req(work);
+	else
+		ret = smb2_check_sign_req(work);
 	work->sess = prev_sess;
 	memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
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
@@ -2665,7 +2692,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
-		if (!smb2_check_binding_sign_req(work, &req->hdr, sess)) {
+		if (!smb2_check_sess_setup_sign_req(work, &req->hdr, sess)) {
 			rc = -EKEYREJECTED;
 			goto out_err;
 		}
@@ -2759,6 +2786,29 @@ int smb2_sess_setup(struct ksmbd_work *work)
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
 
@@ -12982,22 +13032,24 @@ int smb3_check_sign_req(struct ksmbd_work *work)
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
@@ -13041,17 +13093,24 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
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

