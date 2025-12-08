Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A93A2D5C68
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765174999; cv=none; b=hBoUO+l6fd4kgL4xqAy15xxUGEUzarhDQsf8VG4IU212GbZ0MSQ3BJA8sk18mRAovk9nOnmMLMu3Wle6anNSfrFAJPlgc7i8wq4g/ZPZbhKC7O6vRTUALl00iUWonU1He+fi9GfyZdpRWQYaVYbp4TakUVTiJs5X+M8T+gY2ET0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765174999; c=relaxed/simple;
	bh=pRzb8+hsIY8+uEZYO4oKNbJGcUMbe6cfss97TqZkkFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9nFwFqFjaOAIdJZyNsMQiMstECmFU0kuhhuUQ1qM6uEDmX7xPUPc4Ci51fYMGHaXFvvEBUbFFL0M1Mo8NXmqh6U1/uKsXy9pmEK180yiNm7DJjAJCL4Ali55VfJo3gljE9L+MABiF3HK7uiSY+jOm1tYzt7cfeQH6YOVHvjC8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T6uMu0NU; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T6uMu0NU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765174995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J2X6jD6NKRtbno8GH7JQAP8bLmK1PtLbAy024WDVh/M=;
	b=T6uMu0NUMLxsTHuZjCFaJlYlpc/Td1Sb6/D1bVFjB7zCky85EQcBEDjJb3uH0Dk8/s4ei3
	HkrvDX7i7oCBw9WTfGHP1tnxjekaQCmDBq2GR2kndxKFmshKPS3W5GeZaqLUvxc5kiMOCL
	XNcpNvHvplZvep8IJsWVGO6pr8WibCk=
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
Subject: [PATCH 15/30] smb/client: introduce KUnit test to check search result of ntstatus_to_dos_map array
Date: Mon,  8 Dec 2025 14:20:45 +0800
Message-ID: <20251208062100.3268777-16-chenxiaosong.chenxiaosong@linux.dev>
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

The ntstatus_to_dos_map_check_search() checks whether all elements can be
correctly found in the array.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc_test.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/smb/client/netmisc_test.c b/fs/smb/client/netmisc_test.c
index b682098d2fc5..ade5005fecb7 100644
--- a/fs/smb/client/netmisc_test.c
+++ b/fs/smb/client/netmisc_test.c
@@ -46,6 +46,18 @@ static void __array ## _check_search(struct kunit *test)		\
 	}								\
 }
 
+static void test_cmp_ntstatus_to_dos(struct kunit *test,
+				     struct ntstatus_to_dos *expect,
+				     struct ntstatus_to_dos *result)
+{
+	KUNIT_EXPECT_EQ(test, expect->dos_class, result->dos_class);
+	KUNIT_EXPECT_EQ(test, expect->dos_code, result->dos_code);
+	KUNIT_EXPECT_EQ(test, expect->ntstatus, result->ntstatus);
+}
+
+/* ntstatus_to_dos_map_check_search */
+DEFINE_CHECK_SEARCH_FUNC(ntstatus_to_dos, ntstatus, ntstatus_to_dos_map, ntstatus_to_dos_num);
+
 /*
  * Before running these test cases, the smb_init_maperror()
  * function is called first.
@@ -53,6 +65,8 @@ static void __array ## _check_search(struct kunit *test)		\
 static struct kunit_case maperror_test_cases[] = {
 	/* check sort */
 	KUNIT_CASE(ntstatus_to_dos_map_check_sort),
+	/* check search */
+	KUNIT_CASE(ntstatus_to_dos_map_check_search),
 	{}
 };
 
-- 
2.43.0

