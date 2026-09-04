Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4ABA4A498B
	for <linux-cifs@vger.kernel.org>; Fri,  4 Sep 2026 14:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530735; cv=none; b=p/rFeGTBl3ulYlSE5sEdNo+XLQWGuiiWHyq9ghhrt+xfEpzUkC3oQC/XLs2N8Psj9JQyGfNXrxFbwwb2CFldWkB1zASBY5hRaz33VikIMGLmSrPUhI656/mC3sWmavTdRZkA9Ko+ZKDsJy2xYrH8rLmFXIvt7w/AZLF9nhw6Ndk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530735; c=relaxed/simple;
	bh=+tEmWFfrfMdfpRXuM7sJq5Jr/CVlm0Na5b7RR7FV7cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCPmhGT+4/M89PJIOWJNGohCMjxpQ/OU1fz7EVtQ+NXYbm58kiTFaIGYTX31wds4NioyXTvJseB6fIZz1KPNOg68boUM1RBEyYYOygk1ejd41HHXGx1PkUSQD+RiDOm+1oIA/i8FSmn7uZD7Y0i5hH7yw9qvb9ciII4aXFCObvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=kQ8b+rBZ; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="kQ8b+rBZ"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc1c9879395so847116a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 04 Sep 2026 07:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788530733; x=1789135533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hgCC47razGo0X63UNJ31Wa6CvgVCTBYXfU0eNJWGEdg=;
        b=kQ8b+rBZWjVH7Jaagy1LAZqyHANFlhxxvdjAa84AZVSDhx79LuBjVF49/4veDcEkwo
         zuf4JRd5fmJgrN5nkJL3odYU4GYNcDZ1114ZljV/d6dIx5HDmw2vlwDz2BFaMoAAg0yh
         SKhXs3VAaqIBIHZY5YVY3lRwDsn+h3h+Ar89Syg7fEj+0TqOIyqCeS5zWGykVZ3wIkN2
         jr9HhOv5/6Mai9E8GhSb8LUcnd6BZ1lXk019z+9HKsV+sRv45DYTgxo0RtdyeWqkMtsa
         ostBRAbLVtgRLdbI7ao5zkLJgqkNdCEYy/qaCTdXAqPJNFfj2JXkNpdY9W+m6qgXqRUN
         QWgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788530733; x=1789135533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hgCC47razGo0X63UNJ31Wa6CvgVCTBYXfU0eNJWGEdg=;
        b=JLbYB+CxXtdBB++zKeayibV+CB26FLi+mntWE1RpuBWrSe25Ef5z+ajAFy9jStnNAP
         /hLg2rH//TvNaLh/m2YHpjjDrM2S8hPILTw0IDx3yWBEzjIqzdGQMAv+LlRt/Kl+pqVk
         znNTG00Zh6Xtc6FBm/lCSsSZNthwO0nAPqE40bDEyEPCLYOb32QcPg+pqoW6SPkJK676
         70y5o5XUJwZJHS4XWnQie0JvURNtY3sqBx2YBNIv2hzv3wNJEvenI6DbEIupl0i7IYHE
         ELMunczD9+gwgHKedxL5WZHfsxKfX2oWHX9NUmmyEHRrYRoU2X1xNfzatZjMIhwTAoy6
         2TOA==
X-Forwarded-Encrypted: i=1; AKwUvBzrqyniRB+CUnHHLqhepbdxatQ9l0YGosYmn1JeMqQVY+ZiFas1ZhtshcQg3rdp5X1dcWeu68Is2r++@vger.kernel.org
X-Gm-Message-State: AFuF++npxh+fr5/u61yoNy5iaJq6nJBKnucy57avHqDZBZ8clX6ghRaF
	11zLfCtuSVX0Lkg2vSQTxN7ynBxBMjeWkDrOz5ULVtKQyTVujuJpGlG5n9NjZGPiB/LC
X-Gm-Gg: AYBFou3ww8JGbcWrx+WydB2O12yGiTNTw61d5Mx9BzcJcPvBXZEU6R4iGLqaLaKWF9S
	zm6CNyAjU49R9MhDaPMfYJtTMCKBrEKlvYoB1HyaIypilgSag8AnQ1qGNpUEW7L2Z3sj2OIkRx1
	ulV5l9hxRhAKZJYS0PcUlyhmaikvXPJEBGWnzYrtYgPmq02BA7wKE7H0IHGBYHufm0P2lQoKuru
	2IMcCUDGDqxaM0ADb+m9eMUAaaGV960b8SR/mGpATLFg3jnWnt5/IwrocflRQmOcbzJCSBwIdTy
	PBFeZkKdcZC3Cpe9UPwKcEOx2IJfma0cjzTaA1j8JJZy9pWTLcnagzPyI6iG3vjmHNyWvMzMgOX
	tejCX062TIkjUJcJkx1Njw/L+Ku4RUIkm3UX9CGCBz2OKLdqrmfsJ3W/B1vtxXOG4OB/PxmhLN1
	oqQOVIqE4GyHiWAvFLjR81tElFiFEc5r7u80CZvDoHP5fwQRD3kFKWrXsGw+CK6KsuwhDFcdLb4
	ZyWPOBTeZ2XfWPTNUA=
X-Received: by 2002:a05:6a00:1405:b0:846:de21:3da4 with SMTP id d2e1a72fcca58-86168e8abc9mr7624230b3a.3.1788530731778;
        Fri, 04 Sep 2026 07:05:31 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86153e3ac30sm1165524b3a.56.2026.09.04.07.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 07:05:31 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Steve French <sfrench@samba.org>
Cc: Zihan Xi <zihanx@nebusec.ai>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Pavel Shilovsky <pshilovsky@samba.org>,
	Aurelien Aptel <aaptel@suse.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] smb: client: fix create context out-of-bounds reads
Date: Fri,  4 Sep 2026 14:05:17 +0000
Message-ID: <20260904140527.62354-1-zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1788516372.git.zihanx@nebusec.ai>
References: <cover.1788516372.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_parse_contexts() validates the complete create-context area but does
not bound each context record by its Next field before dispatching to a
handler.  A malformed chain can therefore expose bytes past one context
to the handler.  The QFid handler also used a full response-structure
cast even though it only consumes DiskFileId.

Bound each context by Next and reject malformed chains.  Read the QFid
DiskFileId only when the context data covers that field, and do not
call the lease parser unless the record contains every field it reads,
including LeaseFlags.

Fixes: b8c32dbb0deb ("CIFS: Request SMB2.1 leases")
Fixes: 89a5bfa350fa ("smb3: optimize open to not send query file internal info")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v3:
  - Resend after no response on v2; no functional code changes.
  - v2 Link: https://lore.kernel.org/all/cover.1787486936.git.zihanx@nebusec.ai/
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
index 4ce165e40657f..95d862a1241be 100644
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

-- 
2.43.0
