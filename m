Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E77A525A72
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 15:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789572594; cv=none; b=EeTcPO3oyL4mVp7u/bfpvYvjTwMzKrFwKPWKXw+vg8vUlHjaULPF2WJ+lQlYfODY+Vc/D8x7owRZ47rPEOBLuRhbXpXQekBD9cik4zgMAf+uJiadpkN87Z5ygIJgwdqFm8OfNrbkxrPPUsl3bohwOQ6FwRGNrJAZpr999Yw6x+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789572594; c=relaxed/simple;
	bh=e4mZrfsxkodpuQqeGRiSfS3fzBv+HZweuvs7ejDvKKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQaXrVw/kNdiNgdX81jLCZhG0KNCjafj67Z+no7/5oaeC0cbsBGXyOkJemaS8f86F+Mf2sSQSH6AJ2V54gLTKT6uDSCQQW3VV1xytBY53WjpgrfPaLy/bkLquvWLi8JUWWdj2ACVrqdVoqxKWU4vZJpUGTe/yKTTCpWAZm1sLKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=Bn1Kq/Ap; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="Bn1Kq/Ap"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cea50dc1so652636a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 08:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789572586; x=1790177386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tPnCpncMFnpccjoQkrRtEWougbMuRTTA3lDYH8x7qRU=;
        b=Bn1Kq/Ap6qgmm+ossvUe5UuBvzxbJlpcWQJ6Y/DIp+on+LUxYPFNs49+FMi5FC/rGf
         6QbblNexMnxAyQ0piKzOYgVwSptCAXuLdU4sZlPYrjHe5dAjvAQzoQPP1+873EaA4kni
         mmiyRWxMhjni6OHlTirSOsW4MpH3gnsWk6uz6VHfclvG6S6eoj5e/+CPNwPm1WYrsxyP
         KlB2rM1qi7r7gk92rqfWShuuXtE+D4iaK7nVWRvmH0UZqkQTI67pZdijwW5b96lR0EB2
         EV+b8VcsKIww+Z873zd6LTeYBWv/EeOLErxmx3uus0WlT3wsdJT82zqOGh4zUSwNRwmX
         WmRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789572586; x=1790177386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tPnCpncMFnpccjoQkrRtEWougbMuRTTA3lDYH8x7qRU=;
        b=lHWrgeuSVgRqTdlwga1I7u8aCn5DiYED41k/V7MPHLcrZLEVDNCz7CBgynQdUc8uCa
         LDjzJiris/qWleOPqWmyzDQgNCd412wVJVoD9xQ2sr0gzDJUBDb1NYM7nEcM6+irY1qU
         xlI5wYfuuZT4drkdVLb/X1smVtMSsjqOh/wmjiVpOxKYsAKJKjpwDUdiBx3/JC5LAcJ4
         b5n/nbPptHDYn2jqqWPfculEfJa6TPIAOqfJBgR0UaTaKJ3DbnRI/CGrFTs3LwWLbdcK
         Rm4No70YsmTyHiOkTE27FWKCQshzo0KKKUr2rzec6lAk8zuJhLjMG5B6Knom8ofnYVjw
         M+lA==
X-Forwarded-Encrypted: i=1; AKwUvBwjwN1Yg+IXtlWpMtx9/ssSbeVDSstYJ7VwuIo+ETO0HQl6YqwTV5kqaHysHf8VHazOwThH1bFm/fkY@vger.kernel.org
X-Gm-Message-State: AFuF++kuaL3Eoktl/eEA8KCxAFf+LCIIZL8NdhlVpIsXoLsKfjsrYlrQ
	zTRRdOAlChVs4B8RnYRL9TLbgEGDdhDWjnuwBVqCdgvKx8chbDW79fopKSz+eD2iRF3A
X-Gm-Gg: AYBFou0Ee/j427ntWQxbFo1wPccrbwu2O0A5z7LQoL0G6Ucw5td7k/L2BwRXRbOiOWQ
	7J37pWdsN+FfRhDuLC/MLUiQZL3BybcW7TKgCZo7DnFfL0mnYxFZFUECjzBe8TvIHRTdj/hiK3X
	ldCXCe9C1ZfQ+GBkMDjkLE8ak2cF0q0Yc614v0U1q+OVyqD3hlI3Y2PazhjJKS4yefc5ofoAJnj
	IQsqgEt8rOyq9Sk2xeaSQJ9ktHNtEcqabGbLGgMWV3t8C3J4Wnq4uUW7tKfuhpT5CgxHzUQDvoG
	37ie59G+7wpOoIl1raiLSz+1dFfrdkajEKFNb5TQ2brLmlv9iyWohmFRaoiBt4AF340zMuTMJ0p
	2bDTs/Xop6UpiZCwfcev9DmskQXATHyzRHDL6+USQtBJHHFBEPd6Z39EisWTeVp1g3l8Cbxd+X6
	MBBWECnlzziFTxDoqVJakUChwVEJVpH84PVLOhyvi8WLNEVXUGIoIn2PoNyLvbg7q2ABHoILdXy
	TsujBsHYZAoWTRa96PrJ0qtgxP/iCe6LcT3ER1/
