Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285262D9792
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765175008; cv=none; b=r98fDHj2UrhkXD8SW7AdbfqtPbebntSkIDSagvHTLt0HmWABRAVDAsVohJyY05FnlHE/OVZ4WR1dClbLGfSZKjPoOiX55ZAoz1jLfk7Tgt9xB978riEFfoUJDafHeKuLH/E06FEOI5/cFhODN2UcYwEiwthSlYiWthr8QYpQ8aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765175008; c=relaxed/simple;
	bh=hTEU60Ul9bDNx0t9jq1ILofxUa5uUJnx6Zk1JulIIDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mspXxL+m7VU/XtvNyEst6WSs/+xGoAiSO193ACLuNKRxRtTnY/pcti2jrXSrDdIDtYrAkK6/cZa8HbZ3ROks698mXlmzqEWc/o5gTAYiIxjHqiF5bY4TIwyvcGO2j0xB5nSOF2VPoFbiVCYXRH2K9BwpkipzwcjwTvAD3ZOTgbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ItGmMmnK; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ItGmMmnK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765175005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tv+KH25GcG+4PFhHMsoH/e2hn7jOb2OEkqdUH3tiVtk=;
	b=ItGmMmnKQrvvFO55tNALDJpMf3ZlW/sqMfZx8VbUH+kXw2QslwiQgG5Ta6tWGIQD6N8KGL
	eaFCyRSuAGI23+L/yoHqXd+TIzX5QfKNBUajMsxLN298hyNrpcsuwOEodMK/str6QF/5vq
	uBRcCg1VME2PBSG2F0E7aWsxFCRxOoQ=
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
Subject: [PATCH 18/30] smb/client: use bsearch() to find target in nt_errs array
Date: Mon,  8 Dec 2025 14:20:48 +0800
Message-ID: <20251208062100.3268777-19-chenxiaosong.chenxiaosong@linux.dev>
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

The array currently has 520 elements. When searching for the last element,
the original loop-based search method requires 520 comparisons, while
binary search algorithm requires only 9 comparisons.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index c6fa1389683b..239e5287d4d6 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -806,6 +806,8 @@ DEFINE_CMP_FUNC(nt_err_code_struct, nt_errcode);
 
 /* search_in_ntstatus_to_dos_map */
 DEFINE_SEARCH_FUNC(ntstatus_to_dos, ntstatus, ntstatus_to_dos_map, ntstatus_to_dos_num);
+/* search_in_nt_errs */
+DEFINE_SEARCH_FUNC(nt_err_code_struct, nt_errcode, nt_errs, nt_err_num);
 
 /*****************************************************************************
  Print an error message from the status code
@@ -813,17 +815,14 @@ DEFINE_SEARCH_FUNC(ntstatus_to_dos, ntstatus, ntstatus_to_dos_map, ntstatus_to_d
 static void
 cifs_print_status(__u32 status_code)
 {
-	int idx = 0;
+	struct nt_err_code_struct *err_map;
 
-	while (nt_errs[idx].nt_errstr != NULL) {
-		if (nt_errs[idx].nt_errcode == status_code) {
-			pr_notice("Status code returned 0x%08x %s\n",
-				  status_code, nt_errs[idx].nt_errstr);
-			return;
-		}
-		idx++;
-	}
-	return;
+	err_map = search_in_nt_errs(status_code);
+	if (!err_map)
+		return;
+
+	pr_notice("Status code returned 0x%08x %s\n",
+		  status_code, err_map->nt_errstr);
 }
 
 
-- 
2.43.0

