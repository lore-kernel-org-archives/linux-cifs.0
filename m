Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7E3371D1E
	for <linux-cifs@vger.kernel.org>; Fri,  3 Apr 2026 15:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775230811; cv=none; b=DkHBKNPpvz6BkrUNTEUxAQyNCbq9N2wQMYhuuY/WuF6voC6UoJc4clUOJ5HBieF9Xwxx7Njh9LLm/+zWqPGYyZtx1PVaQNh2FpFA0iGRe/abO+FZpmZpAZL4wLE6DpgKHoARkTsl09qcKRyrIVTtzse/c+x7SD4hncKNgXJSEi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775230811; c=relaxed/simple;
	bh=mY4T69LK6XlZiH2/gE6TC1WoD0Voh24gR6YaIziiKM0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LfArfFySzD4/APKnFOYi1R65mv6QcTE6egIX4oJxdOQgR6amVAni1XIWqCfISoXc9BDR9ky3YgsXK4O1Y2CuoNENcXEcze/yE0aF5K2o8ddqssmRghlieN/oribaVu5lZE8OI222Eo1CyRczrIuV9dosWE59BaIZ+shCKLgh6RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wLNw/h6U; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wLNw/h6U"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775230807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IpPwIcJP0yJkhcSNe4ogC9wyhAsPbDr2I0yKy8q5TVo=;
	b=wLNw/h6UkMfT0F+ueifRVqyvg9/S+DObwMe+lV+6/RUEQozD23IkJcESE/R1I+runwwNxk
	L5Q1c3UCkLIcV/VmzGtODzkxY+STXkcab6dxj66EhxflIQxD7D7MvSgPSp97lK3SAngeFw
	TUUEt298KFmZRyKXqZZmGSqanFkwPqQ=
From: zhang.guodong@linux.dev
To: smfrench@gmail.com,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] smb/client: move smb2maperror declarations to smb2proto.h
Date: Fri,  3 Apr 2026 15:38:52 +0000
Message-ID: <20260403153852.582746-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

For `smb2_error_map_table_test` and `smb2_error_map_num`, if their types
are changed in `smb2maperror.c` but the corresponding extern declarations
in `smb2maperror_test.c` are not updated, the compiler will not report an
error. Moving them to a common header file allows the compiler to catch
type mismatches.

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2maperror.c      | 3 ---
 fs/smb/client/smb2maperror_test.c | 6 ++----
 fs/smb/client/smb2proto.h         | 7 ++++++-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index 2b8782c4f684..9ed21f7b618c 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -112,9 +112,6 @@ int __init smb2_init_maperror(void)
 #define EXPORT_SYMBOL_FOR_SMB_TEST(sym) \
 	EXPORT_SYMBOL_FOR_MODULES(sym, "smb2maperror_test")
 
-/* Previous prototype for eliminating the build warning. */
-const struct status_to_posix_error *smb2_get_err_map_test(__u32 smb2_status);
-
 const struct status_to_posix_error *smb2_get_err_map_test(__u32 smb2_status)
 {
 	return smb2_get_err_map(smb2_status);
diff --git a/fs/smb/client/smb2maperror_test.c b/fs/smb/client/smb2maperror_test.c
index 8c47dea7a2c1..f2dce23daa3d 100644
--- a/fs/smb/client/smb2maperror_test.c
+++ b/fs/smb/client/smb2maperror_test.c
@@ -9,11 +9,9 @@
  */
 
 #include <kunit/test.h>
+#include "cifsglob.h"
 #include "smb2glob.h"
-
-const struct status_to_posix_error *smb2_get_err_map_test(__u32 smb2_status);
-extern const struct status_to_posix_error *smb2_error_map_table_test;
-extern unsigned int smb2_error_map_num;
+#include "smb2proto.h"
 
 static void
 test_cmp_map(struct kunit *test, const struct status_to_posix_error *expect)
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 230bb1e9f4e1..5f74475ba9d1 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -14,7 +14,6 @@
 #include <linux/key-type.h>
 #include "cached_dir.h"
 
-struct statfs;
 struct smb_rqst;
 
 /*
@@ -24,6 +23,12 @@ struct smb_rqst;
  */
 int map_smb2_to_linux_error(char *buf, bool log_err);
 int smb2_init_maperror(void);
+#if IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
+const struct status_to_posix_error *smb2_get_err_map_test(__u32 smb2_status);
+extern const struct status_to_posix_error *smb2_error_map_table_test;
+extern unsigned int smb2_error_map_num;
+#endif
+
 int smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
 		       struct TCP_Server_Info *server);
 unsigned int smb2_calc_size(void *buf);
-- 
2.53.0

