Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0A830F55F
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765175024; cv=none; b=aSM11PxNMr3bIJsytj/8if4ka2VtMCvFtNKH9cOKRlqYfsCt75pkh2YqVVKRMZy+WEcTg714/JHV+3ZOUciBLv6lvyvlSsGJ669/siqFWNKQWPKRX+CVmqbWuR+QIEsyjpCkDlqxdNQeT9bsjSPq/ql0yl8uzQUuxlJ7xzhBHbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765175024; c=relaxed/simple;
	bh=Jbr6hDrJGdOAfgRj6MVJeQmsY5kBlK/eJHBTMHzJ8dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6M4hp203o2laPkFQ6si5DP0eoQ+BYPWS1yRKaCjC+5V3EONJsy8Qg4M3vqyfXD3iLealRRk3h6UbKv0m/OEsii2+/vfQ7HleGQrLXS/clwVFU5/0QfvW5vZYu4eos6pGeDETRVHE6MJoVwFqhbX7iBZ3iPpOgva+hWseNFz8Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ItY/iznT; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ItY/iznT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765175021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kuW2WgMjghek4WLdk+I5pqvQp7iACii/bZ47s+mxCrs=;
	b=ItY/iznTBhkn//G6wu3RtgaZjXXB5Zs+IN6xlAA6ywqPNrzql6sMICeaJlggRwcNB43iym
	7sVc9kDpFvI7isoum3hB6KIBj6w9CHHu0fN9AqdEtMLClFMStkuE6gCm1P1oa9LWYJlqVu
	Bw2ihoovyfEti4JnaJcqeU6adhj9lMM=
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
Subject: [PATCH 23/30] smb/client: use bsearch() to find target in mapping_table_ERRDOS array
Date: Mon,  8 Dec 2025 14:20:53 +0800
Message-ID: <20251208062100.3268777-24-chenxiaosong.chenxiaosong@linux.dev>
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

The array currently has 39 elements. When searching for the last element,
the original loop-based search method requires 39 comparisons, while
binary search algorithm requires only 5 comparisons.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 594a7fae0060..d7d1b9b4abcd 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -813,6 +813,8 @@ DEFINE_CMP_FUNC(smb_to_posix_error, smb_err);
 DEFINE_SEARCH_FUNC(ntstatus_to_dos, ntstatus, ntstatus_to_dos_map, ntstatus_to_dos_num);
 /* search_in_nt_errs */
 DEFINE_SEARCH_FUNC(nt_err_code_struct, nt_errcode, nt_errs, nt_err_num);
+/* search_in_mapping_table_ERRDOS */
+DEFINE_SEARCH_FUNC(smb_to_posix_error, smb_err, mapping_table_ERRDOS, errdos_num);
 
 /*****************************************************************************
  Print an error message from the status code
@@ -861,6 +863,7 @@ map_smb_to_linux_error(char *buf, bool logErr)
 	int rc = -EIO;	/* if transport error smb error may not be set */
 	__u8 smberrclass;
 	__u16 smberrcode;
+	struct smb_to_posix_error *err_map;
 
 	/* BB if NT Status codes - map NT BB */
 
@@ -887,19 +890,9 @@ map_smb_to_linux_error(char *buf, bool logErr)
 	/* DOS class smb error codes - map DOS */
 	if (smberrclass == ERRDOS) {
 		/* 1 byte field no need to byte reverse */
-		for (i = 0;
-		     i <
-		     sizeof(mapping_table_ERRDOS) /
-		     sizeof(struct smb_to_posix_error); i++) {
-			if (mapping_table_ERRDOS[i].smb_err == 0)
-				break;
-			else if (mapping_table_ERRDOS[i].smb_err ==
-								smberrcode) {
-				rc = mapping_table_ERRDOS[i].posix_code;
-				break;
-			}
-			/* else try next error mapping one to see if match */
-		}
+		err_map = search_in_mapping_table_ERRDOS(smberrcode);
+		if (err_map)
+			rc = err_map->posix_code;
 	} else if (smberrclass == ERRSRV) {
 		/* server class of error codes */
 		for (i = 0;
-- 
2.43.0

