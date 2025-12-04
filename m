Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6062FBE14
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 05:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764824411; cv=none; b=SONUcPah9N8q8/bPp4MwT3h8WuLH0FJaRPg1lak9dMDxJvoD9WnwvK/VA/ML0GDofWqOvCcGT1/eacqmmuLcYCmeVYyt+Kl4f596UX20Q7UptKXjRmofRb7hztiEyj8isUApIw6c8/h4GDWq5Om0PAls1g2MJy1rG2FwEKUnDIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764824411; c=relaxed/simple;
	bh=irGUp7ucdaAS65wOUUfmsAJ/emdWlpyAPbRDWpJm5wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oarWD9h/vWH+brf/y+AowpGNd9ZJYxNTYLWkM+dY5bPn9Ih5BA/gReUChzDcu5FlBjjujy/TUxfnyZ+oHluvF/fHWlfrCqQPFYHvezbxISBoMqFMfpR61sDTxWUdpczW0rxYPEEpf0VHWL0GgS4hmjfrm+SLATraKMDmUQoGMS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wn2deWCN; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wn2deWCN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764824406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oQWSTfTqfi36TPw1mkYlE01yHaaPSEMaXv1EtrdIBH8=;
	b=Wn2deWCNwpH0/hdFxIEwP5iVoDnMZWb0gMnk00UW7l0snn5uDpUerTuDFbAQ38I3A9Ci9g
	q5mMODgGuZ80h1BsS8CZggk39ELyUHq/6auvm9ExAyZ/Uwc7Lvp7TSFgKSxu56j+HGrdcV
	A47CITO/99a0jBmrFTIhtgIf6BbDDY0=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 10/10] smb: move client/smb2maperror.c to common/
Date: Thu,  4 Dec 2025 12:58:18 +0800
Message-ID: <20251204045818.2590727-11-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The maperror can also be used by ksmbd, so move it to common/.

  - client/smb2maperror.c -> common/smb2maperror.c
  - Move map_smb2_to_linux_error() into client/smb2misc.c
  - smb2_init_maperror() is called from smb_common_init()
  - Move struct status_to_posix_error into common/common.h
  - Export symbol smb2_get_err_map()
  - The KUnit tests are executed when smb_common.ko is loaded

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/Makefile                   |  2 +-
 fs/smb/client/cifsfs.c                   |  2 -
 fs/smb/client/smb2misc.c                 | 44 ++++++++++++++++
 fs/smb/client/smb2proto.h                |  1 -
 fs/smb/common/Makefile                   |  2 +-
 fs/smb/common/common.c                   |  2 +
 fs/smb/common/common.h                   | 13 +++++
 fs/smb/{client => common}/smb2maperror.c | 64 +++---------------------
 8 files changed, 67 insertions(+), 63 deletions(-)
 rename fs/smb/{client => common}/smb2maperror.c (98%)

diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
index 4c97b31a25c2..e84df2af8be6 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -9,7 +9,7 @@ cifs-y := trace.o cifsfs.o cifs_debug.o connect.o dir.o file.o \
 	  inode.o link.o misc.o netmisc.o smbencrypt.o transport.o \
 	  cached_dir.o cifs_unicode.o nterr.o cifsencrypt.o \
 	  readdir.o ioctl.o sess.o export.o unc.o winucase.o \
-	  smb2ops.o smb2maperror.o smb2transport.o \
+	  smb2ops.o smb2transport.o \
 	  smb2misc.o smb2pdu.o smb2inode.o smb2file.o cifsacl.o fs_context.o \
 	  dns_resolve.o cifs_spnego_negtokeninit.asn1.o asn1.o \
 	  namespace.o reparse.o
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 77d14b3dd650..6eccb9ed9daa 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -49,7 +49,6 @@
 #endif
 #include "fs_context.h"
 #include "cached_dir.h"
