Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03B92D46D6
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765174997; cv=none; b=qXTDFOHBGduBSMrS1VRbo0psXrXQoTq5LXn6xZXmoRo15kG5+0yZxLjeRyAoSSi7ayVGqu8UdDa97kggYbL1O2jwhCccKO7+YEIPH7A6nPGy0Yo0cU1GXvYp55WqE0F46Jvo48/QkY2gTbt/c/eIC+tfMu2/CzntweX/VsyPxXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765174997; c=relaxed/simple;
	bh=w+HjqSmmSbt7zfZ1J0rMAGqbnMjgyRpC5ygAJPZwsr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4MaJX2xuJ2EYEA8LBlMIM9eLzo57SyqTf/OgIHb9LybNm+HQKjzcJ0LtGal74gMW98hffbm9ZMcVroNVgq4p/P34cfWsxTu8Lc0iiepGdxgKZOBTTV62NBtCqu0wHJ5EsFXedPfCAOzvK+/bFaBnfq7HBS5lBLKJqPD/j+3lRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J3f4KxMY; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J3f4KxMY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765174993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aJR3Y2lO+jC+eeKlwNFxeaKtwozyHyD5Wcg011AVdXA=;
	b=J3f4KxMYwQu517VpW2REWNu33uJFntfLH2S24IY0cAjTMNjM+pjLjVuBYUKAhiMn5vgHGp
	FsEMLkclrQNVf9lmF2X9XUo22aDjLZB9reFd/wYQaCKH+eX3ERaWal1bsCSzos+KV5etHC
	j+K8WQuROsDIDhUTYphZnLCjztsSNQI=
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
Subject: [PATCH 14/30] smb/client: introduce DEFINE_CHECK_SEARCH_FUNC()
Date: Mon,  8 Dec 2025 14:20:44 +0800
Message-ID: <20251208062100.3268777-15-chenxiaosong.chenxiaosong@linux.dev>
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

We are going to define 4 functions to check the search results, introduce
the macro DEFINE_CHECK_SEARCH_FUNC() to reduce duplicate code.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc_test.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/smb/client/netmisc_test.c b/fs/smb/client/netmisc_test.c
index a08011621742..b682098d2fc5 100644
--- a/fs/smb/client/netmisc_test.c
+++ b/fs/smb/client/netmisc_test.c
@@ -31,6 +31,21 @@ static void __array ## _check_sort(struct kunit *test)			\
 /* ntstatus_to_dos_map_check_sort */
 DEFINE_CHECK_SORT_FUNC(ntstatus_to_dos_map, ntstatus_to_dos_num, ntstatus);
 
+#define DEFINE_CHECK_SEARCH_FUNC(__struct_name, __field,		\
+				 __array, __num)			\
+static void __array ## _check_search(struct kunit *test)		\
+{									\
+	unsigned int i;							\
+	struct __struct_name expect, *result;				\
+									\
+	for (i = 0; i < __num; i++) {					\
+		expect = __array[i];					\
+		result = search_in_ ## __array(expect.__field);		\
+		KUNIT_EXPECT_PTR_NE(test, NULL, result);		\
+		test_cmp_ ## __struct_name(test, &expect, result);	\
+	}								\
+}
+
 /*
  * Before running these test cases, the smb_init_maperror()
  * function is called first.
-- 
2.43.0

