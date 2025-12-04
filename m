Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6522586E8
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 04:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764824395; cv=none; b=KRBZ4yHj6Lo/PImRbijpsSqWxxyBbqmQtvF9JbKJY6J5E5/nngkV5tlexyxx4O3E5oAQHrnoqdY8RyD2htDYUIX8xeMSJhFd07NkPQA3xUcHMW7Hnng+rzVAvYJFhTG3fri38aRlNsF4KMueJwpAS9Gij8vsqQqbHdjAoBrVpKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764824395; c=relaxed/simple;
	bh=IBYCJ0URnZmHAFg6rVEL8/OhHpGcyVNVskFuPS8njGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqH4+yagKPtCVYgIpH0+8wICyP1qjcUFN7Ny0s+OYzSo6cO7LXbmWtTvIqPZ139Fcpt+HldHYlduCPUvM+jZv70Do61u9OBh1lSXKjSUkhe9hWviKxQFRq5L8MM5MbDi/GUj0EIrVz0O8d62cS7nT779Vi5yUsco+clmBdKnbno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q1RhsfUj; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q1RhsfUj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764824391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dwt91f0JwYANteB0KGN5KnaqVqKN9Td/UOVyuvc+nkw=;
	b=Q1RhsfUjnszoMkw5Z56ZiTv6rKSw2p+I+BvEFjEPKyAAnyYNvDM7d/HPiSJbtyGqFORyOg
	cg0rkRMFfv+ut95vt8zo8TK1z2xHYypwavurEqW/sFDzfDD41TVSvGCS3juppN8khBZg6F
	YdYxgRbyNlhv6GZggj17juQbvbDg/iE=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 04/10] smb/client: sort smb2_error_map_table array
Date: Thu,  4 Dec 2025 12:58:12 +0800
Message-ID: <20251204045818.2590727-5-chenxiaosong.chenxiaosong@linux.dev>
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

Sort the array in ascending order, and then we can use binary search
algorithm to quickly find the target status code.

Since the smb2_init_maperror() is called only once when the module is
loaded, the array is sorted just once.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsfs.c       |  2 ++
 fs/smb/client/smb2maperror.c | 25 ++++++++++++++++++++++++-
 fs/smb/client/smb2proto.h    |  1 +
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 6eccb9ed9daa..77d14b3dd650 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -49,6 +49,7 @@
 #endif
 #include "fs_context.h"
 #include "cached_dir.h"
+#include "smb2proto.h"
 
 /*
  * DOS dates from 1980/1/1 through 2107/12/31
@@ -1908,6 +1909,7 @@ static int __init
 init_cifs(void)
 {
 	int rc = 0;
+	smb2_init_maperror();
 	cifs_proc_init();
 	INIT_LIST_HEAD(&cifs_tcp_ses_list);
 /*
diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index a77467d2d81c..1bd4196386dd 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -8,6 +8,7 @@
  *
  */
 #include <linux/errno.h>
+#include <linux/sort.h>
 #include "cifsglob.h"
 #include "cifs_debug.h"
 #include "smb2pdu.h"
@@ -22,7 +23,7 @@ struct status_to_posix_error {
 	char *status_string;
 };
 
-static const struct status_to_posix_error smb2_error_map_table[] = {
+static struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_WAIT_1, -EIO, "STATUS_WAIT_1"},
 	{STATUS_WAIT_2, -EIO, "STATUS_WAIT_2"},
 	{STATUS_WAIT_3, -EIO, "STATUS_WAIT_3"},
@@ -2418,6 +2419,20 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	"STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP"},
 };
 
+static unsigned int err_map_num = sizeof(smb2_error_map_table) /
+				     sizeof(struct status_to_posix_error);
+
+static int cmp_smb2_status(const void *_a, const void *_b)
+{
+	const struct status_to_posix_error *a = _a, *b = _b;
+
+	if (a->smb2_status < b->smb2_status)
+		return -1;
+	if (a->smb2_status > b->smb2_status)
+		return 1;
+	return 0;
+}
+
 int
 map_smb2_to_linux_error(char *buf, bool log_err)
 {
@@ -2461,3 +2476,11 @@ map_smb2_to_linux_error(char *buf, bool log_err)
 			   le32_to_cpu(smb2err), rc);
 	return rc;
 }
+
+void smb2_init_maperror(void)
+{
+	/* Sort in ascending order */
+	sort(smb2_error_map_table, err_map_num,
+	     sizeof(struct status_to_posix_error),
+	     cmp_smb2_status, NULL);
+}
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 5241daaae543..c988f6b37a1b 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -21,6 +21,7 @@ struct smb_rqst;
  *****************************************************************
  */
 extern int map_smb2_to_linux_error(char *buf, bool log_err);
+extern void smb2_init_maperror(void);
 extern int smb2_check_message(char *buf, unsigned int length,
 			      struct TCP_Server_Info *server);
 extern unsigned int smb2_calc_size(void *buf);
-- 
2.43.0

