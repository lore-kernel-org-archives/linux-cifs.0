Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8084E4C50
	for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790612453; cv=none; b=CnB8DnyMNv5qMRRS46IQorReb1xOfNs9/046me8Y76uivxM/0qPbu7ZcFHXH83mV40r9RtHCNAnimBGhk4I3TR6fin3eR5nSzEHl9sx9+S7hTAYpXmqhyTR2L3ThUVn4IOLyq5WNbr8dAbdnetX0Gum76QTw/ektYDoHzQYen2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790612453; c=relaxed/simple;
	bh=vs01MtfEVBiTmJkI3GpvJwZkshOrLmwv+qiFKh+6pNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCeWuy23vUaCMls8lUg7WNc1cE5JxlqMgZOVjvRHRzTmzfx1q3G4Ipe03x1fbFe6ZCNeD2BLZ44JuEOtEMINcjUHY4RxPbrY3Zk5LshpSpFn3syMPx8cA33ZA8gm9wSlGPpQjUyucHgtVww6Zj/Y+9HwRIUTvCyVEkxl+PCCgZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X0gugmWc; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X0gugmWc"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-3a494638445so175129a91.1
        for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 09:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790612451; x=1791217251; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=drEwMPfBNK7Qvk+gxJqEf+fPVQFTEJ4sYjTDfDQ8114=;
        b=X0gugmWc4n5NSwJfbU/zwULC3fNTCLHehjT8V5kgtzLqHr4fkyU4X1H2No+X3YeeA+
         tS3uZwBqznUDrYet0CPVws9nKfmAIm1QJ72tod7cc/HLhHGfE9LSam20kg7VkjtqT68Q
         u4BuVSPErCAoyZZeF8df5lKCKwujQldPfRVRP8Zc8w9TPpw/YLiAvGkJRG88Eqv308Uj
         oqPbRf1QDzVIzdf9DRqshQaYSTM1AXoMaFo+x3nYeRGdSE5vxxeTjDr8keNDToRKeiAt
         YtPrC2BB8b6v4n05vSTcQnOAOQ8K6GSqPdMPJ+HdXNbkn7IGNRbChQVy5YpjaB0J+0HR
         i7VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790612451; x=1791217251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=drEwMPfBNK7Qvk+gxJqEf+fPVQFTEJ4sYjTDfDQ8114=;
        b=Kk9sSzf26NBRID+ogYSYBqy775fnS2KYA9asVie4TSPxmcm5DCZSB7NNv7PMxqRqYX
         PqIGdSK4Kq3NL86MZvlI0TvkP8jAAZYRgfTt7p0Zf4gWsrZEEjTiLnYQgC8ec5YJRs9C
         a1Napy42SQOHI5C+wBRWjNLA1zol+yUIfb9j5CULUDzaNy5V0wBYlhyRsk+yhK9HLA3A
         r8pbyUHvnEqJtLncmgs8cd/pEhc8C6iq5VdqwbOwuMGKaOBENptBF0desczG3KMUhagu
         gIb9dVzwgMV5m2/889K/749e52qlJE7F2QhCGLPwQ3FBduXOVatXBA6Q2RzOVCabzIHX
         9h/A==
X-Gm-Message-State: AFq9FYKeohqfKQ95brV+vb4z6stbeRF5cNclU96S/rgq9M0YBMZKr7kO
	ktJyCmuDraPVFA50BOxG2mGA4OjlBrmHSG/Y/rSxWhFNgIsOskEsK2muGiszk4jRFOGvYQ==
