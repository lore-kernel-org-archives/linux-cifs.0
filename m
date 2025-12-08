Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839822D9494
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765175005; cv=none; b=Nbd6dnHBHCaKrR4rjd+5CiWJrqPQJgWplXL2Vz4HtXndbHnuUwK0t6C39TsS2x/LJokjcvAzAbGdU3KhO6JEV4195YWfuXXcFmPvvTVqX+Ncto33wMUMK7+IseyTK9W2KsYjyuwvytyOsfnx6WBUBmcJnd3FFuhfNv/yfI71oe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765175005; c=relaxed/simple;
	bh=0m+92y/SBaRNcCGT811om6AHRFNLk/TfN5eGck7ehAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNluVz3PKPqsYQqhRY1KxUBJCyuVEkiXSBmlFmuF7jebp6aSSnYRHsro1ESqAcc81AepkwLAxUV5y+jZVchfeKvwp3U2nQFeJaUwBcQtqOhKmdr9EKP/H1jHSiW57/d9DRyJFTTD8DKtNVO0odgZoO/DpCgqPfWyo0omNLL0dj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wbd6o1n5; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wbd6o1n5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765175002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aCqcQYqATX8tzhKC69tk3LOXN1S0JW2qdhe+oXVr/WY=;
	b=Wbd6o1n5V+SGECBvylRyHawL10rXpQkGZ40WblYz+j8CckOM2RkRXGkOup7dGA09CP5fen
	CK1Un8yB3D7yjWTFs9DHi3yxrMAqAv10o5dn3X57bH7VCSvZdsCCNGn7rRoocsHfMO6xbV
	XBpl7fy4zc2CoMqgaLDvGiUYBxVQWI4=
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
Subject: [PATCH 17/30] smb/client: introduce KUnit test to check sort result of nt_errs array
Date: Mon,  8 Dec 2025 14:20:47 +0800
Message-ID: <20251208062100.3268777-18-chenxiaosong.chenxiaosong@linux.dev>
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

The nt_errs_check_sort() checks whether the array is properly sorted.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/netmisc_test.c b/fs/smb/client/netmisc_test.c
index ade5005fecb7..796c39b02073 100644
--- a/fs/smb/client/netmisc_test.c
+++ b/fs/smb/client/netmisc_test.c
@@ -30,6 +30,8 @@ static void __array ## _check_sort(struct kunit *test)			\
 
 /* ntstatus_to_dos_map_check_sort */
 DEFINE_CHECK_SORT_FUNC(ntstatus_to_dos_map, ntstatus_to_dos_num, ntstatus);
+/* nt_errs_check_sort */
+DEFINE_CHECK_SORT_FUNC(nt_errs, nt_err_num, nt_errcode);
 
 #define DEFINE_CHECK_SEARCH_FUNC(__struct_name, __field,		\
 				 __array, __num)			\
@@ -65,6 +67,7 @@ DEFINE_CHECK_SEARCH_FUNC(ntstatus_to_dos, ntstatus, ntstatus_to_dos_map, ntstatu
 static struct kunit_case maperror_test_cases[] = {
 	/* check sort */
 	KUNIT_CASE(ntstatus_to_dos_map_check_sort),
+	KUNIT_CASE(nt_errs_check_sort),
 	/* check search */
 	KUNIT_CASE(ntstatus_to_dos_map_check_search),
 	{}
-- 
2.43.0

