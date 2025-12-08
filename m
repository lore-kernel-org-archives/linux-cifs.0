Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278982DC76B
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765175015; cv=none; b=m5zL6qqB7NJFYZkdrg6CwjBjfVzXEKE45khjFWfI/nc09opmOVDErGUUy/dsjSC2Ocwt+nMFRF6OLjCrXNn8QaI8Bq6vZzG1md4EAEFemQiXJ80GOszIkGll80YPRiyhBP2K4ZGhSJTmVERWSKflg2RkrW5peEjGoYJVVrV21Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765175015; c=relaxed/simple;
	bh=dhZuDEID0Z/aBeN3xNrwL5VJUnCCXa+touMWdI86x5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+f1nSvqOgIHQBPRpeT15rL6E9mYPG0lh/CoeTet7a5OsUqcfaXtgaHAmfLiO3eXDADa2qlMnaUPwSyRETik8VKOI1SwHHcOs3QrhZCPI8I9eK/xqE2SMRsmdEEcleysyH89nfc3rqBb4qAanUnKJlsQlFOJI/UUemCmKu9c7RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HtLL2y6m; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HtLL2y6m"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765175012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E6vPz4QHk5IDZ2k4eGBbQRT992n8e3dUaVTP5QHxf6E=;
	b=HtLL2y6m1HIDTEDjxOw9p7Oz0nfeF+r1PHYzwHQDTr/oqjl2IUrL83vuDIoeudkwkXoPvP
	z25a0UScxGa+iSZ4FnVI+R22hcYOGZvOAC6Vlu1KEfWCXlxcssdW3WosqJPN01Ghpdyfve
	Rwe3k4feTMQ13Ju2974JrBg9T6ZKAd0=
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
Subject: [PATCH 20/30] smb/client: introduce KUnit test to check search result of nt_errs array
Date: Mon,  8 Dec 2025 14:20:50 +0800
Message-ID: <20251208062100.3268777-21-chenxiaosong.chenxiaosong@linux.dev>
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

The KUnit test are executed when cifs.ko is loaded.

The nt_errs_check_search() checks whether all elements can be correctly
found in the nt_errs array.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc_test.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/client/netmisc_test.c b/fs/smb/client/netmisc_test.c
index 796c39b02073..195c889af7be 100644
--- a/fs/smb/client/netmisc_test.c
+++ b/fs/smb/client/netmisc_test.c
@@ -57,8 +57,18 @@ static void test_cmp_ntstatus_to_dos(struct kunit *test,
 	KUNIT_EXPECT_EQ(test, expect->ntstatus, result->ntstatus);
 }
 
+static void test_cmp_nt_err_code_struct(struct kunit *test,
+					struct nt_err_code_struct *expect,
+					struct nt_err_code_struct *result)
+{
+	KUNIT_EXPECT_STREQ(test, expect->nt_errstr, result->nt_errstr);
+	KUNIT_EXPECT_EQ(test, expect->nt_errcode, result->nt_errcode);
+}
+
 /* ntstatus_to_dos_map_check_search */
 DEFINE_CHECK_SEARCH_FUNC(ntstatus_to_dos, ntstatus, ntstatus_to_dos_map, ntstatus_to_dos_num);
+/* nt_errs_check_search */
+DEFINE_CHECK_SEARCH_FUNC(nt_err_code_struct, nt_errcode, nt_errs, nt_err_num);
 
 /*
  * Before running these test cases, the smb_init_maperror()
@@ -70,6 +80,7 @@ static struct kunit_case maperror_test_cases[] = {
 	KUNIT_CASE(nt_errs_check_sort),
 	/* check search */
 	KUNIT_CASE(ntstatus_to_dos_map_check_search),
+	KUNIT_CASE(nt_errs_check_search),
 	{}
 };
 
-- 
2.43.0

