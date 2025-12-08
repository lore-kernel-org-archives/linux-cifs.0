Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5AC3112BC
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765175044; cv=none; b=K4Jpp9Ywl42EfCZs0ByYv8N8bARH4+0PuV3vigxuPizHOxT3Af+IIqgCueVOHXIoOAKz4Y2G1DGxSNJWMhAlesaHC7+w1/NvqyeQSSzitoI1J1Hdzt7w8gpOYOWKoFtSxf1XOFF373hlOV+tmFb0KHR0PT1frGqUhcNhSmOh2dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765175044; c=relaxed/simple;
	bh=lNfalccXq2mZa6T379vmj1fWDRFnL44cgaeZY+hpIjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQTNIi+MBgEOB6/AHkplDoJitGMim2u7TnWSEd45k7tIBYUIcsz3QOgK/Rh+DxZMarVhpoQ4fWkRqlGKmOiON1Usrzvjho+gTIs+TwHVlcNR57XCYYZgokV5pqJlM8/uBgY3DOFuSPbLHkqw/0/p7cyHUGaYgwT4k+lKxe9ZnqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=laKcQEst; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="laKcQEst"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765175040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6vHqVxcBfcpccrXZOm1g4GOCESBEdv6OnJh0S45kJKs=;
	b=laKcQEstT7AIU8+JnmuvLAoDWpZws9CMcXO1G6XR4vbH2mLS/lqeiyvioGFUAw6zt7SRme
	zMNtgb3fCrL/KWZjWwZbPLo3JXD9A3L3Qjl/ahpoRS6D4+l/aK91BlaPqSOvgzZkxciX8H
	NA+Orovb4MZ3ETWAY4UM7gIQvv180p0=
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
Subject: [PATCH 30/30] smb/client: introduce KUnit test to check search result of mapping_table_ERRSRV array
Date: Mon,  8 Dec 2025 14:21:00 +0800
Message-ID: <20251208062100.3268777-31-chenxiaosong.chenxiaosong@linux.dev>
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

The mapping_table_ERRSRV_check_search() checks whether all elements can be
correctly found in the array.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/netmisc_test.c b/fs/smb/client/netmisc_test.c
index 4a82edd58dcc..fa8e98b46e88 100644
--- a/fs/smb/client/netmisc_test.c
+++ b/fs/smb/client/netmisc_test.c
@@ -83,6 +83,8 @@ DEFINE_CHECK_SEARCH_FUNC(ntstatus_to_dos, ntstatus, ntstatus_to_dos_map, ntstatu
 DEFINE_CHECK_SEARCH_FUNC(nt_err_code_struct, nt_errcode, nt_errs, nt_err_num);
 /* mapping_table_ERRDOS_check_search */
 DEFINE_CHECK_SEARCH_FUNC(smb_to_posix_error, smb_err, mapping_table_ERRDOS, errdos_num);
+/* mapping_table_ERRSRV_check_search */
+DEFINE_CHECK_SEARCH_FUNC(smb_to_posix_error, smb_err, mapping_table_ERRSRV, errsrv_num);
 
 /*
  * Before running these test cases, the smb_init_maperror()
@@ -98,6 +100,7 @@ static struct kunit_case maperror_test_cases[] = {
 	KUNIT_CASE(ntstatus_to_dos_map_check_search),
 	KUNIT_CASE(nt_errs_check_search),
 	KUNIT_CASE(mapping_table_ERRDOS_check_search),
+	KUNIT_CASE(mapping_table_ERRSRV_check_search),
 	{}
 };
 
-- 
2.43.0

