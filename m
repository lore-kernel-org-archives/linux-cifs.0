Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EB51624D5
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 04:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764909083; cv=none; b=S/Sd8UtykOLU3wRS/1hhVVcz+dFq+TTTjQXrFGN49rT7SHpUfNEF+70ndMTMObnIs4T/QumcfeuTLI7vUWKAMknHuJh5XARNZMjRqe55peUUC8ioirzSU4Q9DD6m6J9vody1h6VwuiJdmW8DtQDN1OoRaqKBKr7vNEpiRl8LnJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764909083; c=relaxed/simple;
	bh=4+703upttbLBXrs3HCR/osHe0MWHMFb29STOXf/zQlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRZ8kY8JH5jPnd2Cd06uGYGJY5/xW+uo5c6SG3yzgiQPg0tAgtlPrtj0lOEwwOsEtdr7GjFv447y8fEFxA8hzFus289nL0JFUJi3MRyaHndo4pMkOdusdPMPI3QEUHWYzmGBY5vDoyxIHQyXGuQrR/NNGkF3TIswptf8XOwpTGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TKM9D1Ho; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TKM9D1Ho"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764909079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/IbInYvILPYcoixt21Z2SWUU0ENgDuclZexoYjmKwdA=;
	b=TKM9D1HoXxt9Y5NphY20zpbQ6r9CFJNwnoLhfjUAeUCi8hl4ZAA9TASk4eGqXSP7NM12cs
	+eugVup//dbEbol8cFusnZTGmBA8cBXs4xvBsC8sQgKJwB59Ug8RVMJ202IbF9Ax8zCIX1
	HzEuhj0tDkjKhuQVexyh1xZJr0OFl4c=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 8/9] smb/client: introduce smb2maperror KUnit tests
Date: Fri,  5 Dec 2025 12:29:56 +0800
Message-ID: <20251205042958.2658496-9-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251205042958.2658496-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251205042958.2658496-1-chenxiaosong.chenxiaosong@linux.dev>
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