-#include "smb2proto.h"
 
 /*
  * DOS dates from 1980/1/1 through 2107/12/31
@@ -1909,7 +1908,6 @@ static int __init
 init_cifs(void)
 {
 	int rc = 0;
-	smb2_init_maperror();
 	cifs_proc_init();
 	INIT_LIST_HEAD(&cifs_tcp_ses_list);
 /*
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 96bfe4c63ccf..2cdcc9e6f47f 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -18,6 +18,7 @@
 #include "smb2glob.h"
 #include "nterr.h"
 #include "cached_dir.h"
+#include "../common/common.h"
 
 static int
 check_smb2_hdr(struct smb2_hdr *shdr, __u64 mid)
@@ -927,3 +928,46 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		sha512_update(&sha_ctx, iov[i].iov_base, iov[i].iov_len);
 	sha512_final(&sha_ctx, ses->preauth_sha_hash);
 }
+
+int
+map_smb2_to_linux_error(char *buf, bool log_err)
+{
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
+	int rc = -EIO;
+	__le32 smb2err = shdr->Status;
+	struct status_to_posix_error *err_map;
+
+	if (smb2err == 0) {
+		trace_smb3_cmd_done(le32_to_cpu(shdr->Id.SyncId.TreeId),
+			      le64_to_cpu(shdr->SessionId),
+			      le16_to_cpu(shdr->Command),
+			      le64_to_cpu(shdr->MessageId));
+		return 0;
+	}
+
+	log_err = (log_err && (smb2err != STATUS_MORE_PROCESSING_REQUIRED) &&
+		   (smb2err != STATUS_END_OF_FILE)) ||
+		  (cifsFYI & CIFS_RC);
+
+	err_map = smb2_get_err_map(smb2err);
+	if (!err_map)
+		goto out;
+
+	rc = err_map->posix_error;
+	if (log_err)
+		pr_notice("Status code returned 0x%08x %s\n", smb2err,
+			  err_map->status_string);
+
+out:
+	/* on error mapping not found  - return EIO */
+
+	cifs_dbg(FYI, "Mapping SMB2 status code 0x%08x to POSIX err %d\n",
+		 __le32_to_cpu(smb2err), rc);
+
+	trace_smb3_cmd_err(le32_to_cpu(shdr->Id.SyncId.TreeId),
+			   le64_to_cpu(shdr->SessionId),
+			   le16_to_cpu(shdr->Command),
+			   le64_to_cpu(shdr->MessageId),
+			   le32_to_cpu(smb2err), rc);
+	return rc;
+}
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index c988f6b37a1b..5241daaae543 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -21,7 +21,6 @@ struct smb_rqst;
  *****************************************************************
  */
 extern int map_smb2_to_linux_error(char *buf, bool log_err);
-extern void smb2_init_maperror(void);
 extern int smb2_check_message(char *buf, unsigned int length,
 			      struct TCP_Server_Info *server);
 extern unsigned int smb2_calc_size(void *buf);
diff --git a/fs/smb/common/Makefile b/fs/smb/common/Makefile
index 4f1dc5123e99..3bfd510a5204 100644
--- a/fs/smb/common/Makefile
+++ b/fs/smb/common/Makefile
@@ -4,4 +4,4 @@
 #
 
 obj-$(CONFIG_SMBFS) += smb_common.o
-smb_common-objs := common.o cifs_md4.o
+smb_common-objs := common.o cifs_md4.o smb2maperror.o
diff --git a/fs/smb/common/common.c b/fs/smb/common/common.c
index 4142e05039c0..eb3703b3cc22 100644
--- a/fs/smb/common/common.c
+++ b/fs/smb/common/common.c
@@ -13,6 +13,8 @@ static int __init smb_common_init(void)
 {
 	int rc = 0;
 
+	smb2_init_maperror();
+
 	return rc;
 }
 
