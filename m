Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1016C23EAB9
	for <linux-cifs@vger.kernel.org>; Wed, 24 Dec 2025 02:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766543595; cv=none; b=XOwCr3Ysn1h6UC1PpAsBHGVzVs2wcAu8OKp99e4ULD89FMy7daTJCxAhpJ83TzuCUQ85ulg2P6bDCTtk9XX7fPv3YukEbfZ4jXezI2rk2olxbOF9WzfopIgmfbTWTRh4wuHHYJTxNbIC67lM2pQlbc/gq8aNhgvcY61qBPpsdBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766543595; c=relaxed/simple;
	bh=m0iA1VRA0MoVzfLDkFQmu0pxIwls3yuwWPihoI4Bdm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZ08eSNe17tK/fV/T0HNRMNGYAvnKKgmvqDzkUwwqpyRFUyA4oNqh9cNTCuxttBj4kkgTSqUYHnSxSf4aeVhLzexdKkkbEBjZo8U84K5I04FEGwqWQU0pkDgAb1a5ISvHrvHjnE9uPUf2vHBvuTexv9N3Fl6YuVVRbDjsv5AQjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CO2ddxQW; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CO2ddxQW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766543589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ICyGjfBpFiQcaN/szhEtjItEwqHKIkbg35LZk7Wl/CM=;
	b=CO2ddxQWcD/onviTYpHPqe0mPDBgdbfX4JpvLkZujiqgkq/r42SoK/LPPWvdhRpfi27ILt
	4u8Jiju/IqV719xS8+uMDOQtMxF+sXQjbIgbWBqMTBBsSAJrb823BiKHzBuBbV7DEgAw8d
	ZhG8eDdB3VSxFlopJMW5hqNSYcJke1g=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 5/5] smb/client: introduce KUnit test to check search result of smb2_error_map_table
Date: Wed, 24 Dec 2025 10:31:44 +0800
Message-ID: <20251224023145.608165-6-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251224023145.608165-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251224023145.608165-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The KUnit test are executed when cifs.ko is loaded.

Just like `fs/ext4/mballoc.c` includes `fs/ext4/mballoc-test.c`.
`smb2maperror.c` also includes `smb2maperror_test.c`, allowing KUnit
tests to access any functions and variables in `smb2maperror.c`.

The maperror_test_check_search() checks whether all elements can be
correctly found in the array.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/Kconfig                    | 17 +++++++++++
 fs/smb/client/smb2maperror.c      |  4 +++
 fs/smb/client/smb2maperror_test.c | 48 +++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+)
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
index e47564cc3a04..e71ee23400e8 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -114,3 +114,7 @@ int smb2_init_maperror(void)
 
 	return 0;
 }
+
+#if IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
+#include "smb2maperror_test.c"
+#endif /* CONFIG_SMB_KUNIT_TESTS */
diff --git a/fs/smb/client/smb2maperror_test.c b/fs/smb/client/smb2maperror_test.c
new file mode 100644
index 000000000000..bb2ae4f32611
--- /dev/null
+++ b/fs/smb/client/smb2maperror_test.c
@@ -0,0 +1,48 @@
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
+static void
+test_cmp_map(struct kunit *test, struct status_to_posix_error *expect)
+{
+	struct status_to_posix_error *result;
+
+	result = smb2_get_err_map(expect->smb2_status);
+	KUNIT_EXPECT_PTR_NE(test, NULL, result);
+	KUNIT_EXPECT_EQ(test, expect->smb2_status, result->smb2_status);
+	KUNIT_EXPECT_EQ(test, expect->posix_error, result->posix_error);
+	KUNIT_EXPECT_STREQ(test, expect->status_string, result->status_string);
+}
+
+static void maperror_test_check_search(struct kunit *test)
+{
+	unsigned int i;
+	struct status_to_posix_error expect;
+
+	for (i = 0; i < err_map_num; i++) {
+		expect = smb2_error_map_table[i];
+		test_cmp_map(test, &expect);
+	}
+}
+
+static struct kunit_case maperror_test_cases[] = {
+	KUNIT_CASE(maperror_test_check_search),
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

