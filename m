Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415A434DB41
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 06:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790405424; cv=none; b=SlcStIsdbqReO/Dy4NtbjNGIB1VD/ZJPx17X/kuQ4/Klx/Vfiksy4HxbgksDaQoE4WMZudJ3AkingSIOKNO4Mq2mI6GmIfVudn7e3kj+bR21qv3J9aMPl9npKaFKsUiEfHN0Wirl70F6KGILvx1LWoYWteNeQruE5Id9F6AmK7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790405424; c=relaxed/simple;
	bh=e+Ut2QFN7CI3vbeEn82zMl57Xjd0B2AHAqke8Cvb+i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYETj/AP7vGy1KlbbE6QB5T+IDyt7eLVLIAwZgU/k4hYlnkAF7lsqH8EHIvgr7SzVu0ROaBUsVDOv0KS08a+udHqBlENfsxR3OKXNG3NUK9wVnKvupg+2JtmmucRpjN1o8ByX4i5t2sFj5he8MGUhx4Z2l+k34BGfme15zETTW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=fABC+22k; arc=none smtp.client-ip=74.125.227.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="fABC+22k"
Received: by mail-pj2-f40.google.com with SMTP id 98e67ed59e1d1-3a0df0bb2d6so189783a91.3
        for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2026 23:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790405422; x=1791010222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OSTQl7TWfO/HBakXURDp6p7BA/fXMZ8rsqfWWwwFT8M=;
        b=fABC+22k9AnXokgT5PO+rqln/2f6yH/LaqEm3h464Kr+CVkAgEKmr+dtV754XCIdFJ
         gS/boBd30josbZsaM4VxP/sVQOb6e58fXS7Bj72DWrRwiGrTlyp0t6CDEfp7wQ4yEG0h
         mv7AwdOZoCdRbRvMJXRxb5jIkSoangh62wJitp8cFRp0SXIsKKuw1gRmtLUMk7xJMwO/
         LVmavxAgUHOQq1Py12b95nkGbTX610DRXn7fm1C3h5IrVULj0CSzOWo92G9U/5DeysX4
         ajft3VI4BpyvkzTezCmr84Cm4SXcLRQMT6yH1yqTI5iJBqkLk5kYrwwF4SfZV5CBgn93
         A97w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790405422; x=1791010222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OSTQl7TWfO/HBakXURDp6p7BA/fXMZ8rsqfWWwwFT8M=;
        b=Vv3yo//pBmLWo4ZxXQovJ7VRgFf3wRHVBqR+y7a+otybivr8TYMQKU399bGfWdSDBj
         uFRlRH8u1KEXq8QoM37agCFWnIlt+ZZ9vgNHfcYkM4lOSPmoOUXQ6UNdCc6WC1lDCjEn
         Ei2pYPsm+ybBW2GPlIveBMa6EswGvSuMZhes3BCVBNudaMaGcH74D0ypsGbG6dMOLwY/
         iGV9RYOeSZA668ywUqaPqtUpJLhE6N04Ay+7G6pHAAAx9jd/cpniQWk+Ib4AZTonIOjm
         V54DnFdSm6UpOvtM6sNcXw53jfjpDzhpTxtFI8y6z1CxZ0sT+A/Bvda3xCxMOuIvnZa7
         Qlug==
X-Forwarded-Encrypted: i=1; AKwUvBzqbP12akNgvdRNA1Y4oiP+/usuC/yGIE+m1SO//SkIhFZukUCSv57uHP4OQtnT95Zd2Ubv1H1Y+rkM@vger.kernel.org
X-Gm-Message-State: AFuF++kBb2Cr8K8LHjx7AJIrTqQ+vvaSWfkgqHeJXGOFWdWZLinJJ9Lu
	o3w9IQre+Vb8cqSdg5kLYjuaYL/xJ2DYOp5uk2KXiisIru1seO24GiJGByYjJc7612ze
X-Gm-Gg: AYBFou3ruFYV1eBX5nVfzE2lV58rgZdrTCItzRRAD64zg8boLNr3IFpfAp7ivV71D06
	hekJ4iS58cZfqKeR8iABvfsNTX+F1ubmHcDgdhwJ7B8AQG29sywA4JE9gwFDhJxV3vYI5H7K7Jb
	Th7KPr1sxaNMXiSScj/s2bbuSrpVwq1rPZOQxTZPvbBdfLOtI806jKVL/QV31eK6oSsY3S32Ick
	Y4xWHoFa4v4CFJeJZG0fX4fJIucj8+yiFSjmcY9fHIKREMQIZr9vD+1Uy4LlVEbv7gE/yhWU3+H
	iiY96KvrFcBJyXfe0gjJDtGENJOJ44uPMdemK3Uyw8jtWqExCxbHTTHUntlMjDkBEQqwGTuedy6
	OI+eHsk1JcPzXt1FDk/e8a6Apmeauj5Wq7PHPJXpfZ+RnndHekYjYQjLuXlD/Wo7gV1xR2dF9vV
	uyuhf3XbrC/iCxwHneqd//mQp0OvPN9dZvkl5n1JBsJdrEPTCNlPpBTLq0e7QVgaV4roIhmECuc
	lx1pb8CaTgylONntWILzm6lYjTnaA==
X-Received: by 2002:a17:90b:44:b0:3a0:cc33:2285 with SMTP id 98e67ed59e1d1-3a0cc3324bcmr2093889a91.22.1790405422398;
        Fri, 25 Sep 2026 23:50:22 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b498fb12sm3447327a91.0.2026.09.25.23.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 23:50:21 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: sfrench@samba.org
Cc: zihanx@nebusec.ai,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	pshilovsky@samba.org,
	aaptel@suse.com,
	pali@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v5 1/6] smb: client: fix create context out-of-bounds reads
Date: Sat, 26 Sep 2026 06:49:21 +0000
Message-ID: <3e9396339a0bc331aa8d7dcd319a750b827a67f8.1790398755.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1790398755.git.zihanx@nebusec.ai>
References: <cover.1790398755.git.zihanx@nebusec.ai>
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
changes in v5:
  - Rerolled the series after fixing a NULL dereference reported by the
    kernel test robot Smatch analysis in patch 5:
    https://lore.kernel.org/r/202609241449.HlHmnZFZ-lkp@intel.com/
  - v4 Link: https://lore.kernel.org/all/cover.1789478666.git.zihanx@nebusec.ai/
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

