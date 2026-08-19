Received: from mail-pj2-f0.google.com (mail-pj2-f0.google.com [74.125.227.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317683C1405
	for <linux-cifs@vger.kernel.org>; Wed, 19 Aug 2026 03:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787110254; cv=none; b=BkThR0PDl3xCz9a6c1QHasBrc8kgJyJ+w2fu4jaGrI4FVR3BPvxj47gZryEeG2m6+k2cO2OK3LCaRc2STgljv05MmhDWgxHo7gcQ6zu9kXtmasO1+jcvx33OS1g7GzC/96P7fN5TBH2VsYWoEeJpdmciCblyLvM3kiSNy9bmxfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787110254; c=relaxed/simple;
	bh=hb7BHcjQJ/ePVMBAbacKMzwaTPQGZG1NZqrUvDX3KXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQEpzi+iRUHlE29baP2pwGjC6u9ZXAFnoCcCof4iZ8XQLq3p/e+XDzQ1pxGgPjEnGc0I4M+vnHRLDPRfNg7MPtewjNv/bbnVptpl30W41LPCQHzpnPwaP2GSiTSuvUDemyzQlqn4xI06upS+dgmWW14M5dDBYQCYBWqGL1zNhBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n9s6dG+x; arc=none smtp.client-ip=74.125.227.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n9s6dG+x"
Received: by mail-pj2-f0.google.com with SMTP id 98e67ed59e1d1-380f4166f80so452513a91.1
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 20:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787110252; x=1787715052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gVaRouPmNQ+w1HW6IVFjQLBVf+VDAcpLcN8RP06iAA0=;
        b=n9s6dG+xgyLoEcFWBb1L7EoTT9jYaj5sc8MLhNMVTtXPXhTKQ0kYMizJVnm5Tt09Ib
         Pt9nw250gAXWyQt2CBDR4N8sBYqh1VN2dqqsoAKI1rxrtZmULry1Paqh52LdVmHcBjM2
         TZTJ7vxVXm/jbWBwHJzkrZh02iK0K6zAhFmr8Pcnu5fMmySLPnD34eDswvVXaRbznDkP
         yPYY5xAt7y8TJfrZWJ4EJ2ktJ8VGCOUqtIFLwUMoWLxS5wAZ7WjALmoQGNlb51lNR59f
         fypxpi4k4hnJ5BkFurUBOC9zbxrXmQqDWrDyexhi44a1NJEfjAcYIaN7Cx3kYuvk+RSh
         Bc3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787110252; x=1787715052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gVaRouPmNQ+w1HW6IVFjQLBVf+VDAcpLcN8RP06iAA0=;
        b=iuoWbhkWSzjZ5CJMlQF4wY1ioNyP/6y9LQNUNbgfAhJmSCrOGisRRHUJrLCFJk6Cnl
         P4doCNkFmnTOizwxeELYdP11w0l9hgK/7c7X0WgFNNXRCbK71C/2V0taqcsyVmxSLyUd
         ZJMk4O/I6KDpMK6lX/h6pk4T4g+y6rwSxjC80InFj+8mbj2VbNSc6pJ1eAIkc2Al4okX
         BnyI0ihDQw360ZQeJKGzyo3kMiuqLjUAStCws4Af2FjFbE21A4KAZS+RVhvsA+8jB3NV
         pgfHn4cpNYHq9cwNvPlbFGwlBJQ980HaZD5rd1hQnr2q34SPMyCMJUmy0RDuKoMLDQhu
         e+XQ==
X-Gm-Message-State: AOJu0YxM+jdnpHIFR+sZG2H20zHJ6y7kNMFW0rr5yyFwPRUrnenx9P/P
	DAp0Ki2DQuBkRj2+stwhagj0ZW4c92DKjT/H+DFATKgnchoum1VnMpuR
X-Gm-Gg: AR+sD105gHu9l6mbPy0epdu7VkuWX2tOgZvpP7/qhdjzTxpjKJDIrjbrJIFWcSPn7r/
	Lln/DLwv0gdoU0ZtN2yipWeZurJ5XUTPnumXmW2kaDrOiVvghbtV8nHLVCLUbZieL/faULMQimC
	iyfVsKJCGovOv4oUQhU3ahkbRljX/IVthfHCsbgcRIaKEvGCcywyE72/0tK+dW+qoFie/72nDp4
	+oOVA7Q/zL8HEX+F+XJ8FxW8Id7w1I4zNmLXpHB5pb6duq6T/8st047Uh1m5vjswITpeJ0kKlVG
	cRd2TbMST0dlCgwk1n3qisq6n4MF6dI3cUUsCQVxdsu8r9DqgjvNJfHTPJ6aJHIqjnjdg5YeL1W
	4UYsrdoDB/uQk/hDSBJpdBUcIw8WL1HueAGoF/zqdVLCoXOMEMAAaVsk2nMz+fFam0HtalFqRDo
	5UjbHcNPtt5sFnoKD/FlgSBxSYGx9VIHFwQYSmQbXQamNYpBBcioXYRM8sKNn6Pfb+IccAwqSM2
	/M=
X-Received: by 2002:a17:90b:2c8f:b0:38e:4f41:83df with SMTP id 98e67ed59e1d1-395810a4e52mr2952424a91.15.1787110252264;
        Tue, 18 Aug 2026 20:30:52 -0700 (PDT)
Received: from localhost.localdomain ([180.138.223.172])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb17f48sm1016793a91.2.2026.08.18.20.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 20:30:51 -0700 (PDT)
From: nanx95726@gmail.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	Hang Nan <nanx95726@gmail.com>
Subject: [PATCH v4 1/3] ksmbd: add KUnit test for the DACL walk boundary
Date: Wed, 19 Aug 2026 11:30:11 +0800
Message-ID: <20260819033013.46824-2-nanx95726@gmail.com>
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

smb_check_perm_dacl() must stop walking ACEs at the DACL declared
size instead of using the enclosing security descriptor length.

Add the ksmbd KUnit test configuration and a semantic harness that
verifies a crafted access-granting ACE beyond the declared DACL size is
ignored.

Suggested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Hang Nan <nanx95726@gmail.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/Kconfig              |   2 +
 fs/smb/server/Makefile             |   1 +
 fs/smb/server/tests/Kconfig        |  15 +++
 fs/smb/server/tests/Makefile       |   4 +
 fs/smb/server/tests/smbacl_kunit.c | 170 +++++++++++++++++++++++++++++
 5 files changed, 192 insertions(+)
 create mode 100644 fs/smb/server/tests/Kconfig
 create mode 100644 fs/smb/server/tests/Makefile
 create mode 100644 fs/smb/server/tests/smbacl_kunit.c

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 08d8b7a965a6..0d61a27990c6 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -72,3 +72,5 @@ config SMB_SERVER_KERBEROS5
 	bool "Support for Kerberos 5"
 	depends on SMB_SERVER
 	default y
+
+source "fs/smb/server/tests/Kconfig"
diff --git a/fs/smb/server/Makefile b/fs/smb/server/Makefile
index a3e9306055e8..9bc87695a53c 100644
--- a/fs/smb/server/Makefile
+++ b/fs/smb/server/Makefile
@@ -19,3 +19,4 @@ $(obj)/ksmbd_spnego_negtokentarg.asn1.o: $(obj)/ksmbd_spnego_negtokentarg.asn1.c
 
 ksmbd-$(CONFIG_SMB_SERVER_SMBDIRECT) += transport_rdma.o
 ksmbd-$(CONFIG_PROC_FS) += proc.o
+obj-$(CONFIG_SMB_SERVER_KUNIT_TESTS) += tests/
diff --git a/fs/smb/server/tests/Kconfig b/fs/smb/server/tests/Kconfig
new file mode 100644
index 000000000000..ad7a4e94ceaa
--- /dev/null
+++ b/fs/smb/server/tests/Kconfig
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (C) 2026 Hang Nan <nanx95726@gmail.com>
+
+config SMB_SERVER_KUNIT_TESTS
+	tristate "KUnit tests for SMB3 server helpers" if !KUNIT_ALL_TESTS
+	depends on SMB_SERVER && SMB_KUNIT_TESTS && TMPFS_XATTR
+	default SMB_KUNIT_TESTS
+	help
+	  This builds the KUnit tests for ksmbd server helpers. The tests
+	  exercise internal server functionality and help detect regressions
+	  in server-side behavior. They are intended for kernel developers
+	  and are not suitable for production systems.
+
+	  For more information on KUnit and unit tests in the kernel,
+	  please read Documentation/dev-tools/kunit/index.rst.
diff --git a/fs/smb/server/tests/Makefile b/fs/smb/server/tests/Makefile
new file mode 100644
index 000000000000..8738ab0b0667
--- /dev/null
+++ b/fs/smb/server/tests/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (C) 2026 Hang Nan <nanx95726@gmail.com>
+
+obj-$(CONFIG_SMB_SERVER_KUNIT_TESTS) += smbacl_kunit.o
diff --git a/fs/smb/server/tests/smbacl_kunit.c b/fs/smb/server/tests/smbacl_kunit.c
new file mode 100644
index 000000000000..733c2fa92030
--- /dev/null
+++ b/fs/smb/server/tests/smbacl_kunit.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit tests for ksmbd security descriptor (DACL) handling.
+ *
+ * Copyright (C) 2026 Hang Nan <nanx95726@gmail.com>
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
+#include "../smbacl.h"
+#include "../smb_common.h"
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

