Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295643BB9ED
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780927369; cv=none; b=HERWo+cG4PFUH77ImefRbh9f/jLoLyhTpeJypXdhRi8C/Rv5xwMEDUzp0ymJIpcJKs5kme52S6i3DkEy9bQr2i/HFHQ/f+0aOTryJAUDA64ctb8iQq9HpuAJJfXJtwu+tj3lkXZ0eNHnjjTwv+3hTQChoeQGShOGGESbIdoILkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780927369; c=relaxed/simple;
	bh=funVBjnNwoXRCQ9DJYDw0qK8IcbCnb8nhNXF93KwlOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfQpVLKRLfMZWKRwGlD2HVgWOU9cYbd+t1yZp24A80KDDob8qMmMuwpEzKDXicYWkPwRXAwfPJDAUCHqguNJu4eBm1I+ZpuQjRbeDNS9j/7DcOZeNMx6TzpU/0gpejGtEOKqnrlqZlKRAHBxqUy9JbHeAgEuMLcM4ExeA8xS0vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=We6Rresr; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="We6Rresr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780927364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DHbkQyekF0uBmRMj0tOnP8Nwg2d6a/OfgRyBfvDwpfU=;
	b=We6Rresr9cpyxYDaBEjVdXsXqy1OwtuY75PVMFnSSj2kLUyDzrJlcpzqCcMcy4vcKJyWuN
	3nf0ZPhRDx9xPAcFJMY1L08/Pzv5IhKMsK59OWIfOt/akSlLVPNCNPdjzMtP4towrRPao4
	+atpJ2OD6Q/tPW3MPRy0xyVhY3/QzdD6IP1rOBuMkjTMVpL0t2BVU10qEGapUBcoD+vWuu
	avJsN1zZAWFDru/LOqueaGJxGlOaQH0T41kWFvtx6/nK/bdLfqH1kqijCqRsUYZyPa0Duy
	CitqoOADGTNRK+yexrDCRvVFj2X4TrDaje80+dz6uRWqjYcpFXlst230kxw9Bw==
From: chenxiaosong@chenxiaosong.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 1/7] smb: remove duplicate server/smbfsctl.h
Date: Mon,  8 Jun 2026 14:01:22 +0000
Message-ID: <20260608140128.387844-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260608140128.387844-1-chenxiaosong@chenxiaosong.com>
References: <20260608140128.387844-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename the following places:

  - FSCTL_COPYCHUNK -> FSCTL_SRV_COPYCHUNK
  - FSCTL_COPYCHUNK_WRITE -> FSCTL_SRV_COPYCHUNK_WRITE
  - FSCTL_REQUEST_RESUME_KEY -> FSCTL_SRV_REQUEST_RESUME_KEY

server/smbfsctl.h contains the following additional definitions compared to
common/smbfsctl.h:

  - IO_REPARSE_TAG_LX_SYMLINK_LE
  - IO_REPARSE_TAG_AF_UNIX_LE
  - IO_REPARSE_TAG_LX_FIFO_LE
  - IO_REPARSE_TAG_LX_CHR_LE
  - IO_REPARSE_TAG_LX_BLK_LE

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/common/smbfsctl.h |  6 +++
 fs/smb/server/smb2pdu.c  | 12 +++---
 fs/smb/server/smbfsctl.h | 91 ----------------------------------------
 3 files changed, 12 insertions(+), 97 deletions(-)
 delete mode 100644 fs/smb/server/smbfsctl.h

diff --git a/fs/smb/common/smbfsctl.h b/fs/smb/common/smbfsctl.h
index 3253a18ecb5c..74e78bcb4618 100644
--- a/fs/smb/common/smbfsctl.h
+++ b/fs/smb/common/smbfsctl.h
@@ -159,6 +159,12 @@
 #define IO_REPARSE_TAG_LX_CHR	     0x80000025
 #define IO_REPARSE_TAG_LX_BLK	     0x80000026
 
+#define IO_REPARSE_TAG_LX_SYMLINK_LE   cpu_to_le32(IO_REPARSE_TAG_LX_SYMLINK)
+#define IO_REPARSE_TAG_AF_UNIX_LE      cpu_to_le32(IO_REPARSE_TAG_AF_UNIX)
+#define IO_REPARSE_TAG_LX_FIFO_LE      cpu_to_le32(IO_REPARSE_TAG_LX_FIFO)
+#define IO_REPARSE_TAG_LX_CHR_LE       cpu_to_le32(IO_REPARSE_TAG_LX_CHR)
+#define IO_REPARSE_TAG_LX_BLK_LE       cpu_to_le32(IO_REPARSE_TAG_LX_BLK)
+
 /* If Name Surrogate Bit is set, the file or directory represents another named entity in the system. */
 #define IS_REPARSE_TAG_NAME_SURROGATE(tag) (!!((tag) & 0x20000000))
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a97fc9b7e44c..8bf418e2da1c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -16,7 +16,7 @@
 #include <linux/filelock.h>
 
 #include "glob.h"
