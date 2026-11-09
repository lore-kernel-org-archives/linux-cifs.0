Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794253320;
	b=MERj+jDAmSHpieoAskzbiqjyA4TjuAB1qzeDkECAixit1+JK+OuKbBS0S0ipG1Myo3pD
	 BN3FmvRtkNVOlFBzrRPkeenGJ+Xtu7VnLrBZPLCe4f6w5AMFOSBNq65ZTyOnHwNX/L3Ti
	 jgkveUbTAw8pO7yRyJpl4E4qeCS0XPbqytYdp4LMfJb0iUMwCaq8gzdZ5CFh4BvooTUHe
	 f6DSghGmwFyjXEbxm0KFGMMXCJ5QeLBy/ZEVBJvnKyCr8kj+cIC/A8aE6Txftvlh/lNaj
	 ubhNVFHAf2myk9lw41A1KCQh91agjBBEhzdLcfQ9//Ai1SoB4y7/Fy2uqXzMdelWaLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794253320;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pm5tgrvS4mxwXIED4+gFl49LnVQMWhYzlp2m+wLFFK4=;
	b=3ElRPYTdnjvNe6F5URLG2ESLnqYuxGXSgv9608TsKH+Vw1UvFhRw+gBvFNg2ft0LVYHv
	 slylbHNKZHc4UWl+lU/HDE/h6eCU0sX4sMJM8wVOyeF0LOWwyuwIPIjetTm3DFXQfa5eG
	 ou6HbTIHpiHC3BrjgsdXgqtVLuYQkb1WE4YzHyWKkrUvPVMab4quHfECXt9BcW16aDQHQ
	 5tpILusMQyNE5eCC6a5JAfbuGzOAVWhrMqsBrby+fD/cZI5FdddOUMrm8ZUK1lOG7iVi+
	 eLMdbz1YcnMhZTZubR6g4WjqS6qjVX4oSDek706ITqeEv37WrUoVfVOS85HLjOaRL+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="x/Rw7ojk";
	arc=none smtp.remote-ip=209.85.214.177
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D33606A321
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 19:42:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34D33606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x/Rw7ojk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2eb0f1b592bso4755565ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 11:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794253319; x=1794858119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pm5tgrvS4mxwXIED4+gFl49LnVQMWhYzlp2m+wLFFK4=;
        b=x/Rw7ojkBV1ZHNo3L36EabZCWxrpQADkCWB/M5JmAbPgLZxtm0S5+06vl0pU9NoOjH
         Bi+c2Ke0Js8Faq7w9dLkpyg3yDAQwTgODhQzJmfjV8qkC1bo/3527WmjQBp3MlgOyHgt
         5KR9oSUuJnccwagtpOv9qM0hS35N1wM1jLF0jQyXjs+Sfyg/yL2z2CjniMv4RiIn+tpz
         BglCi6tBprvAgu0CIy5FrO+h04UK8XlMagG8aCgdjFLPNVY0EfOE3tbIjLQ4lvA0AD7M
         jzLtJm0eLNU3yN59dQer1w5GOfiyNvB9xsbe3AEiPjGzZ4HX6NzAocDo1rnmHym8bA5w
         CesQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794253319; x=1794858119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pm5tgrvS4mxwXIED4+gFl49LnVQMWhYzlp2m+wLFFK4=;
        b=qYaTM2jv8SXQK+9U3xYylAIdI5WWm3fImCoknKYXDqGQSGnkAlMkwo+X4expbgV04U
         agscPJd4oj2u36fA9L4sWaU28VMPvX4PjYh34ETOT4cS3Qz2/xfm6B7RFWD9GnbosNpK
         To/8BQPRUmpzgX3gF4wg4GP/9JXliqVmhXU7AJkP6ye+f/0P4RBSNFxMi07j4dK3sANy
         siyjKCAmuhUPqtqhpbQg3GjSXt09q2XMgMdydEDHsh87RGyq/yDtLWbhor9I/an20Npw
         IHgLXr5NoeMbhlK5bZFaWRtV9yrBHGsPmG2AlWI+BVnN9W7zrxdsJgPgmO8UUjZrZNdV
         c/fw==