X-Received: by 2002:a17:90b:560c:b0:39d:e523:8f3e with SMTP id 98e67ed59e1d1-39e1e2657b1mr7088907a91.3.1789572585728;
        Wed, 16 Sep 2026 08:29:45 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e35dab2e9sm28214a91.1.2026.09.16.08.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 08:29:45 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: pc@manguebit.org
Cc: linkinjeon@kernel.org,
	zihanx@nebusec.ai,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH v4 1/6] smb: client: fix create context out-of-bounds reads
Date: Wed, 16 Sep 2026 15:29:24 +0000
Message-ID: <4e24aefb4162e26094cf1be2a57db43fe3171ad4.1789478666.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1789478666.git.zihanx@nebusec.ai>
References: <cover.1789478666.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_parse_contexts() validates the complete create-context area but
does not limit each record to its Next field before dispatching it.  A
malformed chain can therefore expose bytes beyond the current context to
a handler.  The QFid handler also used a full response-structure cast
although it only reads DiskFileId.

The SMB2/SMB3 lease parsers made the same layout assumption: they read
LeaseState and LeaseFlags at canonical offsets rather than at
DataOffset.  A valid non-canonical DataOffset could therefore yield
unrelated in-bounds data, while a short DataLength was still accepted.

Limit each context to its Next value, reject offsets before the context
header, and reject malformed chains.  Bound the name range by the current
context and do not dispatch a known handler when DataLength is zero.  Read
the QFid DiskFileId only when the context data covers that field.  Parse the
lease context from DataOffset and require DataLength to match the v1 or v2
lease_context size used by ksmbd.  A size mismatch skips lease parsing
without failing the open.

Fixes: b8c32dbb0deb ("CIFS: Request SMB2.1 leases")
Fixes: f047390a097e ("CIFS: Add create lease v2 context for SMB3")
Fixes: 89a5bfa350fa ("smb3: optimize open to not send query file internal info")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>

---
changes in v4:
  - Reject NameOffset and DataOffset values before the context header and
    use checked arithmetic for the name range.
  - Bound the name range by the current record and skip known-handler
    dispatch when DataLength is zero.
  - Parse lease data from DataOffset and require exact v1/v2 payload sizes.
  - Add the SMB3 lease v2 Fixes attribution for f047390a097e.
  - v3 Link: https://lore.kernel.org/all/cover.1788516372.git.zihanx@nebusec.ai/
changes in v3:
  - Split the POSIX handler check into a separate patch and corrected the
    parser Fixes history.
  - v2 Link: https://lore.kernel.org/all/cover.1787486936.git.zihanx@nebusec.ai/
changes in v2:
  - Bound each response context by Next and reject malformed chains.
  - Read QFid DiskFileId only when DataLength covers the payload.
  - Extend the SMB2 lease minimum through the LeaseFlags field.
  - Add a POSIX handler check for the three fixed fields.
  - v1 Link: https://lore.kernel.org/all/eb1bc35611f91bd10a4772400b37fac26f660956.1782579150.git.xizh2024@lzu.edu.cn/

