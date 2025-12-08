Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F72F30FF27
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765175036; cv=none; b=QISsce76HSv1m//UktTNAbsR2RRL18mY7BWnQV7bLRTsDK5MD9lsFQnhYhTylEVVEixTBj1ceoJmR3DCHZlGoXn7GOiCbGIdz4GuOyjJO/7ZQlpaC5hK7wUXIUUM5S0r1i5rvnQ/ymbuMk131twdE9u0aufGNUAm8Yl9TZ4lLSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765175036; c=relaxed/simple;
	bh=HmEIZPiTzZtmInpYFTQ9y71yoi+Z8ZV7mN815riZDDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGc3N4wSCBY6B5T3Cj6dr6hRbHkLZbYtbgch9nKqDRsMOuR+jfAX6/X5HARSSQJq2XgpILcBSa5/F7GMuWM+vM+q2tE2hQ57WwCEc533hzVWXjk+AB3zPcOZWI1g+Bt0hpzjHrkTZAGd2dOLSm/aWqPUH4l0TmBjCRQaCAn9rXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Lr6BopQ/; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Lr6BopQ/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765175033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tTWF30hl8lTzoVC1euBYS/+HX2I0FeNLuaIl8DWNwa0=;
	b=Lr6BopQ/tjIeKeP/Dd8mR9mrfygRxKSsqzabKfsnwblaw7XfnQNkzlfX+5nS3HaaEi0Mn7
	mn0qtWUrtb9CVrpI8H/vTYxzhZbXXAZyvI1zluzjM+Bfpu11naR5a2dhPeXkWVUzPu+6t9
	b+qzjA2M4ybCu0bVDiUCNF9jKb2vxTA=
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
Subject: [PATCH 27/30] smb/client: introduce KUnit test to check sort result of mapping_table_ERRSRV array
Date: Mon,  8 Dec 2025 14:20:57 +0800
Message-ID: <20251208062100.3268777-28-chenxiaosong.chenxiaosong@linux.dev>
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

The mapping_table_ERRSRV_check_sort() checks whether the array is properly
sorted.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/netmisc_test.c b/fs/smb/client/netmisc_test.c
index eae6c0c09519..4a82edd58dcc 100644
--- a/fs/smb/client/netmisc_test.c
+++ b/fs/smb/client/netmisc_test.c
@@ -34,6 +34,8 @@ DEFINE_CHECK_SORT_FUNC(ntstatus_to_dos_map, ntstatus_to_dos_num, ntstatus);
 DEFINE_CHECK_SORT_FUNC(nt_errs, nt_err_num, nt_errcode);
 /* mapping_table_ERRDOS_check_sort */
 DEFINE_CHECK_SORT_FUNC(mapping_table_ERRDOS, errdos_num, smb_err);
+/* mapping_table_ERRSRV_check_sort */
+DEFINE_CHECK_SORT_FUNC(mapping_table_ERRSRV, errsrv_num, smb_err);
 
 #define DEFINE_CHECK_SEARCH_FUNC(__struct_name, __field,		\
 				 __array, __num)			\
@@ -91,6 +93,7 @@ static struct kunit_case maperror_test_cases[] = {
 	KUNIT_CASE(ntstatus_to_dos_map_check_sort),
 	KUNIT_CASE(nt_errs_check_sort),
 	KUNIT_CASE(mapping_table_ERRDOS_check_sort),
+	KUNIT_CASE(mapping_table_ERRSRV_check_sort),
 	/* check search */
 	KUNIT_CASE(ntstatus_to_dos_map_check_search),
 	KUNIT_CASE(nt_errs_check_search),
-- 
2.43.0

