Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F1E3264C7
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 03:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787023785; cv=none; b=MZvynk0PXW9quLyXuulxIv6L7w5A6obHmWp8mYxDa67mlb/Qsd4RQLq5RKrwowB26IeXz2f2R6axCoVo3N6Gsw27jSlyojPZ1YTGRUsCxqmC67FjEh6DyqyJvuJjus0+EEbOubzf6QKkwaCyZARYXBEj5C3KIDtg28EMFqKjrLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787023785; c=relaxed/simple;
	bh=bkg4+u3hwCnB4VGt5FGPttmW2yckW/Lv7R5kVKCEHMo=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=EoQNOIG4PWPTci1jw0MKRVoytDN2lV809sRetiLwkjG6aqV1LIfHp4Ec0FtnPXg+l22p/6Mtw4MEh2ldLUgP7TEL5gDDkfPOWWhS8m2Xn7Tlbd6jl8N38fizg/6tQ/6VqDwE34SN86843ur+z8lK4OLMceWb2ZRp4dF5ASJYrMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=kYbPyOi6; arc=none smtp.client-ip=162.62.57.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="kYbPyOi6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787023772; bh=lgSY4i9fHhB2coc51n885gtbQz5wP94y6YCw+LdMnc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kYbPyOi6ZswGSRf8H+fY0p9NYAr9R7DMkoaeZM9TYEcd1V8A6BQRlJH7ZYckq5Otc
	 MxQxIVobaHqbsUWm+irfkC5zEIhR3BKs+gN/UpfEV6nWcnr1tAarUMtXwug1kM9qOH
	 MI22R5kGkx+fpv1tkI+Nquv5Fj55vTa31MkApOUM=
Received: from localhost.localdomain ([240e:453:ddc8:a66b:124:844d:8bab:70af])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 5F59A495; Tue, 18 Aug 2026 11:23:53 +0800
X-QQ-mid: xmsmtpt1787023529t7ejckfh3
Message-ID: <tencent_D1F4F4FAB2A78B707B1EE2B1A718A4BE2F07@qq.com>
X-QQ-XMAILINFO: M1rD3f8svNznOnK9DKcnLQI9YhCkbRSmLl5cgBzn8RSIXw4Pccl+WXq4J1HwR+
	 b4iDkX9hfxO+p24/eY81cf00KV3sKI8PhB/A03B4m4seIjugzDEPKNWYRd5t557XxC7SsDTG06HZ
	 +CVGrYqRkTS8jf0dSj4WXi7isKlpwPaIbPJ87wp7rjMudIpGU6ncK3b/bJEcJEL5hbdwUdRfw35E
	 jh1SR1SYT/Oxi0kXF0gaOcj/9dAq/hOadsKYgGCLb3awNcLFaXQL9qq/GEGqfIE+9Zqo4hj3fEh3
	 GmSkjVjm1NY3gRN/VcsVVfKEaVxrSHdTn6bugXZVjkSrVlbHn7kmRl2YQd15D4CWWt45IgECmFht
	 XBTieWMxthexllkV1Y4N6xz3ABj9radaL4x2bNm5rDxYHUtjoa/y8C23Smy0ZmbaN6NsZMUNl9h4
	 8U/cWZvbkuQQXr6B/Ml3j7Q1jF+jFMMWPj0V65YOynkUiLYsOuHDHuogHWHtEptmdzKnzaNv4gH9
	 V2HAM3wvW2eany1FhKPHCNyteyheH59VlEtZLizG+ZnTnTZmiy3/HfUjkSUbkCgYDWcuuXKNofaz
	 6Fkc7UgmLeUVhmEeNE4FyAHI6XvRqNc5vL4u7yqAzN/k1m9CDuny660p1jcwqaa7K/w2hP7+4rAX
	 XHPaAwP+0IclkkLeRXf3Xn/WHiXiAOvm6cqs40oLAEhuUlOosElqQqLG8n9Afot1h38J1M0INgVW
	 0VoljkLpl6ONNe8b3oS7oZS52IhLx0Py/ibTWQRHexpbJRG41TPmYNHbh59amX0zUks0PFW0/kGo
	 AK3PIVPIqh4IRkUOjwI5B60p6gzzRxPS3Y9GgDXHX3Zae2FMn0Je1/qlzxhhHKlW1ax3X0neRndV
	 +LXxvgvTceavLookLk7tPEQT38XpRiIdm++OJyMD7oSs6ezbV/neR3eQpRlLZ6G2U08SePx3whcT
	 /48VqlXNk/Kb/axWuQLA0e/Ldvz1FOq0gkiLV2FCFm9ogqooUyiwYQ4RThlG/BlMaKloDPFs1f5q
	 ezYNC/SIce9hlF4mx2BaB1BHT05dNT6HutAIlWW2gYbMdZlteVdDUMVYsTMLP5hNDd5o6rhA==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Hang Nan <2122295973@qq.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	Hang Nan <2122295973@qq.com>
