Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A1E3EBF34
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 14:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775139606; cv=none; b=NauS0W28xtfhScaGht2b9aw/gm97Am0VbT9gbpEjPbbeuyHNQIzDZ0MjXrQYJs1BeUcX4KDPPyNarTpLDVt7RtWmlHLdRz/9GZHOtS0ALd4YMYBPLhA0i0BuI1JzA2nlzZ7RvsBJIfhffFWVCSAWg/kxTFYG6QcMAWQiuVtyGvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775139606; c=relaxed/simple;
	bh=DCUsEPoSHGz3KZW4w2lZlrX+CpThEUA592tv92yadoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0c/t8SGNEvgLrDug6hYKg+3w9WLk+6aFOtY6pZ4s0tcwFAQFMZqyjLDJ8IBUKRY4DtbM/QB9dc0KCoX7z5Y18TGYQpAKiPo2iBgtCGF94eyrr1elHe6Xpbqr6oTDlGiASqxAc+8Q6JsGlZ6XBo6/Lb1TP2t/LIyWyYXSS0GjrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w36iFBzC; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w36iFBzC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775139602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QvkybnxUd5xos7EzrWqUlelewNUK11lK0zjP03X0Zr4=;
	b=w36iFBzC257zgoxG/K+FhzCpD6renyX1J/xIUuy2AnTFVuni123cELulLKePVMpwUZyzZ+
	Sv1UvSihdF58O+AbH5pee4gQBI/I2RVhXcJaKLihShCZ0l8A+YFtEfcL5AE8xs1rpXwO7d
	7un4Geux54mjyUBO/2SXC0hOdJrRgTM=
From: huiwen.he@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com,
	tangyouling@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v3 07/13] smb/client: introduce KUnit test to check ntstatus_to_dos_map search
Date: Thu,  2 Apr 2026 14:18:33 +0000
Message-ID: <20260402141839.461257-8-huiwen.he@linux.dev>
In-Reply-To: <20260402141839.461257-1-huiwen.he@linux.dev>
References: <20260402141839.461257-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

Check whether all elements can be correctly found in the array.

Introduce CONFIG_SMB1_KUNIT_TESTS for smb1maperror_test.ko since
smb1maperror.o is only built when CONFIG_CIFS_ALLOW_INSECURE_LEGACY
is enabled.

We are going to define 3 functions to check the search results, introduce
the macro DEFINE_CHECK_SEARCH_FUNC() to reduce duplicate code.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/Kconfig             | 11 ++++++
 fs/smb/client/Makefile            |  1 +
 fs/smb/client/smb1maperror.c      | 19 ++++++++++
 fs/smb/client/smb1maperror_test.c | 61 +++++++++++++++++++++++++++++++
 fs/smb/client/smb1proto.h         |  4 ++
 5 files changed, 96 insertions(+)
 create mode 100644 fs/smb/client/smb1maperror_test.c

diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index 17bd368574e9..2e72d3c8423f 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -217,4 +217,15 @@ config CIFS_COMPRESSION
 	  Say Y here if you want SMB traffic to be compressed.
 	  If unsure, say N.
 
+config SMB1_KUNIT_TESTS
+	tristate "KUnit tests for SMB1"
+	depends on SMB_KUNIT_TESTS && CIFS_ALLOW_INSECURE_LEGACY
+	default SMB_KUNIT_TESTS
+	help
+	  This builds the SMB1-specific KUnit tests.
+
+	  These tests are only enabled when legacy insecure SMB1 support
+	  (CIFS_ALLOW_INSECURE_LEGACY) is enabled.
+
+	  If unsure, say N.
 endif
diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
index 8560fe99ec2b..220a97c8a488 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -71,6 +71,7 @@ $(obj)/smb2maperror.o: $(obj)/smb2_mapping_table.c
 quiet_cmd_gen_smb2_mapping = GEN     $@
       cmd_gen_smb2_mapping = perl $(src)/gen_smb2_mapping $< $@
 
+obj-$(CONFIG_SMB1_KUNIT_TESTS) += smb1maperror_test.o
 obj-$(CONFIG_SMB_KUNIT_TESTS) += smb2maperror_test.o
 
 # Let Kbuild handle tracking and cleaning
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 66ceebbe535e..419057f296a7 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -288,3 +288,22 @@ int __init smb1_init_maperror(void)
 
 	return rc;
 }
