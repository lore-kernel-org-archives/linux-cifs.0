Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3C029827E;
	Sun, 12 Oct 2025 15:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760281901; cv=none; b=IGbnakubyXW1DrtCOXNZZyTQ01E6dIeoHDhNzbaUWkbsALZNKxtRQpoE6sg3V77iQjnHoDkuE8vtdHJkCW79AQOuUAzED7zEMJdbiCddkB5EASjGVCk88M5AOrsS8XHtOWpQ22ihw0k+K+j8MowzidC6OPlulZEL8gl8CT5xn0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760281901; c=relaxed/simple;
	bh=q0HdpeNIIiHEFblFeZm1MfcHh6AlakLgDfW+bJ5Iz4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsstyNoL0aPAhGVl5Cc5V/8wpCUC8OfQDSW5Igrp4T/6XYsIhkh12tkK0th+gWv43Sr0acLUOk5l6w9YbreEVsVsORLZLrdiPtm3PpMcawZCJ9mQSHbQc+s5snODOxkYMdL1nz0CMQoSzD/K+1S2NoBH8MkQNbKsDzr5KxnDcsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281811t02595afb
X-QQ-Originating-IP: emXT2lbgOh2Yhu0UXvJdyuKT+/RuXjymNQfxq8goquw=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:10 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 10083397319782511198
From: chenxiaosong@chenxiaosong.com
To: stfrench@microsoft.com,
	metze@samba.org,
	pali@kernel.org,
	linkinjeon@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 03/22] smb: move some duplicate definitions to common/cifsglob.h
Date: Sun, 12 Oct 2025 23:08:56 +0800
Message-ID: <9C8C84DE02D904B4+20251012150915.2992220-4-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
References: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: MxDmZisZxeG6UGtTG2V/DEKAsuQAG1By0CzQE57p5nQMCsyRhR8nq3Hg
	82CHrH1h458ClXftzlOPuwY6iPCfydZUBYpiy+be092jxAbUx9irHQQUPBmYg5uXEhR9SC9
	97ox5g1ho+NCgrpmHBjQ7UV0SemSBkGq6+ijzFOh7cKbvHFbxS2WC/ak2IMnDGK5Az6iCWw
	aKs63A66I6phEl39wh4+/6xBsf2RqOam4a8FJI0XGwUCmLw3aX5lCpYoRYR5bh1Jh4iDtBY
	txugO8WL/Tk1AH1t6k0l64HhGTzibLIT6l5YbO20obyAbQ3coMCjjFyQtChVUga7xyIpEuD
	V7zooaPTviY+RUiEoPHnDHqR6tF1N7VLDIonUPJ6dIQMMvo5are//H/24Xf+w7gNEDa5LxX
	DqjH8AJiCXrbuS5vGPtUxHNjmIYvb/LcHs2FlyurU/CkQdt6wFXaqmbFmmnIc13VV1APID+
	W6RK9cA3zeJMmYUxYOkQzXs9ipjEsqFotIs5NQGVDvoWk5QA8E2psSPonF/wVHa1RkW3y9y
	2dhSZ9Y5nymuxy9hpkI+urzh5YMyYTiseac4AOtjCaYyB4axqjwWM/IpUBANlBgDmpTzRC9
	C8Etf7gh7AoypClOByN2duDPaV9Ix0HBjkK3nrtLFJkB1yR9rWwLmSFrjzPjtD9qQi+70Aj
	+iWGJwlXsfXSF2zVmcTELFK7gg8hdUy27VCXl5XRijYEDp9Bfp3j1hfU2kSFfDs7ABXn4eN
	cT9flo4n5RCooDNPdGAhNiRzpAS2WGeTEw/JlOpITLDMc9v8fy4zMme0beALi77N7mQj0ad
	6FvOlIQbsT7s5B6gXSrZWLev3B0+PLzHRSK+EeF9GM0lrG1fVT/uhrpq9Ph5LWNhwVn1VFY
	Qi84HApIez/cc+OBwuieneDA+e71IkAkx71jOFQHwKwPzQOxreUT82WS+raY9FjnLhQXzEL
	SPgFKesPjqFI4E9Fsb9wN3fsEoErROXlIDPUR6LBWd3pQs52Nqgnws9G6XMleRjHBAjKMCZ
	KnxPyfAFE5oVeKVAjPEZNQVg9mD7M=
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-QQ-RECHKSPAM: 0

From: ZhangGuoDong <zhangguodong@kylinos.cn>

In order to maintain the code more easily, move duplicate definitions to
new common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/client/cifsglob.h   | 19 +------------------
 fs/smb/common/cifsglob.h   | 30 ++++++++++++++++++++++++++++++
 fs/smb/server/smb_common.h | 14 +-------------
 3 files changed, 32 insertions(+), 31 deletions(-)
 create mode 100644 fs/smb/common/cifsglob.h

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 8f6f567d7474..c5034cf9ac9e 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -24,6 +24,7 @@
 #include "cifsacl.h"
 #include <crypto/internal/hash.h>
 #include <uapi/linux/cifs/cifs_mount.h>
+#include "../common/cifsglob.h"
 #include "../common/smb2pdu.h"
 #include "smb2pdu.h"
 #include <linux/filelock.h>
@@ -702,12 +703,6 @@ get_rfc1002_length(void *buf)
 	return be32_to_cpu(*((__be32 *)buf)) & 0xffffff;
 }
 
