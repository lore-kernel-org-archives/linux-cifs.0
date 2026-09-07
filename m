Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AE64E66BF;
	Mon,  7 Sep 2026 15:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788793273; cv=none; b=VXQMGvg4galxaLJSvKwmcjmWEQXPuQZgPPZHV8SW1MJ0sQggkx3KYKFWsVwxMIO0TgLDTgQ6GnOXx6BjYuX7MTVBDpnaCUW0z+1itlJXTyA8A5qKKskBKg1/SmcU2tRTE+AJgIpjjl1VgdzLGQBeYHW5rUDqRFBSQyJ7QRcSVRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788793273; c=relaxed/simple;
	bh=4GDFYp04LzWFrG6vP54z3ljimzzAQ4XkhLJdKOeg6P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkWj/EaHgY5sF7tnBCJAlLRnMI1NamytoE6eFFA9mFb6yGDRkR81FUHo31mruIZTDo/3sNLLr6Nv4CIXAXZQ73wOXG6gQ24bXB3u0JWZ6VYmFaEWaNg5X2FA6syt91/K9jmupHk875HNYKWc4/TVyJOt0FtSWd1xR2K6ulec/00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7FpGcCw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7FpGcCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0811F00ACA;
	Mon,  7 Sep 2026 15:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788793266;
	bh=LgAu6qnFg5tVRgHSSEKAIkTxZMnZF43I7rK8qHGnsho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P7FpGcCwQuDGeVwe6ROytHFF6W8t10Ci6Kegir/OQxkXg19gwDk8Ml4txoo/X3bXT
	 vUax3n4YS5APMofMcaC6oZHOmulWld0Y6K+YogddQ67GbP9GGN0fUrXPI76o362Yzw
	 LORrQEMsliileEsL6aN8+Bc+nBRWpSa+plPZJ6xGOoVc3DJN5tKD/tu7glEs2JTwN6
	 BFnUwCJsp3oPsZxQg8js8s1vsSG7ln/ynQBNBGmLqsbxqxceEKqXS7i7Seo1Bfif20
	 sMKqCo3tackdbiBns3L7JCDjojNUzuKHTA0w9u46RFb+z0K1rM6RssNchxkDJL80iR
	 FTUcqTimepWlA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12.y 5/6] cifs: SMB1 split: Create smb1proto.h for SMB1 declarations
Date: Mon,  7 Sep 2026 11:00:58 -0400
Message-ID: <20260907150059.3712249-5-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907150059.3712249-1-sashal@kernel.org>
References: <2026090303-ashamed-silver-ed5c@gregkh>
 <20260907150059.3712249-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 86c666506ea2c42649879eeac7f29e7bedef2f23 ]

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Acked-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>

For the stable backport, also move the existing TRANS2 receive helpers to
smb1transport.c.  This mirrors the later upstream code motion needed for the
fix being unblocked while retaining the stable implementation unchanged.

Stable-dep-of: 730d0bb19507 ("smb: client: fix UAF and buffer leak in cifs_check_trans2() for malformed secondary T2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/Makefile        |   2 +-
 fs/smb/client/cifsglob.h      |   2 -
 fs/smb/client/cifsproto.h     |  11 +-
 fs/smb/client/smb1ops.c       | 171 -------------------------------
 fs/smb/client/smb1proto.h     |  40 ++++++++
 fs/smb/client/smb1transport.c | 185 ++++++++++++++++++++++++++++++++++
 6 files changed, 227 insertions(+), 184 deletions(-)
 create mode 100644 fs/smb/client/smb1proto.h
 create mode 100644 fs/smb/client/smb1transport.c

diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
index 22023e30915b9..2a84c49679d51 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -32,6 +32,6 @@ cifs-$(CONFIG_CIFS_SMB_DIRECT) += smbdirect.o
 
 cifs-$(CONFIG_CIFS_ROOT) += cifsroot.o
 
-cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += smb1ops.o cifssmb.o
+cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += smb1ops.o smb1transport.o cifssmb.o
 
 cifs-$(CONFIG_CIFS_COMPRESSION) += compress.o compress/lz77.o
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 13b01a90c2ea4..914238a259890 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2061,8 +2061,6 @@ extern mempool_t cifs_io_subrequest_pool;
 
 /* Operations for different SMB versions */
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-extern struct smb_version_operations smb1_operations;
-extern struct smb_version_values smb1_values;
 extern struct smb_version_operations smb20_operations;
 extern struct smb_version_values smb20_values;
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 1f71a0977469f..2d7eef770d0c2 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dfs_cache.h"
 #endif
+#include "smb1proto.h"
 
 struct statfs;
 struct smb_rqst;
@@ -419,16 +420,6 @@ extern int CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
 			      struct cifsFileInfo *cfile, __u64 size,
 			      bool set_allocation);
 
