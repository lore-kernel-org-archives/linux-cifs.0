Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA623C1D75
	for <linux-cifs@vger.kernel.org>; Wed, 19 Aug 2026 03:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787110261; cv=none; b=iP20oytE76KvjUle+kv1Fe0BycGuFdRSlLIazy4JfLVdZCG/1F0HSF95oqB2Z0GQPY7mC3cFYf4NwSb9OyG7CkoFoYik4sTB0GRJ37k7sFJy1FUfZmkWRzaZaaXXDxLWbDQ1i7R+mUL+N6rU5YIJnw9g+xBPky+SxOKEE46HsiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787110261; c=relaxed/simple;
	bh=rGZwzduOtoAOhoeyHA1C58dZZ2C7gDqywshgn05q4vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RP67ObST+X7UNSY0IRK+kMqa8WuKO0rSvdVhZod26KWLxvmfu0SgLTfdhbGYZX2Uvy5TiUI2EwtiahKoXfFhGkh/OLrdDqnxlYZTqOU3MqORofxeBj88fNkRYfb+ikHK6N5esbpfFViCCRiy7OphGOaqAvX0l8BqZuggrx9pbok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e7sPpQn4; arc=none smtp.client-ip=74.125.227.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e7sPpQn4"
Received: by mail-pj2-f4.google.com with SMTP id 98e67ed59e1d1-3896ccc93b5so218580a91.1
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 20:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787110258; x=1787715058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jLXOm0554xvU45psVm2Z4tGu2Xw61PPyNDtEWG2ORY8=;
        b=e7sPpQn4lJbOyIE2cYDnQfpbiK2vDYpZRy/yqmGcln6BVdIitKdG3MAXeKLCMWabFV
         0iCP0WTNjj1tiNzM0upxCcfrxi57psndZctifUMWwFk3D+UNf38w633o6YlqoEisNpcb
         6ecwQ7Tl02of8TJh6FidCvRwhTjo9z4mRuQehF7OcLi8bC2ebjM+jYGkTkNAv9r8x1vs
         2zQWqytmwjiQZEz/s3/4cqJTxqmn9/1GvyaQv+3F0WqMBaL0uhJK9BhACpLTyzOvW2kp
         X+FdVgZOiLmDtoZkYUMp1xmca+mpqzH0zOhHxTL/cZPb5Qgmq4km3WDamDEYMaVLp32E
         4MtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787110258; x=1787715058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jLXOm0554xvU45psVm2Z4tGu2Xw61PPyNDtEWG2ORY8=;
        b=d6KYFQoS61t0ApoawAQlPq/qok98HRlPo4VifY5RFT9PKUEBWySsZMsVwD7asZCj8c
         VIXzi9oWaWQipyNFWqK9SBMntDZZ6Yw9WkAuB9svFLV3hmZ8T/j4shcxIaWP3E2eWGii
         nRVMKddB1DXqUKlKm4sweFfYpiDN0fozia6nFIiguJOGWkqc85p64n1gScNwTeIaLaY/
         dlxcvpmG28+/ww9dVsX0SFV01Gibh0MIgn67DOsM4V7dEi4gHpEVG0FHKLrHPkQcY82/
         WcZjx69FdHFeKaUU/+InjwWYfsTknKTwV6/5Q/SBr8k1j4kHf6tVmeVtkQV8Kt1y2etn
         rPeQ==
X-Gm-Message-State: AOJu0YzzqDMxV4gi8n5MHz9BCg3QS1UK1hZtnqYlrkzhIGQP8VSJVurs
	+Exqdi4o1sA8PZEdH6hIoj9Mjuqr5vOz1ub8LHEtU3/l46wMIHgFW2R8
