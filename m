Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B002609FD
	for <linux-cifs@vger.kernel.org>; Sun,  2 Nov 2025 07:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762068765; cv=none; b=pvJwUX9p29/l8g1Y6OkaAz34aEVuxuQOuFkfNCjrEvCanamqIRMq7RP+IEo3swf+5xuvRTj5/9/c5JmwPvLkJC5W0hBEzRoTHlQheMA3gUdMi1gkXfUTEiFnygGDCWCUximLGIQC8JFR7Ww2H6+Gvc0DuEalvqvnmxWL6//GKMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762068765; c=relaxed/simple;
	bh=zYDM1VAGtIyTPtSxkZzEy99U3EqOLKAqiqCwV/ozeSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBHej8voMdnlCYZnlk46cRuJJsCAemVLySSTU+bJ4Drw4ENL+SMUPILWUdBdcM/Drlyq+KPDvzo0ORkm8J6xpZhqscYpX43FwPA2isxMavOCHPY3FoXsPFVwRRw3I8r6+ndwRNp5oXK/XB0eSJqDl6gK7ezj9agNlfV6IxmPqPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FAAtAJAV; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FAAtAJAV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762068762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1YqAwYSerPicXylaH/mD/M55vhYHC2KuC7PxZC8ZrFc=;
	b=FAAtAJAVnB/AtAG/T/3JIDUwqpWCPAZHD2oVTPof/3fVMJ4JpT7L1PmmX3cwJ+Bn+KGO9g
	Sg+5GBvAqZ3BBRNcduqIGGFDjJhRMCu7XUDjM7UzFbJn2EgsD1PNKNiZr4JDUjMOVo9cxQ
	pVhGYqmGUDLKhswxTzq3ROsBXqD5IFs=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 09/14] smb: move list of FileSystemAttributes to common/fscc.h
Date: Sun,  2 Nov 2025 15:30:54 +0800
Message-ID: <20251102073059.3681026-10-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

These definitions are exactly the same on both client and server,
so move them to new common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsglob.h   |  1 +
 fs/smb/client/cifspdu.h    | 27 ------------------------
 fs/smb/common/fscc.h       | 42 ++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb_common.h | 28 +------------------------
 4 files changed, 44 insertions(+), 54 deletions(-)
 create mode 100644 fs/smb/common/fscc.h

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 4d0aca8097c1..0c76e0a31386 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -26,6 +26,7 @@
 #include <uapi/linux/cifs/cifs_mount.h>
 #include "../common/smbglob.h"
 #include "../common/smb2pdu.h"
+#include "../common/fscc.h"
 #include "smb2pdu.h"
 #include <linux/filelock.h>
 
diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 1e16ef6f0ff5..7816bd3da8d7 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2100,33 +2100,6 @@ typedef struct {
 /* minimum includes first three fields, and empty FS Name */
 #define MIN_FS_ATTR_INFO_SIZE 12
 
-
-/* List of FileSystemAttributes - see 2.5.1 of MS-FSCC */
-#define FILE_SUPPORTS_SPARSE_VDL	0x10000000 /* faster nonsparse extend */
-#define FILE_SUPPORTS_BLOCK_REFCOUNTING	0x08000000 /* allow ioctl dup extents */
-#define FILE_SUPPORT_INTEGRITY_STREAMS	0x04000000
-#define FILE_SUPPORTS_USN_JOURNAL	0x02000000
-#define FILE_SUPPORTS_OPEN_BY_FILE_ID	0x01000000
-#define FILE_SUPPORTS_EXTENDED_ATTRIBUTES 0x00800000
-#define FILE_SUPPORTS_HARD_LINKS	0x00400000
-#define FILE_SUPPORTS_TRANSACTIONS	0x00200000
-#define FILE_SEQUENTIAL_WRITE_ONCE	0x00100000
-#define FILE_READ_ONLY_VOLUME		0x00080000
-#define FILE_NAMED_STREAMS		0x00040000
-#define FILE_SUPPORTS_ENCRYPTION	0x00020000
-#define FILE_SUPPORTS_OBJECT_IDS	0x00010000
-#define FILE_VOLUME_IS_COMPRESSED	0x00008000
-#define FILE_SUPPORTS_POSIX_UNLINK_RENAME 0x00000400
-#define FILE_RETURNS_CLEANUP_RESULT_INFO  0x00000200
-#define FILE_SUPPORTS_REMOTE_STORAGE	0x00000100
-#define FILE_SUPPORTS_REPARSE_POINTS	0x00000080
-#define FILE_SUPPORTS_SPARSE_FILES	0x00000040
-#define FILE_VOLUME_QUOTAS		0x00000020
-#define FILE_FILE_COMPRESSION		0x00000010
-#define FILE_PERSISTENT_ACLS		0x00000008
-#define FILE_UNICODE_ON_DISK		0x00000004
-#define FILE_CASE_PRESERVED_NAMES	0x00000002
-#define FILE_CASE_SENSITIVE_SEARCH	0x00000001
 typedef struct {
 	__le32 Attributes;
 	__le32 MaxPathNameComponentLength;
diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
new file mode 100644
index 000000000000..c8bfb87232ac
--- /dev/null
+++ b/fs/smb/common/fscc.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ *
+ *   Copyright (c) International Business Machines  Corp., 2009, 2013
+ *                 Etersoft, 2012
+ *                 2018 Samsung Electronics Co., Ltd.
+ *   Author(s): Steve French (sfrench@us.ibm.com)
+ *              Pavel Shilovsky (pshilovsky@samba.org) 2012
+ *              Namjae Jeon (linkinjeon@kernel.org)
+ *
+ */
+#ifndef _COMMON_SMB_FSCC_H
+#define _COMMON_SMB_FSCC_H
+
+/* List of FileSystemAttributes - see MS-FSCC 2.5.1 */
+#define FILE_SUPPORTS_SPARSE_VDL	0x10000000 /* faster nonsparse extend */
+#define FILE_SUPPORTS_BLOCK_REFCOUNTING	0x08000000 /* allow ioctl dup extents */
+#define FILE_SUPPORT_INTEGRITY_STREAMS	0x04000000
+#define FILE_SUPPORTS_USN_JOURNAL	0x02000000
+#define FILE_SUPPORTS_OPEN_BY_FILE_ID	0x01000000
+#define FILE_SUPPORTS_EXTENDED_ATTRIBUTES 0x00800000
+#define FILE_SUPPORTS_HARD_LINKS	0x00400000
+#define FILE_SUPPORTS_TRANSACTIONS	0x00200000
+#define FILE_SEQUENTIAL_WRITE_ONCE	0x00100000
+#define FILE_READ_ONLY_VOLUME		0x00080000
+#define FILE_NAMED_STREAMS		0x00040000
+#define FILE_SUPPORTS_ENCRYPTION	0x00020000
+#define FILE_SUPPORTS_OBJECT_IDS	0x00010000
+#define FILE_VOLUME_IS_COMPRESSED	0x00008000
+#define FILE_SUPPORTS_POSIX_UNLINK_RENAME 0x00000400
+#define FILE_RETURNS_CLEANUP_RESULT_INFO  0x00000200
+#define FILE_SUPPORTS_REMOTE_STORAGE	0x00000100
+#define FILE_SUPPORTS_REPARSE_POINTS	0x00000080
+#define FILE_SUPPORTS_SPARSE_FILES	0x00000040
+#define FILE_VOLUME_QUOTAS		0x00000020
+#define FILE_FILE_COMPRESSION		0x00000010
+#define FILE_PERSISTENT_ACLS		0x00000008
+#define FILE_UNICODE_ON_DISK		0x00000004
+#define FILE_CASE_PRESERVED_NAMES	0x00000002
+#define FILE_CASE_SENSITIVE_SEARCH	0x00000001
+
+#endif /* _COMMON_SMB_FSCC_H */
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index cd21756379b5..a6004338c6c3 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -12,6 +12,7 @@
 #include "nterr.h"
 #include "../common/smbglob.h"
 #include "../common/smb2pdu.h"
+#include "../common/fscc.h"
 #include "smb2pdu.h"
 
 /* ksmbd's Specific ERRNO */
@@ -48,33 +49,6 @@
 #define ATTR_NO_BUFFERING		0x20000000
 #define ATTR_WRITE_THROUGH		0x80000000
 
-/* List of FileSystemAttributes - see 2.5.1 of MS-FSCC */
-#define FILE_SUPPORTS_SPARSE_VDL	0x10000000 /* faster nonsparse extend */
-#define FILE_SUPPORTS_BLOCK_REFCOUNTING	0x08000000 /* allow ioctl dup extents */
-#define FILE_SUPPORT_INTEGRITY_STREAMS	0x04000000
-#define FILE_SUPPORTS_USN_JOURNAL	0x02000000
-#define FILE_SUPPORTS_OPEN_BY_FILE_ID	0x01000000
-#define FILE_SUPPORTS_EXTENDED_ATTRIBUTES 0x00800000
-#define FILE_SUPPORTS_HARD_LINKS	0x00400000
-#define FILE_SUPPORTS_TRANSACTIONS	0x00200000
-#define FILE_SEQUENTIAL_WRITE_ONCE	0x00100000
-#define FILE_READ_ONLY_VOLUME		0x00080000
-#define FILE_NAMED_STREAMS		0x00040000
-#define FILE_SUPPORTS_ENCRYPTION	0x00020000
-#define FILE_SUPPORTS_OBJECT_IDS	0x00010000
-#define FILE_VOLUME_IS_COMPRESSED	0x00008000
-#define FILE_SUPPORTS_POSIX_UNLINK_RENAME 0x00000400
-#define FILE_RETURNS_CLEANUP_RESULT_INFO  0x00000200
-#define FILE_SUPPORTS_REMOTE_STORAGE	0x00000100
-#define FILE_SUPPORTS_REPARSE_POINTS	0x00000080
-#define FILE_SUPPORTS_SPARSE_FILES	0x00000040
-#define FILE_VOLUME_QUOTAS		0x00000020
-#define FILE_FILE_COMPRESSION		0x00000010
-#define FILE_PERSISTENT_ACLS		0x00000008
-#define FILE_UNICODE_ON_DISK		0x00000004
-#define FILE_CASE_PRESERVED_NAMES	0x00000002
-#define FILE_CASE_SENSITIVE_SEARCH	0x00000001
-
 /* Combinations of file access permission bits */
 #define SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA \
 		| FILE_READ_ATTRIBUTES \
-- 
2.43.0