X-Gm-Gg: AYBFou02fv2X36bjcvNmQURA+upSNZ9jjRyYmf1GwmTlHEl+W7zcYnRE4vZTy26Bw/g
	h4/Jo+u2BtucwMHrIo+x9MFieUQ6aMUOWjy130anq3pFVRZc95LPip1bSZJZacnHoh+v17o73Dr
	WWnWHrSAasKpzw6oNQMBraZgGi5zqg9hDnfFZudf8an3g9XWZ3Xn4dG7h5A/rs6OaK+va5Xy9fB
	WrlR1hfXZF/chYtSco8foI/ffMSRhVF/KtsuelhmD95CnsxcxKP9nDcu2Sehij4Kv6FJvdCE2B+
	Qhh6QyvCaJxSiEshnlORPIWVMQAtpn10tTrrUY0+wCZuaWoKbl40YgWInNoktipX8l4Bx0miwCK
	179USUbONhQ6+BF74Uc5wkyt/lRarAIqZmq1YklRJT8oaeEODuCAh3qqpptnNTtPLWCY+Netpuj
	gekOTvHSZymkwzTOcCyOiolbBn0ai1wQlOGqYOL/P4OJtPRzw8O8VzVvs4tfDaunaFKg==
X-Received: by 2002:a17:90a:fc48:b0:3a4:7bd0:2821 with SMTP id 98e67ed59e1d1-3a47bd02e51mr1017410a91.6.1790612450963;
        Mon, 28 Sep 2026 09:20:50 -0700 (PDT)
Received: from localhost ([8.219.235.175])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a497ebc998sm306128a91.2.2026.09.28.09.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 09:20:50 -0700 (PDT)
From: Dairui Zhang <zhangdairui@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Dairui Zhang <zhangdairui@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: verify transform SessionId matches the decrypted header
Date: Tue, 29 Sep 2026 00:20:47 +0800
Message-ID: <20260928162047.1829104-1-zhangdairui@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928031300.1782690-1-zhangdairui@gmail.com>
References: <20260928031300.1782690-1-zhangdairui@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
as a protocol error. Add that check before dispatching: the message
has to be at least one fixed SMB2 header, the first operation must
not set SMB2_FLAGS_RELATED_OPERATIONS and its SessionId must match
the transform SessionId, and every following operation in a
compound chain must either set RELATED or carry the same SessionId.
The usual ULLONG_MAX wildcard is accepted for those, same as the
existing compound session check, since it means the compound's
session and cannot be a different session. NextCommand offsets must
be 8-byte aligned and stay inside the message, and the accumulated
offset is guarded against u32 overflow.

While here I noticed there is no decompression step after
decryption, so an encrypted compression transform would be
dispatched as if it were a plain SMB2 message. ProtocolId is not
checked anywhere on that path, so a crafted transform could be made
to parse as a valid command under any session id in the payload.
Reject those for now; if encrypted compression ever comes back, the
decompression step has to be restored and the message needs the
same check after decompression.

Reported-by: Dairui Zhang <zhangdairui@gmail.com>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>
---
v3 -> v4:
- Rebase onto ksmbd-for-next as requested.
- Guard the chain-walk offset accumulation with
  check_add_overflow() before updating it, per Namjae's review
  (an invalid NextCommand could otherwise wrap the offset and loop).
- Reject encrypted compression transforms outright: for-next has no
  decompression step after decryption, and an undecoded transform
  would otherwise be dispatched as an attacker-crafted command
  (ProtocolId is not validated downstream).
- Exempt SessionId == ULLONG_MAX in subsequent compound operations,
  matching the existing compound session-check behavior (it means
  the compound's session and cannot be a confused deputy).
---
 fs/smb/server/smb2pdu.c | 85 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index bfa8954..ec47457 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -11634,6 +11634,64 @@ bool smb3_is_transform_hdr(void *buf)
 	return trhdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM;
 }
 