X-Gm-Gg: AR+sD12k4RI0EsdSFvUlJdPV4mCKTkpZUEWxCilJKdhcZpvXHTplrloycOHtQTk/lcF
	3l6+itek8J5+33BPH/hVeVdH2VV70LMzqdtuQTAdV7sIoRoXeTnNjpuW8ZBr5Ne2nWnPXk/NXDt
	vi1UVspCCDjH3+1mhQ506g9N1/Ggrp/rIePlIGDMnOHRlGOPuGLplJdcCdOqm8fGgjyP3hT1QGv
	DSXyBvh/+YWrK+rgl3smhui1gXklfX2BToDtYbNZ3moGor8/dLsM/Hoqk/+pV2QJYnxS/2AtaYK
	P4RsE+Cu7fdnd6AtewLCjK3mtPi5G7a7s7BQjpF7oD9y5WItxHTN9v+un7SLBX4b7Qhu6hgyi/a
	zRs0kdsaXYqtm3qJgETJdivh6tE5mj7Hg+asSxY7zMGwFJRygaRS6stBNgwHYQakuUfSlh2MDfx
	2jVVfRIa4R+t1NQDTqhVzCCaM8OPIknQ6y6Ef1LTSWdlZCQ7AVOYpsTA1g9taGYm43/o9QgtcWF
	ho=
X-Received: by 2002:a17:90b:2748:b0:392:7f74:58c9 with SMTP id 98e67ed59e1d1-395810f2738mr3033554a91.15.1787110257700;
        Tue, 18 Aug 2026 20:30:57 -0700 (PDT)
Received: from localhost.localdomain ([180.138.223.172])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb17f48sm1016793a91.2.2026.08.18.20.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 20:30:57 -0700 (PDT)
From: nanx95726@gmail.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	Hang Nan <nanx95726@gmail.com>
Subject: [PATCH v4 2/3] ksmbd: test smb_check_perm_dacl() DACL walk boundary
Date: Wed, 19 Aug 2026 11:30:12 +0800
Message-ID: <20260819033013.46824-3-nanx95726@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260819033013.46824-1-nanx95726@gmail.com>
References: <20260819033013.46824-1-nanx95726@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hang Nan <nanx95726@gmail.com>

Drive smb_check_perm_dacl() through ksmbd's NTACL xattr path with a
crafted descriptor whose second ACE is beyond the declared DACL size.

Verify that the out-of-boundary ACE is not selected and access remains
denied.

Suggested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Hang Nan <nanx95726@gmail.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smbacl.c             |  2 +
 fs/smb/server/tests/smbacl_kunit.c | 90 ++++++++++++++++++++++++++++++
 fs/smb/server/vfs.c                |  2 +
 3 files changed, 94 insertions(+)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 8ad2e5a5cca8..5b2d46c09da7 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/fs.h>
+#include <kunit/visibility.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/mnt_idmapping.h>
@@ -1652,6 +1653,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	kfree(pntsd);
 	return rc;
 }
+EXPORT_SYMBOL_IF_KUNIT(smb_check_perm_dacl);
 
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
diff --git a/fs/smb/server/tests/smbacl_kunit.c b/fs/smb/server/tests/smbacl_kunit.c
index 733c2fa92030..391b1f5d181c 100644
--- a/fs/smb/server/tests/smbacl_kunit.c
+++ b/fs/smb/server/tests/smbacl_kunit.c
@@ -11,13 +11,22 @@
  *   security descriptor (the pre-fix behaviour) selects an ACE that
  *   sits beyond struct smb_acl::size; stopping at the declared DACL
  *   size (the fixed behaviour) rejects it.
+ *
+ * - ksmbd_smb_check_perm_dacl_boundary: drives the real
+ *   smb_check_perm_dacl() with a descriptor stored through ksmbd's own
+ *   NTACL xattr path on a tmpfs file, and asserts that a post-boundary
+ *   ACE is not selected for a regular access check.
  */
 
 #include <kunit/test.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/shmem_fs.h>
 #include <linux/slab.h>
 
 #include "../smbacl.h"
 #include "../smb_common.h"
+#include "../vfs.h"
 
 struct ksmbd_acl_walk_result {
 	bool found;
@@ -154,8 +163,88 @@ static void ksmbd_dacl_walk_must_stop_at_declared_size(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, enclosing.allowed);
 }
 
