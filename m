Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8E7369D57
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 16:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787501238; cv=none; b=al4rJ8ERZbg1pYlfirUCcX16xufd9zDwI9u9eQbDN98qimXVkYHJPEQpKJge1eRCH7ysA5QvaNI5VKpiPf7YuHmxtvwXSwiKgkHZbwifIN815CMq1bmlcjX+pTiUH3Us9Yx1ddBY8w7VrG0e1LQKICCtZFsLub9jgL7C8hXUu5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787501238; c=relaxed/simple;
	bh=WmRoR2qjdL0S4mdn9pkVY06GU4Q99k2G2O6p9GYRgmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tm+Hg+4GsxGiyq4dj3o4dBTgDAvEnh3YhHoBZFvGiV5FTOlYfpESfi19apehjX1YUE6qSLFgj9xyGE/gWplB/oIYNSO4ptgiuvbn08ZOaB3ElXlg2gMPzyzkuWRppQCLs83vp3LkRSV7gbJzq1Nvx8x2Llk+QoTorUdMmjENgcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=kSROMfAt; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="kSROMfAt"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84a652535dcso1414979b3a.3
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 09:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1787501236; x=1788106036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mNgkMYHHXvaXh9ETBcwWCoDa3W5TTVRzmfpXC6Gf2Lg=;
        b=kSROMfAtIUVWsJkXiKZbfQRVzzD8j0viXKOlkngEU/dbsyOH7DX0uyV0LzAm6YWiPg
         FojawNGvnOAptF54vdqyy0WNlKZpYXvtWkSNCykA3fIxC3ARtJ3d7ac9ZftDFzfgl7pI
         HDbVXQ3uw8p3arnhAiMsrsMLdjFUmm/6nR/4mv0j+CKcxWN8TCoBss5fdG2DzROzCXnt
         94uN2clQF8tjYfLO/Y5z5ZAjPb3YmgOxVRrVAQOOf2UAWVe0KauET/KyrrwRBF/9zZcm
         qtiAeBBdPH4gwlc5HANQgUkuRlBserf5JG5aEabpbyi/gaV0JCBGKCeXM0uVBDhr7cB4
         w9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787501236; x=1788106036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mNgkMYHHXvaXh9ETBcwWCoDa3W5TTVRzmfpXC6Gf2Lg=;
        b=oHYubBUSPsIM5fnP77fbLnXzhpeOWtsHqz3iFTv1WeBxP60tkhv5hncgfvdZEiVhTo
         +R/5osGEWaYITPGcXiq4M0K42qurSHKYLtUp0UZ20Ow6HUDuVldruU9GREVaCrYllkxa
         Bh2I0pBZQwB2SPWZOoDFrb4EA70H/Kf3oOWfUvb9RBo/0r2UKl2g2Q+OBiaeRn3u+PGx
         UHfscA91r/jLbUmvtBwDFetbIx63BYDU81neUeRWoICc5ENftpxkhX+W8V3o4lTvrhtY
         4gVMeVi8AKlcTSIZeakpaz3+WGxXGC0sU0+RgdJLX1XE4dOvtOr254N/wANs3qBVLa1F
         O9fA==
X-Gm-Message-State: AFuF++kdetyncEVys7lkUPTBiN+ze1b4NOt42GkO2iX5uMF+eiTzX8O5
	t9+46pmsG5PzZIoEovutQFInsVfqvsFSo3nqutfvzvbpW2GNxgqGGYBi6Q22DtkEUthj
X-Gm-Gg: AR+sD121CMlniLrroibH5FhZBHeItOGE69AQwdGPRux46fIVjQ3NB+pGBxC9FyGjm8w
	b9na0wE1qkqRkHApB+/7w4pQJzbmqWW2kG6ZCgjbrjzCaoxC0yOsAHm6zM7MIGHRHJ5hMZ8w0Ga
	jgr0OdgcT3MUyW3Krm0Ig7hFkcbrbZHoY+gDCgzPzs3sdLbHKj/i5jY6ixon6TSz7MpBTB1Xtzb
	YTkbjg/ytW43NO0Nn6M3rF1xtfeih///HYV9vjGiB5zwgF/cDY/HKcHr0VfYjldlpNyZsYmXFao
	LgmntsyR78W7pIIMBjLtDBDWVza2NOT9g/HNk9nTx7Z361qGLpahouauMA5gyO7KETfQZ741sdT
	JYGesd6AXKhq5p4lg52GOKjyVHtpY7GYXKKKUJi/7tMGnijfbXt1B+nbYJF4gfbVmDvflfaDTB4
	yqgK4z5SCYhfqpuWah/RtoA7UuO7iFdBkwj6ZZJwNu3jx8ndzLExldxHbYOTs7QaTfLB5Daxsyy
	MNfaJc5yh/0IcU=
X-Received: by 2002:a05:6a00:b42:b0:848:62ab:7b7 with SMTP id d2e1a72fcca58-8520be923e7mr20008268b3a.16.1787501236345;
        Sun, 23 Aug 2026 09:07:16 -0700 (PDT)
