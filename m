Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E91257825
	for <linux-cifs@vger.kernel.org>; Sat, 21 Feb 2026 08:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771661301; cv=none; b=SgF+MgAhX/FW+hAk9v0zC9ALsYO5Bp78y6iBkypsxFs9g5i2pqAQ6x2joVVFP5/Jdb3zrWS9jl8ZtlP3QXfr4envFcRunuUCUCp9QWoIodaH/OGFx90MCd/91IY/g7hjz+UIs3EBI5ENgsatIYeeNBIlhI4nW/Su4cHRcQNWI/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771661301; c=relaxed/simple;
	bh=6fZiLqPakru4wihcRraIcXzlUgcEh8FNVn8kU9+FJb8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RjhAxogiUS+JRpYUPXEOpLpyrIcGIvLUfvbjQ21axUx+Ke3MOdo030Fgy8gHFu/rxA29OWuwFMHnQXvy8eZCOM77A6soVEsa4/T5cWr/fNWGEZ8+BWj1wOjV94/YJMjCyfO6hfzoK5sJK54Y+C3U4WhUjYb/m//z3U5iQVfdNaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dKLRh47o; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dKLRh47o"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771661296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kB5wkLlLL4Q8JcSwSpRRkWZf+bzURTT2yEPXEZOtjV0=;
	b=dKLRh47oNimg8sC2hREhB+/mW0PV/srKRDGgQ+UAIxVTKX+auMD4L1r2cTRxc2Jra9g04E
	OTdSf7DSb5TJDc1ScE9mjykykdJHD++yRgU3Jc70HyEB8RfY8I8Prg+HvkkgI3Sbi6FFMS
	aUHfA9mI8QvEQH1Uzh5musWzowMWRz4=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	geert@linux-m68k.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] smb/client: make SMB2 maperror KUnit tests a separate module
Date: Sat, 21 Feb 2026 08:07:12 +0000
Message-ID: <20260221080712.491144-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Build the SMB2 maperror KUnit tests as `smb2maperror_test.ko`.

Link: https://lore.kernel.org/linux-cifs/20260210081040.4156383-1-geert@linux-m68k.org/
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/Makefile            |  2 ++
 fs/smb/client/smb2glob.h          | 12 ++++++++++++
 fs/smb/client/smb2maperror.c      | 28 +++++++++++++++-------------
 fs/smb/client/smb2maperror_test.c | 12 +++++++++---
 4 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
index 3abd357d6df6..26b6105f04d1 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -56,4 +56,6 @@ $(obj)/smb2maperror.o: $(obj)/smb2_mapping_table.c
 quiet_cmd_gen_smb2_mapping = GEN     $@
       cmd_gen_smb2_mapping = perl $(src)/gen_smb2_mapping $< $@
 
+obj-$(CONFIG_SMB_KUNIT_TESTS) += smb2maperror_test.o
+
 clean-files	+= smb2_mapping_table.c
diff --git a/fs/smb/client/smb2glob.h b/fs/smb/client/smb2glob.h
index e56e4d402f13..19da74b1edab 100644
--- a/fs/smb/client/smb2glob.h
+++ b/fs/smb/client/smb2glob.h
@@ -46,4 +46,16 @@ enum smb2_compound_ops {
 #define END_OF_CHAIN 4
 #define RELATED_REQUEST 8
 
+/*
+ *****************************************************************
+ * Struct definitions go here
+ *****************************************************************
+ */
+
+struct status_to_posix_error {
+	__u32 smb2_status;
+	int posix_error;
+	char *status_string;
+};
+
 #endif	/* _SMB2_GLOB_H */
diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index cd036365201f..f4cff44e2796 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -8,7 +8,6 @@
  *
  */
 #include <linux/errno.h>
-#include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "smb2proto.h"
@@ -16,12 +15,6 @@
 #include "../common/smb2status.h"
 #include "trace.h"
 
-struct status_to_posix_error {
-	__u32 smb2_status;
-	int posix_error;
-	char *status_string;
-};
-
 static const struct status_to_posix_error smb2_error_map_table[] = {
 /*
  * Automatically generated by the `gen_smb2_mapping` script,
@@ -115,10 +108,19 @@ int __init smb2_init_maperror(void)
 	return 0;
 }
 
-#define SMB_CLIENT_KUNIT_AVAILABLE \
-	((IS_MODULE(CONFIG_CIFS) && IS_ENABLED(CONFIG_KUNIT)) || \
-	 (IS_BUILTIN(CONFIG_CIFS) && IS_BUILTIN(CONFIG_KUNIT)))
+#if IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
+/* Previous prototype for eliminating the build warning. */
+const struct status_to_posix_error *smb2_get_err_map_test(__u32 smb2_status);
+
+const struct status_to_posix_error *smb2_get_err_map_test(__u32 smb2_status)
+{
+	return smb2_get_err_map(smb2_status);
+}
+EXPORT_SYMBOL_GPL(smb2_get_err_map_test);
+
+const struct status_to_posix_error *smb2_error_map_table_test = smb2_error_map_table;
+EXPORT_SYMBOL_GPL(smb2_error_map_table_test);
 
-#if SMB_CLIENT_KUNIT_AVAILABLE && IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
-#include "smb2maperror_test.c"
-#endif /* CONFIG_SMB_KUNIT_TESTS */
+unsigned int smb2_error_map_num = ARRAY_SIZE(smb2_error_map_table);
+EXPORT_SYMBOL_GPL(smb2_error_map_num);
+#endif
diff --git a/fs/smb/client/smb2maperror_test.c b/fs/smb/client/smb2maperror_test.c
index 38ea6b846a99..8c47dea7a2c1 100644
--- a/fs/smb/client/smb2maperror_test.c
+++ b/fs/smb/client/smb2maperror_test.c
@@ -9,13 +9,18 @@
  */
 
 #include <kunit/test.h>
+#include "smb2glob.h"
+
+const struct status_to_posix_error *smb2_get_err_map_test(__u32 smb2_status);
+extern const struct status_to_posix_error *smb2_error_map_table_test;
+extern unsigned int smb2_error_map_num;
 
 static void
 test_cmp_map(struct kunit *test, const struct status_to_posix_error *expect)
 {
 	const struct status_to_posix_error *result;
 
-	result = smb2_get_err_map(expect->smb2_status);
+	result = smb2_get_err_map_test(expect->smb2_status);
 	KUNIT_EXPECT_PTR_NE(test, NULL, result);
 	KUNIT_EXPECT_EQ(test, expect->smb2_status, result->smb2_status);
 	KUNIT_EXPECT_EQ(test, expect->posix_error, result->posix_error);
@@ -26,8 +31,8 @@ static void maperror_test_check_search(struct kunit *test)
 {
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(smb2_error_map_table); i++)
-		test_cmp_map(test, &smb2_error_map_table[i]);
+	for (i = 0; i < smb2_error_map_num; i++)
+		test_cmp_map(test, &smb2_error_map_table_test[i]);
 }
 
 static struct kunit_case maperror_test_cases[] = {
@@ -43,3 +48,4 @@ static struct kunit_suite maperror_suite = {
 kunit_test_suite(maperror_suite);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("KUnit tests of SMB2 maperror");
-- 
2.52.0

