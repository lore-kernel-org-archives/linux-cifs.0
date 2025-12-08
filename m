Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B84920E030
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765174968; cv=none; b=YtNBGGA6ZSqioPGq7STN8L+m+oSJX2mA4GGpQtAEexAkYuiLDpEtE/HjruT5mF7Lsxt4+nV+6y88j5XVgELghI0QgPshrhVaQVChcCxp/BySqGi4L245BqRhv7boYLrV5fj235GMxLULT8Il9gGpmJ+2WzfvLrlnccSSvxEMYvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765174968; c=relaxed/simple;
	bh=45gtJ4TDeo035YyRd6gLxLlo/JltDydNK4mdOBiaVbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8eQAoNhF0nzPJid2R3WS2QU4C8y+QNwwKuVk6VqUD0Cwknm88PADP9OIc6Imr9InBQKaFeL8q3wLLA8/nK9xMQVicZhksenxAiw4vPEQnjP/F/kHkU60lF4wK6S4S15rXI0XDwK5IhduoHcyMeJJWFiLR8kAYXEq8zwrshW6iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IzHGCgPf; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IzHGCgPf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765174964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sZ6sNuUV8H/0CDiMN0hDcnN3fcjAX8x8J+6K/titgKc=;
	b=IzHGCgPfBmqweZ6mJOvDqXbzyYFE8T8wvi43ELYAL9u1Sv7KmQGUdGywesb/v7o3I+0JhS
	bItQ4Im04DGJskb5+hHwNPpM7VMwKw/Ryq+UmmMAPCiExFCn4JcLr5AcG53Clol37usVSZ
	HXoNv7VBJv8IxNlKohSG3Y9ZrCGewsg=
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
Subject: [PATCH 05/30] smb/client: add 4 NT error code definitions
Date: Mon,  8 Dec 2025 14:20:35 +0800
Message-ID: <20251208062100.3268777-6-chenxiaosong.chenxiaosong@linux.dev>
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

From server/nterr.h that has been removed.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c | 5 +++++
 fs/smb/client/nterr.h | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 8f0bc441295e..77f84767b7df 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -13,6 +13,7 @@
 
 const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_OK", NT_STATUS_OK},
+	{"NT_STATUS_PENDING", NT_STATUS_PENDING},
 	{"NT_STATUS_MEDIA_CHANGED", NT_STATUS_MEDIA_CHANGED},
 	{"NT_STATUS_END_OF_MEDIA", NT_STATUS_END_OF_MEDIA},
 	{"NT_STATUS_MEDIA_CHECK", NT_STATUS_MEDIA_CHECK},
@@ -544,6 +545,7 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_DOMAIN_TRUST_INCONSISTENT",
 	 NT_STATUS_DOMAIN_TRUST_INCONSISTENT},
 	{"NT_STATUS_FS_DRIVER_REQUIRED", NT_STATUS_FS_DRIVER_REQUIRED},
+	{"NT_STATUS_INVALID_LOCK_RANGE", NT_STATUS_INVALID_LOCK_RANGE},
 	{"NT_STATUS_NO_USER_SESSION_KEY", NT_STATUS_NO_USER_SESSION_KEY},
 	{"NT_STATUS_USER_SESSION_DELETED", NT_STATUS_USER_SESSION_DELETED},
 	{"NT_STATUS_RESOURCE_LANG_NOT_FOUND",
@@ -675,9 +677,12 @@ const struct nt_err_code_struct nt_errs[] = {
 	 NT_STATUS_QUOTA_LIST_INCONSISTENT},
 	{"NT_STATUS_FILE_IS_OFFLINE", NT_STATUS_FILE_IS_OFFLINE},
 	{"NT_STATUS_NOT_A_REPARSE_POINT", NT_STATUS_NOT_A_REPARSE_POINT},
+	{"NT_STATUS_NETWORK_SESSION_EXPIRED", NT_STATUS_NETWORK_SESSION_EXPIRED},
 	{"NT_STATUS_NO_MORE_ENTRIES", NT_STATUS_NO_MORE_ENTRIES},
 	{"NT_STATUS_MORE_ENTRIES", NT_STATUS_MORE_ENTRIES},
 	{"NT_STATUS_SOME_UNMAPPED", NT_STATUS_SOME_UNMAPPED},
 	{"NT_STATUS_NO_SUCH_JOB", NT_STATUS_NO_SUCH_JOB},
+	{"NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP",
+	 NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP},
 	{NULL, 0}
 };
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 09263c91d07a..4bc20c7bfe72 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -35,6 +35,7 @@ extern const struct nt_err_code_struct nt_errs[];
  */
 
 #define NT_STATUS_OK                   0x0000
+#define NT_STATUS_PENDING              0x0103
 #define NT_STATUS_SOME_UNMAPPED        0x0107
 #define NT_STATUS_BUFFER_OVERFLOW  0x80000005
 #define NT_STATUS_NO_MORE_ENTRIES  0x8000001a
@@ -451,6 +452,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_NOLOGON_SERVER_TRUST_ACCOUNT 0xC0000000 | 0x019a
 #define NT_STATUS_DOMAIN_TRUST_INCONSISTENT 0xC0000000 | 0x019b
 #define NT_STATUS_FS_DRIVER_REQUIRED 0xC0000000 | 0x019c
+#define NT_STATUS_INVALID_LOCK_RANGE 0xC0000000 | 0x01a1
 #define NT_STATUS_NO_USER_SESSION_KEY 0xC0000000 | 0x0202
 #define NT_STATUS_USER_SESSION_DELETED 0xC0000000 | 0x0203
 #define NT_STATUS_RESOURCE_LANG_NOT_FOUND 0xC0000000 | 0x0204
@@ -547,6 +549,8 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_QUOTA_LIST_INCONSISTENT 0xC0000000 | 0x0266
 #define NT_STATUS_FILE_IS_OFFLINE 0xC0000000 | 0x0267
 #define NT_STATUS_NOT_A_REPARSE_POINT 0xC0000000 | 0x0275
+#define NT_STATUS_NETWORK_SESSION_EXPIRED  0xC0000000 | 0x035c
 #define NT_STATUS_NO_SUCH_JOB 0xC0000000 | 0xEDE	/* scheduler */
+#define NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP 0xC0000000 | 0x5D0000
 
 #endif				/* _NTERR_H */
-- 
2.43.0

