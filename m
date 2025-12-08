Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF8230F951
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765175030; cv=none; b=N1ssAONbqRJlG2Zsd+iqF92FDS9YTi3gzvMhHL0/sfkafiL9ewHQ9dqI8ARrsJlp6iEOkn9R+lVmdVVUNGW0av/YRDopQ1zlMu2mOwK1b7HxYnJCMvXaJ+rSkCorbiuvPkwms0364O2NdFlZKCaRuZSoM7XAJLlSiY++y80C6Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765175030; c=relaxed/simple;
	bh=bKSGWnqPVBrpvQ0xwNszsXsGsytqu6vbNWKR9bqvvAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMs0o0dO1yrUfNcZaL8h+qUMT/AY61hc+4kMTDMcDn0rW/sRytALua0yEjqbq3e8lCLZEP+B6iFfkVg6ac8/vMr0nb5kNfPd4kdeZQ+I4UA7SxRbNhaqAfqlwm7F3qijllZYtWChrvEEcIR2TpudYqNEHy6ijsvWh6sXY47lE7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SjfkD1d9; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SjfkD1d9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765175026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gnY9ve5jhkgPJFFO+RNK/MJ5nNh2WHNobvcaEftFspk=;
	b=SjfkD1d9N3FLP8BjlxvInpK8OrFC0sTcZgMtnLME6JEcJu3pOOTUCrUzTQmwGggVUT0Y4R
	UTUBhIzNqsanUXnsI9VqT9fTFpHqO7Xuy1MnlvZ3GPaCTV5scK4yOXoUtmxxnorQcEwb85
	brGwy5qrNNcYOpElqQcXMgFgY7ubghM=
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
Subject: [PATCH 25/30] smb/client: introduce KUnit test to check search result of mapping_table_ERRDOS array
Date: Mon,  8 Dec 2025 14:20:55 +0800
Message-ID: <20251208062100.3268777-26-chenxiaosong.chenxiaosong@linux.dev>
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

The mapping_table_ERRDOS_check_search() checks whether all elements can be
correctly found in the array.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc_test.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/client/netmisc_test.c b/fs/smb/client/netmisc_test.c
index caa0892ec119..eae6c0c09519 100644
--- a/fs/smb/client/netmisc_test.c
+++ b/fs/smb/client/netmisc_test.c
@@ -67,10 +67,20 @@ static void test_cmp_nt_err_code_struct(struct kunit *test,
 	KUNIT_EXPECT_EQ(test, expect->nt_errcode, result->nt_errcode);
 }
 
+static void test_cmp_smb_to_posix_error(struct kunit *test,
+					struct smb_to_posix_error *expect,
+					struct smb_to_posix_error *result)
+{
+	KUNIT_EXPECT_EQ(test, expect->smb_err, result->smb_err);
+	KUNIT_EXPECT_EQ(test, expect->posix_code, result->posix_code);
+}
+
 /* ntstatus_to_dos_map_check_search */
 DEFINE_CHECK_SEARCH_FUNC(ntstatus_to_dos, ntstatus, ntstatus_to_dos_map, ntstatus_to_dos_num);
 /* nt_errs_check_search */
 DEFINE_CHECK_SEARCH_FUNC(nt_err_code_struct, nt_errcode, nt_errs, nt_err_num);
+/* mapping_table_ERRDOS_check_search */
+DEFINE_CHECK_SEARCH_FUNC(smb_to_posix_error, smb_err, mapping_table_ERRDOS, errdos_num);
 
 /*
  * Before running these test cases, the smb_init_maperror()
@@ -84,6 +94,7 @@ static struct kunit_case maperror_test_cases[] = {
 	/* check search */
 	KUNIT_CASE(ntstatus_to_dos_map_check_search),
 	KUNIT_CASE(nt_errs_check_search),
+	KUNIT_CASE(mapping_table_ERRDOS_check_search),
 	{}
 };
 
-- 
2.43.0

