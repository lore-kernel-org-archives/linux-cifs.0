Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8183941E6B9
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 17:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790704148; cv=none; b=oSIGi+keSJp/p0zU9mXdrceDH5YS2dT9/1E38iXp+rZUc6oOdXCfJ8BxVooM+jGrF8SmMRhVMYRCkNcyvEpVVG0EAkLavRGLl1eoY4XDGniy5/ZHgQPtMtVRJz0MSjr1gJhw3u1PCeP1PNttKpjdqrxiq0yEiJs0LM8edlqoyc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790704148; c=relaxed/simple;
	bh=DGKar043qh7mF3oApXVN1ifKyPRkQ26pdC8koiQiUto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYAHzoNaRtnv5reuGlpEzcB4D2Fe4OWIlKyNxZ0qoATBuCMg27PVBh4Wh2pg3OBYSLRugBkEwxXBTfYidtnHw8ULrHpgbx0NkZ4gblZpAH0dMRMMlqqv7ckr1KyOE2rZRpj5DDINu8J3U0GKH18ENA3BV/XVOylWGPQv6fXPqwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UAC9a2Au; arc=none smtp.client-ip=74.125.228.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UAC9a2Au"
Received: by mail-pz2-f37.google.com with SMTP id 41be03b00d2f7-cc7cc70890fso395470a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 10:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790704146; x=1791308946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+BMWFgWXT5y9cget/rTTOuD10OkCUTWCz8jmjfj2Gy4=;
        b=UAC9a2AuXh00SL3MAM1cCoq6Px++XJV/tjS1/d7Zi9Gqgay7VgOiu1556+trv7PJU3
         EDk6csC3q+BrjC/48aCabtHKq3LOGceVUgKbR1k6YX4CTBSUZdXhCvX3d0IRU7iLNuVB
         1TqrpRfwNpr1nvFzrp3ToFYGAzUZo/FdxLshDKbu+3j6bPnLG/orlMCslU6NUc2zl1BZ
         2bWjQNn6VTbJzMn8TdUYgZRWa3fpd/cgLH/RCMs86alTEEBhPhJFl+LEYKcdToQ0s2uP
         l4wEPQwwWdZSiGq+cCyuccNK4cSzJrqudFxLmOa1wMXO4LbRuU+aYZzDzc9gw+VZKuP4
         QdaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790704146; x=1791308946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+BMWFgWXT5y9cget/rTTOuD10OkCUTWCz8jmjfj2Gy4=;
        b=SQHJJfqcVyStN6C3klnY9g7ZL1/4mYwLBSB7rgSlGBUvHuzBEs+92LTUSNf2d5yECc
         3nXenartIif9dKx8BKkdVpVWhQSb2dHUfaZc1PRhGp3UuRbRUAkpMNthZ5g4NUoCt1Qo
         V2NNuU027LTnzLCJ1j4D9Xo0YDuovwo7kNZHVYk+ZPKfHy6WJmZjERTOP/owwMCVwInU
         cW8UHNalV9EVUxKVzVloQUFnoOLLh+34z5Zir7pD3Vm4JLCci6DJQCYyW+ZJ/zcLqAd7
         MgS4jPDap2MbSZEYKVsL0LYpczld4u+cnlEv3lZW7Y41anPHDAxND8Ddz+yCQQBU//rx
         jcBA==
X-Gm-Message-State: AFq9FYIGr5EPsdHVc9v8W48x5Ec6nAEvwGkRLCv83V/iI2WBbyAtuCoj
	RfivE7/zIFzEi4VmGWKB8TkMcHF7pOmcx1vxxzN02sqxqNRHjl9NjJ0X
