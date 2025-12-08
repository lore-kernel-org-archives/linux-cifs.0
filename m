Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61371242D9D
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765174982; cv=none; b=CwBg76dVETd/O9fiU11wLfDvFFiY6Dveu2JFT9+9AbnqRk2uGwxTPbNPV2in2pIDBBMZnD0wTvT5vl7nof7jwO1Bhgq6LqVdFs8GMgGMLX/GAP6QOlDOqeXMKMEPqed1ptP8B2dnp/xwkB+JdJKjkUw0//ciXgSelI6D/tyvuL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765174982; c=relaxed/simple;
	bh=w0nNCAawtWga2Wz7UljYjaZNJs1R7DG4IhmvbN7y/hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4AIt0jqof7IJBDI4UNp6hRMSzsQg7ZDIRPpZ68ebt3feFxUsXTySKYphTiFC/i+vKJlgAyw3sRLPZ+Xx4NC+ijLFlHn4bDvqYNUORPPUO8hrZg+oOODD3iOaxhhX4oTVKCxa402WVXTCFAJMUKj0cqeeHG3G9sFu0kZTeGW0HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F7fMAAhL; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F7fMAAhL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765174978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K1lLUuJbzKaoVowgzOVVnSVe2ltCt18Z1gofNbgQXKI=;
	b=F7fMAAhLT/QEFhI6YEI7tE1VkGZB4ujNJJgejYJHLjKYIiKnGcpb/ewcqVkODhvDyLM+Sd
	Yv2uGZutBdzUKGva4E7p5t4acF5aB7d7e+rZOawB5kJ7Xyn3Jo7prvSPuSX1THypP3hYgZ
	gCF4JphhFmTZO3qZnPSlgtJxI/8IrR8=
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
Subject: [PATCH 09/30] smb/client: create netmisc_test.c and introduce DEFINE_CHECK_SORT_FUNC()
Date: Mon,  8 Dec 2025 14:20:39 +0800
Message-ID: <20251208062100.3268777-10-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

We are going to define 4 functions to check the sort results, introduce the
macro DEFINE_CHECK_SORT_FUNC() to reduce duplicate code.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc.c      |  4 ++++
 fs/smb/client/netmisc_test.c | 46 ++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)
 create mode 100644 fs/smb/client/netmisc_test.c

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 54ede1db2c7f..32197a3a4e81 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -1056,3 +1056,7 @@ void smb_init_maperror(void)
 	sort(ntstatus_to_dos_map, ntstatus_to_dos_num,
 	     sizeof(struct ntstatus_to_dos), cmp_ntstatus_to_dos, NULL);
 }
+
+#if IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
+#include "netmisc_test.c"
+#endif /* CONFIG_SMB_KUNIT_TESTS */
diff --git a/fs/smb/client/netmisc_test.c b/fs/smb/client/netmisc_test.c
new file mode 100644
index 000000000000..f937b7b3d3f2
--- /dev/null
+++ b/fs/smb/client/netmisc_test.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ *
+ *   KUnit tests of SMB1 maperror
+ *
+ *   Copyright (C) 2025 KylinSoft Co., Ltd. All rights reserved.
+ *   Author(s): ChenXiaoSong <chenxiaosong@kylinos.cn>
+ *
+ */
+
+#include <kunit/test.h>
+
+#define DEFINE_CHECK_SORT_FUNC(__array, __num, __field)			\
+static void __array ## _check_sort(struct kunit *test)			\
+{									\
+	bool is_sorted = true;						\
+	unsigned int i;							\
+									\
+	for (i = 1; i < __num; i++) {					\
+		if (__array[i].__field >= __array[i - 1].__field)	\
+			continue;					\
+									\
+		pr_err("%s array order is incorrect\n", #__array);	\
+		is_sorted = false;					\
+		break;							\
+	}								\
+									\
+	KUNIT_EXPECT_EQ(test, true, is_sorted);				\
+}
+
+/*
+ * Before running these test cases, the smb_init_maperror()
+ * function is called first.
+ */
+static struct kunit_case maperror_test_cases[] = {
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
-- 
2.43.0

