Received: from bg1.exmail.qq.com (bg1.exmail.qq.com [114.132.124.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE71C1C461C;
	Tue, 20 Aug 2024 14:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.132.124.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724164616; cv=none; b=O/gRM02S4u38HlrqWr/21M6JJBi9V9LikPlY+cZ/HAfpGgIBB8yizL94aMwyEvwcXLWwMzQTSavXMSGTB0/utIPJh26Z+4N9uvitXEE4FXmWT474I0ein4oxa/y2zWqbLyWIbPGyJV/lpKXCuxUd2wP/RYs12v+kizWYGp1GMOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724164616; c=relaxed/simple;
	bh=WWAlaUYKMyhkaKrGJ+NkNuvoz3gdJnw234sPLrkI9dU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dz9gOL4yiqAqDFuy6Ro8exFBPetLksKyFIpNzM/q676VOP8MMJ32Mygjvu4/0yTGqD4KXaIJbzPjgawrr8y3w4k/+LyS9Iwvlm9TbiJG/Ug7Q1Re1ZWcC9sjxGtl3Qr8QjH4jTIL0SG6rdtvfyCKF1vxVe4hUaFTi944gJUVb5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=114.132.124.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtpsz13t1724164462tg54l8
X-QQ-Originating-IP: tneDG1M7cgdx2m0lq7VTApBdHFr8zBRVqYfMFZ7drCc=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 20 Aug 2024 22:34:18 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 7612338860620871913
From: chenxiaosong@chenxiaosong.com
To: linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com
Cc: chenxiaosong@kylinos.cn,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: [PATCH 6/8] smb: move some duplicate definitions to common/smbacl.h
Date: Tue, 20 Aug 2024 14:33:17 +0000
Message-Id: <20240820143319.274033-7-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com>
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

In order to maintain the code more easily, move duplicate acl
definitions to new common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
---
 fs/smb/client/cifsacl.h | 58 +--------------------------
 fs/smb/common/smbacl.h  | 88 +++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smbacl.h  | 80 +------------------------------------
 3 files changed, 91 insertions(+), 135 deletions(-)
 create mode 100644 fs/smb/common/smbacl.h

diff --git a/fs/smb/client/cifsacl.h b/fs/smb/client/cifsacl.h
index ccbfc754bd3c..74cff8a121e5 100644
--- a/fs/smb/client/cifsacl.h
+++ b/fs/smb/client/cifsacl.h
@@ -9,8 +9,7 @@
 #ifndef _CIFSACL_H
 #define _CIFSACL_H
 
-#define NUM_AUTHS (6)	/* number of authority fields */
-#define SID_MAX_SUB_AUTHORITIES (15) /* max number of sub authority fields */
+#include "../common/smbacl.h"
 
 #define READ_BIT        0x4
 #define WRITE_BIT       0x2
@@ -23,12 +22,6 @@
 #define UBITSHIFT	6
 #define GBITSHIFT	3
 
-#define ACCESS_ALLOWED	0
-#define ACCESS_DENIED	1
-
-#define SIDOWNER 1
-#define SIDGROUP 2
-
 /*
  * Security Descriptor length containing DACL with 3 ACEs (one each for
  * owner, group and world).
@@ -37,24 +30,6 @@
 			      sizeof(struct cifs_acl) + \
 			      (sizeof(struct cifs_ace) * 4))
 
-/*
- * Maximum size of a string representation of a SID:
- *
- * The fields are unsigned values in decimal. So:
- *
- * u8:  max 3 bytes in decimal
- * u32: max 10 bytes in decimal
- *
- * "S-" + 3 bytes for version field + 15 for authority field + NULL terminator
- *
- * For authority field, max is when all 6 values are non-zero and it must be
- * represented in hex. So "-0x" + 12 hex digits.
- *
- * Add 11 bytes for each subauthority field (10 bytes each + 1 for '-')
- */
-#define SID_STRING_BASE_SIZE (2 + 3 + 15 + 1)
-#define SID_STRING_SUBAUTH_SIZE (11) /* size of a single subauth string */
-
 struct cifs_ntsd {
 	__le16 revision; /* revision level */
 	__le16 type;
@@ -80,37 +55,6 @@ struct cifs_acl {
 	__le32 num_aces;
 } __attribute__((packed));
 
-/* ACE types - see MS-DTYP 2.4.4.1 */
-#define ACCESS_ALLOWED_ACE_TYPE	0x00
-#define ACCESS_DENIED_ACE_TYPE	0x01
-#define SYSTEM_AUDIT_ACE_TYPE	0x02
-#define SYSTEM_ALARM_ACE_TYPE	0x03
-#define ACCESS_ALLOWED_COMPOUND_ACE_TYPE 0x04
-#define ACCESS_ALLOWED_OBJECT_ACE_TYPE	0x05
-#define ACCESS_DENIED_OBJECT_ACE_TYPE	0x06
-#define SYSTEM_AUDIT_OBJECT_ACE_TYPE	0x07
-#define SYSTEM_ALARM_OBJECT_ACE_TYPE	0x08
-#define ACCESS_ALLOWED_CALLBACK_ACE_TYPE 0x09
-#define ACCESS_DENIED_CALLBACK_ACE_TYPE	0x0A
-#define ACCESS_ALLOWED_CALLBACK_OBJECT_ACE_TYPE 0x0B
-#define ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE  0x0C
-#define SYSTEM_AUDIT_CALLBACK_ACE_TYPE	0x0D
-#define SYSTEM_ALARM_CALLBACK_ACE_TYPE	0x0E /* Reserved */
-#define SYSTEM_AUDIT_CALLBACK_OBJECT_ACE_TYPE 0x0F
-#define SYSTEM_ALARM_CALLBACK_OBJECT_ACE_TYPE 0x10 /* reserved */
-#define SYSTEM_MANDATORY_LABEL_ACE_TYPE	0x11
-#define SYSTEM_RESOURCE_ATTRIBUTE_ACE_TYPE 0x12
-#define SYSTEM_SCOPED_POLICY_ID_ACE_TYPE 0x13
-
-/* ACE flags */
-#define OBJECT_INHERIT_ACE	0x01
-#define CONTAINER_INHERIT_ACE	0x02
-#define NO_PROPAGATE_INHERIT_ACE 0x04
-#define INHERIT_ONLY_ACE	0x08
-#define INHERITED_ACE		0x10
-#define SUCCESSFUL_ACCESS_ACE_FLAG 0x40
-#define FAILED_ACCESS_ACE_FLAG	0x80
-
 struct cifs_ace {
 	__u8 type; /* see above and MS-DTYP 2.4.4.1 */
 	__u8 flags;
diff --git a/fs/smb/common/smbacl.h b/fs/smb/common/smbacl.h
new file mode 100644
index 000000000000..b46341d56e6a
--- /dev/null
+++ b/fs/smb/common/smbacl.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: LGPL-2.1+ */
+/*
+ *   Copyright (c) International Business Machines  Corp., 2007
+ *   Author(s): Steve French (sfrench@us.ibm.com)
+ *   Modified by Namjae Jeon (linkinjeon@kernel.org)
+ */
+
+#ifndef _COMMON_SMBACL_H
+#define _COMMON_SMBACL_H
+
+#define NUM_AUTHS (6)	/* number of authority fields */
+#define SID_MAX_SUB_AUTHORITIES (15) /* max number of sub authority fields */
+
+/*
+ * ACE types - see MS-DTYP 2.4.4.1
+ */
+enum {
+	ACCESS_ALLOWED,
+	ACCESS_DENIED,
+};
+
+/*
+ * Security ID types
+ */
+enum {
+	SIDOWNER = 1,
+	SIDGROUP,
+	SIDCREATOR_OWNER,
+	SIDCREATOR_GROUP,
+	SIDUNIX_USER,
+	SIDUNIX_GROUP,
+	SIDNFS_USER,
+	SIDNFS_GROUP,
+	SIDNFS_MODE,
+};
+
+/* ACE types - see MS-DTYP 2.4.4.1 */
+#define ACCESS_ALLOWED_ACE_TYPE 0x00
+#define ACCESS_DENIED_ACE_TYPE  0x01
+#define SYSTEM_AUDIT_ACE_TYPE   0x02
+#define SYSTEM_ALARM_ACE_TYPE   0x03
+#define ACCESS_ALLOWED_COMPOUND_ACE_TYPE 0x04
+#define ACCESS_ALLOWED_OBJECT_ACE_TYPE  0x05
+#define ACCESS_DENIED_OBJECT_ACE_TYPE   0x06
+#define SYSTEM_AUDIT_OBJECT_ACE_TYPE    0x07
+#define SYSTEM_ALARM_OBJECT_ACE_TYPE    0x08
+#define ACCESS_ALLOWED_CALLBACK_ACE_TYPE 0x09
+#define ACCESS_DENIED_CALLBACK_ACE_TYPE 0x0A
+#define ACCESS_ALLOWED_CALLBACK_OBJECT_ACE_TYPE 0x0B
+#define ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE  0x0C
+#define SYSTEM_AUDIT_CALLBACK_ACE_TYPE  0x0D
+#define SYSTEM_ALARM_CALLBACK_ACE_TYPE  0x0E /* Reserved */
+#define SYSTEM_AUDIT_CALLBACK_OBJECT_ACE_TYPE 0x0F
+#define SYSTEM_ALARM_CALLBACK_OBJECT_ACE_TYPE 0x10 /* reserved */
+#define SYSTEM_MANDATORY_LABEL_ACE_TYPE 0x11
+#define SYSTEM_RESOURCE_ATTRIBUTE_ACE_TYPE 0x12
+#define SYSTEM_SCOPED_POLICY_ID_ACE_TYPE 0x13
+
+/* ACE flags */
+#define OBJECT_INHERIT_ACE		0x01
+#define CONTAINER_INHERIT_ACE		0x02
+#define NO_PROPAGATE_INHERIT_ACE	0x04
+#define INHERIT_ONLY_ACE		0x08
+#define INHERITED_ACE			0x10
+#define SUCCESSFUL_ACCESS_ACE_FLAG	0x40
+#define FAILED_ACCESS_ACE_FLAG		0x80
+
+/*
+ * Maximum size of a string representation of a SID:
+ *
+ * The fields are unsigned values in decimal. So:
+ *
+ * u8:  max 3 bytes in decimal
+ * u32: max 10 bytes in decimal
+ *
+ * "S-" + 3 bytes for version field + 15 for authority field + NULL terminator
+ *
+ * For authority field, max is when all 6 values are non-zero and it must be
+ * represented in hex. So "-0x" + 12 hex digits.
+ *
+ * Add 11 bytes for each subauthority field (10 bytes each + 1 for '-')
+ */
+#define SID_STRING_BASE_SIZE (2 + 3 + 15 + 1)
+#define SID_STRING_SUBAUTH_SIZE (11) /* size of a single subauth string */
+
+#define DOMAIN_USER_RID_LE	cpu_to_le32(513)
+
+#endif /* _COMMON_SMBACL_H */
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index 2b52861707d8..3e44bb77d6b0 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -8,6 +8,7 @@
 #ifndef _SMBACL_H
 #define _SMBACL_H
 
+#include "../common/smbacl.h"
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/posix_acl.h>
@@ -15,32 +16,6 @@
 
 #include "mgmt/tree_connect.h"
 
-#define NUM_AUTHS (6)	/* number of authority fields */
-#define SID_MAX_SUB_AUTHORITIES (15) /* max number of sub authority fields */
-
-/*
- * ACE types - see MS-DTYP 2.4.4.1
- */
-enum {
-	ACCESS_ALLOWED,
-	ACCESS_DENIED,
-};
-
-/*
- * Security ID types
- */
-enum {
-	SIDOWNER = 1,
-	SIDGROUP,
-	SIDCREATOR_OWNER,
-	SIDCREATOR_GROUP,
-	SIDUNIX_USER,
-	SIDUNIX_GROUP,
-	SIDNFS_USER,
-	SIDNFS_GROUP,
-	SIDNFS_MODE,
-};
-
 /* Revision for ACLs */
 #define SD_REVISION	1
 
@@ -62,57 +37,6 @@ enum {
 #define RM_CONTROL_VALID	0x4000
 #define SELF_RELATIVE		0x8000
 
-/* ACE types - see MS-DTYP 2.4.4.1 */
-#define ACCESS_ALLOWED_ACE_TYPE 0x00
-#define ACCESS_DENIED_ACE_TYPE  0x01
-#define SYSTEM_AUDIT_ACE_TYPE   0x02
-#define SYSTEM_ALARM_ACE_TYPE   0x03
-#define ACCESS_ALLOWED_COMPOUND_ACE_TYPE 0x04
-#define ACCESS_ALLOWED_OBJECT_ACE_TYPE  0x05
-#define ACCESS_DENIED_OBJECT_ACE_TYPE   0x06
-#define SYSTEM_AUDIT_OBJECT_ACE_TYPE    0x07
-#define SYSTEM_ALARM_OBJECT_ACE_TYPE    0x08
-#define ACCESS_ALLOWED_CALLBACK_ACE_TYPE 0x09
-#define ACCESS_DENIED_CALLBACK_ACE_TYPE 0x0A
-#define ACCESS_ALLOWED_CALLBACK_OBJECT_ACE_TYPE 0x0B
-#define ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE  0x0C
-#define SYSTEM_AUDIT_CALLBACK_ACE_TYPE  0x0D
-#define SYSTEM_ALARM_CALLBACK_ACE_TYPE  0x0E /* Reserved */
-#define SYSTEM_AUDIT_CALLBACK_OBJECT_ACE_TYPE 0x0F
-#define SYSTEM_ALARM_CALLBACK_OBJECT_ACE_TYPE 0x10 /* reserved */
-#define SYSTEM_MANDATORY_LABEL_ACE_TYPE 0x11
-#define SYSTEM_RESOURCE_ATTRIBUTE_ACE_TYPE 0x12
-#define SYSTEM_SCOPED_POLICY_ID_ACE_TYPE 0x13
-
-/* ACE flags */
-#define OBJECT_INHERIT_ACE		0x01
-#define CONTAINER_INHERIT_ACE		0x02
-#define NO_PROPAGATE_INHERIT_ACE	0x04
-#define INHERIT_ONLY_ACE		0x08
-#define INHERITED_ACE			0x10
-#define SUCCESSFUL_ACCESS_ACE_FLAG	0x40
-#define FAILED_ACCESS_ACE_FLAG		0x80
-
-/*
- * Maximum size of a string representation of a SID:
- *
- * The fields are unsigned values in decimal. So:
- *
- * u8:  max 3 bytes in decimal
- * u32: max 10 bytes in decimal
- *
- * "S-" + 3 bytes for version field + 15 for authority field + NULL terminator
- *
- * For authority field, max is when all 6 values are non-zero and it must be
- * represented in hex. So "-0x" + 12 hex digits.
- *
- * Add 11 bytes for each subauthority field (10 bytes each + 1 for '-')
- */
-#define SID_STRING_BASE_SIZE (2 + 3 + 15 + 1)
-#define SID_STRING_SUBAUTH_SIZE (11) /* size of a single subauth string */
-
-#define DOMAIN_USER_RID_LE	cpu_to_le32(513)
-
 struct ksmbd_conn;
 
 struct smb_ntsd {
@@ -131,7 +55,7 @@ struct smb_sid {
 	__le32 sub_auth[SID_MAX_SUB_AUTHORITIES]; /* sub_auth[num_subauth] */
 } __packed;
 
-/* size of a struct cifs_sid, sans sub_auth array */
+/* size of a struct smb_sid, sans sub_auth array */
 #define CIFS_SID_BASE_SIZE (1 + 1 + NUM_AUTHS)
 
 struct smb_acl {
-- 
2.34.1