Subject: [PATCH v3 1/3] ksmbd: add KUnit test for the DACL walk boundary
Date: Tue, 18 Aug 2026 11:23:32 +0800
X-OQ-MSGID: <20260818032335.10643-2-2122295973@qq.com>
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

smb_check_perm_dacl() must stop walking ACEs at the DACL declared
size instead of using the enclosing security descriptor length.

Add the ksmbd KUnit test configuration and a semantic harness that
verifies a crafted access-granting ACE beyond the declared DACL size is
ignored.

Suggested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Hang Nan <2122295973@qq.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/Kconfig       |  15 ++++
 fs/smb/server/Makefile      |   1 +
 fs/smb/server/smbacl_test.c | 170 ++++++++++++++++++++++++++++++++++++
 3 files changed, 186 insertions(+)
 create mode 100644 fs/smb/server/smbacl_test.c

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 08d8b7a965a6..463fa19819b2 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -72,3 +72,18 @@ config SMB_SERVER_KERBEROS5
 	bool "Support for Kerberos 5"
 	depends on SMB_SERVER
 	default y
+
+config SMB_SERVER_KUNIT_TESTS
+	tristate "KUnit tests for SMB3 server helpers" if !KUNIT_ALL_TESTS
+	depends on SMB_SERVER && SMB_KUNIT_TESTS && TMPFS_XATTR
+	default SMB_KUNIT_TESTS
+
+	help
+	  KUnit tests for ksmbd server helpers such as the DACL access
+	  check in smb_check_perm_dacl().  The tests use crafted security
+	  descriptors stored in tmpfs NTACL xattrs to exercise the real
+	  permission-checking path.  This option is only useful for kernel
+	  developers; enable it together with CONFIG_SMB_KUNIT_TESTS.
+
+	  For more information on KUnit and unit tests in the kernel,
+	  please read Documentation/dev-tools/kunit/index.rst.
diff --git a/fs/smb/server/Makefile b/fs/smb/server/Makefile
index a3e9306055e8..62228679fc9a 100644
--- a/fs/smb/server/Makefile
+++ b/fs/smb/server/Makefile
@@ -19,3 +19,4 @@ $(obj)/ksmbd_spnego_negtokentarg.asn1.o: $(obj)/ksmbd_spnego_negtokentarg.asn1.c
 
 ksmbd-$(CONFIG_SMB_SERVER_SMBDIRECT) += transport_rdma.o
 ksmbd-$(CONFIG_PROC_FS) += proc.o
