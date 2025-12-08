Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D32E2D3EDE
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765174993; cv=none; b=Vg7R1T/wlCM6v+xLgbuLKzcxZ0VQ7fp0Cz+cJhDMq4pNdfrpXh5VKntxzu6NSZKRACZV9Y6z0hQ/BiQ9yc8yFtobMfHPzCB+nPfFbWl/P0skDx3fgiVlfXu1FczAhuR2TZoffJSsInOQJ/2S9PEAPcIGALxQPq0IBVfNL/AguKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765174993; c=relaxed/simple;
	bh=5PZXQ0lfVCycMNP5oO+I4374U1dXCYUzUOah9Up10Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Af/AJSIeaZkZSuUiej0MwPwICYzISletSDgk8G5PKEfvMeCxvkxqLjjwuuMz5+j9xdMJZsZVMKe2+0ufYt+5fWFusVLgXHqrEcz7mSHasKMr06mVWU+a3Rx/Pkt5KcbxGq4Hj8bw7a0yBbnMQj5g1fqxyqSBE+PlPtVqoxHAyY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gWrx0LFy; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gWrx0LFy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765174987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jd4R/6HSD4HfcnXGIikZ/cx0ryI1RWeea5PAWHJfTQI=;
	b=gWrx0LFyCYsrb8g64EoOTWyvPFhA+UX+y/qlDpy4OdLyY/1nOqqExQzaCJiZvSALsbd86u
	nQ25XIBP7WnOD19ytwRIIEg4o8O+R2dHP3Xx4SQulA3zbiJu59rfD/iiauPLaj15YzmU2H
	J0AfNhVB9UyFE7GsYWS+eB72knbRck4=
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
Subject: [PATCH 12/30] smb/client: use bsearch() to find target in ntstatus_to_dos_map array
Date: Mon,  8 Dec 2025 14:20:42 +0800
Message-ID: <20251208062100.3268777-13-chenxiaosong.chenxiaosong@linux.dev>
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

The array currently has 525 elements. When searching for the last element,
the original loop-based search method requires 525 comparisons, while
binary search algorithm requires only 9 comparisons.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 8a84f826d486..55100c2c14cf 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -803,6 +803,9 @@ static unsigned int ntstatus_to_dos_num = sizeof(ntstatus_to_dos_map) /
 /* cmp_ntstatus_to_dos */
 DEFINE_CMP_FUNC(ntstatus_to_dos, ntstatus);
 
+/* search_in_ntstatus_to_dos_map */
+DEFINE_SEARCH_FUNC(ntstatus_to_dos, ntstatus, ntstatus_to_dos_map, ntstatus_to_dos_num);
+
 /*****************************************************************************
  Print an error message from the status code
  *****************************************************************************/
@@ -826,19 +829,21 @@ cifs_print_status(__u32 status_code)
 static void
 ntstatus_to_dos(__u32 ntstatus, __u8 *eclass, __u16 *ecode)
 {
-	int i;
+	struct ntstatus_to_dos *err_map;
+
 	if (ntstatus == 0) {
 		*eclass = 0;
 		*ecode = 0;
 		return;
 	}
-	for (i = 0; ntstatus_to_dos_map[i].ntstatus; i++) {
-		if (ntstatus == ntstatus_to_dos_map[i].ntstatus) {
-			*eclass = ntstatus_to_dos_map[i].dos_class;
-			*ecode = ntstatus_to_dos_map[i].dos_code;
-			return;
-		}
+
+	err_map = search_in_ntstatus_to_dos_map(ntstatus);
+	if (err_map) {
+		*eclass = err_map->dos_class;
+		*ecode = err_map->dos_code;
+		return;
 	}
+
 	*eclass = ERRHRD;
 	*ecode = ERRgeneral;
 }
-- 
2.43.0

