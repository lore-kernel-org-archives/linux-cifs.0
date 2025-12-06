Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB25B26F2B8
	for <linux-cifs@vger.kernel.org>; Sat,  6 Dec 2025 15:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765034403; cv=none; b=Sms0MRbBQNyH/m/0mIw9Gje+e5R1T0BXo2CAx68buI+NER/RwnlaRVJg1iPLNP9NfRLAUYYIK6IV8GI+xAqAT3nDxRdpnpy5V8la8ctnSK41ZSe0peCReqANPSTPiimnBM0lH4wsc+G+2At4Hg3OpLsJKnoJ09YI2aPOWKDLLSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765034403; c=relaxed/simple;
	bh=ItznE9xO9nE+ynYfhpI9VzpnAVK16BiNAzqrCTv3Ju0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHjbdpziXl6fw/Bv1MyyAh+8jAw9ED86SSwOtFhiiL8/5ASY2LkvFXtYEvm4ScE36iFFnvtrMM/k0/0fDBlivR4Fol5kYOdNBNX7v82zQRT0Xg4nGkWVntnviU7KuufEfXws79lX9eXJMTZAyqWlEbjiFXi7z08zHnFtpfHMSVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JVRbMz5/; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JVRbMz5/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765034398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wd88q46PpGK00oQptPYJ58tyZw7mx6W7G+ZzZQ0l7ZQ=;
	b=JVRbMz5/VeV8JD0bGXNImIr8tbeGU2m7fe9URUYUVbmwJ1aXNTZoHgHzdEg2EhwGyjq6gj
	1iGCkqY9XLVsfZ1Tm0oO4HQs8dilzBv6ykB3De4cUmL1Jem5ceGZGOwida7Q+0Yl9lGYjk
	LlovFRzCD36U1ji3ljxW+UAH3LuMw/E=
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
Subject: [PATCH v4 08/10] smb/client: introduce smb2maperror KUnit tests
Date: Sat,  6 Dec 2025 23:18:24 +0800
Message-ID: <20251206151826.2932970-9-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev>
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

The maperror_test_check_search() checks whether the expected element can be
correctly searched for in the smb2_error_map_table array.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/Kconfig                    | 17 ++++++++
 fs/smb/client/smb2maperror.c      |  4 ++
 fs/smb/client/smb2maperror_test.c | 71 +++++++++++++++++++++++++++++++
 3 files changed, 92 insertions(+)
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
index 000000000000..b807a860ca59
--- /dev/null
+++ b/fs/smb/client/smb2maperror_test.c
@@ -0,0 +1,71 @@
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
+/*
+ * Before running these test cases, the smb2_init_maperror()
+ * function is called first.
+ */
+static struct kunit_case maperror_test_cases[] = {
+	KUNIT_CASE(maperror_test_check_sort),
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