+
+#if IS_ENABLED(CONFIG_SMB1_KUNIT_TESTS)
+#define EXPORT_SYMBOL_FOR_SMB_TEST(sym) \
+	EXPORT_SYMBOL_FOR_MODULES(sym, "smb1maperror_test")
+
+const struct ntstatus_to_dos_err *
+search_ntstatus_to_dos_map_test(__u32 ntstatus)
+{
+	return search_ntstatus_to_dos_map(ntstatus);
+}
+EXPORT_SYMBOL_FOR_SMB_TEST(search_ntstatus_to_dos_map_test);
+
+const struct ntstatus_to_dos_err *
+ntstatus_to_dos_map_test = ntstatus_to_dos_map;
+EXPORT_SYMBOL_FOR_SMB_TEST(ntstatus_to_dos_map_test);
+
+unsigned int ntstatus_to_dos_num = ARRAY_SIZE(ntstatus_to_dos_map);
+EXPORT_SYMBOL_FOR_SMB_TEST(ntstatus_to_dos_num);
+#endif
diff --git a/fs/smb/client/smb1maperror_test.c b/fs/smb/client/smb1maperror_test.c
new file mode 100644
index 000000000000..b38857dc388c
--- /dev/null
+++ b/fs/smb/client/smb1maperror_test.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *
+ *   KUnit tests of SMB1 maperror
+ *
+ *   Copyright (C) 2026 KylinSoft Co., Ltd. All rights reserved.
+ *   Author(s): Youling Tang <tangyouling@kylinos.cn>
+ *              ChenXiaoSong <chenxiaosong@kylinos.cn>
+ *
+ */
+
+#include <kunit/test.h>
+#include "smb1proto.h"
+#include "nterr.h"
+
+extern const struct ntstatus_to_dos_err *ntstatus_to_dos_map_test;
+extern unsigned int ntstatus_to_dos_num;
+
+#define DEFINE_CHECK_SEARCH_FUNC(__struct_name, __field,		\
+				 __array, __num)			\
+static void check_search_ ## __array(struct kunit *test)		\
+{									\
+	unsigned int i;							\
+	const struct __struct_name *expect, *result;			\
+									\
+	for (i = 0; i < __num; i++) {					\
+		expect = &__array ## _test[i];				\
+		result = search_ ## __array ## _test(expect->__field);	\
+		KUNIT_ASSERT_NOT_NULL(test, result);			\
+		test_cmp_ ## __struct_name(test, expect, result);	\
+	}								\
+}
+
+static void
+test_cmp_ntstatus_to_dos_err(struct kunit *test,
+			     const struct ntstatus_to_dos_err *expect,
+			     const struct ntstatus_to_dos_err *result)
+{
+	KUNIT_EXPECT_EQ(test, expect->dos_class, result->dos_class);
+	KUNIT_EXPECT_EQ(test, expect->dos_code, result->dos_code);
+	KUNIT_EXPECT_EQ(test, expect->ntstatus, result->ntstatus);
+	KUNIT_EXPECT_STREQ(test, expect->nt_errstr, result->nt_errstr);
+}
+
+/* check_search_ntstatus_to_dos_map */
+DEFINE_CHECK_SEARCH_FUNC(ntstatus_to_dos_err, ntstatus, ntstatus_to_dos_map,
+			 ntstatus_to_dos_num);
+
+static struct kunit_case maperror_test_cases[] = {
+	KUNIT_CASE(check_search_ntstatus_to_dos_map),
+	{}
+};
+
+static struct kunit_suite maperror_suite = {
+	.name = "smb1_maperror",
+	.test_cases = maperror_test_cases,
+};
+
+kunit_test_suite(maperror_suite);
+
+MODULE_LICENSE("GPL");
diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
index dd98d04e837a..43b773e7964b 100644
--- a/fs/smb/client/smb1proto.h
+++ b/fs/smb/client/smb1proto.h
@@ -237,6 +237,10 @@ int map_smb_to_linux_error(char *buf, bool logErr);
 int smb1_init_maperror(void);
 int map_and_check_smb_error(struct TCP_Server_Info *server,
 			    struct mid_q_entry *mid, bool logErr);
+#if IS_ENABLED(CONFIG_SMB1_KUNIT_TESTS)
+const struct ntstatus_to_dos_err *
+search_ntstatus_to_dos_map_test(__u32 ntstatus);
+#endif
 
 /*
  * smb1misc.c
-- 
2.53.0