X-Forwarded-Encrypted: i=1; AL+hErGm/aDggKhQSQxrNa0FUHg5lJ9+JMQ3hYZ+DrrOsfItTGN+LgQxTXzdKJH100a2bj3XjTMHZ2TGUak9@vger.kernel.org
X-Gm-Message-State: APuU4Z87b9Hi1J+pf9fuSt0MeEAG7H4Lmjh0SClu7n0z+R9ZtD+NTtqT
	xhP3zfN/ZpzVX3FfuWjJFSf7/xHUbnP027qufPwOMLAHsWrZ768cpc/l
X-Gm-Gg: AYBFou2uPM80Zdww6UcJ2gq/LOEKlpClAjW8bhrowPswRQ4biCqjH14PHtwLN/1PmQC
	7NcMMMc009goLNNDg9ZJ/GvG0amAOa3P57PJNcvkaet/TAhduCSbUiisGfIX8NjXmMK0+SMeKnS
	AGNJrWXzpBFBQ6XKUrzZaNs6yeheUvXDa14ELu6V1OEc5X+aZBWBS5nvdBfRcKMH6+q0vps9Yeb
	kGStUaJlvBmGaZY5BGbZD8dkq3pN2Fmb80rDs3QBFLbgKZ2VFriCINcZhzqgXBAc6Cdng+38A+m
	O0Dh8Z5eBAarxcGiZZu9kn42/Mtq01jt5wnjrxGXrQwcILzfYU8Ue2xlz1JsBt5LWCsiJ2oJp/r
	9okud/JFy9ejZXnUnFVzwF+7OSuNe4VXuwgDSZk2WXwAyXrIv9OR0WyTuYizE1Oha/a4xgHap7W
	CAbWIIcu5DVJh12zyzts5ZHKV+h7bO9FDWxCIsimPWTL1Yb5MGM3oHUZaEbqfWLbGLlQowpjYyp
	/UVMmjI5OYYCoJfbUcwzRT9LBt3wu3xWLBfIfOI5IZV0/sthgB39gHNxAZnaid2H6CC+U3xblRU
	58JJxl9SRSES4GwIBdhGoqA+5SQssl8cln2/HhwKECvnG18l9FAiRV6Dr1hSJI6fslBHhwqUYLN
	/Nn5jmt5kDLE3KHlkUWCNQRWoKxVs/lpTywgJfAXd3k+0zvycqipAad0=
X-Received: by 2002:a17:903:1b6c:b0:2ed:2e3a:1fa4 with SMTP id d9443c01a7336-2edb92f56a1mr1330285ad.62.1794253319491;
        Mon, 09 Nov 2026 11:41:59 -0800 (PST)
Received: from localhost.localdomain (mx-ll-183.88.2-201.dynamic.3bb.co.th. [183.88.2.201])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d4b950sm1388585ad.13.2026.11.09.11.41.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 11:41:59 -0800 (PST)
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
Subject: [PATCH v3 1/6] ksmbd: verify the signature of session binding requests
Date: Tue, 10 Nov 2026 02:41:39 +0700
Message-ID: <20261109194144.22814-2-mike.michalo@gmail.com>
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

The other binding branch, which rejects a binding request that is not a
valid multichannel bind, verifies the signature as well. A missing
negation on the multichannel flag made that branch unreachable for an
SMB 3.x request when multichannel is disabled: such a request fell
through to the reauthentication path instead and was answered with an
unsigned STATUS_USER_SESSION_DELETED. Correct the condition so the
request is verified and rejected there.

An AI assistant was used to draft the patch and as an independent
reviewer.

Reported-by: Ian Bridges <icb@fastmail.org>
Closes: https://lore.kernel.org/all/20261103171742.18816-1-icb@fastmail.org/
Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/smb2pdu.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b084cca8813cc..129a4c5c74f44 100644
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
@@ -2675,7 +2703,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 		conn->binding = true;
 	} else if ((conn->dialect < SMB30_PROT_ID ||
-		    server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL) &&
+		    !(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)) &&
 		   (req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
 		sess = ksmbd_session_lookup_slowpath(le64_to_cpu(req->hdr.SessionId));
 		if (sess) {
-- 
2.43.0

