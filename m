Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FF12D6400
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765175003; cv=none; b=Gy4WoKJ4gtomfvDaAiyb6kSIkAs/A7PEDgldiTwnr7BwzVadGMttDnjYqoOkcesT+EvuYaUHIeorxwgbmkTrkeyytm/cjLv1XcCs1dz8tlGifC83GiM46UCtVgHFQtyRz424o5e5wcRqLzVAZulD0EQNcY/5W8XlSUK1doOwhQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765175003; c=relaxed/simple;
	bh=zUlsFP0kWfxP/Nu/vQ/1H6Q3bmcHNjs5eBBcX6VTM4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcT63cHMDXbO4rr/c9H3b0PbXLLKyOipWwDejQJm75KasmNKbsjGzNMq3mKndXetEV9QWjumN1I29fYYIzXmYPkw1eMbmn1t8WOfOS+vYOmSbMGMdrF4RVEVPM0gBv5rIAfjGhyULXLNkFGoDLdHM/rJM+lDhpIUy6OCuWP+Z5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CaRdO9oH; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CaRdO9oH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765174998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=asRNZfXDHvIaiQ61/yuTWsSsdsmPp8zd3zs+4ob8ifo=;
	b=CaRdO9oHe8KhdIOKx2nb2aaTgNHdZchEoRxV/lpzrPyKt0Rw+iuA+9CUTfYRQ9mPAWZphT
	QVtZz5tAHC3arpzPTa3qtKG+iJ2kkAqKhQAlo5QFfYbF5DZWjqjYBrwWvEwjbdY9bJj438
	fILoFwE4SME4UZBGV9MMjJJa5okUkeY=
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
Subject: [PATCH 16/30] smb/client: sort nt_errs array
Date: Mon,  8 Dec 2025 14:20:46 +0800
Message-ID: <20251208062100.3268777-17-chenxiaosong.chenxiaosong@linux.dev>
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

Sort the array in ascending order, and then we can use binary search
algorithm to quickly find the target NT error code.

The array is sorted only once when cifs.ko is loaded.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc.c | 4 ++++
 fs/smb/client/nterr.c   | 5 ++++-
 fs/smb/client/nterr.h   | 3 ++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 4e6312593d6f..c6fa1389683b 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -801,6 +801,8 @@ static unsigned int ntstatus_to_dos_num = sizeof(ntstatus_to_dos_map) /
 
 /* cmp_ntstatus_to_dos */
 DEFINE_CMP_FUNC(ntstatus_to_dos, ntstatus);
+/* cmp_nt_err_code_struct */
+DEFINE_CMP_FUNC(nt_err_code_struct, nt_errcode);
 
 /* search_in_ntstatus_to_dos_map */
 DEFINE_SEARCH_FUNC(ntstatus_to_dos, ntstatus, ntstatus_to_dos_map, ntstatus_to_dos_num);
@@ -1075,6 +1077,8 @@ void smb_init_maperror(void)
 	/* Sort in ascending order */
 	sort(ntstatus_to_dos_map, ntstatus_to_dos_num,
 	     sizeof(struct ntstatus_to_dos), cmp_ntstatus_to_dos, NULL);
+	sort(nt_errs, nt_err_num, sizeof(struct nt_err_code_struct),
+	     cmp_nt_err_code_struct, NULL);
 }
 
 #if IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 77f84767b7df..8d0007db6af9 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -11,7 +11,7 @@
 #include <linux/fs.h>
 #include "nterr.h"
 
-const struct nt_err_code_struct nt_errs[] = {
+struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_OK", NT_STATUS_OK},
 	{"NT_STATUS_PENDING", NT_STATUS_PENDING},
 	{"NT_STATUS_MEDIA_CHANGED", NT_STATUS_MEDIA_CHANGED},
@@ -686,3 +686,6 @@ const struct nt_err_code_struct nt_errs[] = {
 	 NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP},
 	{NULL, 0}
 };
+
+unsigned int nt_err_num = sizeof(nt_errs) /
+			  sizeof(struct nt_err_code_struct);
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 81f1a78cf41f..e85e65278fb5 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -20,7 +20,8 @@ struct nt_err_code_struct {
 	__u32 nt_errcode;
 };
 
-extern const struct nt_err_code_struct nt_errs[];
+extern struct nt_err_code_struct nt_errs[];
+extern unsigned int nt_err_num;
 
 /* Win32 Status codes. */
 #define NT_STATUS_MORE_ENTRIES         0x0105
-- 
2.43.0