X-Gm-Gg: AYBFou3upKKIAdX1hxa2C+Wip8h0oWosZ/G9uWCEnE470vODs1CgP8a7+Le0FPDxT35
	Gg7odJKsk9I8k2oZdSL0ayH9ZiGl6UZ79iu84hvh5oKoTNfBJBw9mE4doLpsOf8BSprfD71jSqX
	rIgWCy02wmf28MBAQpa+f3aQ6Zg5Y7QtOgR4u+yr3fLHzXxfBwbYUvwiFTdC3tieeGjKqYEtTo8
	4CnnXPCQ3Aqc404INbhTA1KnpBblisLD+Dwq+prplR2VAQM2YIH4jsLFkiDaF22csgcXNbXU6Ke
	GOA+RgHaPG2QPh3ROvmk++oVl15RBNMsil8jYmljCLBhlni6kQ2aUzMGgJ2aT9UNGecqHLlXzZU
	LnF0LxBv+JoritRJ0CTFmuz4nF42kZLc7dMDTsPo3iT2uYyCZQTQamqSu9F/R/xh1JYfnZBT8vY
	ayiM6VWdSAIdxKjIN/uFtcGHGgg+XhKZ9fmX2ZsazisaJXSmBmyLw2Cton/YBtXEt2
X-Received: by 2002:a17:90b:3841:b0:39e:6a81:f34f with SMTP id 98e67ed59e1d1-3a4bfe88f4emr105045a91.41.1790704145844;
        Tue, 29 Sep 2026 10:49:05 -0700 (PDT)