diff --git a/fs/smb/common/common.h b/fs/smb/common/common.h
index 07ee24ecccb8..71933f8497b8 100644
--- a/fs/smb/common/common.h
+++ b/fs/smb/common/common.h
@@ -24,4 +24,17 @@ int cifs_md4_init(struct md4_ctx *mctx);
 int cifs_md4_update(struct md4_ctx *mctx, const u8 *data, unsigned int len);
 int cifs_md4_final(struct md4_ctx *mctx, u8 *out);
 
+/*
+ * Definitions for smb2 map error
+ */
+
+struct status_to_posix_error {
+	__le32 smb2_status;
+	int posix_error;
+	char *status_string;
+};
+
+struct status_to_posix_error *smb2_get_err_map(__le32 smb2_status);
+void smb2_init_maperror(void);
+
 #endif /* __SMB_COMMON_H__ */
diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/common/smb2maperror.c
similarity index 98%
rename from fs/smb/client/smb2maperror.c
rename to fs/smb/common/smb2maperror.c
index 95e4a41ecc5a..c4109fc6320f 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/common/smb2maperror.c
@@ -7,21 +7,11 @@
  *   Author(s): Steve French (sfrench@us.ibm.com)
  *
  */
-#include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/sort.h>
-#include "cifsglob.h"
-#include "cifs_debug.h"
-#include "smb2pdu.h"
-#include "smb2proto.h"
-#include "../common/smb2status.h"
-#include "smb2glob.h"
-#include "trace.h"
-
-struct status_to_posix_error {
-	__le32 smb2_status;
-	int posix_error;
-	char *status_string;
-};
+#include <linux/bsearch.h>
+#include "common.h"
+#include "smb2status.h"
 
 static struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_WAIT_1, -EIO, "STATUS_WAIT_1"},
@@ -2433,7 +2423,7 @@ static int cmp_smb2_status(const void *_a, const void *_b)
 	return 0;
 }
 
-static struct status_to_posix_error *
+struct status_to_posix_error *
 smb2_get_err_map(__le32 smb2_status)
 {
 	struct status_to_posix_error *err_map, key;
@@ -2446,49 +2436,7 @@ smb2_get_err_map(__le32 smb2_status)
 			  cmp_smb2_status);
 	return err_map;
 }
-
-int
-map_smb2_to_linux_error(char *buf, bool log_err)
-{
-	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
-	int rc = -EIO;
-	__le32 smb2err = shdr->Status;
-	struct status_to_posix_error *err_map;
-
-	if (smb2err == 0) {
-		trace_smb3_cmd_done(le32_to_cpu(shdr->Id.SyncId.TreeId),
-			      le64_to_cpu(shdr->SessionId),
-			      le16_to_cpu(shdr->Command),
-			      le64_to_cpu(shdr->MessageId));
-		return 0;
-	}
-
-	log_err = (log_err && (smb2err != STATUS_MORE_PROCESSING_REQUIRED) &&
-		   (smb2err != STATUS_END_OF_FILE)) ||
-		  (cifsFYI & CIFS_RC);
-
-	err_map = smb2_get_err_map(smb2err);
-	if (!err_map)
-		goto out;
-
-	rc = err_map->posix_error;
-	if (log_err)
-		pr_notice("Status code returned 0x%08x %s\n", smb2err,
-			  err_map->status_string);
-
-out:
-	/* on error mapping not found  - return EIO */
-
-	cifs_dbg(FYI, "Mapping SMB2 status code 0x%08x to POSIX err %d\n",
-		 __le32_to_cpu(smb2err), rc);
-
-	trace_smb3_cmd_err(le32_to_cpu(shdr->Id.SyncId.TreeId),
-			   le64_to_cpu(shdr->SessionId),
-			   le16_to_cpu(shdr->Command),
-			   le64_to_cpu(shdr->MessageId),
-			   le32_to_cpu(smb2err), rc);
-	return rc;
-}
+EXPORT_SYMBOL_GPL(smb2_get_err_map);
 
 void smb2_init_maperror(void)
 {
-- 
2.43.0

