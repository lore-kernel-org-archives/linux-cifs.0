Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CF826FD86
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 01:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765242741; cv=none; b=OQnyvhKE2CZHvYBlfYXVqmzePiBd3HAdTWTuSFbtDhs29w+y8/t6IMN2gb2qp6dpI6Z6xsyXXWFPN4XAsGTrwydRZaPDJfMPKNLQ9cR0eXgsXmduqQ/hjm1NARbEv0IXKbxdWYEY0Xv6v1NrGhNN8KJi255AHMElnkEUTH6z4Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765242741; c=relaxed/simple;
	bh=iMsBndZy+57BwS2YpW+pYGYWj/zSktJhn288AZDrwEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOjQZGvoGf55i4j43tQqdxi/Mp7dwO+vrJsVU95EGncA2Mo6VpA2QoL2zHhovZfC+T9/xYJdXoJhtW8MVda+iInLy42wQNC1HIxgmCmS+SkHW/q/xHzfBouauqatcZmxGZ0k/7AYq5CFAr9o3w7iPYU9YKTfT5c+UP+1h9oQoXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AtKGUHr4; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AtKGUHr4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765242737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ihM5FF9M8Iy+7B3rwj1A/4c7MPSS/DnRTaC52u6Nj68=;
	b=AtKGUHr4lIkQ/G3TeQl2FZKooCh62ZNLhMHfiNy8eP5cCVd4M7EsmhOZJ2qAiSiUz6XfF5
	ao3wqWplryg6abB5IFBVzZrZEJYfiCIS106kl1tOCoCdggZrAuemwrzlkRJr+NCdRl/jpg
	61WGFADX31TztgrgR2vraSWGEHCuL9g=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 13/13] smb: move some SMB1 definitions into common/smb1pdu.h
Date: Tue,  9 Dec 2025 09:10:19 +0800
Message-ID: <20251209011020.3270989-14-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

These definitions are only used by SMB1, so move them into the new
common/smb1pdu.h.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    |  2 +-
 fs/smb/common/smb1pdu.h    | 59 ++++++++++++++++++++++++++++++++++++++
 fs/smb/common/smb2pdu.h    | 44 ----------------------------
 fs/smb/common/smbglob.h    |  2 --
 fs/smb/server/smb_common.h |  1 +
 5 files changed, 61 insertions(+), 47 deletions(-)
 create mode 100644 fs/smb/common/smb1pdu.h

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 758ea29769da..bf6329cb4fd4 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -12,7 +12,7 @@
 #include <net/sock.h>
 #include <linux/unaligned.h>
 #include "../common/smbfsctl.h"
-#include "../common/smb2pdu.h"
+#include "../common/smb1pdu.h"
 
 #define CIFS_PROT   0
 #define POSIX_PROT  (CIFS_PROT+1)
diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
new file mode 100644
index 000000000000..11797471b2eb
--- /dev/null
+++ b/fs/smb/common/smb1pdu.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ *
+ *   Copyright (c) International Business Machines  Corp., 2002,2009
+ *                 2018 Samsung Electronics Co., Ltd.
+ *   Author(s): Steve French (sfrench@us.ibm.com)
+ *              Namjae Jeon (linkinjeon@kernel.org)
+ *
+ */
+
+#ifndef _COMMON_SMB1_PDU_H
+#define _COMMON_SMB1_PDU_H
+
+#define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)
+
+/*
+ * See MS-CIFS 2.2.3.1
+ *     MS-SMB 2.2.3.1
+ */
+struct smb_hdr {
+	__be32 smb_buf_length;	/* BB length is only two (rarely three) bytes,
+		with one or two byte "type" preceding it that will be
+		zero - we could mask the type byte off */
+	__u8 Protocol[4];
+	__u8 Command;
+	union {
+		struct {
+			__u8 ErrorClass;
+			__u8 Reserved;
+			__le16 Error;
+		} __packed DosError;
+		__le32 CifsError;
+	} __packed Status;
+	__u8 Flags;
+	__le16 Flags2;		/* note: le */
+	__le16 PidHigh;
+	union {
+		struct {
+			__le32 SequenceNumber;  /* le */
+			__u32 Reserved; /* zero */
+		} __packed Sequence;
+		__u8 SecuritySignature[8];	/* le */
+	} __packed Signature;
+	__u8 pad[2];
+	__u16 Tid;
+	__le16 Pid;
+	__u16 Uid;
+	__le16 Mid;
+	__u8 WordCount;
+} __packed;
+
+/* See MS-CIFS 2.2.4.52.1 */
+typedef struct smb_negotiate_req {
+	struct smb_hdr hdr;	/* wct = 0 */
+	__le16 ByteCount;
+	unsigned char DialectsArray[];
+} __packed SMB_NEGOTIATE_REQ;
+
+#endif /* _COMMON_SMB1_PDU_H */
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 2d68bd24f3bd..098f147680c5 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1642,42 +1642,6 @@ struct smb2_lease_ack {
 	__le64 LeaseDuration;
 } __packed;
 
-/*
- * See MS-CIFS 2.2.3.1
- *     MS-SMB 2.2.3.1
- */
-struct smb_hdr {
-	__be32 smb_buf_length;	/* BB length is only two (rarely three) bytes,
-		with one or two byte "type" preceding it that will be
-		zero - we could mask the type byte off */
-	__u8 Protocol[4];
-	__u8 Command;
-	union {
-		struct {
-			__u8 ErrorClass;
-			__u8 Reserved;
-			__le16 Error;
-		} __packed DosError;
-		__le32 CifsError;
-	} __packed Status;
-	__u8 Flags;
-	__le16 Flags2;		/* note: le */
-	__le16 PidHigh;
-	union {
-		struct {
-			__le32 SequenceNumber;  /* le */
-			__u32 Reserved; /* zero */
-		} __packed Sequence;
-		__u8 SecuritySignature[8];	/* le */
-	} __packed Signature;
-	__u8 pad[2];
-	__u16 Tid;
-	__le16 Pid;
-	__u16 Uid;
-	__le16 Mid;
-	__u8 WordCount;
-} __packed;
-
 #define OP_BREAK_STRUCT_SIZE_20		24
 #define OP_BREAK_STRUCT_SIZE_21		36
 
@@ -1782,14 +1746,6 @@ struct smb_hdr {
 #define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
 				| READ_CONTROL | SYNCHRONIZE)
 
-/* See MS-CIFS 2.2.4.52.1 */
-typedef struct smb_negotiate_req {
-	struct smb_hdr hdr;	/* wct = 0 */
-	__le16 ByteCount;
-	unsigned char DialectsArray[];
-} __packed SMB_NEGOTIATE_REQ;
-
-
 /*
  * [POSIX-SMB2] SMB3 POSIX Extensions
  * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/smb3_posix_extensions.md
diff --git a/fs/smb/common/smbglob.h b/fs/smb/common/smbglob.h
index 7853b5771128..353dc4f0971a 100644
--- a/fs/smb/common/smbglob.h
+++ b/fs/smb/common/smbglob.h
@@ -11,8 +11,6 @@
 #ifndef _COMMON_SMB_GLOB_H
 #define _COMMON_SMB_GLOB_H
 
-#define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)
-
 struct smb_version_values {
 	char		*version_string;
 	__u16		protocol_id;
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index b8da31cdbfd1..f47ce4a6719c 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -11,6 +11,7 @@
 #include "glob.h"
 #include "nterr.h"
 #include "../common/smbglob.h"
+#include "../common/smb1pdu.h"
 #include "../common/smb2pdu.h"
 #include "../common/fscc.h"
 #include "smb2pdu.h"
-- 
2.43.0