Received: from localhost ([8.219.43.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4986a1910sm6837750a91.14.2026.09.29.10.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 10:49:05 -0700 (PDT)
From: Dairui Zhang <zhangdairui@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	stable@vger.kernel.org,
	Dairui Zhang <zhangdairui@gmail.com>
Subject: [PATCH v6] ksmbd: verify transform SessionId matches the decrypted header
Date: Wed, 30 Sep 2026 01:49:02 +0800
Message-ID: <20260929174902.1899561-1-zhangdairui@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260929161930.1894929-1-zhangdairui@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Namjae, Tom,

Re-checked v5 against the updated MS-SMB2 text. The ~0
exemption was my mistake - the spec has no wildcard for
non-related operations. Dropped it in v6. The other checks
already match, decompression included. No other changes.

From a320c66f1aeb773cf65d2489fae9f982eaf3873f Mon Sep 17 00:00:00 2001
From: Dairui Zhang <zhangdairui@gmail.com>
Date: Tue, 29 Sep 2026 22:30:00 +0800
Subject: [PATCH v6] ksmbd: verify transform SessionId matches the decrypted
 header

When an encrypted request comes in, the decryption key is picked by
the SessionId in the transform header, but the request is then
authorized under whatever session the decrypted inner header names.
Nothing ever compares the two, so on a connection with more than
one session a client can get a request decrypted with one session's
key and run it as another session. Encrypted requests are exempt
from signing too, so a valid AEAD tag is the only proof of session
identity, and it is checked against the wrong session.

MS-SMB2 says the server must check that the transform SessionId
matches the one in the decrypted SMB2 header and treat a mismatch
as a protocol error. Add that check in __handle_ksmbd_work() after
decryption, before dispatching: the message has to be at least one
fixed SMB2 header, the first operation must not set
SMB2_FLAGS_RELATED_OPERATIONS and its SessionId must match the
transform SessionId, and every following non-related operation in
a compound chain must carry the same SessionId. NextCommand
offsets must be 8-byte aligned and stay inside the message; the
bounds check is done by subtraction so it cannot wrap.

When the decrypted payload is a compression transform, the
existing decompression step runs first and the decompressed SMB2
message is checked instead, since a compression transform header
carries no SessionId.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Dairui Zhang <zhangdairui@gmail.com>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>
---
v4 -> v5:
- Move the check into __handle_ksmbd_work(), after the existing
  decompression step, instead of rejecting encrypted compression
  transforms in smb3_decrypt_req(), per Namjae's review. The
  transform SessionId is saved before decryption.
- Use subtraction for the compound-walk bounds check; the
  addition form could wrap on 32-bit.
- Add the Fixes tag and drop the incorrect claims about the
  decompression step and ProtocolId check from the commit message.

v5 -> v6:
- Drop the SessionId ~0 exemption for subsequent non-related
  operations, per Tom Talpey's review.
---
 fs/smb/server/server.c  | 16 ++++++++++++
 fs/smb/server/smb2pdu.c | 54 ++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.h |  1 +
 3 files changed, 71 insertions(+)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -187,6 +187,16 @@
 
 	if (conn->ops->is_transform_hdr &&
 	    conn->ops->is_transform_hdr(work->request_buf)) {
+		u64 tr_sess_id;
+
+		if (get_rfc1002_len(work->request_buf) <
+		    sizeof(struct smb2_transform_hdr)) {
+			ksmbd_conn_abort(conn);
+			return;
+		}
+		tr_sess_id = le64_to_cpu(((struct smb2_transform_hdr *)
+				smb_get_msg(work->request_buf))->SessionId);
+
 		rc = conn->ops->decrypt_req(work);
 		if (rc < 0) {
 			ksmbd_conn_abort(conn);
@@ -215,6 +225,12 @@
 			ksmbd_conn_abort(conn);
 			return;
 		}
+
+		rc = ksmbd_check_transform_session(work, tr_sess_id);
+		if (rc < 0) {
+			ksmbd_conn_abort(conn);
+			return;
+		}
 	}
 
 	if (conn->ops->allocate_rsp_buf(work))
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -12256,6 +12256,60 @@
 	return trhdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM;
 }
 
+/*
+ * The decryption key is selected by the transform SessionId, but
+ * the request is authorized under the session named in the
+ * decrypted SMB2 header. Per MS-SMB2 the two must match, so check
+ * the decrypted message and its compound chain before dispatch.
+ */
+int ksmbd_check_transform_session(struct ksmbd_work *work, u64 tr_sess_id)
+{
+	struct smb2_hdr *hdr = smb_get_msg(work->request_buf);
+	size_t msg_len = get_rfc1002_len(work->request_buf);
+	size_t off = 0;
+	bool first = true;
+
+	if (msg_len < sizeof(*hdr)) {
+		pr_err_ratelimited("Decrypted message is smaller than SMB2 header\n");
+		return -ECONNABORTED;
+	}
+
+	for (;;) {
+		u64 sid = le64_to_cpu(hdr->SessionId);
+		u32 next;
+
+		if (first) {
+			if (hdr->Flags & SMB2_FLAGS_RELATED_OPERATIONS) {
+				pr_err_ratelimited("RELATED_OPERATIONS set on first operation\n");
+				return -ECONNABORTED;
+			}
+			if (sid != tr_sess_id) {
+				pr_err_ratelimited("SessionId mismatch between transform and inner header\n");
+				return -ECONNABORTED;
+			}
+			first = false;
+		} else if (!(hdr->Flags & SMB2_FLAGS_RELATED_OPERATIONS) &&
+			   sid != tr_sess_id) {
+			pr_err_ratelimited("SessionId mismatch in compound chain\n");
+			return -ECONNABORTED;
+		}
+
+		next = le32_to_cpu(hdr->NextCommand);
+		if (!next)
+			return 0;
+		if (next % 8) {
+			pr_err_ratelimited("NextCommand %u is not 8-byte aligned\n", next);
+			return -ECONNABORTED;
+		}
+		if (next > msg_len - off - sizeof(*hdr)) {
+			pr_err_ratelimited("NextCommand %u is out of the message\n", next);
+			return -ECONNABORTED;
+		}
+		off += next;
+		hdr = (struct smb2_hdr *)((u8 *)smb_get_msg(work->request_buf) + off);
+	}
+}
+
 int smb3_decrypt_req(struct ksmbd_work *work)
 {
 	char *buf = work->request_buf;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -416,6 +416,7 @@
 void smb3_preauth_hash_rsp(struct ksmbd_work *work);
 bool smb3_is_transform_hdr(void *buf);
 int smb3_decrypt_req(struct ksmbd_work *work);
+int ksmbd_check_transform_session(struct ksmbd_work *work, u64 tr_sess_id);
 int smb3_encrypt_resp(struct ksmbd_work *work);
 bool smb3_11_final_sess_setup_resp(struct ksmbd_work *work);
 int smb2_set_rsp_credits(struct ksmbd_work *work);
-- 
2.53.0
