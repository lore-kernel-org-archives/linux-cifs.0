Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793992002;
	b=qC8TIKsEsPb/ZElWnfJOYRnQTZOyrFFhw0cmtGaJFQpEmCe70IwqAPFW8jD6j8YjFefn
	 f6j9HOP5y0UI0i/8XGE+ruElOJBWMOw8j9pRwATG0DD4tUNrFGyp0Mjyi8fr8PSExtZRv
	 0AJLTx0PHAJc0LjgRMtq0oXPeVkRLEMeeHqZ5DQm39bK60BLQcWEnf8klC8r70qNlH1lz
	 8sZRmPvs0rvaNhHSok5aIntujfMzBnef8ru6afeknnd4ZTlWCNqyNUssEyvekcxXPFZ+u
	 YWCHyYkg1d4WQOnIOcc6NCT/NKNUQRT3ncMNhL2YVZootxR+kLCmopE76Zj40LoidJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793992002;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zf/S7tdQ1qGKN7A52dLSJCwU/JAAKqCo7rxpcX/3Ue4=;
	b=PVnWZJ/NT3fpWoPn+YKMD4fMZiWIiP/YtiUrXGo4R670wTHDxSnT1PUGd7mMq8PDWUJL
	 P+c3/aXFlo0asaYCVy+fS+En0yayXlBteF9rOMJ1fulG/P/kCiMpNB38QWFXiv86Heqme
	 vqb1zyqRkcNCJp+OLzs3V59xMRFZjlovFfZec8qWeGgsjeRY5XKuUCn5j/tM8wlUOL5Vh
	 aBDaSl/QhZsucZbjtLRKUSXRg+vO/Nh4oFOTjZjHysU5bFv1EyjCwdj+lKCZvT8Xt6TrU
	 rsrbhId1VyztXAxOG9rkWGg5YdPadWSgDLq/ue3KsgirokvP20RIzuFJ/o65C1cTU6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xTsZ6YAb;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05401606A326
	for <linux-cifs@vger.kernel.org>; Fri,  6 Nov 2026 19:06:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05401606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xTsZ6YAb
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e1d0e5dafso1340109f8f.1
        for <linux-cifs@vger.kernel.org>; Fri, 06 Nov 2026 11:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793992000; x=1794596800; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zf/S7tdQ1qGKN7A52dLSJCwU/JAAKqCo7rxpcX/3Ue4=;
        b=xTsZ6YAbbUvbLWYiiHtssfb55e1KT6gBMmrYpBPgsqwCzLW4FoVOu3UoomP2K9uoMe
         1AR65SR/Lx/jnhktfRVMis7srF3VyNH83mJ7iGWhhDtfiebC80eX8fx27RAsOEeA3Bp+
         qA6mEtFOJVN7Y1a2SNpqcV9a8IMIwI4SbGr3KcyyaTLoJvICm4yPK3NC/y35Df6Oia5E
         H/ZtGXa1OREEucxrebjz9cwcn1TU7Mm7aLvFzWZbCb1lZFk20fo2tmGA7etTH1tttfuw
         oM8bX5/xCS36qxzsXKMjF96sE80RUQLQ4H1P9ZEdfLQnxlqcZZBXH06eaq3jl8zRgTbg
         dl6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793992000; x=1794596800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zf/S7tdQ1qGKN7A52dLSJCwU/JAAKqCo7rxpcX/3Ue4=;
        b=cpHLwqKz3v5Sus7MK3VqNV5wn4k2Wx5g8rkEmzHRfyGYvG9wx/dDsWQAkux95aiKoh
         0tKGh1ZXW5Za7B1dbG5Z1sjrlfPkTwCnjA8mGilr9QuMt0YplTMEbFE74H582hdVXPE4
         nj0PqSg86j5Y/WhVAjbzyntKmRGBVOo+gjqqz0/zjWM7Hupkf+X62CHhBBskNYh5Lrh6
         UkP4+zTVPBuVRGggeL4yMFOnyajaEpjPiS2jpvCTfMKQ9wJe//BlKirJAUG0sPf+C7I7
         DCjsV82vNpvXXWwLXWLgV3RLNc6XWYzuPzmDig6/DcM9XAgRrZ5aNC/Fp16DYE+85O7G
         f81g==
X-Forwarded-Encrypted: i=1; AL+hErEHbtthDeO4iFAxoCLWBbVPjT268Ljct+eMvZcxP+hxtaLLHXCLCknSOwPQKMhy4GlezrP1O2gr3y2p@vger.kernel.org
X-Gm-Message-State: APuU4Z8mT02SAvY4uPoAk2s0buRJye5M87t9YyKk4CZbLwHLfwJ2G0d0
	Du10YIhF6N9r67w1Pzef4SnjtOsK5o9vPIKJTWYRBoFEm72RpkRvNhoQ
