Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C2C337B9F
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 13:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764941234; cv=none; b=S/uxvw7BK8u21MR0SFDZ3P9KoGzB92cF2EcHJAWF9/R6oT8gt3YU7q9+YductftdBSRZtSP1f3bzmhwh3wntbQ0+WExLEPxUmPzeO/0vHZifsn///dlS3NsVoFlXG++gX8VvsqUYC4XZE0eOe8FNmLYHU+5BmvlgZMqIRc2elt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764941234; c=relaxed/simple;
	bh=LTTsvVq7z/CGtsgUZatr6VcdmuapKBG4em3dsHA41CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCGEtNEuWoxx3VzzOrP2yQXqsG3cfx2+HnFEKjqZj3YJYzxAY8qiQJkW0lDPzQqJsliSym/he8e35DR4gimJ2qorbe5EUhdL5sFTEm0b56w3cvlreV+TzSg0Gohid0F9pQYoL28X69fGUNgZ1d+Ff3C6TjV8pfmrKWkDfD0XVz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aIk7Yolp; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aIk7Yolp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764941226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mEYrHLMp9QvQcSNlYsklyfYv5l60SwPNXhW4ZMGC2jQ=;
	b=aIk7YolpQwhy1oFYIOogYs36znqdS067leYdS965pZYIFIUW9YW3nE7yPiCtrFF1n5VY4k
	Yfrj6aGRb90OqRjtSALY8cf7GnBapQmp6jCU1hzJ2QM+oXKfmyJz2cQXsYEQkkSd7n4TXY
	lgHR5IQbfhbwQv/ludpieOCyI2Musck=
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
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 7/9] smb/client: introduce smb2_get_err_map()
Date: Fri,  5 Dec 2025 21:25:33 +0800
Message-ID: <20251205132536.2703110-8-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251205132536.2703110-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251205132536.2703110-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

We may need to get struct status_to_posix_error information in other files
in the future. So we move struct status_to_posix_error to smb2glob.h, and
introduce new global function smb2_get_err_map().

Additionally, delete unused forward declaration `struct statfs`
in smb2proto.h.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2glob.h     |  6 ++++++
 fs/smb/client/smb2maperror.c | 28 +++++++++++++++-------------
 fs/smb/client/smb2proto.h    |  3 ++-
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/smb2glob.h b/fs/smb/client/smb2glob.h
index e56e4d402f13..fe6a5c7f01c4 100644
--- a/fs/smb/client/smb2glob.h
+++ b/fs/smb/client/smb2glob.h
@@ -13,6 +13,12 @@
 #ifndef _SMB2_GLOB_H
 #define _SMB2_GLOB_H
 
+struct status_to_posix_error {
+	__le32 smb2_status;
+	int posix_error;
+	char *status_string;
+};
+
 /*
  *****************************************************************
  * Constants go here
diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index df8db12ff7a9..0d46fa98952c 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -17,12 +17,6 @@
 #include "smb2glob.h"
 #include "trace.h"
 
-struct status_to_posix_error {
-	__le32 smb2_status;
-	int posix_error;
-	char *status_string;
-};
-
 static struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_WAIT_1, -EIO, "STATUS_WAIT_1"},
 	{STATUS_WAIT_2, -EIO, "STATUS_WAIT_2"},
@@ -2433,13 +2427,26 @@ static int cmp_smb2_status(const void *_a, const void *_b)
 	return 0;
 }
 
+struct status_to_posix_error *smb2_get_err_map(__le32 smb2_status)
+{
+	struct status_to_posix_error *err_map, key;
+
+	key = (struct status_to_posix_error) {
+		.smb2_status = smb2_status,
+	};
+	err_map = bsearch(&key, smb2_error_map_table, err_map_num,
+			  sizeof(struct status_to_posix_error),
+			  cmp_smb2_status);
+	return err_map;
+}
+
 int
 map_smb2_to_linux_error(char *buf, bool log_err)
 {
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	int rc = -EIO;
 	__le32 smb2err = shdr->Status;
-	struct status_to_posix_error *err_map, key;
+	struct status_to_posix_error *err_map;
 
 	if (smb2err == 0) {
 		trace_smb3_cmd_done(le32_to_cpu(shdr->Id.SyncId.TreeId),
@@ -2453,12 +2460,7 @@ map_smb2_to_linux_error(char *buf, bool log_err)
 		   (smb2err != STATUS_END_OF_FILE)) ||
 		  (cifsFYI & CIFS_RC);
 
-	key = (struct status_to_posix_error) {
-		.smb2_status = smb2err,
-	};
-	err_map = bsearch(&key, smb2_error_map_table, err_map_num,
-			  sizeof(struct status_to_posix_error),
-			  cmp_smb2_status);
+	err_map = smb2_get_err_map(smb2err);
 	if (!err_map)
 		goto out;
 
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index c988f6b37a1b..224840e3a00d 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -12,8 +12,8 @@
 #include <linux/nls.h>
 #include <linux/key-type.h>
 
-struct statfs;
 struct smb_rqst;
+struct status_to_posix_error;
 
 /*
  *****************************************************************
@@ -21,6 +21,7 @@ struct smb_rqst;
  *****************************************************************
  */
 extern int map_smb2_to_linux_error(char *buf, bool log_err);
+extern struct status_to_posix_error *smb2_get_err_map(__le32 smb2_status);
 extern void smb2_init_maperror(void);
 extern int smb2_check_message(char *buf, unsigned int length,
 			      struct TCP_Server_Info *server);
-- 
2.43.0

