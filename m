Received: from out203-205-221-242.mail.qq.com (out203-205-221-242.mail.qq.com [203.205.221.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5D1246788
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 03:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787023783; cv=none; b=Eu007trl7JSYEMRHYgFkYR+Eq8NwY5cYqUEPgwbyP+kzsXJrc7oUosiamk/vUImqRBABGGIJg+n6DSZnf/fzPnjY9lvvq4nYFZkWRjcnzJI/VZs9wuwTJm3Ujbp4lGUdPfs2UdvOdKtVpgWZsUT/s9tH6YInww9RXlx23eoLc0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787023783; c=relaxed/simple;
	bh=G+lD/pwkbTbJEEG1zvZjwb+ng2FKGlvEgz/Hp/TQ90k=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=pzRaX8747dhqR0+ynAB+bf8cNoHL/QEfJ9SzN/HQ51q5L9820uMMWexmUnYedmdL7ORlWB7CdKIf+0v7ZwoypgThUyugnu1giVKJR5v7P3BxMyfeXaQedP6z2v1+xkV+tmJVzm+Oi/l0JHldudu2qOyaKGxRiiSbcf7o2HfHdvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=EHz1/7cw; arc=none smtp.client-ip=203.205.221.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="EHz1/7cw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787023773; bh=hpmbVwcrRO15E7aJPt0eYzl0wXYP9lLH4gxtaZcqSbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHz1/7cwz+UCOsYETAQov2vqcFcbwsMHPeCFB2zTPdXayCcpxZZPG6DOUu3AnOX5o
	 NYXjIFECDlKCzz23TwrE09GbQGHXP0gsaB1as+eAycbB9EMRrncyaJGiOrru0of1uj
	 QvZ0cpaVjia+vPASlxEqHQb2lfLCIS4uTRCC1VdA=
Received: from localhost.localdomain ([240e:453:ddc8:a66b:124:844d:8bab:70af])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 5F59A495; Tue, 18 Aug 2026 11:23:53 +0800
X-QQ-mid: xmsmtpt1787023741t8qrorg84
Message-ID: <tencent_E05F41E97F655A17B0F6D8C44E4F7F481E08@qq.com>
X-QQ-XMAILINFO: N12ELSCN06j9cbmuoTngQ28XLvI91SvkgyD2n2plTYA/hIeY+EKMpSIyLoQUmB
	 OQh7VHgSl1Roh7M/jc6FB6Pvtq8O+yHanLgffEy20SHmxQYaF4gn5YwxBJh/05raU5t9zRvZILv0
	 bUPHZqUXhm1F9VWwQ0Lkw7nvW6ejx3JDZhGvjvdtStLc/pr0iwF05vUAgfpuvId5OYR742T/1jmn
	 x16e9nIRE8znirycXgz/PSKd/Ruyff0N7h/iOu/FQcDFnME873+eSxvAm2LxNbf2ug6lLHqw/V2/
	 CQYAbbI8SLX8lfGszSufqq23Ztae4vchAKK9G6pCFOdJUgnXWUY0hWQFAlLwO8Ewfg4kXNQfemhV
	 45fyMh6SyjK2Y7K/6U1C52F7RZ30tMs9pnC08avbiTDvCLWfIFnvCfkNZryVYy0jmqGSl5Bgfqxt
	 XYvmTcvQdXnOz5U/4P8o+doUNQsEo3ZoYz9lxwTRGMaIvO+F1Y1MUrILE1QPuSBzRULp4Li32XSK
	 KjSm/eochCC5CId7oQzW2HS8ud93t1J+0wEjUizWCmiDNsZd/P5dxbDZPzHqUJUGxi0OmZ+b1f8c
	 Xv1MqVkYy3fNG6yvsbgBWf3mW9ZON7rlT0JHcRBGr7e3r6y0LMsqf9q2BBgDNyNOSIsgux5Khz48
	 n9o+VZh/mz12+bss6r9/782CeyQIxXnqdcFBzvEWaLLSwjWHZ5yj1O14o6rZeFvvZ/wsABdRw7GR
	 7Y6tKSXTjPeScKa3GGRnaZ1eSP6i6SlQ9HSYmiLemmkmvfdSn5Aw4m3eakhEhpVFsdxolefb3CHx
	 cYKDkCcH/JW1WS0llIUvQdOAsdGjbZ+jmGtwr4xvSxjBsuxWoY4Iu7Wz6glAC/uJfldSOIGihWx2
	 HDhArATKw8GPy9Kz96w2eplh4Kjy+SMJ+Y0LQrj5AIPBd12L8gwy5jL1aS+PMe1kSogN7Vv5jiD8
	 ThKUqyCmr4vPb92tv8epVPyokqfB50xXQMMLszJPM2r2qT0JwAM02aGakt6M9U0Zbgrw3hoTn5mt
	 tqpITS3FjeUgiswGMQ8HUQEhTYmdxObIccyXWqN4//ENBUMqKEpmsbgGcJWTbaK+/ULVvzgNIA0J
	 byhYrdULdPVFXJIXPymQ7a7tqr++iGRCmNaCACfMBunWAEFQEEGnk9oaniPQ==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Hang Nan <2122295973@qq.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	Hang Nan <2122295973@qq.com>
Subject: [PATCH v3 3/3] ksmbd: test maximal-access DACL walk boundary
Date: Tue, 18 Aug 2026 11:23:34 +0800
X-OQ-MSGID: <20260818032335.10643-4-2122295973@qq.com>
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

Add a maximal-access variant of the smb_check_perm_dacl() boundary
test.  The in-boundary ACE grants read access, while a trailing ACE
beyond the declared DACL size grants write access.

Verify that maximal-access calculation includes the in-boundary
permission and ignores the trailing permission.

Suggested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Hang Nan <2122295973@qq.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smbacl_test.c | 47 ++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smbacl_test.c b/fs/smb/server/smbacl_test.c
index d1703b83aeff..f1f7722bb5d5 100644
--- a/fs/smb/server/smbacl_test.c
+++ b/fs/smb/server/smbacl_test.c
@@ -12,10 +12,11 @@
  *   sits beyond struct smb_acl::size; stopping at the declared DACL
  *   size (the fixed behaviour) rejects it.
  *
- * - ksmbd_smb_check_perm_dacl_boundary: drives the real
+ * - ksmbd_smb_check_perm_dacl_boundary and
+ *   ksmbd_smb_check_perm_dacl_maximal_boundary: drive the real
  *   smb_check_perm_dacl() with a descriptor stored through ksmbd's own
- *   NTACL xattr path on a tmpfs file, and asserts that a post-boundary
- *   ACE is not selected for a regular access check.
+ *   NTACL xattr path on a tmpfs file, and assert that a post-boundary
+ *   ACE is not selected for either a regular or maximal access check.
  */
 
 #include <kunit/test.h>
@@ -242,9 +243,49 @@ static void ksmbd_smb_check_perm_dacl_boundary_test(struct kunit *test)
 	fput(file);
 }
 
+static void
+ksmbd_smb_check_perm_dacl_maximal_boundary_test(struct kunit *test)
+{
+	struct file *file;
+	struct smb_ntsd *pntsd;
+	__le32 daccess = FILE_MAXIMAL_ACCESS_LE;
+	int ntsd_size, rc;
+
+	/*
+	 * The in-boundary ACE grants read access.  The trailing ACE grants
+	 * write access, which must not be included in the maximal access mask.
+	 */
+	pntsd = build_boundary_ntsd(test, &test_owner_sid, FILE_READ_DATA,
+				     FILE_WRITE_DATA, &ntsd_size);
+	KUNIT_ASSERT_NOT_NULL(test, pntsd);
+
+	file = shmem_file_setup("ksmbd-kunit-dacl-maximal", 0,
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
+				 FILE_MAXIMAL_ACCESS_LE, 0, false);
+	KUNIT_EXPECT_EQ(test, 0, rc);
+	if (rc)
+		goto out;
+
+	KUNIT_EXPECT_TRUE(test, le32_to_cpu(daccess) & FILE_READ_DATA);
+	KUNIT_EXPECT_FALSE(test, le32_to_cpu(daccess) & FILE_WRITE_DATA);
+out:
+	fput(file);
+}
+
 static struct kunit_case ksmbd_smbacl_test_cases[] = {
 	KUNIT_CASE(ksmbd_dacl_walk_must_stop_at_declared_size),
 	KUNIT_CASE(ksmbd_smb_check_perm_dacl_boundary_test),
+	KUNIT_CASE(ksmbd_smb_check_perm_dacl_maximal_boundary_test),
 	{}
 };
 
-- 
2.55.0