Received: from gmail.com ([115.199.218.100])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8520f14a418sm1211724b3a.47.2026.08.23.09.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 09:07:15 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Pavel Shilovsky <pshilovsky@samba.org>,
	Aurelien Aptel <aaptel@suse.com>,
	stable@vger.kernel.org,
	Vega <vega@nebusec.ai>
Subject: [PATCH v2 1/2] smb: client: fix create context out-of-bounds reads
Date: Sun, 23 Aug 2026 16:06:28 +0000
Message-ID: <20260823160638.12198-1-zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1787486936.git.zihanx@nebusec.ai>
References: <cover.1787486936.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_parse_contexts() validates the complete create-context area but does
not bound each context record by its Next field before dispatching to a
handler.  A malformed chain can therefore expose bytes past one context to
the handler.  The QFid handler also used a full response-structure cast even
though it only consumes DiskFileId.

Bound each context by Next and reject malformed chains.  Read the QFid
DiskFileId only when the context data covers that field, and do not call the
lease parser unless the record contains every field it reads, including
LeaseFlags.

Fixes: b8c32dbb0deb ("CIFS: Request SMB2.1 leases")
Fixes: 89a5bfa350fa ("smb3: optimize open to not send query file internal info")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v2:
  - Bound each response context by Next and reject malformed chains.
  - Read QFid DiskFileId only when DataLength covers the payload.
  - Extend the SMB2 lease minimum through the LeaseFlags field.
  - Correct Fixes history for the pre-existing Next/lease path and the later QFid path.
  - v1 Link: https://lore.kernel.org/all/eb1bc35611f91bd10a4772400b37fac26f660956.1782579150.git.xizh2024@lzu.edu.cn/
---
 fs/smb/client/smb2pdu.c | 38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 4ce165e40657..95d862a1241b 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2375,14 +2375,29 @@ create_reconnect_durable_buf(struct cifs_fid *fid)
 	return buf;
 }
 
+static size_t smb2_create_lease_min_cc_len(struct TCP_Server_Info *server)
+{
+	if (server->vals->create_lease_size == sizeof(struct create_lease_v2))
+		return offsetof(struct create_lease_v2, lcontext.Epoch) +
+			sizeof(__le16);
+	return offsetof(struct create_lease, lcontext.LeaseFlags) +
+		sizeof(__le32);
+}
+
 static void
 parse_query_id_ctxt(struct create_context *cc, struct smb2_file_all_info *buf)
 {
-	struct create_disk_id_rsp *pdisk_id = (struct create_disk_id_rsp *)cc;
+	u16 doff = le16_to_cpu(cc->DataOffset);
+	u32 dlen = le32_to_cpu(cc->DataLength);
+	u8 *beg;
+
+	if (dlen < sizeof(__le64))
+		return;
 
-	cifs_dbg(FYI, "parse query id context 0x%llx 0x%llx\n",
-		pdisk_id->DiskFileId, pdisk_id->VolumeId);
-	buf->IndexNumber = pdisk_id->DiskFileId;
+	beg = (u8 *)cc + doff;
+	memcpy(&buf->IndexNumber, beg, sizeof(__le64));
+	cifs_dbg(FYI, "parse query id context 0x%llx\n",
+		 le64_to_cpu(buf->IndexNumber));
 }
 
 static void
@@ -2430,6 +2445,7 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 	struct smb2_create_rsp *rsp = rsp_iov->iov_base;
 	struct create_context *cc;
 	size_t rem, off, len;
+	size_t cc_len;
 	size_t doff, dlen;
 	size_t noff, nlen;
 	char *name;
@@ -2452,9 +2468,18 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 		buf->IndexNumber = 0;
 
 	while (rem >= sizeof(*cc)) {
+		off = le32_to_cpu(cc->Next);
+		if (off) {
+			if ((off & 0x7) || off > rem || off < sizeof(*cc))
+				return -EINVAL;
+			cc_len = off;
+		} else {
+			cc_len = rem;
+		}
+
 		doff = le16_to_cpu(cc->DataOffset);
 		dlen = le32_to_cpu(cc->DataLength);
-		if (check_add_overflow(doff, dlen, &len) || len > rem)
+		if (check_add_overflow(doff, dlen, &len) || len > cc_len)
 			return -EINVAL;
 
 		noff = le16_to_cpu(cc->NameOffset);
@@ -2466,7 +2491,8 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 		switch (nlen) {
 		case 4:
 			if (!strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4)) {
-				*oplock = server->ops->parse_lease_buf(cc, epoch,
+				if (cc_len >= smb2_create_lease_min_cc_len(server))
+					*oplock = server->ops->parse_lease_buf(cc, epoch,
 								       lease_key);
 			} else if (buf &&
 				   !strncmp(name, SMB2_CREATE_QUERY_ON_DISK_ID, 4)) {
