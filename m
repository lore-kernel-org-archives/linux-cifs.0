Received: from out203-205-221-173.mail.qq.com (out203-205-221-173.mail.qq.com [203.205.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0A9423E8B;
	Wed, 12 Aug 2026 10:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786531206; cv=none; b=IwZ6tfjLUetix6BuWC+5+EWVw7o0/irD0fE+NlBFndwjmSOjHnlcBnGU8FmOKSQ2Ft16mC+HrqeX6zljDy+Ha5n/AmtcwFGCTYFty1sYKhY29Y9kkFA1pavf99Aql3CoJHolWAemTSNYk95POkgNc/qq8OXdcLTc6/De8CPbt7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786531206; c=relaxed/simple;
	bh=xbTDjpwhz+wY8JuJCuTGJLpLI4gu00jDk20RW8yBNZI=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=DwBzFJ6xJS0XEAyglKQz+S602cTtwC+SL1q+DPdDJEOvK1SOqFbAiTXc2wyljMg8AlEzKx0t09DpOyJAN5Y3+JuNBwbX1zXy7P2HdNwzoU75wJyhxw9hqQQWpcVRXtDi3p/eNRw9OsR9lff1an0KWnxR1NCenVUNaR75zhbi7uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=BTliXhRJ; arc=none smtp.client-ip=203.205.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="BTliXhRJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786531191; bh=loGSziwBZxle4hBPYBiR/THsMdXE5VgAjNt4IASBfUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTliXhRJIB6sQzX6XPpjgDKoP+hjqZMGy96AkAkTMS6MXuh4depMtzXHqKN5y5UTZ
	 CMfjbYP8TWXME7X9rm1BsLXE2iZHROEhUbCkIcx3rGuYDRd9vyjJA8MEq32UjauE/i
	 g7+ftduOD4EkqvnHttuyR4Mn5KdSu23Stp8JXJrg=
Received: from localhost.localdomain ([240e:452:ddba:7caa:44f2:d3f7:942:3f36])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 9EE2B0DB; Wed, 12 Aug 2026 18:39:46 +0800
X-QQ-mid: xmsmtpt1786531189t50epu4gw
Message-ID: <tencent_A5CB0E2E28ECF588B59EF49004BE80D22B09@qq.com>
X-QQ-XMAILINFO: NMiAo2azIaDAeqXUJ8wEvfY93oMiyati8m/pOwn/VQZ73oI6xWBrpd4J7sC/+A
	 lP2gUo9eBAlbRulcgoT7mCA15gQWPEfCx0tAUeBCbdngCoFa+bLv71iBGPuMhPRDCG6n96oe87hy
	 kID69/wMy2HbxWZYlhl1+A9AES08yRMcWlDBPR9vuXHGEB4NF6QtOfxgHb6f0MdlMsCzTvt7UcDs
	 HnRCHs9oYAedsufdaGA76bnsEJ1VRoS4NgodniIS+CVS5orW3UQzLPqjByZoS7yVZ4WVPX5cZxZQ
	 jL8l9GJroRkNTX7Ypj2YOQ2yD/xMSrwqVa4vQYN6pjCbJWyfRO8j0w7Vawva7HRwkWwMSRvq9Rcq
	 9saFu0497LNuFTLu0TfGOB4tt0XY5JwkdzxEkhpHMfMBp27DM9uvASzub0BG97odpZSrkVYAPgeA
	 cViEfK2FFQnHInH//fZ5xHw08e2pzKJalTI5RIEJcRN8XWRaiy8AN1/UmADjQJcDi/eEjAqLPtAg
	 /cW2gbFetCxArPp5tcaWRxHs6Nf2LAdV3znT9XUKaGmjtVrHBTwsG02CCz9ADWy7ygowxK/av0fD
	 TZgI1NXmLGG3x3wIY1b/ZHpmly2rlfJRpAZ5ZIMUCK27LWVndCpHwCGBMDQczCN4EC7c2ksNBVOD
	 HbcBNxiXXyyyg5KO51z7nMQs5ZbpHDEBSvT0qyJffHwLQdS5M8qOuBnQ0w0eZD3nunDlhYo/fVdJ
	 X+Vzu5JfCan4lEL+NCpygP39UqdOM7fpERg3BxxVzhMqns2dKmaH3j/rllTwLLFQW69oE5vvv3V+
	 BjvxKna3gUCvVMHnCxe6B1hqLGncwhtSQlz8ZwUyVvjN6QI5c30ULKetKZGbWXton5mXTz0kAXlz
	 tK+hb1ZbyOcdZ/HFEw3dUbtnGtjyHq+kDFV1EeMsS/YRrorNLVXGaUSCIcV8ltqd8mYSSbEMX4uc
	 4e2+ILDN9YOLxhGD1pOqra7Py5ixSMpKkElaKjHPmQJvxeJ3y484pDD7MWWKWPVk0TVVBDVtV/g0
	 kebzW+1OAyRqgg8LcRRz554hdSI7nyTxx0FNFrzTRfheGeaWXg991E9yloxpS8uiRS6s+Jlw==
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Hang Nan <2122295973@qq.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Hang Nan <2122295973@qq.com>
Subject: [PATCH v2 2/2] ksmbd: add KUnit tests for the DACL declared-size boundary
Date: Wed, 12 Aug 2026 18:39:46 +0800
X-OQ-MSGID: <20260812103945.82495-3-2122295973@qq.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260812103945.82495-1-2122295973@qq.com>
References: <8970140c-1de1-4989-b32c-ea485be00b79@chenxiaosong.com>
 <20260812103945.82495-1-2122295973@qq.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: nanhang <2122295973@qq.com>

fs/smb/server currently has no KUnit tests; add the first one,
covering smb_check_perm_dacl()'s DACL walk boundary.

smb_check_perm_dacl() walks the DACL ACE list to decide whether the
requested access is granted.  The walk must stop at struct
smb_acl::size (the declared DACL size): a crafted DACL can place an
access-granting ACE beyond pdacl->size, and the pre-fix code selected
it because the walk used the enclosing security descriptor length
instead.

- ksmbd_dacl_walk_must_stop_at_declared_size: a pure semantic harness
  modelling the walk; it shows the post-boundary ACE is selected with
  the old (enclosing descriptor length) boundary and rejected with the
  declared-size boundary.

- ksmbd_smb_check_perm_dacl_boundary: drives the real
  smb_check_perm_dacl() with a crafted descriptor stored through
  ksmbd's own NTACL xattr path on a tmpfs file, and asserts the
  post-boundary ACE is rejected with -EACCES.

Validated with KUnit (UML, x86_64, KASAN): with the fix applied both
tests pass; with the fix reverted, ksmbd_smb_check_perm_dacl_boundary
fails as expected (the post-boundary ACE is selected and access is
granted).

Signed-off-by: Hang Nan <2122295973@qq.com>
---
 fs/smb/server/Kconfig             |  13 ++
 fs/smb/server/Makefile            |   1 +
 fs/smb/server/smbacl_kunit_test.c | 254 ++++++++++++++++++++++++++++++
 3 files changed, 268 insertions(+)
 create mode 100644 fs/smb/server/smbacl_kunit_test.c

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 08d8b7a965a6..05d16052b9a7 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -72,3 +72,16 @@ config SMB_SERVER_KERBEROS5
 	bool "Support for Kerberos 5"
 	depends on SMB_SERVER
 	default y
+
+config SMB_SERVER_KUNIT_TEST
+	tristate "KUnit tests for SMB3 server helpers" if !KUNIT_ALL_TESTS
+	depends on SMB_SERVER && KUNIT && SHMEM
+	default KUNIT_ALL_TESTS
+
+	help
+	  KUnit tests for ksmbd server helpers such as the DACL access
+	  check in smb_check_perm_dacl().  This option is only useful
+	  for kernel developers; enable it together with CONFIG_KUNIT.
+
+	  For more information on KUnit and unit tests in the kernel,
+	  please read Documentation/dev-tools/kunit/index.rst.
diff --git a/fs/smb/server/Makefile b/fs/smb/server/Makefile
index a3e9306055e8..dff9d3cd43bd 100644
--- a/fs/smb/server/Makefile
+++ b/fs/smb/server/Makefile
@@ -19,3 +19,4 @@ $(obj)/ksmbd_spnego_negtokentarg.asn1.o: $(obj)/ksmbd_spnego_negtokentarg.asn1.c
 
 ksmbd-$(CONFIG_SMB_SERVER_SMBDIRECT) += transport_rdma.o
 ksmbd-$(CONFIG_PROC_FS) += proc.o
+ksmbd-$(CONFIG_SMB_SERVER_KUNIT_TEST) += smbacl_kunit_test.o
diff --git a/fs/smb/server/smbacl_kunit_test.c b/fs/smb/server/smbacl_kunit_test.c
new file mode 100644
index 000000000000..34129708aef6
--- /dev/null
+++ b/fs/smb/server/smbacl_kunit_test.c
@@ -0,0 +1,254 @@
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
+ *
+ * - ksmbd_smb_check_perm_dacl_boundary: drives the real
+ *   smb_check_perm_dacl() with a descriptor stored through ksmbd's own
+ *   NTACL xattr path on a tmpfs file, and asserts that a post-boundary
+ *   ACE is not selected (access denied with -EACCES).
+ */
+
+#include <kunit/test.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/shmem_fs.h>
+#include <linux/slab.h>
+
+#include "smbacl.h"
+#include "smb_common.h"
+#include "vfs.h"
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
+static u16 fill_test_ace(struct smb_ace *ace, const struct smb_sid *sid,
+			 u32 access_req)
+{
+	u16 size = offsetof(struct smb_ace, sid) + CIFS_SID_BASE_SIZE +
+		   sid->num_subauth * sizeof(__le32);
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
+#define TEST_ACE1_SIZE	(offsetof(struct smb_ace, sid) + CIFS_SID_BASE_SIZE + \
+			 5 * sizeof(__le32))
+#define TEST_ACE2_SIZE	(offsetof(struct smb_ace, sid) + CIFS_SID_BASE_SIZE + \
+			 2 * sizeof(__le32))
+#define TEST_DACL_SIZE	(sizeof(struct smb_acl) + TEST_ACE1_SIZE)
+#define TEST_NTSD_SIZE	(sizeof(struct smb_ntsd) + sizeof(struct smb_acl) + \
+			 TEST_ACE1_SIZE + TEST_ACE2_SIZE)
+
+/*
+ * Build an NTSD whose DACL declares one ACE (pdacl->size) but actually
+ * contains two: the second ACE sits beyond the declared DACL boundary
+ * yet inside the enclosing security descriptor.  It grants FILE_READ_DATA
+ * to S-1-22-1-0 (the caller's SID for uid == 0), so the pre-fix walk
+ * that used the descriptor length would select it and grant access.
+ */
+static struct smb_ntsd *build_boundary_ntsd(struct kunit *test)
+{
+	struct smb_ntsd *pntsd;
+	struct smb_acl *pdacl;
+	struct smb_ace *ace;
+
+	pntsd = kunit_kzalloc(test, TEST_NTSD_SIZE, GFP_KERNEL);
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
+	pdacl->size = cpu_to_le16(TEST_DACL_SIZE);
+
+	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
+	fill_test_ace(ace, &test_nonmatching_sid, 0);
+
+	ace = (struct smb_ace *)((char *)ace + TEST_ACE1_SIZE);
+	fill_test_ace(ace, &test_owner_sid, FILE_READ_DATA);
+
+	return pntsd;
+}
+
+static void ksmbd_smb_check_perm_dacl_boundary_test(struct kunit *test)
+{
+	struct file *file;
+	struct smb_ntsd *pntsd;
+	__le32 daccess = cpu_to_le32(FILE_READ_DATA);
+	int rc;
+
+	file = shmem_file_setup("ksmbd-kunit-dacl", 0,
+				mk_vma_flags(VMA_NORESERVE_BIT));
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, file);
+
+	pntsd = build_boundary_ntsd(test);
+	KUNIT_ASSERT_NOT_NULL(test, pntsd);
+
+	rc = ksmbd_vfs_set_sd_xattr(NULL, mnt_idmap(file->f_path.mnt),
+				    &file->f_path, pntsd, TEST_NTSD_SIZE,
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
+static struct kunit_case ksmbd_smbacl_test_cases[] = {
+	KUNIT_CASE(ksmbd_dacl_walk_must_stop_at_declared_size),
+	KUNIT_CASE(ksmbd_smb_check_perm_dacl_boundary_test),
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
2.47.3

