Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09DF2DF703
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765175019; cv=none; b=eKfezxM0cM6R6Hd4sko32bM4azsEwQvFy8qDomM3TokE86vRWcz7W5xe/orru1xTDTAghB/j/zAzkpKGrPHqLxml9mVqU0U5XHCSrT6frVd0Bk1jZNOjYuXLv9Xr8OMi1tDomZB447v3J6VfMsgNOb4LVFUZyo1cBidW/Lyb3kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765175019; c=relaxed/simple;
	bh=a2N8B5Nx3ViquvPdyy7KH0AjMXxP0tN7pkGiOUzzfQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sap/uvr+1A0lwnF9U2/0+vN4pBJc6fcnbrQbXolCU8LxdFzWjekArhU6oq3JzYdZhAG3lHrfyMzkEb5Cqv6Mg9XVGjUIeernzR3JW/fSithTjJnclHWTMAKIp4QkVNAmFe2oSnxtDO56D2Z2eudX2mdsyhDbyuTdOfuorlTjPqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oSYeVcmb; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oSYeVcmb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765175015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lmKdOMmwHq0K/uYxFG+HlBTA7AlJoFguUk+L55bURDQ=;
	b=oSYeVcmbXeuDt2QdzJzNTjifMMuo0HN0lvKcuMkjuB0uq6i1EgGTeIB5lZrzfbxWfxSkXv
	jvLbz8YajkH382CSJUSnL0K2qRydSyNsfiffHTqdI5Po1rsoJz1oB4Kpx6hTWiPc1NrGAN
	eyvTveioW24ejsiyii6YoZR4UrvSOs0=
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
Subject: [PATCH 21/30] smb/client: sort mapping_table_ERRDOS array
Date: Mon,  8 Dec 2025 14:20:51 +0800
Message-ID: <20251208062100.3268777-22-chenxiaosong.chenxiaosong@linux.dev>
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
algorithm to quickly find the target DOS class smb error code.

The array is sorted only once when cifs.ko is loaded.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 239e5287d4d6..594a7fae0060 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -59,7 +59,7 @@ struct smb_to_posix_error {
 	int posix_code;
 };
 
-static const struct smb_to_posix_error mapping_table_ERRDOS[] = {
+static struct smb_to_posix_error mapping_table_ERRDOS[] = {
 	{ERRbadfunc, -EINVAL},
 	{ERRbadfile, -ENOENT},
 	{ERRbadpath, -ENOTDIR},
@@ -101,6 +101,9 @@ static const struct smb_to_posix_error mapping_table_ERRDOS[] = {
 	{0, 0}
 };
 
+static unsigned int errdos_num = sizeof(mapping_table_ERRDOS) /
+				 sizeof(struct smb_to_posix_error);
+
 static const struct smb_to_posix_error mapping_table_ERRSRV[] = {
 	{ERRerror, -EIO},
 	{ERRbadpw, -EACCES},  /* was EPERM */
@@ -803,6 +806,8 @@ static unsigned int ntstatus_to_dos_num = sizeof(ntstatus_to_dos_map) /
 DEFINE_CMP_FUNC(ntstatus_to_dos, ntstatus);
 /* cmp_nt_err_code_struct */
 DEFINE_CMP_FUNC(nt_err_code_struct, nt_errcode);
+/* cmp_smb_to_posix_error */
+DEFINE_CMP_FUNC(smb_to_posix_error, smb_err);
 
 /* search_in_ntstatus_to_dos_map */
 DEFINE_SEARCH_FUNC(ntstatus_to_dos, ntstatus, ntstatus_to_dos_map, ntstatus_to_dos_num);
@@ -1078,6 +1083,8 @@ void smb_init_maperror(void)
 	     sizeof(struct ntstatus_to_dos), cmp_ntstatus_to_dos, NULL);
 	sort(nt_errs, nt_err_num, sizeof(struct nt_err_code_struct),
 	     cmp_nt_err_code_struct, NULL);
+	sort(mapping_table_ERRDOS, errdos_num,
+	     sizeof(struct smb_to_posix_error), cmp_smb_to_posix_error, NULL);
 }
 
 #if IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
-- 
2.43.0

