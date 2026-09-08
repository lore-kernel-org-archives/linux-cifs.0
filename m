Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F12530E12;
	Tue,  8 Sep 2026 12:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870009; cv=none; b=NbR837ls2jgnbClMQAVHlb8S4tYV9o+xkxxV8vKWsGgkL5M3Cj/fzJ02sq9nSIG5cYYok0dklTlc5O2QEtbsDKfBDHyu2eRULFeCIDuJQN921fnQXiepaE+htQ3c00grCimO8IAaRNDVXLhYJDfsOhTkbEZasPft2zebU8gkj1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870009; c=relaxed/simple;
	bh=rUz60QY6hEOa/UBHY++U20fAHfIj+fGeLbWwulTLC/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOA0aW8gMtjS47MlgvWZ1FaZbQhNgkOXzXY0UgZ3CCx+zcxl82gDVbilKGDl+xGyyAhRXT12JJpMniZbecheoijIeUAhatQxnwHNVf/nDeqIbzE1oR4WKRYIgXHUw6CX8M3SqEoQyEde42vPEoZaXUxTzVdCkZueYD23rrFEXF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCED1F00ADB;
	Tue,  8 Sep 2026 12:20:02 +0000 (UTC)
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
Subject: [PATCH 5.10.y 2/3] cifs: SMB1 split: Create smb1proto.h for SMB1 declarations
Date: Tue,  8 Sep 2026 08:19:59 -0400
Message-ID: <20260908122000.2049341-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260908122000.2049341-1-sashal@kernel.org>
References: <2026090305-henchman-snipping-25aa@gregkh>
 <20260908122000.2049341-1-sashal@kernel.org>
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

[ sashal: Reduced backport -- upstream 86c666506ea2c touches 3 file(s), this
  backport carries 8. Not backported here:
  fs/smb/client/cifsglob.h
  fs/smb/client/cifsproto.h
  fs/smb/client/smb1proto.h
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 730d0bb19507 ("smb: client: fix UAF and buffer leak in cifs_check_trans2() for malformed secondary T2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/Makefile              |   2 +-
 fs/cifs/cifsglob.h            |   2 -
 fs/cifs/cifsproto.h           |  11 +--
 fs/cifs/fs_context.c          |   1 +
 fs/cifs/smb1ops.c             | 171 --------------------------------
 fs/cifs/smb1proto.h           |  40 ++++++++
 fs/cifs/smb1transport.c       |   3 +
 fs/smb/client/smb1transport.c | 180 ++++++++++++++++++++++++++++++++++
 8 files changed, 226 insertions(+), 184 deletions(-)
 create mode 100644 fs/cifs/smb1proto.h
 create mode 100644 fs/cifs/smb1transport.c
 create mode 100644 fs/smb/client/smb1transport.c

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index cd17d0e50f2a1..f992815ce5041 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_CIFS) += cifs.o
 cifs-y := trace.o cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o \
 	  inode.o link.o misc.o netmisc.o smbencrypt.o transport.o asn1.o \
 	  cifs_unicode.o nterr.o cifsencrypt.o \
-	  readdir.o ioctl.o sess.o export.o smb1ops.o winucase.o \
+	  readdir.o ioctl.o sess.o export.o smb1ops.o smb1transport.o winucase.o \
 	  smb2ops.o smb2maperror.o smb2transport.o \
 	  smb2misc.o smb2pdu.o smb2inode.o smb2file.o cifsacl.o fs_context.o
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d0905aa0b04cd..98c9b97480136 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1990,8 +1990,6 @@ extern mempool_t *cifs_mid_poolp;
 #define SMB1_VERSION_STRING	"1.0"
 #define SMB20_VERSION_STRING    "2.0"
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-extern struct smb_version_operations smb1_operations;
-extern struct smb_version_values smb1_values;
 extern struct smb_version_operations smb20_operations;
 extern struct smb_version_values smb20_values;
 #endif /* CIFS_ALLOW_INSECURE_LEGACY */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index f99cc6f0c5d9c..eacf4c78543cc 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -25,6 +25,7 @@
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dfs_cache.h"
 #endif
+#include "smb1proto.h"
 
 struct statfs;
 struct smb_vol;
@@ -373,16 +374,6 @@ extern int CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
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
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index ad6c2fed4055b..e6a4257f925e1 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -9,6 +9,7 @@
 #include "cifsglob.h"
 #include "cifs_debug.h"
 #include "fs_context.h"
+#include "smb1proto.h"
 
 static const match_table_t cifs_smb_version_tokens = {
 	{ Smb_1, SMB1_VERSION_STRING },
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index f4247e9536a9d..bbde5559d6751 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -227,146 +227,6 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
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
@@ -375,37 +235,6 @@ cifs_downgrade_oplock(struct TCP_Server_Info *server,
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
diff --git a/fs/cifs/smb1proto.h b/fs/cifs/smb1proto.h
new file mode 100644
index 0000000000000..6a8fa2931008b
--- /dev/null
+++ b/fs/cifs/smb1proto.h
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
+/*
+ * smb1transport.c
+ */
+bool cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+		       char *buf, int malformed);
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
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
+#endif /* _SMB1PROTO_H */
diff --git a/fs/cifs/smb1transport.c b/fs/cifs/smb1transport.c
new file mode 100644
index 0000000000000..41b62c429b845
--- /dev/null
+++ b/fs/cifs/smb1transport.c
@@ -0,0 +1,3 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "../smb/client/smb1transport.c"
diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
new file mode 100644
index 0000000000000..f2b19d7786f42
--- /dev/null
+++ b/fs/smb/client/smb1transport.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * SMB1 transport receive helpers
+ */
+
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