-static inline void
-inc_rfc1001_len(void *buf, int count)
-{
-	be32_add_cpu((__be32 *)buf, count);
-}
-
 struct TCP_Server_Info {
 	struct list_head tcp_ses_list;
 	struct list_head smb_ses_list;
@@ -1021,8 +1016,6 @@ compare_mid(__u16 mid, const struct smb_hdr *smb)
 #define CIFS_MAX_RFC1002_WSIZE ((1<<17) - 1 - sizeof(WRITE_REQ) + 4)
 #define CIFS_MAX_RFC1002_RSIZE ((1<<17) - 1 - sizeof(READ_RSP) + 4)
 
-#define CIFS_DEFAULT_IOSIZE (1024 * 1024)
-
 /*
  * Windows only supports a max of 60kb reads and 65535 byte writes. Default to
  * those values when posix extensions aren't in force. In actuality here, we
@@ -2148,30 +2141,20 @@ extern mempool_t cifs_io_request_pool;
 extern mempool_t cifs_io_subrequest_pool;
 
 /* Operations for different SMB versions */
-#define SMB1_VERSION_STRING	"1.0"
-#define SMB20_VERSION_STRING    "2.0"
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 extern struct smb_version_operations smb1_operations;
 extern struct smb_version_values smb1_values;
 extern struct smb_version_operations smb20_operations;
 extern struct smb_version_values smb20_values;
 #endif /* CIFS_ALLOW_INSECURE_LEGACY */
-#define SMB21_VERSION_STRING	"2.1"
 extern struct smb_version_operations smb21_operations;
 extern struct smb_version_values smb21_values;
-#define SMBDEFAULT_VERSION_STRING "default"
 extern struct smb_version_values smbdefault_values;
-#define SMB3ANY_VERSION_STRING "3"
 extern struct smb_version_values smb3any_values;
-#define SMB30_VERSION_STRING	"3.0"
 extern struct smb_version_operations smb30_operations;
 extern struct smb_version_values smb30_values;
-#define SMB302_VERSION_STRING	"3.02"
-#define ALT_SMB302_VERSION_STRING "3.0.2"
 /*extern struct smb_version_operations smb302_operations;*/ /* not needed yet */
 extern struct smb_version_values smb302_values;
-#define SMB311_VERSION_STRING	"3.1.1"
-#define ALT_SMB311_VERSION_STRING "3.11"
 extern struct smb_version_operations smb311_operations;
 extern struct smb_version_values smb311_values;
 
diff --git a/fs/smb/common/cifsglob.h b/fs/smb/common/cifsglob.h
new file mode 100644
index 000000000000..00fd215e3eb5
--- /dev/null
+++ b/fs/smb/common/cifsglob.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ *
+ *   Copyright (C) International Business Machines  Corp., 2002,2008
+ *   Author(s): Steve French (sfrench@us.ibm.com)
+ *              Jeremy Allison (jra@samba.org)
+ *
+ */
+#ifndef _COMMON_CIFS_GLOB_H
+#define _COMMON_CIFS_GLOB_H
+
+static inline void inc_rfc1001_len(void *buf, int count)
+{
+	be32_add_cpu((__be32 *)buf, count);
+}
+
+#define SMB1_VERSION_STRING	"1.0"
+#define SMB20_VERSION_STRING    "2.0"
+#define SMB21_VERSION_STRING	"2.1"
+#define SMBDEFAULT_VERSION_STRING "default"
+#define SMB3ANY_VERSION_STRING "3"
+#define SMB30_VERSION_STRING	"3.0"
+#define SMB302_VERSION_STRING	"3.02"
+#define ALT_SMB302_VERSION_STRING "3.0.2"
+#define SMB311_VERSION_STRING	"3.1.1"
+#define ALT_SMB311_VERSION_STRING "3.11"
+
+#define CIFS_DEFAULT_IOSIZE (1024 * 1024)
+
+#endif	/* _COMMON_CIFS_GLOB_H */
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index d742ba754348..863716207a0d 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -10,6 +10,7 @@
 
 #include "glob.h"
 #include "nterr.h"
+#include "../common/cifsglob.h"
 #include "../common/smb2pdu.h"
 #include "smb2pdu.h"
 
@@ -26,16 +27,8 @@
 #define SMB311_PROT		6
 #define BAD_PROT		0xFFFF
 
-#define SMB1_VERSION_STRING	"1.0"
-#define SMB20_VERSION_STRING	"2.0"
-#define SMB21_VERSION_STRING	"2.1"
-#define SMB30_VERSION_STRING	"3.0"
-#define SMB302_VERSION_STRING	"3.02"
-#define SMB311_VERSION_STRING	"3.1.1"
-
 #define SMB_ECHO_INTERVAL	(60 * HZ)
 
-#define CIFS_DEFAULT_IOSIZE	(64 * 1024)
 #define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
 
 #define MAX_STREAM_PROT_LEN	0x00FFFFFF
@@ -464,9 +457,4 @@ static inline unsigned int get_rfc1002_len(void *buf)
 {
 	return be32_to_cpu(*((__be32 *)buf)) & 0xffffff;
 }
-
-static inline void inc_rfc1001_len(void *buf, int count)
-{
-	be32_add_cpu((__be32 *)buf, count);
-}
 #endif /* __SMB_COMMON_H__ */
-- 
2.43.0