+/*
+ * Validate the session binding of a decrypted message against the
+ * encryption transform SessionId, per MS-SMB2:
+ *  - the message must be at least one fixed SMB2 header;
+ *  - the first operation must not set SMB2_FLAGS_RELATED_OPERATIONS
+ *    and its SessionId must match the transform SessionId;
+ *  - each following operation in a compound chain must either set
+ *    SMB2_FLAGS_RELATED_OPERATIONS or carry the same SessionId;
+ *  - NextCommand offsets must be 8-byte aligned, and the accumulated
+ *    offset must not overflow and must stay inside the message.
+ * Returns 0 on success, -ECONNABORTED on protocol error.
+ */
+static int ksmbd_check_transform_session(struct smb2_hdr *hdr,
+				  unsigned int msg_len, __u64 tr_sess_id)
+{
+	struct smb2_hdr *in_hdr = hdr;
+	bool first = true;
+	u32 off = 0, next;
+
+	if (msg_len < sizeof(struct smb2_hdr)) {
+		pr_err_ratelimited("Decrypted message is smaller than SMB2 header\n");
+		return -ECONNABORTED;
+	}
+
+	for (;;) {
+		if (first) {
+			if (in_hdr->Flags & SMB2_FLAGS_RELATED_OPERATIONS) {
+				pr_err_ratelimited("RELATED_OPERATIONS set on first operation\n");
+				return -ECONNABORTED;
+			}
+			if (le64_to_cpu(in_hdr->SessionId) != tr_sess_id) {
+				pr_err_ratelimited("SessionId mismatch between transform and inner header\n");
+				return -ECONNABORTED;
+			}
+			first = false;
+		} else if (!(in_hdr->Flags & SMB2_FLAGS_RELATED_OPERATIONS) &&
+			   le64_to_cpu(in_hdr->SessionId) != ULLONG_MAX &&
+			   le64_to_cpu(in_hdr->SessionId) != tr_sess_id) {
+			pr_err_ratelimited("SessionId mismatch in compound chain\n");
+			return -ECONNABORTED;
+		}
+
+		next = le32_to_cpu(in_hdr->NextCommand);
+		if (!next)
+			return 0;
+		if (next % 8) {
+			pr_err_ratelimited("NextCommand %u is not 8-byte aligned\n", next);
+			return -ECONNABORTED;
+		}
+		if (check_add_overflow(off, next, &off) ||
+		    off + sizeof(struct smb2_hdr) > msg_len) {
+			pr_err_ratelimited("NextCommand %u is out of the message\n", next);
+			return -ECONNABORTED;
+		}
+		in_hdr = (struct smb2_hdr *)((u8 *)hdr + off);
+	}
+}
+
 int smb3_decrypt_req(struct ksmbd_work *work)
 {
 	char *buf = work->request_buf;
@@ -11641,6 +11699,7 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	struct kvec iov[2];
 	int buf_data_size = pdu_length - sizeof(struct smb2_transform_hdr);
 	struct smb2_transform_hdr *tr_hdr = smb_get_msg(buf);
+	__le32 proto;
 	int rc = 0;
 
 	if (pdu_length < sizeof(struct smb2_transform_hdr) ||
@@ -11663,6 +11722,32 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	if (rc)
 		return rc;
 
+	/*
+	 * The decryption key is selected by the transform header SessionId,
+	 * while the request is authorized under the session named in the
+	 * decrypted inner header. Per MS-SMB2 the two must match, so
+	 * validate the decrypted message before dispatching it.
+	 */
+	proto = ((struct smb2_hdr *)iov[1].iov_base)->ProtocolId;
+	if (proto == SMB2_PROTO_NUMBER) {
+		rc = ksmbd_check_transform_session(
+				(struct smb2_hdr *)iov[1].iov_base,
+				buf_data_size,
+				le64_to_cpu(tr_hdr->SessionId));
+		if (rc)
+			return rc;
+	} else if (proto == SMB2_COMPRESSION_TRANSFORM_ID) {
+		/*
+		 * There is no decompression step after decryption, so a
+		 * compression transform would be dispatched as if it were
+		 * an SMB2 message. ProtocolId is not checked on that path,
+		 * so a crafted transform could be made to run as a valid
+		 * command under any session id in the payload.
+		 */
+		pr_err_ratelimited("Encrypted compression transform is not supported\n");
+		return -ECONNABORTED;
+	}
+
 	memmove(buf + 4, iov[1].iov_base, buf_data_size);
 	*(__be32 *)buf = cpu_to_be32(buf_data_size);
 
-- 
2.53.0

