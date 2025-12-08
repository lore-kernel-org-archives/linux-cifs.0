Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798942FE07F
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765175022; cv=none; b=EFpL4evTNdXUJ20cIM8fz8UYNNmbRKUh83YYGXk7oF0yXLZ4dTLBpjkGQWJ0q+5KZC4o2Qx0gHW5QyKAPWAEltmxsKmwBw9GwzqQ3AynjBJk2iLSd7pvLQwzTeP1/PFUHKSLI+L3xYT31WUP74VjoJhbA+plg3jcAuAhhuzSFko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765175022; c=relaxed/simple;
	bh=0+TSKn9xvstbLXf28cDor21+UnVBtpTPfgpOiLO93hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZpE/Uj62tCjPHKvq/XMMqpTZoeoN8Q/e1DXA8P4u36Cw8MwGZy2wA7eVqjwpHAUfvKKgzK4OhOzscMz8TTwACu7TpizKS6mvuEBH2gm4m9Ppt2N+z1MRkxx0bs/sogSz9zxeNoG5rO5TRmtZzR1Th6T2DIgbTUGgHT/zIxx5kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XHrSb8m9; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XHrSb8m9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765175018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wyr3AOKUBR7one2NvGhD8gKURCb8oQFRzSJsmDBjxzE=;
	b=XHrSb8m9VNnDfToYM2vPVMf2D+WegJvrGg1N7b5xltATveQYR5IPRNm3aYgWl4mRe+/lNf
	nIjQvwIr5XGrQI8SgdnztJoPypdLIwM76bfJJTs+CEQaBCHzrZnLoLRfnBAH1hZm8ae5SL
	3CcZP2paPS1dlGJNKFJ7SDQ42307jPo=
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
Subject: [PATCH 22/30] smb/client: introduce KUnit test to check sort result of mapping_table_ERRDOS array
Date: Mon,  8 Dec 2025 14:20:52 +0800
Message-ID: <20251208062100.3268777-23-chenxiaosong.chenxiaosong@linux.dev>
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

The mapping_table_ERRDOS_check_sort() checks whether the array is properly
sorted.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/netmisc_test.c b/fs/smb/client/netmisc_test.c
index 195c889af7be..caa0892ec119 100644
--- a/fs/smb/client/netmisc_test.c
+++ b/fs/smb/client/netmisc_test.c
@@ -32,6 +32,8 @@ static void __array ## _check_sort(struct kunit *test)			\
 DEFINE_CHECK_SORT_FUNC(ntstatus_to_dos_map, ntstatus_to_dos_num, ntstatus);
 /* nt_errs_check_sort */
 DEFINE_CHECK_SORT_FUNC(nt_errs, nt_err_num, nt_errcode);
+/* mapping_table_ERRDOS_check_sort */
+DEFINE_CHECK_SORT_FUNC(mapping_table_ERRDOS, errdos_num, smb_err);
 
 #define DEFINE_CHECK_SEARCH_FUNC(__struct_name, __field,		\
 				 __array, __num)			\
@@ -78,6 +80,7 @@ static struct kunit_case maperror_test_cases[] = {
 	/* check sort */
 	KUNIT_CASE(ntstatus_to_dos_map_check_sort),
 	KUNIT_CASE(nt_errs_check_sort),
+	KUNIT_CASE(mapping_table_ERRDOS_check_sort),
 	/* check search */
 	KUNIT_CASE(ntstatus_to_dos_map_check_search),
 	KUNIT_CASE(nt_errs_check_search),
-- 
2.43.0

