Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410A923EA85
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 14:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775139622; cv=none; b=TGqRGG0ubExgwVgduPsMAH86c/04CxTCRPKotffNRl/QHYEbhTYs+6rQGowlcLZ5lbV3iRpoLdZpclFM5AFmi6L5PU0cPiWm0tg5xnBTCaxwYLN08OhP5y0Pr/8KNuCW7HIIMz7ZkK2v6LHds5AZ/Y0Up6C9ljZCVVeNi8QV0uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775139622; c=relaxed/simple;
	bh=QSSJTMc2GDyONWHj/8mxA1ksfbquFhlZfD2GH6xQe4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvcT5hr5N7uuZ8pCqMp6BT04ZXcPnCeLRWamS0fUt9FkTSBI5oMRmKHglGKEu51LcdcaJFTzUQwZHK8hjgWkYm1XPTJEkxXCDD9uSUg73xBxrDP5r4hhQFtpVZe9sDdVfZ1wlzTWqK6RVKZuVbmxCkepIkoelP3neohoikyA/Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sRsAgCET; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sRsAgCET"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775139619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4hkOz/9ZrCAW2nUvtbPrZi1e/vtm1eSKJN9kgwDc7B8=;
	b=sRsAgCETSO+KKunS9Np0axAbuuf9fIJyL1R/VQF2Bq4moXkvjGAiBbH4cGylk01fHZfRgO
	6Re+w43nWxjYMqkCGZD9lE3nKOipJ/yTP6ZnuzfjzIIupcbY2dwYXREdD/T9Ep/DnC6EJz
	TVnWt7KzYnkBzTdftFiI2kOVAqeNJPg=
From: huiwen.he@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com,
	tangyouling@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v3 13/13] smb/client: introduce KUnit tests to check DOS/SRV err mapping search
Date: Thu,  2 Apr 2026 14:18:39 +0000
Message-ID: <20260402141839.461257-14-huiwen.he@linux.dev>
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

Check whether all elements can be correctly found in the arrays.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb1maperror.c      | 33 ++++++++++++++++++++++++++-----
 fs/smb/client/smb1maperror_test.c | 22 +++++++++++++++++++++
 fs/smb/client/smb1proto.h         |  4 ++++
 fs/smb/client/smberr.h            |  5 +++++
 4 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index bca9b60ac836..74530088d17d 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -16,11 +16,6 @@
 #include "nterr.h"
 #include "cifs_debug.h"
 
-struct smb_to_posix_error {
-	__u16 smb_err;
-	int posix_code;
-};
-
 static __always_inline int smb1_posix_error_cmp(const void *_key, const void *_pivot)
 {
 	__u16 key = *(__u16 *)_key;
@@ -260,4 +255,32 @@ EXPORT_SYMBOL_FOR_SMB_TEST(ntstatus_to_dos_map_test);
 
 unsigned int ntstatus_to_dos_num = ARRAY_SIZE(ntstatus_to_dos_map);
 EXPORT_SYMBOL_FOR_SMB_TEST(ntstatus_to_dos_num);
+
+const struct smb_to_posix_error *
+search_mapping_table_ERRDOS_test(__u16 smb_err)
+{
+	return search_mapping_table_ERRDOS(smb_err);
+}
+EXPORT_SYMBOL_FOR_SMB_TEST(search_mapping_table_ERRDOS_test);
+
+const struct smb_to_posix_error *
+mapping_table_ERRDOS_test = mapping_table_ERRDOS;
+EXPORT_SYMBOL_FOR_SMB_TEST(mapping_table_ERRDOS_test);
+
+unsigned int mapping_table_ERRDOS_num = ARRAY_SIZE(mapping_table_ERRDOS);
+EXPORT_SYMBOL_FOR_SMB_TEST(mapping_table_ERRDOS_num);
+
+const struct smb_to_posix_error *
+search_mapping_table_ERRSRV_test(__u16 smb_err)
+{
+	return search_mapping_table_ERRSRV(smb_err);
+}
+EXPORT_SYMBOL_FOR_SMB_TEST(search_mapping_table_ERRSRV_test);
+
+const struct smb_to_posix_error *
+mapping_table_ERRSRV_test = mapping_table_ERRSRV;
+EXPORT_SYMBOL_FOR_SMB_TEST(mapping_table_ERRSRV_test);
+
+unsigned int mapping_table_ERRSRV_num = ARRAY_SIZE(mapping_table_ERRSRV);
+EXPORT_SYMBOL_FOR_SMB_TEST(mapping_table_ERRSRV_num);
 #endif
diff --git a/fs/smb/client/smb1maperror_test.c b/fs/smb/client/smb1maperror_test.c
index b38857dc388c..935142dfdcb0 100644
--- a/fs/smb/client/smb1maperror_test.c
+++ b/fs/smb/client/smb1maperror_test.c
@@ -12,9 +12,14 @@
 #include <kunit/test.h>
 #include "smb1proto.h"
 #include "nterr.h"
+#include "smberr.h"
 
 extern const struct ntstatus_to_dos_err *ntstatus_to_dos_map_test;
 extern unsigned int ntstatus_to_dos_num;
+extern const struct smb_to_posix_error *mapping_table_ERRDOS_test;
+extern unsigned int mapping_table_ERRDOS_num;
+extern const struct smb_to_posix_error *mapping_table_ERRSRV_test;
+extern unsigned int mapping_table_ERRSRV_num;
 
 #define DEFINE_CHECK_SEARCH_FUNC(__struct_name, __field,		\
 				 __array, __num)			\
