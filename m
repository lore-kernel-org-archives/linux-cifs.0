Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5A2339847
	for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 05:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790572667; cv=none; b=CD1BTwGwMdWS5vOiDqxagezLdxUvKk7PYp2D9plXKPvnDQecFZieieb71uXo0pbvl9QZLJYTSq7AaKceoNYCw2cc70wvlcr/irjEbwLitnHfhjEW8HjjEYzWFVAJ1bM/N5jrBpZsT9+ECignoGrglal2N5ZHcFGMwUD9/VyIPjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790572667; c=relaxed/simple;
	bh=2Hq9DFIiqjEZe5IKsdoAZF84k0pJ1/ldPkMnQ9Ooois=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6QQacuzh8TZOpqafRrJrkxzj4dom2qdwEb3jwRam1MY/hqj5uUq/IG9IIs2r6w9LyrYNJmg/I2wTu8lQavQfpAlMTMjGi/zYw87nkkg3It4zMQNktkVHYXMbbgnwGsGX+5w/50VXF+lnMj5XskenFizk9a0JYUhZ8ZwYjk6ch8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JRRQWyCW; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JRRQWyCW"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-8693af0d7c4so1410789b3a.3
        for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 22:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790572666; x=1791177466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iGDgz8iOX6yN9PoA3D3adfZ5p5XVTeyZBwSy3n4uqr4=;
        b=JRRQWyCWjUutvbSB6TZEzCHiTU1hLdzvlVnTAzGv6YLuw8sr1pQ8BveKBtH571H5s2
         Qcnm9Kd9zUAXHj48fPnHzL/MKQzZZNvNpftXIRGRYKqiRyAmLEtiKUynDrxeqTu4p3aG
         IgOU2zJXAJf7LVjGUwgacKm/1RfwJGvKVM3jWh7E7jEcDHKRM3oAUxnWukPu6LiUgHju
         BI58dTWTNXG2YBVuXj/lhnSHsiBAAO3GXEOUZVkR7779LFAFqMw7gt06dUWbhtJJFs6f
         3TnzvmKLW1UbsOrEiSCk9CaHoJftJh5oeOwW+bQPlcL3TnEF5cB0K4UC6hfW6xd+t8WI
         KKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790572666; x=1791177466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iGDgz8iOX6yN9PoA3D3adfZ5p5XVTeyZBwSy3n4uqr4=;
        b=VxZ/D2pOdkjb4YcBRjqc1SOaQbrXfMt/eo/64MCE1Wq8NMz6COI35z44ifNod3ISMx
         3Bjr2fALGUXbO5x0vw2ndB3iYGM8/c+B9H+Hb6zR1AQ8XpFMHzQgttJjRXz8dF+F91+U
         w1SvXH9nbiLayj63TbBd+vE6hgRUHB7XgzCgl8bwEWko4UXXRGsczXD778Kr3KV77eXG
         e30g94uuEXUVwKUg39bQ5/oI/zPq6mJjIImVdhK9zXlTKbwVoaT4xpiQlAEouw+hvZkV
         +GE0UF67Maims61T3IMV9R8EV6fJwhTeJmtrdUMQF5OYY4i+/MSlipZVheuhOVCEOFyd
         xkng==
X-Gm-Message-State: AFuF++mRXNzllIx7U0FvLPcb+N2DiJ6a3rNWAXOs/BCMRIusQViu99kr
	30Fal1xsgHOkBD73fheeiSN1mfO/jf7tSspmYqeaS7laxLESoM7b8R3M+wSsUD+NJRWsSQ==
