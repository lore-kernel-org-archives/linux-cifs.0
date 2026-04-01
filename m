Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E3139BFE8
	for <linux-cifs@vger.kernel.org>; Wed,  1 Apr 2026 07:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775028659; cv=none; b=A9yddHGYL8vYVmW3zEe3dxjQjKr3wTAaey9QVs7kNeQ1vdUWfIWEAXg3BoXjd+nsgbC9UyaLQgze5UHtItcjcI+BbBKDLuaB6s5kvPau1a7ivuID9FpWeZcUOZGDYa9c+s8jPH0+U0JCfcPSC3CX+DFVVzHV6C1p/KmTbRmfec0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775028659; c=relaxed/simple;
	bh=370RcPGWjdPNNWg2fzn9VctH7gsnlEgZCebDvNUqir4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alIxd/GXAq/5Y/rPc6gmPQWi/Nkp6mj9CGqHS7ARhnE/0WekvDkFC5gNNtFE+hwbcolvxtih2G9aosuLxe46xezjrU52PGWcnrrWkesYhKcGi5HD1KdQVZqK1DZTgUkWIgKxMw6HAiAQDdvsI8ZlEvqDjYuN7XoNuqKmaqt99JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oSl3bzTX; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oSl3bzTX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775028656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EJGcXHGbEY5b4n39LqwoDjh6sox5p6H+jhULx5MlftY=;
	b=oSl3bzTXB1ppUF3kQ1goDZL5MmZUXLUnAy4qWXawDez14rPQmFAsCusv9UbZ3Qeiaa+rXv
	TMs1JN2FbC7mUCWiBWtBXVFihBGHIFRn+ECXBATdwzHRTBJ+07hGC+ARQ/ulS3Z1Qq/g/u
	vaeNzAQRTZLva3hjtYo8sF2YLZekqYo=
From: huiwen.he@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com,
	tangyouling@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v2 12/12] smb/client: introduce KUnit tests to check DOS/SRV err mapping search
Date: Wed,  1 Apr 2026 07:29:12 +0000
Message-ID: <20260401072912.355072-13-huiwen.he@linux.dev>
In-Reply-To: <20260401072912.355072-1-huiwen.he@linux.dev>
References: <20260401072912.355072-1-huiwen.he@linux.dev>
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
index e8f559754178..e80e01c1c7a0 100644
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
index f25008d149f5..d62c2b943399 100644
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
index 98074c64587d..02d065ff5b12 100644
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
2.52.0

