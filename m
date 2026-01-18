Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382CB292B44
	for <linux-cifs@vger.kernel.org>; Sun, 18 Jan 2026 09:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768727683; cv=none; b=mrjZz5SvCiYibDtq7JpCzo2f5zzmLgWGtVn/Veeg5iYe1CAztW5F6HHDun4gA38mGg1DNpwfrUP/F9A798coapZNMwF56xbW5NDz5fvR9c9MJvhQ/exqA/daIXz232cERsQ+z+DMiX3d+/ZqhgSQ4M+BdnvpSTF/T0A0QLwQnYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768727683; c=relaxed/simple;
	bh=b4oM9UhyTwGAkxU6n5EhGo6wde+vwTeuPyulD2wYNVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1vgZ+En7WGmikbHycUnqryKXtDjdNAF03JdIZbJJtJVvbgco5FQADcl/Nfy0hr6744bPDHuo2CxJG6QyGZ08J8qBl2UakTfw6y6e1wUYT16Rth0jzwX2VFHqYgrSDUtA6GK1XnzBN5E4cUCmC9/n6vOYwEHbKwqjBBhQTsboa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SrZ2GOKL; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SrZ2GOKL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768727677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jK6vYjpGieE1UkxbNNS2zgCQfHBJhgYS9qsVC5jK7Dw=;
	b=SrZ2GOKLocFKfe/e7a1ry0DQSwoA3+ezITMuYUuIf5pMQBDPdkR5YDfVq/ASY+7srYSFbo
	hKJ92g1jGfJVoaGOOfUBdlWfNBo82iL6uh6/NXjbx91O2jKJUEA5ZIwu8dbbtJ29J9hHh0
	wfzsYlePE/n62W/7lHQWxQj1IdQfNJ4=
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
Subject: [PATCH v9 1/1] smb/client: introduce KUnit test to check search result of smb2_error_map_table
Date: Sun, 18 Jan 2026 17:13:13 +0800
Message-ID: <20260118091313.1988168-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260118091313.1988168-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260118091313.1988168-1-chenxiaosong.chenxiaosong@linux.dev>
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

Suggested-by: David Howells <dhowells@redhat.com>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/Kconfig                    | 17 ++++++++++++
 fs/smb/client/smb2maperror.c      |  8 ++++++
 fs/smb/client/smb2maperror_test.c | 45 +++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+)
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
index 090bbd10623d..cd036365201f 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -114,3 +114,11 @@ int __init smb2_init_maperror(void)
 
 	return 0;
 }
+
+#define SMB_CLIENT_KUNIT_AVAILABLE \
+	((IS_MODULE(CONFIG_CIFS) && IS_ENABLED(CONFIG_KUNIT)) || \
+	 (IS_BUILTIN(CONFIG_CIFS) && IS_BUILTIN(CONFIG_KUNIT)))
+
+#if SMB_CLIENT_KUNIT_AVAILABLE && IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
+#include "smb2maperror_test.c"
+#endif /* CONFIG_SMB_KUNIT_TESTS */
diff --git a/fs/smb/client/smb2maperror_test.c b/fs/smb/client/smb2maperror_test.c
new file mode 100644
index 000000000000..38ea6b846a99
--- /dev/null
+++ b/fs/smb/client/smb2maperror_test.c
@@ -0,0 +1,45 @@
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
+test_cmp_map(struct kunit *test, const struct status_to_posix_error *expect)
+{
+	const struct status_to_posix_error *result;
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
+
+	for (i = 0; i < ARRAY_SIZE(smb2_error_map_table); i++)
+		test_cmp_map(test, &smb2_error_map_table[i]);
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