X-Gm-Gg: AYBFou01lqPysBAXrwX1OWbmrzXRcXa/3iUNTsnMOFWRuNMYhy713jsf5ZNEYw3V7Tq
	fzYrog5SPDL751wtRO2gdmzuEvcvZsPVH01ynmBNm6EO0CUqA7JhQZqWW3fJVMPdtg7MY8F/LAC
	cVK1JqSx194jksYboc8iYk7iWojcdmRVZkZrFx4w8R1nQgROJdOw3gMj44cMVuUfzLVN7lvOX0p
	hKcrX2lXkzVDvjcRHN3yzkagySssf+pCKRlsOTAnRAVMz80KJUyZT4kio5aVbcmeHPa6gdgs2IR
	d83Bt/Y15zoI3ebb4cSAci8QHfGoScdTjyou5kuz98JVgPf7YqEni8L/YePpcUPt0FHJcsH9NsF
	66XEXeyoCHf6NhKXpnVdsT8jHZjSkYnna6plybieIIJxyoIyrTY+xbt1DYvb2nmXe51BzsJsP9R
	bkYlbHt686e40VZGikV0oun0h8xtHKlF48FE/laAOKTMyDIbxau4Eabd34+zuzDC9R
X-Received: by 2002:a05:6a20:3d21:b0:3d0:8abe:9e08 with SMTP id adf61e73a8af0-3de0e6fb52amr10099015637.3.1790572665562;
        Sun, 27 Sep 2026 22:17:45 -0700 (PDT)
