Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99134329C61
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764941236; cv=none; b=Dax+XdyVaneapzb0OWVBq44tScxc61iBQiQgI8gyPwNNlc3q9kEfDyCvfo2y/KEUtX4+IQrkcO47dL7/6ajXRDJQmxmA/eDmYzCLGQS61+FqJ1tPicLRvzBlCvXtWxghGY9MKhRT2OR1rhvQm1tJeFjGFZsPQOMjh8niAyh6ZHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764941236; c=relaxed/simple;
	bh=0Dt6ThJmpUM6jUb+9ufYLCI4cNN15hOgHOmxlzosTq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cb+2asRxSov5GagrcrNUJHAHD253m3uzyBw3P7XHeEesv/DZelG+AEk5mWkSuSLaz07892WlSfxi/nro/hgzARqxi15mDFLfKMxrCBGVzLkZ7NmBZybcLwx801YRm8WBKwpzKnIiu0oP+Y9g8AHeBlOewotKjcM4kSph3AZ8lG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PzfhaFof; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PzfhaFof"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764941228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7pXCTgJnAzruXxECTbbkqU5nEeqNlzfC8x7e87fcV7s=;
	b=PzfhaFoft/QxQzYZJkkZO+YZ7ciVv9yyKq2tFDBbeQhnvMMEhX91X5qpUNT5SVjVyHfGVn
	g1u+GeEFWHDJASpe5ePVmKHPJgi/qVyqktVkl5GCwH4ylwQcOgUnKkQLPBWOhaOcytuBR4
	Xqb/0vJCqmYs2GHLVCrfra7Ce9EXBAc=
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
Subject: [PATCH v3 8/9] smb/client: introduce smb2maperror KUnit tests
Date: Fri,  5 Dec 2025 21:25:34 +0800
Message-ID: <20251205132536.2703110-9-chenxiaosong.chenxiaosong@linux.dev>
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

The KUnit tests are executed when cifs.ko is loaded.

Just like fs/ext4/mballoc.c includes fs/ext4/mballoc-test.c.
smb2maperror.c also includes smb2maperror_test.c, allowing KUnit tests to
access any functions and variables in smb2maperror.c.

The maperror_test_check_sort() checks whether the array is properly sorted.

The maperror_test_get_err_map() checks whether the expected element can be
correctly searched for in the smb2_error_map_table array.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/Kconfig                    | 17 ++++++
 fs/smb/client/smb2maperror.c      |  4 ++
 fs/smb/client/smb2maperror_test.c | 86 +++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+)
 create mode 100644 fs/smb/client/smb2maperror_test.c

diff --git a/fs/smb/Kconfig b/fs/smb/Kconfig
index ef425789fa6a..85f7ad5fbc5e 100644
--- a/fs/smb/Kconfig
+++ b/fs/smb/Kconfig
@@ -9,3 +9,20 @@ config SMBFS
 	tristate
 	default y if CIFS=y || SMB_SERVER=y
 	default m if CIFS=m || SMB_SERVER=m
+
+config SMB_KUNIT_TESTS
+	tristate "KUnit tests for SMB" if !KUNIT_ALL_TESTS
+	depends on SMBFS && KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the SMB KUnit tests.
+
+	  KUnit tests run during boot and output the results to the debug log
+	  in TAP format (https://testanything.org/). Only useful for kernel devs
+	  running KUnit test harness and are not for inclusion into a production
+	  build.
+
+	  For more information on KUnit and unit tests in general please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index 0d46fa98952c..dc2edeafc93b 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -2490,3 +2490,7 @@ void smb2_init_maperror(void)
 	     sizeof(struct status_to_posix_error),
 	     cmp_smb2_status, NULL);
 }
+
+#if IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
+#include "smb2maperror_test.c"
+#endif /* CONFIG_SMB_KUNIT_TESTS */
diff --git a/fs/smb/client/smb2maperror_test.c b/fs/smb/client/smb2maperror_test.c
new file mode 100644
index 000000000000..d2f3123e0676
--- /dev/null
+++ b/fs/smb/client/smb2maperror_test.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ *
+ *   KUnit tests of SMB2 maperror
+ *
+ *   Copyright (C) 2025 KylinSoft Co., Ltd. All rights reserved.
+ *   Author(s): ChenXiaoSong <chenxiaosong@kylinos.cn>
+ *
+ */
+
+#include <kunit/test.h>
+
+static void maperror_test_check_sort(struct kunit *test)
+{
+	bool is_sorted = true;
+	unsigned int i;
+
+	for (i = 1; i < err_map_num; i++) {
+		if (smb2_error_map_table[i].smb2_status >=
+		    smb2_error_map_table[i - 1].smb2_status)
+			continue;
+
+		pr_err("smb2_error_map_table array order is incorrect\n");
+		is_sorted = false;
+		break;
+	}
+
+	KUNIT_EXPECT_EQ(test, true, is_sorted);
+}
+
+static void
+get_and_cmp_err_map(struct kunit *test, struct status_to_posix_error *expect)
+{
+	struct status_to_posix_error *result;
+
+	result = smb2_get_err_map(expect->smb2_status);
+	KUNIT_EXPECT_PTR_NE(test, NULL, result);
+	KUNIT_EXPECT_EQ(test, expect->posix_error, result->posix_error);
+	KUNIT_EXPECT_STREQ(test, expect->status_string, result->status_string);
+}
+
+static void maperror_test_get_err_map(struct kunit *test)
+{
+	struct status_to_posix_error expect;
+
+	/* first element */
+	expect = smb2_error_map_table[0];
+	get_and_cmp_err_map(test, &expect);
+
+	/* last element */
+	expect = smb2_error_map_table[err_map_num - 1];
+	get_and_cmp_err_map(test, &expect);
+
+	expect = (struct status_to_posix_error) {
+		.smb2_status = STATUS_SERIAL_COUNTER_TIMEOUT,
+		.posix_error = -ETIMEDOUT,
+		.status_string = "STATUS_SERIAL_COUNTER_TIMEOUT",
+	};
+	get_and_cmp_err_map(test, &expect);
+
+	expect = (struct status_to_posix_error) {
+		.smb2_status = STATUS_IO_REPARSE_TAG_NOT_HANDLED,
+		.posix_error = -EOPNOTSUPP,
+		.status_string = "STATUS_REPARSE_NOT_HANDLED",
+	};
+	get_and_cmp_err_map(test, &expect);
+}
+
+/*
+ * Before running these test cases, the smb2_init_maperror()
+ * function is called first.
+ */
+static struct kunit_case maperror_test_cases[] = {
+	KUNIT_CASE(maperror_test_check_sort),
+	KUNIT_CASE(maperror_test_get_err_map),
+	{}
+};
+
+static struct kunit_suite maperror_suite = {
+	.name = "smb2_maperror",
+	.test_cases = maperror_test_cases,
+};
+
+kunit_test_suite(maperror_suite);
+
+MODULE_LICENSE("GPL");
-- 
2.43.0

