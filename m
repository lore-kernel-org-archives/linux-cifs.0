Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A279C30E0FF
	for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 07:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760426470; cv=none; b=InkdsJ/VqM3aLUB4P5YqVUd8w+NVMa1IVtEBNjHAzO4a4AUKF7BYPT5ImBfkyZtvqi8GnDd+7K/eOkm9aeIxhahmwlbzUBfD6R76uZv7T1JnoWsGlE6IaOQjxuut5wWLf0Q0sWFeBglMv30cfz5Q7pasdfIWvXm2ztwOu5+WhqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760426470; c=relaxed/simple;
	bh=q0HdpeNIIiHEFblFeZm1MfcHh6AlakLgDfW+bJ5Iz4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0YeWPUZEc8/FexCjwlLcgHiTDt6mn2aNNTtcEMuhUimwSD3lzkq6v2j4pF3KTmDxDEYeLlbU8SbD+0vyYje9MV5IzevcVD7qjPu8XWSiSPu8/EYXfrOET4aoQhaRWEZCXR3PCgTazfm4dtSUqOorf05gV8eOVbJRP4WddxdRSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZkSGvOo+; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZkSGvOo+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760426466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1wz+a1Hcv+25nZho/rZsjoDCkJt+fE08VIiNQrPlLbI=;
	b=ZkSGvOo+mTPuzGHGhmeXyJmJ1gSOVGPWQ8MKa81c8Dy+Sn7j4dxr28dUGfP3A6LBJstHiS
	WPsM5joNt4jqeBZgGBOCOtoxoRNmSmF8OlCXxlb7n4J1bB0jXxBBQ+Y8FY5DJC7s3NOCfN
	UgwdTQhuxmsPL9wq5ybd/PknmZWYykA=
From: chenxiaosong.chenxiaosong@linux.dev
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
	christophe.jaillet@wanadoo.fr,
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 03/22] smb: move some duplicate definitions to common/cifsglob.h
Date: Tue, 14 Oct 2025 15:18:58 +0800
Message-ID: <20251014071917.3004573-4-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

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

