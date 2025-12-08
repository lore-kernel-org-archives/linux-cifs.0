Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B532566E9
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765174975; cv=none; b=dt/f9VQBoz9xVwgFBn6cGeU7fNOkOTYU7aPA83P6E/XR8dJ0Qx+oFGH6gtn5AhyBySgzR+8u+Ruad1zruFBsAETbf9zUPrmVKiK/C20Di/hJNuJC7O1hu515gMrrQjUuMFjHPqayAx5NF8LsbWGx4CFs5OHTtfTZudHHXjaHm6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765174975; c=relaxed/simple;
	bh=nZTuQhjwIpPjbwuagfzZPzOkVBrlB8U4WUJ3BP/FweU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XF6wb3cfCAeA6w7DWIn30+9/xJIPUhruK8GFfdoZfIpJe71qTluDG0C+mFKfpQXjOcu7GFC20A3Jssmr0VNIaShumNHrSjUsVvhpyKG0kIgfIjwFYtQyyRjq1GsUY0IzpLUaQ8t1J51Uvv3uZy9z91wFrSnZPwkIEz3+xGm5yBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aliJ0NRl; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aliJ0NRl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765174972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YVAPLorQxjFEanIHxcNjJCHMjZghfvqqIOcU2B1W6j4=;
	b=aliJ0NRlgsTTkohIUgcfUt4xJ32EXKhPoGAQKtt/pylkK0L+gzbkZjtaO/ytFVmIV0ViwZ
	ROhILtvsZrkEIiORb1EzwFFg3i/T3hgsBugsX+ADP96mNT07dUzcxk4ZXQPZiOyBzieLoy
	A6L+r/2KYDxtvuwjRhBxfIW012w/zYc=
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
Subject: [PATCH 07/30] smb/client: introduce DEFINE_CMP_FUNC()
Date: Mon,  8 Dec 2025 14:20:37 +0800
Message-ID: <20251208062100.3268777-8-chenxiaosong.chenxiaosong@linux.dev>
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

We are going to define 3 comparison functions, introduce this macro to
reduce duplicate code.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 9ec20601cee2..73c40ae91607 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -24,6 +24,19 @@
 #include "cifs_debug.h"
 #include "nterr.h"
 
+/* Define a comparison function for ascending order. */
+#define DEFINE_CMP_FUNC(__struct_name, __field)				\
+static int cmp_ ## __struct_name(const void *_a, const void *_b)	\
+{									\
+	const struct __struct_name *a = _a, *b = _b;			\
+									\
+	if (a->__field < b->__field)					\
+		return -1;						\
+	if (a->__field > b->__field)					\
+		return 1;						\
+	return 0;							\
+}
+
 struct smb_to_posix_error {
 	__u16 smb_err;
 	int posix_code;
-- 
2.43.0

