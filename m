Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E328C30FC1C
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765175033; cv=none; b=F6L5B4ctwP2ypqrN4aLB1znNaKLqbQ5evv9dP/WXbFTsCmVtEsCo7NbmSLlhep79x+opX/CEn2v0GkXL8fyA8NN7PCO6wYxRGDaUUNwIHloVv8WQ97Ix33QdTjfXm1qcp6MzdoTPpAaIvT9v7H4EYVw+imiuwHnUhFbIzdEIfco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765175033; c=relaxed/simple;
	bh=t/gWtxmWHXLeFCb/PnJWVuWs41WVMsMLmMD27T57+O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMjq+F85I+pmxWepmy+4uLxDqjUM7rDOQjPbdt8OdyJ+HwDBxBHIev9Y3jyjLScZtxQekQS1xo0ESp/DmByWCB/ZazZ1TVV4RiPHAlTS17rmUXUVF0FD4v+9TStDiq+2Pw6NYTYls8xuhsOHn0cLqV9y1LHnJ+TyxW3g1s+hWxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tCmWhCdu; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tCmWhCdu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765175030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xnfwpZ7U7qrRTN6vrRAaZXSNXeyTmImDnhiYizXNn0Q=;
	b=tCmWhCdu73ODKyryakX/TEAGBc/3nmtYW7Qw2750LMDxuXphNRsgkNBHbrD01T9Z192lHc
	f91Y22pGfQcV98LRAlDP/A4n6HiatG+ORvvotrurKW3FwhlpJjoX2cAMQ7z1GKdXQL2r3J
	P+nxVWvwPhIyP1yvLU/pmL6R9zHiJ9g=
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
Subject: [PATCH 26/30] smb/client: sort mapping_table_ERRSRV array
Date: Mon,  8 Dec 2025 14:20:56 +0800
Message-ID: <20251208062100.3268777-27-chenxiaosong.chenxiaosong@linux.dev>
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
algorithm to quickly find the target server class of error code.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 553d2a33b6de..4b5c049d69b9 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -103,7 +103,7 @@ static struct smb_to_posix_error mapping_table_ERRDOS[] = {
 static unsigned int errdos_num = sizeof(mapping_table_ERRDOS) /
 				 sizeof(struct smb_to_posix_error);
 
-static const struct smb_to_posix_error mapping_table_ERRSRV[] = {
+static struct smb_to_posix_error mapping_table_ERRSRV[] = {
 	{ERRerror, -EIO},
 	{ERRbadpw, -EACCES},  /* was EPERM */
 	{ERRbadtype, -EREMOTE},
@@ -148,6 +148,9 @@ static const struct smb_to_posix_error mapping_table_ERRSRV[] = {
 	{0, 0}
 };
 
+static unsigned int errsrv_num = sizeof(mapping_table_ERRSRV) /
+				 sizeof(struct smb_to_posix_error);
+
 /*
  * Convert a string containing text IPv4 or IPv6 address to binary form.
  *
@@ -1077,6 +1080,8 @@ void smb_init_maperror(void)
 	     cmp_nt_err_code_struct, NULL);
 	sort(mapping_table_ERRDOS, errdos_num,
 	     sizeof(struct smb_to_posix_error), cmp_smb_to_posix_error, NULL);
+	sort(mapping_table_ERRSRV, errsrv_num,
+	     sizeof(struct smb_to_posix_error), cmp_smb_to_posix_error, NULL);
 }
 
 #if IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
-- 
2.43.0

