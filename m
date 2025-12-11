Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345BB285CAA;
	Thu, 11 Dec 2025 14:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765463634; cv=none; b=doDpBHZ1mfGKdmJ2VATTadoyZedbj0xf1aiUVjQBYM4YLL+OKLLdD47Q3JMrmltcOZ5IP0sCA4U5NsGy0j25c9FVQtM+kUI0EoPrbTTJtxlElLV0T61Jy3Nc7FvkvvFexCmGQWJ3xVwU3P3XSZvEw0Un7Kms3eONOZX+OoLSzx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765463634; c=relaxed/simple;
	bh=hCRIJyz4TTNdKdO0mZGm+yOGLDFBImZTlRV4zmUbomw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RznZsFb0XQWPRSwTuWNq/ZSKO0Ryb0b3YgVPcSgo9Ir8/2hmcLuOP6KRk07oZGiscbtYLv5kw7XaupVLDeNWjtgjZXUcHnKrIn468sKN0Sf/AIcjyFIuNjivTdVgOW0ViCLMv8C10nzW2Q8hRrW8lw0d0GfgzU6ece9J91lY418=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PoRTlu1+; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PoRTlu1+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765463629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ehH3XCWHeHmZZ620Aa1+AZsIP8iX8kBtHlUdLWKIrTg=;
	b=PoRTlu1+hEM6WWeOITPKkAVCOd5X/o74n3G+WFFhrIKC86am4Z5sn3UZNMyjfXOdKSCDp3
	DQkdrHgz0cOhzXs7ra2wRcaNn3jm+BnL6pFkcxfR+IA/mSNJYYFzBtX8o6hgt2/9fsdFF4
	fMV8mCtilpBSjJ0Ak94xI0nDUQDX6Oo=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 3/7] smb: move some SMB1 definitions into common/smb1pdu.h
Date: Thu, 11 Dec 2025 22:32:24 +0800
Message-ID: <20251211143228.172470-4-chenxiaosong.chenxiaosong@linux.dev>
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

These definitions are only used by SMB1, so move them into the new
common/smb1pdu.h.

KSMBD only implements SMB_COM_NEGOTIATE, see MS-SMB2 3.3.5.2.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/cifspdu.h    |  2 +-
 fs/smb/common/smb1pdu.h    | 56 ++++++++++++++++++++++++++++++++++++++
 fs/smb/common/smb2pdu.h    | 40 ---------------------------
 fs/smb/common/smbglob.h    |  2 --
 fs/smb/server/smb_common.h |  1 +
 5 files changed, 58 insertions(+), 43 deletions(-)
 create mode 100644 fs/smb/common/smb1pdu.h

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index eeb4011cb217..fdd84369e7b8 100644
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
index 000000000000..df6d4e11ae92
--- /dev/null
+++ b/fs/smb/common/smb1pdu.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ *
+ *   Copyright (C) International Business Machines  Corp., 2002,2009
+ *                 2018 Samsung Electronics Co., Ltd.
+ *   Author(s): Steve French <sfrench@us.ibm.com>
+ *              Namjae Jeon <linkinjeon@kernel.org>
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
index 3c8d8a4e7439..28460c3d4979 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1985,39 +1985,6 @@ struct smb2_lease_ack {
 	__le64 LeaseDuration;
 } __packed;
 
-/*
- * See MS-CIFS 2.2.3.1
- *     MS-SMB 2.2.3.1
- */
-struct smb_hdr {
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
 
@@ -2122,11 +2089,4 @@ struct smb_hdr {
 #define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
 				| READ_CONTROL | SYNCHRONIZE)
 
-/* See MS-CIFS 2.2.4.52.1 */
-typedef struct smb_negotiate_req {
-	struct smb_hdr hdr;	/* wct = 0 */
-	__le16 ByteCount;
-	unsigned char DialectsArray[];
-} __packed SMB_NEGOTIATE_REQ;
-
 #endif				/* _COMMON_SMB2PDU_H */
diff --git a/fs/smb/common/smbglob.h b/fs/smb/common/smbglob.h
index 9562845a5617..4e33d91cdc9d 100644
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
index 2baf4aa330eb..89adfd190370 100644
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

