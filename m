Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E67A248F72
	for <linux-cifs@vger.kernel.org>; Thu, 11 Dec 2025 14:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765463641; cv=none; b=VMznZ+EtrggGo9A8TqEXybf4WnOwsqjsx35RtJvTxlAyhJkSZ9KKCzEbVTfJnyBK/PkclEwvRdlcsmjtpPd/lMlkl14FfCZcf84aEKgDuKZPZ3SP7nkgfUP65vMsnb6lfYN/28bYua29QoG3bP7L2OnKYTFGWuFP7IZ8mK+nr4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765463641; c=relaxed/simple;
	bh=XOuSJQyYqIGcE79QSyKPELFt53248Al3LYainA5CQN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bveGQ8E+oE03wBlNzi2oq6nz/uoVn9w+oYOUKlGGpYBlWPk6c/pGYNTjS/V/vsb8W/6WQ3w1xmf35DCG+qNLkIYNGQqP3xFsgRzS5ukULY2Yh+yBVRt4XbG4/029kcHY6GSBJdX2+yCB69NIe6Jj4EzQf0pHj8mSJJoN/SVvOz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gyANQZ01; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gyANQZ01"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765463637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DUaM8R4HFwegycxKHXiuzYrU6BKgkAd9rH4gJamrx1c=;
	b=gyANQZ01mdloBvm4+xZ23HtflZEwH2nSuFk+Ol4724gZxjCYGRBIjT6LZwdGMb4d0Rf7WR
	VauqunKilWXURE2l2LbiaDeSM040YjG63CS3beoPEeXgrRwrNS4wwpBagIQ4kKB0JIIFXS
	tTRmAOupx8gnXA+K4c+R9c7s/xFk5+0=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 6/7] smb: introduce struct create_posix_ctxt_rsp
Date: Thu, 11 Dec 2025 22:32:27 +0800
Message-ID: <20251211143228.172470-7-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251211143228.172470-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251211143228.172470-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Modify the following places:

  - introduce new struct create_posix_ctxt_rsp
  - some fields in "struct create_posix_rsp" -> "struct create_posix_ctxt_rsp"
  - create_posix_rsp_buf(): offsetof(..., nlink) -> offsetof(..., ctxt_rsp)

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/client/smb2pdu.c |  9 +++++----
 fs/smb/client/smb2pdu.h |  6 ++----
 fs/smb/common/smb2pdu.h | 17 +++++++++++++++++
 fs/smb/server/oplock.c  |  8 ++++----
 fs/smb/server/smb2pdu.h |  6 ++----
 5 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5d57c895ca37..b532eb2026ae 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2362,9 +2362,9 @@ parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info,
 
 	memset(posix, 0, sizeof(*posix));
 
-	posix->nlink = le32_to_cpu(*(__le32 *)(beg + 0));
-	posix->reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
-	posix->mode = le32_to_cpu(*(__le32 *)(beg + 8));
+	posix->ctxt_rsp.nlink = le32_to_cpu(*(__le32 *)(beg + 0));
+	posix->ctxt_rsp.reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
+	posix->ctxt_rsp.mode = le32_to_cpu(*(__le32 *)(beg + 8));
 
 	sid = beg + 12;
 	sid_len = posix_info_sid_size(sid, end);
@@ -2383,7 +2383,8 @@ parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info,
 	memcpy(&posix->group, sid, sid_len);
 
 	cifs_dbg(FYI, "nlink=%d mode=%o reparse_tag=%x\n",
-		 posix->nlink, posix->mode, posix->reparse_tag);
+		 posix->ctxt_rsp.nlink, posix->ctxt_rsp.mode,
+		 posix->ctxt_rsp.reparse_tag);
 }
 
 int smb2_parse_contexts(struct TCP_Server_Info *server,
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 78bb99f29d38..4928fb620233 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -251,11 +251,9 @@ struct smb2_file_id_extd_directory_info {
 
 extern char smb2_padding[7];
 
-/* equivalent of the contents of SMB3.1.1 POSIX open context response */
+/* See POSIX-SMB2 2.2.14.2.16 */
 struct create_posix_rsp {
-	u32 nlink;
-	u32 reparse_tag;
-	u32 mode;
+	struct create_posix_ctxt_rsp ctxt_rsp;
 	struct smb_sid owner; /* var-sized on the wire */
 	struct smb_sid group; /* var-sized on the wire */
 } __packed;
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 9a0685902233..c46b15e9a2d5 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1771,4 +1771,21 @@ struct smb2_lease_ack {
 #define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
 				| READ_CONTROL | SYNCHRONIZE)
 
+/*
+ * [POSIX-SMB2] SMB3 POSIX Extensions
+ * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/smb3_posix_extensions.md
+ */
+
+/*
+ * SMB2_CREATE_POSIX_CONTEXT Response
+ * See POSIX-SMB2 2.2.14.2.16
+ */
+struct create_posix_ctxt_rsp {
+	__le32 nlink;
+	__le32 reparse_tag;
+	__le32 mode;
+	// var sized owner SID
+	// var sized group SID
+} __packed;
+
 #endif				/* _COMMON_SMB2PDU_H */
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 1f07ebf431d7..8658402ff893 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1703,7 +1703,7 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
 	buf = (struct create_posix_rsp *)cc;
 	memset(buf, 0, sizeof(struct create_posix_rsp));
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof
-			(struct create_posix_rsp, nlink));
+			(struct create_posix_rsp, ctxt_rsp));
 	/*
 	 * DataLength = nlink(4) + reparse_tag(4) + mode(4) +
 	 * domain sid(28) + unix group sid(16).
@@ -1730,9 +1730,9 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
 	buf->Name[14] = 0xCD;
 	buf->Name[15] = 0x7C;
 
-	buf->nlink = cpu_to_le32(inode->i_nlink);
-	buf->reparse_tag = cpu_to_le32(fp->volatile_id);
-	buf->mode = cpu_to_le32(inode->i_mode & 0777);
+	buf->ctxt_rsp.nlink = cpu_to_le32(inode->i_nlink);
+	buf->ctxt_rsp.reparse_tag = cpu_to_le32(fp->volatile_id);
+	buf->ctxt_rsp.mode = cpu_to_le32(inode->i_mode & 0777);
 	/*
 	 * SidBuffer(44) contain two sids(Domain sid(28), UNIX group sid(16)).
 	 * Domain sid(28) = revision(1) + num_subauth(1) + authority(6) +
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 66cdc8e4a648..09311a9eb1de 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -83,13 +83,11 @@ struct create_durable_rsp {
 	} Data;
 } __packed;
 
-/* equivalent of the contents of SMB3.1.1 POSIX open context response */
+/* See POSIX-SMB2 2.2.14.2.16 */
 struct create_posix_rsp {
 	struct create_context_hdr ccontext;
 	__u8    Name[16];
-	__le32 nlink;
-	__le32 reparse_tag;
-	__le32 mode;
+	struct create_posix_ctxt_rsp ctxt_rsp;
 	/* SidBuffer contain two sids(Domain sid(28), UNIX group sid(16)) */
 	u8 SidBuffer[44];
 } __packed;
-- 
2.43.0

