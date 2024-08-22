Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F8F502BE;
	Thu, 22 Aug 2024 08:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724315167; cv=none; b=mepBL5R45ysQA4cHMpaoZ4Lx6JweQImfSBCzbwlzOjxc3nrmb0Zuu5RBmshODUSky3OqFgbqUaFpzBK4ljW+GGZ3H1ndv3QBlkPxWhd93KDiJ9EWUVgj06SXoBJGGesUyH0pyvxeOIUmQe0ZKzaSdHfn4VG2YDMZunGPAg0ZMuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724315167; c=relaxed/simple;
	bh=lWxahNHz+tm3vRNIk6OkjfhoO66D9lzFakL31LQCnk0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PIgen1SmYrccc6juQIG9sGTr/Nf2iF9lKI2nH0iOvQSuS64gGa6UVF+b19Mrq4RGuTHzcEU/ksjCZcgEjc8vt2zKCzQ3+E9pyxFgKbGhleFKMG5gTurQoxSNO+8XfzSA06bWC/9DqDwq+VpUlzJQxG3h99ZCDbFOGZDel1mO/fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtp78t1724314970tq4r97eh
X-QQ-Originating-IP: AG8pGLr3xPPyQafA2Y6C5dxZ0CxT4Y+9KJaIwh6BVrI=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 22 Aug 2024 16:22:47 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 2076485905222529775
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
	chenxiaosong@chenxiaosong.com
Subject: [PATCH v2 10/12] smb: move some duplicate definitions to common/smbacl.h
Date: Thu, 22 Aug 2024 08:20:59 +0000
Message-Id: <20240822082101.391272-11-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

In order to maintain the code more easily, move duplicate definitions
to new common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/cifsacl.h |  91 +-----------------------------
 fs/smb/common/smbacl.h  | 121 ++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smbacl.h  | 111 +-----------------------------------
 3 files changed, 123 insertions(+), 200 deletions(-)
 create mode 100644 fs/smb/common/smbacl.h

diff --git a/fs/smb/client/cifsacl.h b/fs/smb/client/cifsacl.h
index cbaed8038e36..6529478b7f48 100644
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
@@ -37,88 +30,6 @@
 			      sizeof(struct smb_acl) + \
 			      (sizeof(struct smb_ace) * 4))
 
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
-struct smb_ntsd {
-	__le16 revision; /* revision level */
-	__le16 type;
-	__le32 osidoffset;
-	__le32 gsidoffset;
-	__le32 sacloffset;
-	__le32 dacloffset;
-} __attribute__((packed));
-
-struct smb_sid {
-	__u8 revision; /* revision level */
-	__u8 num_subauth;
-	__u8 authority[NUM_AUTHS];
-	__le32 sub_auth[SID_MAX_SUB_AUTHORITIES]; /* sub_auth[num_subauth] */
-} __attribute__((packed));
-
-/* size of a struct smb_sid, sans sub_auth array */
-#define CIFS_SID_BASE_SIZE (1 + 1 + NUM_AUTHS)
-
-struct smb_acl {
-	__le16 revision; /* revision level */
-	__le16 size;
-	__le32 num_aces;
-} __attribute__((packed));
-
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
-struct smb_ace {
-	__u8 type; /* see above and MS-DTYP 2.4.4.1 */
-	__u8 flags;
-	__le16 size;
-	__le32 access_req;
-	struct smb_sid sid; /* ie UUID of user or group who gets these perms */
-} __attribute__((packed));
-
 /*
  * The current SMB3 form of security descriptor is similar to what was used for
  * cifs (see above) but some fields are split, and fields in the struct below
diff --git a/fs/smb/common/smbacl.h b/fs/smb/common/smbacl.h
new file mode 100644
index 000000000000..6a60698fc6f0
--- /dev/null
+++ b/fs/smb/common/smbacl.h
@@ -0,0 +1,121 @@
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
+struct smb_ntsd {
+	__le16 revision; /* revision level */
+	__le16 type;
+	__le32 osidoffset;
+	__le32 gsidoffset;
+	__le32 sacloffset;
+	__le32 dacloffset;
+} __attribute__((packed));
+
+struct smb_sid {
+	__u8 revision; /* revision level */
+	__u8 num_subauth;
+	__u8 authority[NUM_AUTHS];
+	__le32 sub_auth[SID_MAX_SUB_AUTHORITIES]; /* sub_auth[num_subauth] */
+} __attribute__((packed));
+
+/* size of a struct smb_sid, sans sub_auth array */
+#define CIFS_SID_BASE_SIZE (1 + 1 + NUM_AUTHS)
+
+struct smb_acl {
+	__le16 revision; /* revision level */
+	__le16 size;
+	__le32 num_aces;
+} __attribute__((packed));
+
+struct smb_ace {
+	__u8 type; /* see above and MS-DTYP 2.4.4.1 */
+	__u8 flags;
+	__le16 size;
+	__le32 access_req;
+	struct smb_sid sid; /* ie UUID of user or group who gets these perms */
+} __attribute__((packed));
+
+#endif /* _COMMON_SMBACL_H */
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index 2b52861707d8..24ce576fc292 100644
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
 
@@ -62,92 +37,8 @@ enum {
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
 
-struct smb_ntsd {
-	__le16 revision; /* revision level */
-	__le16 type;
-	__le32 osidoffset;
-	__le32 gsidoffset;
-	__le32 sacloffset;
-	__le32 dacloffset;
-} __packed;
-
-struct smb_sid {
-	__u8 revision; /* revision level */
-	__u8 num_subauth;
-	__u8 authority[NUM_AUTHS];
-	__le32 sub_auth[SID_MAX_SUB_AUTHORITIES]; /* sub_auth[num_subauth] */
-} __packed;
-
-/* size of a struct cifs_sid, sans sub_auth array */
-#define CIFS_SID_BASE_SIZE (1 + 1 + NUM_AUTHS)
-
-struct smb_acl {
-	__le16 revision; /* revision level */
-	__le16 size;
-	__le32 num_aces;
-} __packed;
-
-struct smb_ace {
-	__u8 type;
-	__u8 flags;
-	__le16 size;
-	__le32 access_req;
-	struct smb_sid sid; /* ie UUID of user or group who gets these perms */
-} __packed;
-
 struct smb_fattr {
 	kuid_t	cf_uid;
 	kgid_t	cf_gid;
-- 
2.34.1