@@ -42,12 +47,29 @@ test_cmp_ntstatus_to_dos_err(struct kunit *test,
 	KUNIT_EXPECT_STREQ(test, expect->nt_errstr, result->nt_errstr);
 }
 
+static void
+test_cmp_smb_to_posix_error(struct kunit *test,
+			    const struct smb_to_posix_error *expect,
+			    const struct smb_to_posix_error *result)
+{
+	KUNIT_EXPECT_EQ(test, expect->smb_err, result->smb_err);
+	KUNIT_EXPECT_EQ(test, expect->posix_code, result->posix_code);
+}
+
 /* check_search_ntstatus_to_dos_map */
 DEFINE_CHECK_SEARCH_FUNC(ntstatus_to_dos_err, ntstatus, ntstatus_to_dos_map,
 			 ntstatus_to_dos_num);
+/* check_search_mapping_table_ERRDOS */
+DEFINE_CHECK_SEARCH_FUNC(smb_to_posix_error, smb_err, mapping_table_ERRDOS,
+			 mapping_table_ERRDOS_num);
+/* check_search_mapping_table_ERRSRV */
+DEFINE_CHECK_SEARCH_FUNC(smb_to_posix_error, smb_err, mapping_table_ERRSRV,
+			 mapping_table_ERRSRV_num);
 
 static struct kunit_case maperror_test_cases[] = {
 	KUNIT_CASE(check_search_ntstatus_to_dos_map),
+	KUNIT_CASE(check_search_mapping_table_ERRDOS),
+	KUNIT_CASE(check_search_mapping_table_ERRSRV),
 	{}
 };
 
diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
index 43b773e7964b..7d5da03111c1 100644
--- a/fs/smb/client/smb1proto.h
+++ b/fs/smb/client/smb1proto.h
@@ -240,6 +240,10 @@ int map_and_check_smb_error(struct TCP_Server_Info *server,
 #if IS_ENABLED(CONFIG_SMB1_KUNIT_TESTS)
 const struct ntstatus_to_dos_err *
 search_ntstatus_to_dos_map_test(__u32 ntstatus);
+const struct smb_to_posix_error *
+search_mapping_table_ERRDOS_test(__u16 smb_err);
+const struct smb_to_posix_error *
+search_mapping_table_ERRSRV_test(__u16 smb_err);
 #endif
 
 /*
diff --git a/fs/smb/client/smberr.h b/fs/smb/client/smberr.h
index 4ec2c5ffae25..5c3415bf18d7 100644
--- a/fs/smb/client/smberr.h
+++ b/fs/smb/client/smberr.h
@@ -9,6 +9,11 @@
  *
  */
 
+struct smb_to_posix_error {
+	__u16 smb_err;
+	int posix_code;
+};
+
 /* The request was successful. */
 #define SUCCESS	0x00
 /* Error is from the core DOS operating system set */
-- 
2.53.0