X-Gm-Gg: AYBFou2Sbj6pl7cXMDTS4pKpGLwbv4ptlOaJx9hVB4An+k+HxREHPaoyQUxy7khiRqy
	IPxVAR0P/wo/mIESiOJjs4XWLCnhgYS5acsd5aThv83z3+8+ASIXZ3Pxh1ssRzXXt0PJQU9Qos2
	2TsR93qRE42EOf1oE/SATwCRfxJngX7x2L62Y5PnsNISY3j95BbTVJYj/uJMeqOP7ZgJcWacOO7
	PG42FrY/G+Lk0tqtwkiP41EgzLAqJJFZRmjCLZQVnqKNY9ZtAsrNrlLVRubcWi+VJ2/qqQO7B+5
	73RUB5gWkdnLrFU3dKQrFbEWyad1Tl7QNz0N7+P2rfQ/HXQtJ7w+/9wqtyIHzCRh4XrN28v7q7K
	pyJwBLYLX3gTIk0qAE1xjyBjoWNIMsdeoduAGYmJ3UV9GwytGv4jqjLAXb3Fgk24V3ulTYnPX8R
	1Qy8Tn4XN+HMz9PUwlMxeF5hVAEhJ5mqjSMWGy/nNPuXDjCXC5Eubmbkv7l1GfMH/h1/UOgf8te
	GHxTvbtlh2CJkjbCzdl0IRJexVgSdipgp90Fmx61QbRRi/RQW/spgM+jZGYX5ItEOzHf3kgtNOp
	f13jpRzNV2l7tgIQH1B60XKJshIh/RBkYr/0DV01+5pB2o0qJg3wsbSWZTFmxYfNqJcvH/Rx1+7
	k1IYf/Gv1mDxpYBk=
X-Received: by 2002:a05:6000:46c6:b0:491:632f:2c8f with SMTP id ffacd0b85a97d-491633e73c5mr8755775f8f.2.1793992000382;
        Fri, 06 Nov 2026 11:06:40 -0800 (PST)
Received: from localhost.localdomain ([74.244.226.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4930a5a91dbsm3960533f8f.35.2026.11.06.11.06.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 11:06:39 -0800 (PST)
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
Subject: [PATCH v2 1/4] ksmbd: verify the signature of session binding requests
Date: Fri,  6 Nov 2026 20:06:19 +0100
Message-ID: <20261106190622.20990-2-mike.michalo@gmail.com>
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

When multichannel is enabled, smb2_sess_setup() accepts a binding
request on a new connection once it finds the session and sees
SMB2_FLAGS_SIGNED, but never checks the signature: SESSION_SETUP is
exempt from the generic check in __process_request(), because
work->sess is not set for it. The request then goes through
authentication, and the response is signed with the session's signing
key, since the request claims to be signed.

So anyone who knows a SessionId and ClientGUID can open a connection
and have the server sign STATUS_MORE_PROCESSING_REQUIRED responses with
another client's session key, each with a fresh NTLM challenge and at a
MessageId of their choice. With AES-CMAC this is a signing oracle. With
AES-GMAC the nonce is the MessageId, so it also lets two different
messages be authenticated under the same key and nonce, which reveals
the GHASH key and allows forging signatures for that session.

MS-SMB2 3.3.5.2.4 requires the server to verify a binding request with
Session.SigningKey and to fail it with STATUS_ACCESS_DENIED if that
fails. Do so before the request is processed further. The failure
response is not signed, because work->sess is only set once the
request has been accepted.

smb3_check_sign_req() zeroes the Signature field in place to compute
the MAC. Restore it afterwards, as generate_preauth_hash() later hashes
the request as received into the channel's SMB 3.1.1 preauth integrity
hash.

The non-multichannel branch already checks the signature before it
rejects the request, so only the multichannel branch changes.

An AI assistant was used to draft the patch and as an independent
reviewer.

Reported-by: Ian Bridges <icb@fastmail.org>
Closes: https://lore.kernel.org/all/20261103171742.18816-1-icb@fastmail.org/
Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/smb2pdu.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b084cca8813c..211dbcdca8df 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2558,6 +2558,29 @@ static int krb5_authenticate(struct ksmbd_work *work,
 }
 #endif
 
+/*
+ * A binding request must be signed with the signing key of the session it
+ * binds to (MS-SMB2 3.3.5.2.4). Check it before the request is processed
+ * and before any response is signed with that key. The Signature field is
+ * restored afterwards, because SMB 3.1.1 adds the request as received to
+ * the channel's preauth integrity hash.
+ */
+static bool smb2_check_binding_sign_req(struct ksmbd_work *work,
+					struct smb2_hdr *hdr,
+					struct ksmbd_session *sess)
+{
+	struct ksmbd_session *prev_sess = work->sess;
+	char signature[SMB2_SIGNATURE_SIZE];
+	int ret;
+
+	memcpy(signature, hdr->Signature, SMB2_SIGNATURE_SIZE);
+	work->sess = sess;
+	ret = smb3_check_sign_req(work);
+	work->sess = prev_sess;
+	memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
+	return ret;
+}
+
 int smb2_sess_setup(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
@@ -2640,6 +2663,11 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
+		if (!smb2_check_binding_sign_req(work, &req->hdr, sess)) {
+			rc = -EKEYREJECTED;
+			goto out_err;
+		}
+
 		if (memcmp(conn->ClientGUID, sess->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE)) {
 			rc = -ENOENT;
-- 
2.43.0