+/*
+ * Build an NTSD whose DACL declares one ACE (pdacl->size) but actually
+ * contains two: the second ACE sits beyond the declared DACL boundary
+ * yet inside the enclosing security descriptor.  The trailing ACE applies
+ * to S-1-22-1-0, which smb_check_perm_dacl() looks for when uid is zero.
+ */
+static struct smb_ntsd *build_boundary_ntsd(struct kunit *test,
+					    const struct smb_sid *first_sid,
+					    u32 first_access,
+					    u32 trailing_access,
+					    int *ntsd_size)
+{
+	struct smb_ntsd *pntsd;
+	struct smb_acl *pdacl;
+	struct smb_ace *ace;
+	u16 first_size = test_ace_size(first_sid);
+	u16 trailing_size = test_ace_size(&test_owner_sid);
+
+	*ntsd_size = sizeof(struct smb_ntsd) + sizeof(struct smb_acl) +
+		     first_size + trailing_size;
+	pntsd = kunit_kzalloc(test, *ntsd_size, GFP_KERNEL);
+	if (!pntsd)
+		return NULL;
+
+	pntsd->revision = cpu_to_le16(SD_REVISION);
+	pntsd->type = cpu_to_le16(DACL_PRESENT);
+	pntsd->dacloffset = cpu_to_le32(sizeof(struct smb_ntsd));
+
+	pdacl = (struct smb_acl *)((char *)pntsd + sizeof(struct smb_ntsd));
+	pdacl->revision = cpu_to_le16(2);
+	pdacl->num_aces = cpu_to_le16(2);
+	pdacl->size = cpu_to_le16(sizeof(struct smb_acl) + first_size);
+
+	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
+	fill_test_ace(ace, first_sid, first_access);
+
+	ace = (struct smb_ace *)((char *)ace + first_size);
+	fill_test_ace(ace, &test_owner_sid, trailing_access);
+
+	return pntsd;
+}
+
+static void ksmbd_smb_check_perm_dacl_boundary_test(struct kunit *test)
+{
+	struct file *file;
+	struct smb_ntsd *pntsd;
+	__le32 daccess = cpu_to_le32(FILE_READ_DATA);
+	int ntsd_size, rc;
+
+	pntsd = build_boundary_ntsd(test, &test_nonmatching_sid, 0,
+				     FILE_READ_DATA, &ntsd_size);
+	KUNIT_ASSERT_NOT_NULL(test, pntsd);
+
+	file = shmem_file_setup("ksmbd-kunit-dacl", 0,
+				mk_vma_flags(VMA_NORESERVE_BIT));
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, file);
+
+	rc = ksmbd_vfs_set_sd_xattr(NULL, mnt_idmap(file->f_path.mnt),
+				    &file->f_path, pntsd, ntsd_size,
+				    false);
+	KUNIT_EXPECT_EQ(test, 0, rc);
+	if (rc)
+		goto out;
+
+	rc = smb_check_perm_dacl(NULL, &file->f_path, &daccess,
+				 cpu_to_le32(FILE_READ_DATA), 0, false);
+
+	/*
+	 * The post-boundary ACE (ACE #2, beyond pdacl->size) grants
+	 * FILE_READ_DATA to the caller's SID, but it must not be
+	 * selected: the walk stops at the declared DACL size and access
+	 * is denied.  Before the fix the walk used the enclosing
+	 * descriptor length, selected ACE #2 and returned 0.
+	 */
+	KUNIT_EXPECT_EQ(test, -EACCES, rc);
+out:
+	fput(file);
+}
+
 static struct kunit_case ksmbd_smbacl_test_cases[] = {
 	KUNIT_CASE(ksmbd_dacl_walk_must_stop_at_declared_size),
+	KUNIT_CASE(ksmbd_smb_check_perm_dacl_boundary_test),
 	{}
 };
 
@@ -168,3 +257,4 @@ kunit_test_suite(ksmbd_smbacl_test_suite);
 
 MODULE_DESCRIPTION("KUnit tests for ksmbd smbacl helpers");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 286536f75144..536300f9eb8f 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -5,6 +5,7 @@
  */
 
 #include <crypto/sha2.h>
+#include <kunit/visibility.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/filelock.h>
@@ -1668,6 +1669,7 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 	kfree(def_smb_acl);
 	return rc;
 }
+EXPORT_SYMBOL_IF_KUNIT(ksmbd_vfs_set_sd_xattr);
 
 int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 			   struct mnt_idmap *idmap,
-- 
2.55.0

