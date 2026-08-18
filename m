Received: from out203-205-221-164.mail.qq.com (out203-205-221-164.mail.qq.com [203.205.221.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2BA3264C7
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 03:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787023748; cv=none; b=Ea+VV8VD7AD+uYuN4fFHNOXWQ3njCVjDdahJoAbkSVda7aWKU7iIM1zqvdUpyc21TZEp9ENQ/UyVv73nCooPC/GKUYWTGdFvC51WezOH4MtAQ4YPldxTpcphhKlstveE/SRWhq5iMO6xE9eHsY+15o05IQhjW7avM0GHX0i+/9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787023748; c=relaxed/simple;
	bh=qWFR6dtsImIgQFNUZBPp+TZ7juHZVowwa+JbMq+ir2g=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=mvKIsWi+y35VYsN2e6L1h0dATMAp071u4CDfi1CCBZ/6prltyQ+gksTJKzp/sSH2mlFkwI1ShzBzFNFZsQb3W9rYZirvb0KblgnWkTq/kpNac7wTLPLPYVoB/WmdPIDLbGnh91WjCymHM09z5KYmdFU9KLN4RR2uHoTkMZFiLbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=tjjNajLM; arc=none smtp.client-ip=203.205.221.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="tjjNajLM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787023742; bh=TmxFRWK57bczxH+UeyPRWIUa04aXqPAucrdgTiZeDuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tjjNajLMT+fYitD3fwHGwTIhnttks5ON6vAWMPa3nDVomDvg/i+9Pr9N86QTUy4zX
	 IzRpl8V14zOtSHQFduVbOyB1kS8rwFkXkahQtpXbeb+ZdrgfLJ+Or6Xmcc21TjkbEa
	 xAKQh9bIagjbL59C/hnx5PppelW76QhA54jabjqI=
Received: from localhost.localdomain ([240e:453:ddc8:a66b:124:844d:8bab:70af])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 5F59A495; Tue, 18 Aug 2026 11:23:53 +0800
X-QQ-mid: xmsmtpt1787023688t7bff1b8j
Message-ID: <tencent_BFF2AB3A7DAFECE7C2C05E9078E3690F6905@qq.com>
X-QQ-XMAILINFO: M0YJCPYfkOgH9iEhG/ne5yLL16XWfyv4MTrSlMOOPzZQCRhmaHlT7cFIfTWNJb
	 93uTB4E+lnhLdmeiqWE+2Y7wtdCDokuJM0/akZNDZVoD2Wf1DF1xetQGWlAzHYKkbU5N4j1dRMCQ
	 ifPWKazc9dzYspCpfNJ1c52lGFStNect33LzbIJ+X/eBYIoTPE90cyVV0zItnhl3Sq6Q0NFMNKEm
	 5DWIdvsgc1ajPqGGNfDjmqG9uUSEGIYOK7cGf0sm1LMJLZiweh/jygkJjPj+pNFuFYBhBTZYoCh5
	 YdZ57liNj0urF/6Ns8nMltcZGfeycA9MzSS9718mKB4JO/XN89GH965ZHE6haa0dtjvxY04IgrCg
	 jsa8Q1/Mx2xjL9ElOOxa0O8HPgkJrHndJe/guFalWUjfTi2j/tjUqaUe51r63NFtQl7nT4hYpiuO
	 TcMtMdthViGq4AWqIGb6DcdOP+Z8y1Ye6AOcXLqldmEbwMI/L6NVbGn3zOLDVM5u4Je6+jpYtvhA
	 siwZqidLo7kli5YLn7hYMABpoNbgriyr+0pJKFfxDGHM23z/5KAGu2YMWlBLyU8lr7CgSKGnySh2
	 +vbea9WGsviYA1aDINrH4HVk+afN+fJWhC4eJ9zAdc+leS/wFOyO7Yaa2wB3Ub51XQuLygG4mWn4
	 gdNOOw21soTVml5QmHuK+Z7cI7v8vtagamek2ncoW8YgKO85QJFX+FStMMTJrLEo/gNoSWqx9shT
	 DHqK3d91utP77cwhFIlk0ArCR5xzu7keU98nYuUoiFB3fg0pWrqgQ+Os3F6IEyTq2J0gmF+27boT
	 irfvLHM3Kt6+BRDq2IXhcaGqOw+WGJ2Bcm4tKOE68nRutDErm/L529jpy5yhvB32Uig50ZmcdTdD
	 efq85l9cBqmMvqt1RU2lynFdjFNpl46MWL9u43DSyTu6n239u5sE2glcfSwBapNbUoCBunzlWDyY
	 uJu+2Kj7sl7C/glzOVKfwj/iztO0yJui1BFNJ01dywSpCv/p/fZBS09LP7M+Q7Hzo+7+8UKTTA6s
	 u87VjPSoA25tVrE8bUjJU6/klZkD+ocpKSUgJri/YfUMJTEhseq/721xbRYm63tfoq7tA3inWEr3
	 +wC8OfpUfDSoenG8cVOiIQyT+oYw==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Hang Nan <2122295973@qq.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	Hang Nan <2122295973@qq.com>
Subject: [PATCH v3 2/3] ksmbd: test smb_check_perm_dacl() DACL walk boundary
Date: Tue, 18 Aug 2026 11:23:33 +0800
X-OQ-MSGID: <20260818032335.10643-3-2122295973@qq.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260818032335.10643-1-2122295973@qq.com>
References: <20260818032335.10643-1-2122295973@qq.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drive smb_check_perm_dacl() through ksmbd's NTACL xattr path with a
crafted descriptor whose second ACE is beyond the declared DACL size.

Verify that the out-of-boundary ACE is not selected and access remains
denied.

Suggested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Hang Nan <2122295973@qq.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smbacl.c      |  2 +
 fs/smb/server/smbacl_test.c | 90 +++++++++++++++++++++++++++++++++++++
 fs/smb/server/vfs.c         |  2 +
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
diff --git a/fs/smb/server/smbacl_test.c b/fs/smb/server/smbacl_test.c
index 9229a3548c01..d1703b83aeff 100644
--- a/fs/smb/server/smbacl_test.c
+++ b/fs/smb/server/smbacl_test.c
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
 
 #include "smbacl.h"
 #include "smb_common.h"
+#include "vfs.h"
 
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

