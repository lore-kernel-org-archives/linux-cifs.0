Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F813C1D7C
	for <linux-cifs@vger.kernel.org>; Wed, 19 Aug 2026 03:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787110265; cv=none; b=h0Eq1SVnDReHA4TyndJjNBnvLeljL1/oL/+VoxbnCem1RYsHiHs5ocNMxlv4SDcfMpP7l4vaBllPZy8qB795nEMzx25WF7n1RgLvKK/WgjqMbd5uU8EZt993lJu4gf0KVkaJHWOC+yqOhIgeZPTm9sVCjp4FbyAnTOJQXrx1YvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787110265; c=relaxed/simple;
	bh=0kwA9tnSAV4PP3SfyZSOagTZmEOgoXBybPYP3R9GX2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siiCaeteumDLtG3PZpuK+8hi4Qxc/oaLvdSqmA6Mgc3V+sBT8IprfmH2k5DHfnl1ElTwqwl0Dr8AgLK97o39h8/NaAf7l8ilQlbfoyudxT9vb/xHxxVqQn+VsLBEzRcQynEi9+UrmlTcMYrfWQeJgeiUZHNWhiGn9YBMXTyKQ6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fW9uGBZd; arc=none smtp.client-ip=74.125.227.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fW9uGBZd"
Received: by mail-pj2-f7.google.com with SMTP id 98e67ed59e1d1-3952813fb92so290352a91.0
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 20:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787110262; x=1787715062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KMFvBXsgdJpqnZiYc5hYuHb5UMDTSnM9AJnf9JIaAOk=;
        b=fW9uGBZd8pftN0hUqYjYEd4KZ+HB4qB0yu/fnmEWOY8J1f7duAdnq5D1IowkZ9R5hQ
         h1Mw5feE45mdD7VaAHSMMtCI5vwiAWvTUBbbm1GeWa7gFk8KOBEWjBdnL39Wn/cozr/y
         pz7ShIMZCbOgZuYWM3KRpHPnq6xoYvFodBtGuvcNMS+nsLn7kQD0wsZBE048oPR5I5FW
         fa7AhiUvGLRgCqTQyCp5h46JWqlxh+sk5qCO+WZe4WcAw13DZmZhsgHdKrK2QU/EVsDo
         YK845/4O3GP4NO3RcR5hS95xbzZwjWZogWvkz/WCL9RfELpFzD9bzkZgYT2CYl5srQx1
         N0hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787110262; x=1787715062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KMFvBXsgdJpqnZiYc5hYuHb5UMDTSnM9AJnf9JIaAOk=;
        b=BjOwBzdBcXrLznOL+LAwlPOSfezqK19SQzvo2Z8S8T4E8GXIaMzh38B3Wb8JVN3+f9
         4/lnj5yikp+BxOd3qteYlqZasvip/Ng0YdRZL8nHb92tacqTcR/yqwWaOQhFu0q5/6Lf
         eO0gahlZ/8G56Cro0JFSVM6tkXC+NAh9AcqUKqIzDnkyDcq+FMrL1A8nEFisBjdO1eFQ
         yACb392CIR8yZJMG6rk4CjV7Sa/bmpNdQiU/F4apyouJWU10LKma6SqIScjaZoEdVxAl
         aKsbJXzzIZCZ8d5QgzChJPAQEi9ltgaNgp2ObirKwhC1xK7ojovv4AUo5fpEnidQt0AE
         WIDw==
X-Gm-Message-State: AOJu0YxQVKo8GthOKKZa9k94LV1rkZ0J1k3eSCtpWZ7+D4W98pfyzFRj
	UvQgIB8PaMZsautAL5dIXyGXbbiKvVRij2A4GiMAHbaxxPYFnsiZNZR6
X-Gm-Gg: AR+sD13toOWvJOwUGx/VZlQYsAAyZwxIL/AGhjUdhD1rSaVefpt56o3Uz/fRi8LZRVO
	hMaxnZPfJx3Cpoh/GKniOJsNq0mQA7GBEYCZzUDjI3R+i5LI02HWTToBj6U16Lpm7fkc3PUeYOJ
	UmxSTODBGImga97e+sppWgitGFLj0Ws12VFI+xOvhfaviaoKUCt5yCQbooC8pPmm3hODTuqu295
	ieyAaxlqLdYOIx+x94JmzVfO5PNy4OMYE0t7s2grLOkRhw4TTeCeweN8fegZfYQSdawLQcYt9vJ
	dmLIovySphKI0XVzgOSKPcrlzkWbWsG+jbTDOSbAV1podf+aBgJcyFNb8NBHgfVLI2YHSpeMtHa
	UG0zYxbfcNx/MIzR/nvCq/8VYKbgmSH5ENyTWq/HTRVt8UjclW4D9573UjOp7GNWt+WMNQhVRUP
	5i3dP0IJtRvASgQdk6FbDLPSzZxRLxH3S5CZ66dRDoMgyBiruPOewJ2oiWetdf/UMUJI2sxIHkV
	cy6ctGVEtJCAQ==
X-Received: by 2002:a17:90a:d60d:b0:390:8361:a532 with SMTP id 98e67ed59e1d1-39580bc9ad4mr3167395a91.7.1787110262192;
        Tue, 18 Aug 2026 20:31:02 -0700 (PDT)
Received: from localhost.localdomain ([180.138.223.172])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb17f48sm1016793a91.2.2026.08.18.20.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 20:31:01 -0700 (PDT)
From: nanx95726@gmail.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	Hang Nan <nanx95726@gmail.com>
Subject: [PATCH v4 3/3] ksmbd: test maximal-access DACL walk boundary
Date: Wed, 19 Aug 2026 11:30:13 +0800
Message-ID: <20260819033013.46824-4-nanx95726@gmail.com>
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

Add a maximal-access variant of the smb_check_perm_dacl() boundary
test.  The in-boundary ACE grants read access, while a trailing ACE
beyond the declared DACL size grants write access.

Verify that maximal-access calculation includes the in-boundary
permission and ignores the trailing permission.

Suggested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Hang Nan <nanx95726@gmail.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/tests/smbacl_kunit.c | 47 ++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/tests/smbacl_kunit.c b/fs/smb/server/tests/smbacl_kunit.c
index 391b1f5d181c..33496b4d31a3 100644
--- a/fs/smb/server/tests/smbacl_kunit.c
+++ b/fs/smb/server/tests/smbacl_kunit.c
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

