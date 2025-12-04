Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4EA30274F
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 05:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764824402; cv=none; b=Lh6bISIcbgc3x3cZbPMGAYR067gGO9ueQ3/6xcv2z1a+lwlrIhDiQRfDExrkttxHKCcDx7I3EXEu/GJv5ER/OuZ5DoviJEWswwwOd82f4BD0pJjAsoK0dAHlHuJ+m6UTLpkHId27s0UJosSl4sSNd1Do5ATVTYq4qSePSASYNKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764824402; c=relaxed/simple;
	bh=4+703upttbLBXrs3HCR/osHe0MWHMFb29STOXf/zQlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvhNGXEu+V2hpQ4g4e9t28FKINXZdLeyk9Winy1pXeo789gUWC3YL6p9hPYIACmsxNW272SpFVzhP6d+IIjc89rhdHqwoIAXG13arEiENmTLgshs0RgGZmB4oC88v80g74VsMA08eRpEUY7moEHhzKyj0uROLgN8buj05lssJ8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QQ8J43FU; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QQ8J43FU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764824398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/IbInYvILPYcoixt21Z2SWUU0ENgDuclZexoYjmKwdA=;
	b=QQ8J43FU7vXA9gornvj10rsWDLILzH2n09kzLp482izhx8quqiH4BcUWNRT3lkpgB8VFXZ
	CEo5Rg8eAQQne0uP90loN+LpECh+cymdFtzyMrdr4sjTi/3iGmsQpFV5uH8dtFS3mtH6kG
	KNLgBsLjI81NE+92vbRIdnpWI+bUQUw=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 07/10] smb/client: introduce smb2maperror KUnit tests
Date: Thu,  4 Dec 2025 12:58:15 +0800
Message-ID: <20251204045818.2590727-8-chenxiaosong.chenxiaosong@linux.dev>
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

The KUnit tests are executed when cifs.ko is loaded.

The maperror_test_check_sort() checks whether the array is properly sorted.

The maperror_test_get_err_map() checks whether the expected element can be
correctly searched for in the smb2_error_map_table array.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/Kconfig               | 13 ++++++
 fs/smb/client/smb2maperror.c | 77 ++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/fs/smb/Kconfig b/fs/smb/Kconfig
index ef425789fa6a..95b29d089e60 100644
--- a/fs/smb/Kconfig
+++ b/fs/smb/Kconfig
@@ -9,3 +9,16 @@ config SMBFS
 	tristate
 	default y if CIFS=y || SMB_SERVER=y
 	default m if CIFS=m || SMB_SERVER=m
+
+config SMB_KUNIT_TEST
+	bool "SMB KUnit tests" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Only useful for kernel devs running KUnit test harness and are not
+	  for inclusion into a production build.
+
+	  For more information on KUnit and unit tests in general please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index f5d999f3b569..95e4a41ecc5a 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -2497,3 +2497,80 @@ void smb2_init_maperror(void)
 	     sizeof(struct status_to_posix_error),
 	     cmp_smb2_status, NULL);
 }
+
+#if IS_ENABLED(CONFIG_SMB_KUNIT_TEST)
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
+	.name = "smb2-maperror",
+	.test_cases = maperror_test_cases,
+};
+
+kunit_test_suite(maperror_suite);
+#endif /* CONFIG_SMB_KUNIT_TEST */
-- 
2.43.0