Received: from localhost ([8.219.43.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87feb67dc92sm3512865b3a.51.2026.09.27.22.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 22:17:45 -0700 (PDT)
From: Dairui Zhang <zhangdairui@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Dairui Zhang <zhangdairui@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] ksmbd: verify transform SessionId matches the decrypted header
Date: Mon, 28 Sep 2026 13:17:42 +0800
Message-ID: <20260928051742.1789650-1-zhangdairui@gmail.com>
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

The decryption key for an encrypted request is selected by the
SessionId in the encryption transform header, but the request is
then authorized under the session named in the decrypted inner SMB2
header. Nothing compares the two, so on a connection carrying more
than one session a client can have a request decrypted with one
session's key and executed under another session's identity. Since
encrypted requests are also exempt from the signing requirement, the
AEAD tag is the only proof of session identity, and it is checked
against the wrong session.

Per MS-SMB2 the server must verify that the SessionId in the
transform header matches the one in the decrypted SMB2 header and
treat a mismatch as a protocol error. Validate the whole decrypted
message before dispatching it: the message must be at least one
fixed SMB2 header; the first operation must not set
SMB2_FLAGS_RELATED_OPERATIONS and its SessionId must match the
transform SessionId; each subsequent operation in a compound chain
must either set SMB2_FLAGS_RELATED_OPERATIONS or carry the same
SessionId; and NextCommand offsets must be 8-byte aligned and within
the message. When the encrypted payload is a compression transform,
the transform SessionId is saved during decryption and the same
validation runs on the decompressed message. (The 8-byte alignment
of compound responses is already handled by the existing
chained-response padding.)

Reported-by: Dairui Zhang <zhangdairui@gmail.com>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>
---
v2 -> v3:
- Per review, extend the check to the whole decrypted message before
  dispatch: first-op size/RELATED_OPERATIONS/SessionId rules and
  per-op compound-chain SessionId and NextCommand validation, shared
  between the plain and compression paths via a common helper.
v1 -> v2:
- Cover the compression-transform case.
- Reject a decrypted SMB2 message smaller than the fixed header
  before reading its SessionId.
---
Resent with the [PATCH v3] subject marker Greg pointed out was
missing; no code changes from the previous submission.
---
 fs/smb/server/compress.c   | 17 +++++++++
 fs/smb/server/ksmbd_work.h |  4 ++
 fs/smb/server/smb2pdu.c    | 78 ++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.h    |  2 +
 4 files changed, 101 insertions(+)

diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
index 5162fb8..b07b140 100644
--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -10,6 +10,7 @@
 
 #include "compress.h"
 #include "smb_common.h"
+#include "smb2pdu.h"
 #include "../common/compress/lz77.h"
 
 #define SMB_COMPRESS_MIN_LEN	PAGE_SIZE
@@ -125,6 +126,22 @@ int ksmbd_decompress_work_request(struct ksmbd_work *work)
 	if (rc)
 		return rc;
 
+	/*
+	 * The encryption transform SessionId was saved before the
+	 * compression transform was parsed; the decompressed message must
+	 * pass the same session binding validation as a plain decrypted
+	 * message.
+	 */
+	if (work->tr_sess_id) {
+		rc = ksmbd_check_transform_session(
+				(struct smb2_hdr *)smb_get_msg(out_buf),
+				get_rfc1002_len(out_buf), work->tr_sess_id);
+		if (rc) {
+			kvfree(out_buf);
+			return rc;
+		}
+	}
+
 	kvfree(work->request_buf);
 	work->request_buf = out_buf;
 	return 0;
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 5f1d3eb..3e8bf2a 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -82,6 +82,10 @@ struct ksmbd_work {
 	/* Contiguous SMB2 compression transform owned by this work item. */
 	void				*compress_buf;
 
+	/* SessionId from the encryption transform header, for the
+	 * post-decompression SessionId check. Zero when unset. */
+	__u64				tr_sess_id;
+
 	unsigned char			state;
 	/* No response for cancelled request */
 	bool                            send_no_response:1;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4cf7083..dbb7dcb 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10852,6 +10852,62 @@ bool smb3_is_transform_hdr(void *buf)
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
+ *  - NextCommand offsets must be 8-byte aligned and inside the message.
+ * Returns 0 on success, -ECONNABORTED on protocol error.
+ */
+int ksmbd_check_transform_session(struct smb2_hdr *hdr,
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
+		off += next;
+		if (off + sizeof(struct smb2_hdr) > msg_len) {
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
@@ -10860,6 +10916,7 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	unsigned int buf_data_size;
 	struct smb2_transform_hdr *tr_hdr = smb_get_msg(buf);
 	unsigned int original_msg_size;
+	__le32 proto;
 	int rc = 0;
 
 	if (pdu_length < sizeof(struct smb2_transform_hdr)) {
@@ -10890,6 +10947,27 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	if (rc)
 		return rc;
 
+	/*
+	 * The decryption key is selected by the transform header SessionId,
+	 * while the request is authorized under the session named in the
+	 * decrypted inner header. Per MS-SMB2 the two must match, so
+	 * validate the whole decrypted message before dispatching it. A
+	 * compression transform payload carries the session id only after
+	 * decompression, so save the transform SessionId for that check
+	 * instead.
+	 */
+	proto = ((struct smb2_hdr *)iov[1].iov_base)->ProtocolId;
+	if (proto == SMB2_PROTO_NUMBER) {
+		rc = ksmbd_check_transform_session(
+				(struct smb2_hdr *)iov[1].iov_base,
+				original_msg_size,
+				le64_to_cpu(tr_hdr->SessionId));
+		if (rc)
+			return rc;
+	} else if (proto == SMB2_COMPRESSION_TRANSFORM_ID) {
+		work->tr_sess_id = le64_to_cpu(tr_hdr->SessionId);
+	}
+
 	/* Drop the AEAD authentication tag from the inner RFC1002 frame. */
 	memmove(buf + 4, iov[1].iov_base, original_msg_size);
 	*(__be32 *)buf = cpu_to_be32(original_msg_size);
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 1836259..2cdeb56 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -399,6 +399,8 @@ struct channel *lookup_chann_list(struct ksmbd_session *sess,
 void smb3_preauth_hash_rsp(struct ksmbd_work *work);
 bool smb3_is_transform_hdr(void *buf);
 int smb3_decrypt_req(struct ksmbd_work *work);
+int ksmbd_check_transform_session(struct smb2_hdr *hdr,
+				  unsigned int msg_len, __u64 tr_sess_id);
 int smb3_encrypt_resp(struct ksmbd_work *work);
 bool smb3_11_final_sess_setup_resp(struct ksmbd_work *work);
 int smb2_set_rsp_credits(struct ksmbd_work *work);
-- 
2.53.0