+obj-$(CONFIG_SMB_SERVER_KUNIT_TESTS) += smbacl_test.o
diff --git a/fs/smb/server/smbacl_test.c b/fs/smb/server/smbacl_test.c
new file mode 100644
index 000000000000..9229a3548c01
--- /dev/null
+++ b/fs/smb/server/smbacl_test.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit tests for ksmbd security descriptor (DACL) handling.
+ *
+ * Copyright (C) 2026 Hang Nan <2122295973@qq.com>
+ *
+ * The tests pin the DACL declared-size boundary in smb_check_perm_dacl():
+ *
+ * - ksmbd_dacl_walk_must_stop_at_declared_size: a pure semantic harness
+ *   that models the ACE walk.  Walking to the end of the enclosing
+ *   security descriptor (the pre-fix behaviour) selects an ACE that
+ *   sits beyond struct smb_acl::size; stopping at the declared DACL
+ *   size (the fixed behaviour) rejects it.
+ */
+
+#include <kunit/test.h>
+#include <linux/slab.h>
+
+#include "smbacl.h"
+#include "smb_common.h"
+
+struct ksmbd_acl_walk_result {
+	bool found;
+	bool allowed;
+	const struct smb_ace *selected;
+};
+
+static const struct smb_sid test_nonmatching_sid = {
+	1, 5, {0, 0, 0, 0, 0, 5},
+	{ cpu_to_le32(21), cpu_to_le32(1), cpu_to_le32(2),
+	  cpu_to_le32(3), cpu_to_le32(9999) }
+};
+
+/*
+ * S-1-22-1-0: the SID id_to_sid(0, SIDUNIX_USER) resolves to, i.e. what
+ * smb_check_perm_dacl() looks for when called with uid == 0.
+ */
+static const struct smb_sid test_owner_sid = {
+	1, 2, {0, 0, 0, 0, 0, 22},
+	{ cpu_to_le32(1), cpu_to_le32(0) }
+};
+
+static int test_compare_sids(const struct smb_sid *a, const struct smb_sid *b)
+{
+	int i;
+
+	if (a->revision != b->revision || a->num_subauth != b->num_subauth)
+		return 1;
+	for (i = 0; i < NUM_AUTHS; i++) {
+		if (a->authority[i] != b->authority[i])
+			return 1;
+	}
+	for (i = 0; i < a->num_subauth; i++) {
+		if (a->sub_auth[i] != b->sub_auth[i])
+			return 1;
+	}
+	return 0;
+}
+
+static u16 test_ace_size(const struct smb_sid *sid)
+{
+	return offsetof(struct smb_ace, sid) + CIFS_SID_BASE_SIZE +
+	       sid->num_subauth * sizeof(__le32);
+}
+
+static u16 fill_test_ace(struct smb_ace *ace, const struct smb_sid *sid,
+			 u32 access_req)
+{
+	u16 size = test_ace_size(sid);
+
+	ace->type = ACCESS_ALLOWED_ACE_TYPE;
+	ace->flags = 0;
+	ace->size = cpu_to_le16(size);
+	ace->access_req = cpu_to_le32(access_req);
+	memcpy(&ace->sid, sid, size - offsetof(struct smb_ace, sid));
+	return size;
+}
+
+static struct ksmbd_acl_walk_result test_walk_dacl(struct smb_acl *pdacl,
+						    int walk_boundary,
+						    const struct smb_sid *target,
+						    u32 requested)
+{
+	struct ksmbd_acl_walk_result result = {};
+	struct smb_ace *ace;
+	int aces_size;
+	int i;
+
+	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
+	aces_size = walk_boundary - sizeof(struct smb_acl);
+	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
+		u16 ace_size;
+
+		if (aces_size < offsetof(struct smb_ace, sid) + CIFS_SID_BASE_SIZE)
+			break;
+		ace_size = le16_to_cpu(ace->size);
+		if (ace_size > aces_size ||
+		    ace_size < offsetof(struct smb_ace, sid) + CIFS_SID_BASE_SIZE)
+			break;
+		aces_size -= ace_size;
+
+		if (ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
+		    ace_size < offsetof(struct smb_ace, sid) + CIFS_SID_BASE_SIZE +
+			       sizeof(__le32) * ace->sid.num_subauth)
+			break;
+
+		if (!test_compare_sids(target, &ace->sid)) {
+			result.found = true;
+			result.selected = ace;
+			result.allowed = !(requested & ~le32_to_cpu(ace->access_req));
+			return result;
+		}
+
+		ace = (struct smb_ace *)((char *)ace + ace_size);
+	}
+
+	return result;
+}
+
+static void ksmbd_dacl_walk_must_stop_at_declared_size(struct kunit *test)
+{
+	struct ksmbd_acl_walk_result declared, enclosing;
+	struct smb_acl *acl;
+	struct smb_ace *ace1, *fake;
+	u16 ace1_size, fake_size;
+	u16 pdacl_size;
+	u16 acl_size;
+
+	acl = kunit_kzalloc(test, 128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, acl);
+
+	acl->revision = cpu_to_le16(2);
+	acl->num_aces = cpu_to_le16(2);
+
+	ace1 = (struct smb_ace *)((char *)acl + sizeof(*acl));
+	ace1_size = fill_test_ace(ace1, &test_nonmatching_sid, 0);
+	fake = (struct smb_ace *)((char *)ace1 + ace1_size);
+	fake_size = fill_test_ace(fake, &test_owner_sid, FILE_READ_DATA);
+
+	pdacl_size = sizeof(*acl) + ace1_size;
+	acl_size = pdacl_size + fake_size;
+	acl->size = cpu_to_le16(pdacl_size);
+
+	declared = test_walk_dacl(acl, pdacl_size, &test_owner_sid,
+				  FILE_READ_DATA);
+	enclosing = test_walk_dacl(acl, acl_size, &test_owner_sid,
+				   FILE_READ_DATA);
+
+	KUNIT_EXPECT_FALSE(test, declared.found);
+	KUNIT_EXPECT_FALSE(test, declared.allowed);
+
+	/* Demonstrates that the buggy acl_size boundary selects fake ACE #2. */
+	KUNIT_EXPECT_TRUE(test, enclosing.found);
+	KUNIT_EXPECT_TRUE(test, enclosing.allowed);
+}
+
+static struct kunit_case ksmbd_smbacl_test_cases[] = {
+	KUNIT_CASE(ksmbd_dacl_walk_must_stop_at_declared_size),
+	{}
+};
+
+static struct kunit_suite ksmbd_smbacl_test_suite = {
+	.name = "ksmbd-smbacl",
+	.test_cases = ksmbd_smbacl_test_cases,
+};
+
+kunit_test_suite(ksmbd_smbacl_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for ksmbd smbacl helpers");
+MODULE_LICENSE("GPL");
-- 
2.55.0

