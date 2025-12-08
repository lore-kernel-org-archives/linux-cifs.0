Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9072D6608
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765175038; cv=none; b=Hsce+yRdwjV5xv7ubRNavk3pc/bmOUM9eaSHw7jF8APFjF81mod+bfhBYfkHWHaWHub3MUazNZxozVeqqxjtSBcF4RET1PV04YyZY5pcvClU8VcN97s0DoZ04oTbQJ3b0JwsiqC1Vgvw3JjQFpKvgrP5EOZU0sTVeuNQjoMcDmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765175038; c=relaxed/simple;
	bh=LL+cC61z4CZdo5xGC6b6E1l5USUUYvk8KH/Lf6GcGAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMDEZAH695cL1bU7Ao4kKIS45AKz3MYViYHYGufRGYiVKFibLgHabHJPAG+gp5CThnidC9VoBHlapWM5eSL8RnU7f+Tjp3Gu2YHEDtDgtL8YVXgTTZrVw2vzS5DmHWklZ8NOvhLV1WrkaaNrhLpb2E+3OEqSadGTakGUVtKpqzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H425qijR; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H425qijR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765175035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VHulEz35B1ziUK2SkbNpw2zGYT0O77ljuB6kzTjoTdk=;
	b=H425qijRsRoYQ/n45jpc+PQSywHSGgs/Y0Hft5q+POiPovPMxlDgzxPzPuwrXBHElLCj4P
	KEkae4z6l8YmdD9P3ydi/ySqXRXWDkTyWnEwott7y/Yw6PwUc1oJFYgi2XbuMAmlWArIy3
	1iI0mFP+ITBQvJV/qlXnIJzE+Rnm3Y4=
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
Subject: [PATCH 28/30] smb/client: use bsearch() to find target in mapping_table_ERRSRV array
Date: Mon,  8 Dec 2025 14:20:58 +0800
Message-ID: <20251208062100.3268777-29-chenxiaosong.chenxiaosong@linux.dev>
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

The array currently has 37 elements. When searching for the last element,
the original loop-based search method requires 37 comparisons, while
binary search algorithm requires only 5 comparisons.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 4b5c049d69b9..8f3242c1d3da 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -817,6 +817,8 @@ DEFINE_SEARCH_FUNC(ntstatus_to_dos, ntstatus, ntstatus_to_dos_map, ntstatus_to_d
 DEFINE_SEARCH_FUNC(nt_err_code_struct, nt_errcode, nt_errs, nt_err_num);
 /* search_in_mapping_table_ERRDOS */
 DEFINE_SEARCH_FUNC(smb_to_posix_error, smb_err, mapping_table_ERRDOS, errdos_num);
+/* search_in_mapping_table_ERRSRV */
+DEFINE_SEARCH_FUNC(smb_to_posix_error, smb_err, mapping_table_ERRSRV, errsrv_num);
 
 /*****************************************************************************
  Print an error message from the status code
@@ -861,7 +863,6 @@ int
 map_smb_to_linux_error(char *buf, bool logErr)
 {
 	struct smb_hdr *smb = (struct smb_hdr *)buf;
-	unsigned int i;
 	int rc = -EIO;	/* if transport error smb error may not be set */
 	__u8 smberrclass;
 	__u16 smberrcode;
@@ -897,19 +898,9 @@ map_smb_to_linux_error(char *buf, bool logErr)
 			rc = err_map->posix_code;
 	} else if (smberrclass == ERRSRV) {
 		/* server class of error codes */
-		for (i = 0;
-		     i <
-		     sizeof(mapping_table_ERRSRV) /
-		     sizeof(struct smb_to_posix_error); i++) {
-			if (mapping_table_ERRSRV[i].smb_err == 0)
-				break;
-			else if (mapping_table_ERRSRV[i].smb_err ==
-								smberrcode) {
-				rc = mapping_table_ERRSRV[i].posix_code;
-				break;
-			}
-			/* else try next error mapping to see if match */
-		}
+		err_map = search_in_mapping_table_ERRSRV(smberrcode);
+		if (err_map)
+			rc = err_map->posix_code;
 	}
 	/* else ERRHRD class errors or junk  - return EIO */
 
-- 
2.43.0

