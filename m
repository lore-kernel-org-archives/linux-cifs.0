Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09182566E9
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765174989; cv=none; b=lO2rnvepuRx0idggULy0mf+ANLBCTzsNyPlpjHVytCPQq/E3J2VsGqW9TmrvI1hdV4/Alo4rwXY+MOHsk11lykS3h5+HjH6iHjBLxjxaqM5S5QOTte/lOlhUIXmgkjUxj5rPjxSwxiU8lSMr5gpJ3kR2DtwiKjAE+ymRwFN8c50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765174989; c=relaxed/simple;
	bh=fevP3c65Jrr2pt5mHG6PuwIAxtCG6QM2L9Lk7M3wPMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9Urt9o0SCKwewAwU8BDuQlm195651cJCiwfwLmXAdBC1SHNzoGwFyoOOFNNRSxxezRbkOjNLvQhj7dhF/VlkJ1rBNdXbedbg9vMswxFVBjQpc5R5Qf8ExIu4Y7viEcRb+urtP1wWPgDsk9lgpoKqPjeLJeYxSH1nXM2o7JSakw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aednyjKG; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aednyjKG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765174983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WPYk9/ct0s2wnteAZDnak811DGumJDrLlBkNn7b5zkA=;
	b=aednyjKG6l31CiTomNmeXe8wFnGD8k842KZOf9P0VTEHKozbAWTj4dEo8QdhU9yD3EtZEy
	Z3jZMHzC0Iivuow93Y8OGrwF9elDP5hMJq4Dqkr3mlS2cpPr93xeOM8BZIRZxqrKqRdacD
	ccp8Jbrbit//l1w0dPJvX5MGZVJoVM0=
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
Subject: [PATCH 11/30] smb/client: introduce DEFINE_SEARCH_FUNC()
Date: Mon,  8 Dec 2025 14:20:41 +0800
Message-ID: <20251208062100.3268777-12-chenxiaosong.chenxiaosong@linux.dev>
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

We are going to define 4 search functions, introduce this macro to
reduce duplicate code.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 32197a3a4e81..8a84f826d486 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -38,6 +38,22 @@ static int cmp_ ## __struct_name(const void *_a, const void *_b)	\
 	return 0;							\
 }
 
+/* Define a function for searching the target error map. */
+#define DEFINE_SEARCH_FUNC(__struct_name, __field, __array, __num)	\
+static struct __struct_name *search_in_ ## __array(__le32 error)	\
+{									\
+	struct __struct_name *err_map, key;				\
+									\
+	key = (struct __struct_name) {					\
+		.__field = error,					\
+	};								\
+	err_map = bsearch(&key, __array, __num,				\
+			  sizeof(struct __struct_name),			\
+			  cmp_ ## __struct_name);			\
+									\
+	return err_map;							\
+}
+
 struct smb_to_posix_error {
 	__u16 smb_err;
 	int posix_code;
-- 
2.43.0