-#include "smbfsctl.h"
+#include "../common/smbfsctl.h"
 #include "oplock.h"
 #include "smbacl.h"
 
@@ -7914,9 +7914,9 @@ static int fsctl_copychunk(struct ksmbd_work *work,
 
 	/*
 	 * FILE_READ_DATA should only be included in
-	 * the FSCTL_COPYCHUNK case
+	 * the FSCTL_SRV_COPYCHUNK case
 	 */
-	if (cnt_code == FSCTL_COPYCHUNK &&
+	if (cnt_code == FSCTL_SRV_COPYCHUNK &&
 	    !(dst_fp->daccess & (FILE_READ_DATA_LE | FILE_GENERIC_READ_LE))) {
 		rsp->hdr.Status = STATUS_ACCESS_DENIED;
 		goto out;
@@ -8390,7 +8390,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		nbytes = ret;
 		break;
-	case FSCTL_REQUEST_RESUME_KEY:
+	case FSCTL_SRV_REQUEST_RESUME_KEY:
 		if (out_buf_len < sizeof(struct resume_key_ioctl_rsp)) {
 			ret = -EINVAL;
 			goto out;
@@ -8404,8 +8404,8 @@ int smb2_ioctl(struct ksmbd_work *work)
 		rsp->VolatileFileId = req->VolatileFileId;
 		nbytes = sizeof(struct resume_key_ioctl_rsp);
 		break;
-	case FSCTL_COPYCHUNK:
-	case FSCTL_COPYCHUNK_WRITE:
+	case FSCTL_SRV_COPYCHUNK:
+	case FSCTL_SRV_COPYCHUNK_WRITE:
 		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 			ksmbd_debug(SMB,
 				    "User does not have write permission\n");
diff --git a/fs/smb/server/smbfsctl.h b/fs/smb/server/smbfsctl.h
deleted file mode 100644
index ecdf8f6e0df4..000000000000
--- a/fs/smb/server/smbfsctl.h
+++ /dev/null
@@ -1,91 +0,0 @@
-/* SPDX-License-Identifier: LGPL-2.1+ */
-/*
- *   fs/smb/server/smbfsctl.h: SMB, CIFS, SMB2 FSCTL definitions
- *
- *   Copyright (c) International Business Machines  Corp., 2002,2009
- *   Author(s): Steve French (sfrench@us.ibm.com)
- */
-
-/* IOCTL information */
-/*
- * List of ioctl/fsctl function codes that are or could be useful in the
- * future to remote clients like cifs or SMB2 client.  There is probably
- * a slightly larger set of fsctls that NTFS local filesystem could handle,
- * including the seven below that we do not have struct definitions for.
- * Even with protocol definitions for most of these now available, we still
- * need to do some experimentation to identify which are practical to do
- * remotely.  Some of the following, such as the encryption/compression ones
- * could be invoked from tools via a specialized hook into the VFS rather
- * than via the standard vfs entry points
- */
-
-#ifndef __KSMBD_SMBFSCTL_H
-#define __KSMBD_SMBFSCTL_H
-
-#define FSCTL_DFS_GET_REFERRALS      0x00060194
-#define FSCTL_DFS_GET_REFERRALS_EX   0x000601B0
-#define FSCTL_REQUEST_OPLOCK_LEVEL_1 0x00090000
-#define FSCTL_REQUEST_OPLOCK_LEVEL_2 0x00090004
-#define FSCTL_REQUEST_BATCH_OPLOCK   0x00090008
-#define FSCTL_LOCK_VOLUME            0x00090018
-#define FSCTL_UNLOCK_VOLUME          0x0009001C
-#define FSCTL_IS_PATHNAME_VALID      0x0009002C /* BB add struct */
-#define FSCTL_GET_COMPRESSION        0x0009003C /* BB add struct */
-#define FSCTL_SET_COMPRESSION        0x0009C040 /* BB add struct */
-#define FSCTL_QUERY_FAT_BPB          0x00090058 /* BB add struct */
-/* Verify the next FSCTL number, we had it as 0x00090090 before */
-#define FSCTL_FILESYSTEM_GET_STATS   0x00090060 /* BB add struct */
-#define FSCTL_GET_NTFS_VOLUME_DATA   0x00090064 /* BB add struct */
-#define FSCTL_GET_RETRIEVAL_POINTERS 0x00090073 /* BB add struct */
-#define FSCTL_IS_VOLUME_DIRTY        0x00090078 /* BB add struct */
-#define FSCTL_ALLOW_EXTENDED_DASD_IO 0x00090083 /* BB add struct */
-#define FSCTL_REQUEST_FILTER_OPLOCK  0x0009008C
-#define FSCTL_FIND_FILES_BY_SID      0x0009008F /* BB add struct */
-#define FSCTL_SET_OBJECT_ID          0x00090098 /* BB add struct */
-#define FSCTL_GET_OBJECT_ID          0x0009009C /* BB add struct */
-#define FSCTL_DELETE_OBJECT_ID       0x000900A0 /* BB add struct */
-#define FSCTL_SET_REPARSE_POINT      0x000900A4 /* BB add struct */
-#define FSCTL_GET_REPARSE_POINT      0x000900A8 /* BB add struct */
-#define FSCTL_DELETE_REPARSE_POINT   0x000900AC /* BB add struct */
-#define FSCTL_SET_OBJECT_ID_EXTENDED 0x000900BC /* BB add struct */
-#define FSCTL_CREATE_OR_GET_OBJECT_ID 0x000900C0 /* BB add struct */
-#define FSCTL_SET_SPARSE             0x000900C4 /* BB add struct */
-#define FSCTL_SET_ZERO_DATA          0x000980C8 /* BB add struct */
-#define FSCTL_SET_ENCRYPTION         0x000900D7 /* BB add struct */
-#define FSCTL_ENCRYPTION_FSCTL_IO    0x000900DB /* BB add struct */
-#define FSCTL_WRITE_RAW_ENCRYPTED    0x000900DF /* BB add struct */
-#define FSCTL_READ_RAW_ENCRYPTED     0x000900E3 /* BB add struct */
-#define FSCTL_READ_FILE_USN_DATA     0x000900EB /* BB add struct */
-#define FSCTL_WRITE_USN_CLOSE_RECORD 0x000900EF /* BB add struct */
-#define FSCTL_SIS_COPYFILE           0x00090100 /* BB add struct */
-#define FSCTL_RECALL_FILE            0x00090117 /* BB add struct */
-#define FSCTL_QUERY_SPARING_INFO     0x00090138 /* BB add struct */
-#define FSCTL_SET_ZERO_ON_DEALLOC    0x00090194 /* BB add struct */
-#define FSCTL_SET_SHORT_NAME_BEHAVIOR 0x000901B4 /* BB add struct */
-#define FSCTL_QUERY_ALLOCATED_RANGES 0x000940CF /* BB add struct */
-#define FSCTL_SET_DEFECT_MANAGEMENT  0x00098134 /* BB add struct */
-#define FSCTL_DUPLICATE_EXTENTS_TO_FILE 0x00098344
-#define FSCTL_SIS_LINK_FILES         0x0009C104
-#define FSCTL_PIPE_PEEK              0x0011400C /* BB add struct */
-#define FSCTL_PIPE_TRANSCEIVE        0x0011C017 /* BB add struct */
-/* strange that the number for this op is not sequential with previous op */
-#define FSCTL_PIPE_WAIT              0x00110018 /* BB add struct */
-#define FSCTL_REQUEST_RESUME_KEY     0x00140078
-#define FSCTL_LMR_GET_LINK_TRACK_INF 0x001400E8 /* BB add struct */
-#define FSCTL_LMR_SET_LINK_TRACK_INF 0x001400EC /* BB add struct */
-#define FSCTL_VALIDATE_NEGOTIATE_INFO 0x00140204
-#define FSCTL_QUERY_NETWORK_INTERFACE_INFO 0x001401FC
-#define FSCTL_COPYCHUNK              0x001440F2
-#define FSCTL_COPYCHUNK_WRITE        0x001480F2
-
-#define IO_REPARSE_TAG_MOUNT_POINT   0xA0000003
-#define IO_REPARSE_TAG_HSM           0xC0000004
-#define IO_REPARSE_TAG_SIS           0x80000007
-
-/* WSL reparse tags */
-#define IO_REPARSE_TAG_LX_SYMLINK_LE	cpu_to_le32(0xA000001D)
-#define IO_REPARSE_TAG_AF_UNIX_LE	cpu_to_le32(0x80000023)
-#define IO_REPARSE_TAG_LX_FIFO_LE	cpu_to_le32(0x80000024)
-#define IO_REPARSE_TAG_LX_CHR_LE	cpu_to_le32(0x80000025)
-#define IO_REPARSE_TAG_LX_BLK_LE	cpu_to_le32(0x80000026)
-#endif /* __KSMBD_SMBFSCTL_H */
-- 
2.54.0