---
 fs/smb/client/smb2ops.c | 28 ++++++++++++++++++--------
 fs/smb/client/smb2pdu.c | 44 +++++++++++++++++++++++++++++++----------
 2 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 192649fec25d5..749cee88fc38d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4437,25 +4437,37 @@ smb3_create_lease_buf(u8 *lease_key, u8 oplock, u8 *parent_lease_key, __le32 fla
 static __u8
 smb2_parse_lease_buf(void *buf, __u16 *epoch, char *lease_key)
 {
-	struct create_lease *lc = (struct create_lease *)buf;
+	struct create_context *cc = buf;
+	struct lease_context lc;
 
 	*epoch = 0; /* not used */
-	if (lc->lcontext.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE)
+	if (le32_to_cpu(cc->DataLength) != sizeof(lc))
+		return 0;
+
+	memcpy(&lc, (u8 *)cc + le16_to_cpu(cc->DataOffset), sizeof(lc));
+	if (lc.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE)
 		return SMB2_OPLOCK_LEVEL_NOCHANGE;
-	return le32_to_cpu(lc->lcontext.LeaseState);
+	return le32_to_cpu(lc.LeaseState);
 }
 
 static __u8
 smb3_parse_lease_buf(void *buf, __u16 *epoch, char *lease_key)
 {
-	struct create_lease_v2 *lc = (struct create_lease_v2 *)buf;
+	struct create_context *cc = buf;
+	struct lease_context_v2 lc;
+
+	if (le32_to_cpu(cc->DataLength) != sizeof(lc)) {
+		*epoch = 0;
+		return 0;
+	}
 
-	*epoch = le16_to_cpu(lc->lcontext.Epoch);
-	if (lc->lcontext.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE)
+	memcpy(&lc, (u8 *)cc + le16_to_cpu(cc->DataOffset), sizeof(lc));
+	*epoch = le16_to_cpu(lc.Epoch);
+	if (lc.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE)
 		return SMB2_OPLOCK_LEVEL_NOCHANGE;
 	if (lease_key)
-		memcpy(lease_key, &lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
-	return le32_to_cpu(lc->lcontext.LeaseState);
+		memcpy(lease_key, lc.LeaseKey, SMB2_LEASE_KEY_SIZE);
+	return le32_to_cpu(lc.LeaseState);
 }
 
 static unsigned int
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 4ce165e40657f..7a6627400ba30 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2378,11 +2378,17 @@ create_reconnect_durable_buf(struct cifs_fid *fid)
 static void
 parse_query_id_ctxt(struct create_context *cc, struct smb2_file_all_info *buf)
 {
-	struct create_disk_id_rsp *pdisk_id = (struct create_disk_id_rsp *)cc;
+	u16 doff = le16_to_cpu(cc->DataOffset);
+	u32 dlen = le32_to_cpu(cc->DataLength);
+	u8 *beg;
 
-	cifs_dbg(FYI, "parse query id context 0x%llx 0x%llx\n",
-		pdisk_id->DiskFileId, pdisk_id->VolumeId);
-	buf->IndexNumber = pdisk_id->DiskFileId;
+	if (dlen < sizeof(__le64))
+		return;
+
+	beg = (u8 *)cc + doff;
+	memcpy(&buf->IndexNumber, beg, sizeof(__le64));
+	cifs_dbg(FYI, "parse query id context 0x%llx\n",
+		 le64_to_cpu(buf->IndexNumber));
 }
 
 static void
@@ -2430,6 +2436,7 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 	struct smb2_create_rsp *rsp = rsp_iov->iov_base;
 	struct create_context *cc;
 	size_t rem, off, len;
+	size_t cc_len;
 	size_t doff, dlen;
 	size_t noff, nlen;
 	char *name;
@@ -2452,29 +2459,41 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 		buf->IndexNumber = 0;
 
 	while (rem >= sizeof(*cc)) {
+		off = le32_to_cpu(cc->Next);
+		if (off) {
+			if ((off & 0x7) || off >= rem || off < sizeof(*cc))
+				return -EINVAL;
+			cc_len = off;
+		} else {
+			cc_len = rem;
+		}
+
 		doff = le16_to_cpu(cc->DataOffset);
 		dlen = le32_to_cpu(cc->DataLength);
-		if (check_add_overflow(doff, dlen, &len) || len > rem)
+		if (doff < sizeof(*cc) ||
+		    check_add_overflow(doff, dlen, &len) || len > cc_len)
 			return -EINVAL;
 
 		noff = le16_to_cpu(cc->NameOffset);
 		nlen = le16_to_cpu(cc->NameLength);
-		if (noff + nlen > doff)
+		if (noff < sizeof(*cc) ||
+		    check_add_overflow(noff, nlen, &len) || len > cc_len ||
+		    (dlen && len > doff))
 			return -EINVAL;
 
 		name = (char *)cc + noff;
 		switch (nlen) {
 		case 4:
-			if (!strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4)) {
+			if (dlen && !strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4)) {
 				*oplock = server->ops->parse_lease_buf(cc, epoch,
 								       lease_key);
-			} else if (buf &&
+			} else if (dlen && buf &&
 				   !strncmp(name, SMB2_CREATE_QUERY_ON_DISK_ID, 4)) {
 				parse_query_id_ctxt(cc, buf);
 			}
 			break;
 		case 16:
-			if (posix && !memcmp(name, smb3_create_tag_posix, 16))
+			if (dlen && posix && !memcmp(name, smb3_create_tag_posix, 16))
 				parse_posix_ctxt(cc, buf, posix);
 			break;
 		default:
@@ -2486,13 +2505,18 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 		}
 
 		off = le32_to_cpu(cc->Next);
-		if (!off)
+		if (!off) {
+			rem = 0;
 			break;
+		}
 		if (check_sub_overflow(rem, off, &rem))
 			return -EINVAL;
 		cc = (struct create_context *)((u8 *)cc + off);
 	}
 
+	if (rem)
+		return -EINVAL;
+
 	if (rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE)
 		*oplock = rsp->OplockLevel;
 
-- 
2.43.0