-struct cifs_unix_set_info_args {
-	__u64	ctime;
-	__u64	atime;
-	__u64	mtime;
-	__u64	mode;
-	kuid_t	uid;
-	kgid_t	gid;
-	dev_t	device;
-};
-
 extern int CIFSSMBUnixSetFileInfo(const unsigned int xid,
 				  struct cifs_tcon *tcon,
 				  const struct cifs_unix_set_info_args *args,
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index ee8c3c54a4634..d570c945f1877 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -234,146 +234,6 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
 	return mid;
 }
 
-/*
-	return codes:
-		0	not a transact2, or all data present
-		>0	transact2 with that much data missing
-		-EINVAL	invalid transact2
- */
-static int
-check2ndT2(char *buf)
-{
-	struct smb_hdr *pSMB = (struct smb_hdr *)buf;
-	struct smb_t2_rsp *pSMBt;
-	int remaining;
-	__u16 total_data_size, data_in_this_rsp;
-
-	if (pSMB->Command != SMB_COM_TRANSACTION2)
-		return 0;
-
-	/* check for plausible wct, bcc and t2 data and parm sizes */
-	/* check for parm and data offset going beyond end of smb */
-	if (pSMB->WordCount != 10) { /* coalesce_t2 depends on this */
-		cifs_dbg(FYI, "Invalid transact2 word count\n");
-		return -EINVAL;
-	}
-
-	pSMBt = (struct smb_t2_rsp *)pSMB;
-
-	total_data_size = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
-	data_in_this_rsp = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
-
-	if (total_data_size == data_in_this_rsp)
-		return 0;
-	else if (total_data_size < data_in_this_rsp) {
-		cifs_dbg(FYI, "total data %d smaller than data in frame %d\n",
-			 total_data_size, data_in_this_rsp);
-		return -EINVAL;
-	}
-
-	remaining = total_data_size - data_in_this_rsp;
-
-	cifs_dbg(FYI, "missing %d bytes from transact2, check next response\n",
-		 remaining);
-	if (total_data_size > CIFSMaxBufSize) {
-		cifs_dbg(VFS, "TotalDataSize %d is over maximum buffer %d\n",
-			 total_data_size, CIFSMaxBufSize);
-		return -EINVAL;
-	}
-	return remaining;
-}
-
-static int
-coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
-{
-	struct smb_t2_rsp *pSMBs = (struct smb_t2_rsp *)second_buf;
-	struct smb_t2_rsp *pSMBt  = (struct smb_t2_rsp *)target_hdr;
-	char *data_area_of_tgt;
-	char *data_area_of_src;
-	int remaining;
-	unsigned int byte_count, total_in_tgt;
-	__u16 tgt_total_cnt, src_total_cnt, total_in_src;
-
-	src_total_cnt = get_unaligned_le16(&pSMBs->t2_rsp.TotalDataCount);
-	tgt_total_cnt = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
-
-	if (tgt_total_cnt != src_total_cnt)
-		cifs_dbg(FYI, "total data count of primary and secondary t2 differ source=%hu target=%hu\n",
-			 src_total_cnt, tgt_total_cnt);
-
-	total_in_tgt = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
-
-	remaining = tgt_total_cnt - total_in_tgt;
-
-	if (remaining < 0) {
-		cifs_dbg(FYI, "Server sent too much data. tgt_total_cnt=%hu total_in_tgt=%u\n",
-			 tgt_total_cnt, total_in_tgt);
-		return -EPROTO;
-	}
-
-	if (remaining == 0) {
-		/* nothing to do, ignore */
-		cifs_dbg(FYI, "no more data remains\n");
-		return 0;
-	}
-
-	total_in_src = get_unaligned_le16(&pSMBs->t2_rsp.DataCount);
-	if (remaining < total_in_src)
-		cifs_dbg(FYI, "transact2 2nd response contains too much data\n");
-
-	/* find end of first SMB data area */
-	data_area_of_tgt = (char *)&pSMBt->hdr.Protocol +
-				get_unaligned_le16(&pSMBt->t2_rsp.DataOffset);
-
-	/* validate target area */
-	data_area_of_src = (char *)&pSMBs->hdr.Protocol +
-				get_unaligned_le16(&pSMBs->t2_rsp.DataOffset);
-
-	data_area_of_tgt += total_in_tgt;
-
-	total_in_tgt += total_in_src;
-	/* is the result too big for the field? */
-	if (total_in_tgt > USHRT_MAX) {
-		cifs_dbg(FYI, "coalesced DataCount too large (%u)\n",
-			 total_in_tgt);
-		return -EPROTO;
-	}
-	put_unaligned_le16(total_in_tgt, &pSMBt->t2_rsp.DataCount);
-
-	/* fix up the BCC */
-	byte_count = get_bcc(target_hdr);
-	byte_count += total_in_src;
-	/* is the result too big for the field? */
-	if (byte_count > USHRT_MAX) {
-		cifs_dbg(FYI, "coalesced BCC too large (%u)\n", byte_count);
-		return -EPROTO;
-	}
-	put_bcc(byte_count, target_hdr);
-
-	byte_count = be32_to_cpu(target_hdr->smb_buf_length);
-	byte_count += total_in_src;
-	/* don't allow buffer to overflow */
-	if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
-		cifs_dbg(FYI, "coalesced BCC exceeds buffer size (%u)\n",
-			 byte_count);
-		return -ENOBUFS;
-	}
-	target_hdr->smb_buf_length = cpu_to_be32(byte_count);
-
-	/* copy second buffer into end of first buffer */
-	memcpy(data_area_of_tgt, data_area_of_src, total_in_src);
-
-	if (remaining != total_in_src) {
-		/* more responses to go */
-		cifs_dbg(FYI, "waiting for more secondary responses\n");
-		return 1;
-	}
-
-	/* we are done */
-	cifs_dbg(FYI, "found the last secondary response\n");
-	return 0;
-}
-
 static void
 cifs_downgrade_oplock(struct TCP_Server_Info *server,
 		      struct cifsInodeInfo *cinode, __u32 oplock,
@@ -382,37 +242,6 @@ cifs_downgrade_oplock(struct TCP_Server_Info *server,
 	cifs_set_oplock_level(cinode, oplock);
 }
 
-static bool
-cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
-		  char *buf, int malformed)
-{
-	if (malformed)
-		return false;
-	if (check2ndT2(buf) <= 0)
-		return false;
-	mid->multiRsp = true;
-	if (mid->resp_buf) {
-		/* merge response - fix up 1st*/
-		malformed = coalesce_t2(buf, mid->resp_buf);
-		if (malformed > 0)
-			return true;
-		/* All parts received or packet is malformed. */
-		mid->multiEnd = true;
-		dequeue_mid(server, mid, malformed);
-		return true;
-	}
-	if (!server->large_buf) {
-		/*FIXME: switch to already allocated largebuf?*/
-		cifs_dbg(VFS, "1st trans2 resp needs bigbuf\n");
-	} else {
-		/* Have first buffer */
-		mid->resp_buf = buf;
-		mid->large_buf = true;
-		server->bigbuf = NULL;
-	}
-	return true;
-}
-
 static bool
 cifs_need_neg(struct TCP_Server_Info *server)
 {
diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
new file mode 100644
index 0000000000000..8dfc6976ceba1
--- /dev/null
+++ b/fs/smb/client/smb1proto.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ *
+ *   Copyright (c) International Business Machines  Corp., 2002,2008
+ *   Author(s): Steve French (sfrench@us.ibm.com)
+ *
+ */
+#ifndef _SMB1PROTO_H
+#define _SMB1PROTO_H
+
+struct cifs_unix_set_info_args {
+	__u64	ctime;
+	__u64	atime;
+	__u64	mtime;
+	__u64	mode;
+	kuid_t	uid;
+	kgid_t	gid;
+	dev_t	device;
+};
+
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
+
+/*
+ * cifssmb.c
+ */
+
+/*
+ * smb1ops.c
+ */
+extern struct smb_version_operations smb1_operations;
+extern struct smb_version_values smb1_values;
+
+/*
+ * smb1transport.c
+ */
+bool cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+		       char *buf, int malformed);
+
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
+#endif /* _SMB1PROTO_H */
diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
new file mode 100644
index 0000000000000..8e66a2d21f406
--- /dev/null
+++ b/fs/smb/client/smb1transport.c
@@ -0,0 +1,185 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * SMB1 transport operations
+ *
+ * Copyright (c) 2012, Jeff Layton <jlayton@redhat.com>
+ */
+
+#include <linux/pagemap.h>
+#include <linux/vfs.h>
+#include <uapi/linux/magic.h>
+#include "cifsglob.h"
+#include "cifsproto.h"
+#include "cifs_debug.h"
+#include "cifspdu.h"
+
+/*
+	return codes:
+		0	not a transact2, or all data present
+		>0	transact2 with that much data missing
+		-EINVAL	invalid transact2
+ */
+static int
+check2ndT2(char *buf)
+{
+	struct smb_hdr *pSMB = (struct smb_hdr *)buf;
+	struct smb_t2_rsp *pSMBt;
+	int remaining;
+	__u16 total_data_size, data_in_this_rsp;
+
+	if (pSMB->Command != SMB_COM_TRANSACTION2)
+		return 0;
+
+	/* check for plausible wct, bcc and t2 data and parm sizes */
+	/* check for parm and data offset going beyond end of smb */
+	if (pSMB->WordCount != 10) { /* coalesce_t2 depends on this */
+		cifs_dbg(FYI, "Invalid transact2 word count\n");
+		return -EINVAL;
+	}
+
+	pSMBt = (struct smb_t2_rsp *)pSMB;
+
+	total_data_size = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
+	data_in_this_rsp = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
+
+	if (total_data_size == data_in_this_rsp)
+		return 0;
+	else if (total_data_size < data_in_this_rsp) {
+		cifs_dbg(FYI, "total data %d smaller than data in frame %d\n",
+			 total_data_size, data_in_this_rsp);
+		return -EINVAL;
+	}
+
+	remaining = total_data_size - data_in_this_rsp;
+
+	cifs_dbg(FYI, "missing %d bytes from transact2, check next response\n",
+		 remaining);
+	if (total_data_size > CIFSMaxBufSize) {
+		cifs_dbg(VFS, "TotalDataSize %d is over maximum buffer %d\n",
+			 total_data_size, CIFSMaxBufSize);
+		return -EINVAL;
+	}
+	return remaining;
+}
+
+static int
+coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
+{
+	struct smb_t2_rsp *pSMBs = (struct smb_t2_rsp *)second_buf;
+	struct smb_t2_rsp *pSMBt  = (struct smb_t2_rsp *)target_hdr;
+	char *data_area_of_tgt;
+	char *data_area_of_src;
+	int remaining;
+	unsigned int byte_count, total_in_tgt;
+	__u16 tgt_total_cnt, src_total_cnt, total_in_src;
+
+	src_total_cnt = get_unaligned_le16(&pSMBs->t2_rsp.TotalDataCount);
+	tgt_total_cnt = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
+
+	if (tgt_total_cnt != src_total_cnt)
+		cifs_dbg(FYI, "total data count of primary and secondary t2 differ source=%hu target=%hu\n",
+			 src_total_cnt, tgt_total_cnt);
+
+	total_in_tgt = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
+
+	remaining = tgt_total_cnt - total_in_tgt;
+
+	if (remaining < 0) {
+		cifs_dbg(FYI, "Server sent too much data. tgt_total_cnt=%hu total_in_tgt=%u\n",
+			 tgt_total_cnt, total_in_tgt);
+		return -EPROTO;
+	}
+
+	if (remaining == 0) {
+		/* nothing to do, ignore */
+		cifs_dbg(FYI, "no more data remains\n");
+		return 0;
+	}
+
+	total_in_src = get_unaligned_le16(&pSMBs->t2_rsp.DataCount);
+	if (remaining < total_in_src)
+		cifs_dbg(FYI, "transact2 2nd response contains too much data\n");
+
+	/* find end of first SMB data area */
+	data_area_of_tgt = (char *)&pSMBt->hdr.Protocol +
+				get_unaligned_le16(&pSMBt->t2_rsp.DataOffset);
+
+	/* validate target area */
+	data_area_of_src = (char *)&pSMBs->hdr.Protocol +
+				get_unaligned_le16(&pSMBs->t2_rsp.DataOffset);
+
+	data_area_of_tgt += total_in_tgt;
+
+	total_in_tgt += total_in_src;
+	/* is the result too big for the field? */
+	if (total_in_tgt > USHRT_MAX) {
+		cifs_dbg(FYI, "coalesced DataCount too large (%u)\n",
+			 total_in_tgt);
+		return -EPROTO;
+	}
+	put_unaligned_le16(total_in_tgt, &pSMBt->t2_rsp.DataCount);
+
+	/* fix up the BCC */
+	byte_count = get_bcc(target_hdr);
+	byte_count += total_in_src;
+	/* is the result too big for the field? */
+	if (byte_count > USHRT_MAX) {
+		cifs_dbg(FYI, "coalesced BCC too large (%u)\n", byte_count);
+		return -EPROTO;
+	}
+	put_bcc(byte_count, target_hdr);
+
+	byte_count = be32_to_cpu(target_hdr->smb_buf_length);
+	byte_count += total_in_src;
+	/* don't allow buffer to overflow */
+	if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
+		cifs_dbg(FYI, "coalesced BCC exceeds buffer size (%u)\n",
+			 byte_count);
+		return -ENOBUFS;
+	}
+	target_hdr->smb_buf_length = cpu_to_be32(byte_count);
+
+	/* copy second buffer into end of first buffer */
+	memcpy(data_area_of_tgt, data_area_of_src, total_in_src);
+
+	if (remaining != total_in_src) {
+		/* more responses to go */
+		cifs_dbg(FYI, "waiting for more secondary responses\n");
+		return 1;
+	}
+
+	/* we are done */
+	cifs_dbg(FYI, "found the last secondary response\n");
+	return 0;
+}
+
+bool
+cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+		  char *buf, int malformed)
+{
+	if (malformed)
+		return false;
+	if (check2ndT2(buf) <= 0)
+		return false;
+	mid->multiRsp = true;
+	if (mid->resp_buf) {
+		/* merge response - fix up 1st*/
+		malformed = coalesce_t2(buf, mid->resp_buf);
+		if (malformed > 0)
+			return true;
+		/* All parts received or packet is malformed. */
+		mid->multiEnd = true;
+		dequeue_mid(server, mid, malformed);
+		return true;
+	}
+	if (!server->large_buf) {
+		/*FIXME: switch to already allocated largebuf?*/
+		cifs_dbg(VFS, "1st trans2 resp needs bigbuf\n");
+	} else {
+		/* Have first buffer */
+		mid->resp_buf = buf;
+		mid->large_buf = true;
+		server->bigbuf = NULL;
+	}
+	return true;
+}
-- 
2.53.0

