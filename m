Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4945545D920
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 16:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790698775; cv=none; b=uoGdrVmJhDqzafYMpvwJ0X+4EumiyfiK/5mmU9CERvM+EEU1doO6Q1PPlZNHGzrQyUui9wX2NZ5k+Q2h5RwnKfphbDycj3fPgl161PAROOaxJUjKnQr8fOZkR40tlfghw+TIL+Fi/T72vVl9r5UyPuWgvqbdRCYr9KSMRDIvOpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790698775; c=relaxed/simple;
	bh=ON/Nm199fXt25tUkNXWt6yTI0ajOWyNykjj4e5sjBPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFXlvMRXTjF+IqSWkX/tT+M/kb6Tk3er/a304p69MMk4CtbvpHnr+Zjc64tx8pLiZSoiI5K1+dGO4xS4gbJNrO/qjMat9wsQu6Cj7oZT+V08boHPmqI32TNM7bjgDsAYYAu1I7FvlUMXFuWp30XGNHdxRO+rb29EUJ4g/uvywPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fY+UQnWG; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fY+UQnWG"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-33e630052ebso4965080eec.0
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 09:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790698773; x=1791303573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ItJcp+tPRukYSHRfLwmMwoYplEEStSxemB80lg82sVU=;
        b=fY+UQnWGcqpnV6JT4FcuSxidcoOn+HkFM3cieDMRrSZe8eLfjwRurB3s9n3mJMSLST
         S+sEOXXoOh3kbdp0ULRvoSbLF3VcfDmPKpSGR/A7IqLVdnMeCr9XyBgOi7BaXr96plMq
         2arFO6B3dlvqCbhuVu5wBOvWm/A5jYAvnecIQOP9URFX0tgmt7Jvh6HEmqmAp6sOlJ8o
         SlvxaABMXRgpRUm+eNuTrGyy62ibrP0tIgvJE/MA8x34MijEmrzecgssrm4pfGoM8wGs
         z7iHzXlXojmIBtTu6zl6yD7S2NFuuEhX9xhdnKcFYbgrFZh30LhAUta1ln/ZFptGmgsl
         LgHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790698773; x=1791303573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ItJcp+tPRukYSHRfLwmMwoYplEEStSxemB80lg82sVU=;
        b=KmYQ/Ne/WWtooU1Ve/b6YZh9kMbicuAbZ0s+DN0V4xUSSveVh7zoG261nproxDEuAq
         y0hlNSI4EtO+OHC/m+m3l0aNzsqPBOAXjuEaxfkOsZHnLMy+LgTt3EdCd1NRgMYwLUb4
         ZmfQuORUK5leISqT5bibZejyX6vKLWh3ajbwGIlJnzDnZ2ntqMARshiNymE1SswtTaAg
         zFWojnDX9BoEECgPTDlON8w03Jaa3xwaAPfS4eoKBnwYlHQnK2daEGOyYGJ24fj0vSeP
         xq0GtkeK4QtgHKuc6QO28hXYTbTqq1CbsyxnPftmvka4XsItzebbff6z8y+XXjDZ1HqH
         550A==
X-Gm-Message-State: AFq9FYIJpFS1lgq8fc/iaBUu6bUFZMs3ZvXmsfuBJsQuod3fpbM3svYp
	JtrrXGh2xN8WaO/Yvs55b+e38uvtgChVU7faKYQQj5HbwFTsNT05oNQP
X-Gm-Gg: AYBFou3wvGpmzbFjKvm+Yg+fRuXvN2pWm7xhcxAggIyB+1L9t06ZMsIOgtJEgETczzj
	YUr5KudMq7+yxTyznnjL0FGMtY2yTgtbCsZPi25JatHOSXm2h8XU5h6bylec6Ud6Rnx1UOZmVay
	eA2UtAtfsgu+rWKo9NkKdSbQAiDgV5HOL8uyp8uFYE3OrSlCVKCUt9+LPbscrwmC3VWtMbyM1XG
	HAd/O8PKRFjl9KxnjG/9FqvpVefTuxrFvy6Y+ef1u2fNfqfB7tmOA9oo1rDZT5f26GdeQ6NgxkM
	OPHlrOoFzxuv7l587vWo4/tiRRwQO2pDTO+WJXwVKfPk4mxsdF7XrSecBf0Y4NHXhEPRBZh63y+
	CVQtHo4tkiryirrsyPZzSZZy2T3U6vYcLmw47SEsgxN6gcMVS4JmUA5KLMtZDx7k/P5Lp9qwwOx
	Crq+D/zj2Dq/hvdadZaqHSjgiJj5eqAluo3WW/TGbfN0oZDsyC61jGlwdPBVGrvdWMJw==
X-Received: by 2002:a05:7301:6493:b0:33e:4e63:5d80 with SMTP id 5a478bee46e88-34c44b10683mr200567eec.11.1790698773247;
        Tue, 29 Sep 2026 09:19:33 -0700 (PDT)
Received: from localhost ([8.219.235.175])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34c386b6bd9sm488985eec.16.2026.09.29.09.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 09:19:32 -0700 (PDT)
From: Dairui Zhang <zhangdairui@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	stable@vger.kernel.org,
	Dairui Zhang <zhangdairui@gmail.com>
Subject: [PATCH v5] ksmbd: verify transform SessionId matches the decrypted header
Date: Wed, 30 Sep 2026 00:19:30 +0800
Message-ID: <20260929161930.1894929-1-zhangdairui@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928162015.1832109-1-zhangdairui@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Namjae,

You're right. I missed the decompression step in
__handle_ksmbd_work(), and the "no decompression step" and
"no ProtocolId check" claims in the v4 commit message were wrong.
Sorry for the sloppy reading and the extra work it caused you.

v5 moves the check to __handle_ksmbd_work(), after the existing
decompression step, so encrypted compression transforms are no
longer rejected. The transform SessionId is read before
decryption and verified against the final SMB2 message.
The compound-walk bounds check now uses subtraction (the
addition could wrap on 32-bit), and I added the Fixes tag.

From a320c66f1aeb773cf65d2489fae9f982eaf3873f Mon Sep 17 00:00:00 2001
From: Dairui Zhang <zhangdairui@gmail.com>
Date: Tue, 29 Sep 2026 22:30:00 +0800
Subject: [PATCH v5] ksmbd: verify transform SessionId matches the decrypted
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
a compound chain must carry the same SessionId. SessionId ~0 is
accepted in subsequent operations, same as the existing compound
session check. NextCommand offsets must be 8-byte aligned and stay
inside the message; the bounds check is done by subtraction so it
cannot wrap.

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
+			   sid != ULLONG_MAX && sid != tr_sess_id) {
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
