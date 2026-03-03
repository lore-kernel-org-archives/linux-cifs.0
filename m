Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CA648C3E4
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 15:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772550860; cv=none; b=T4lE/sjm7V6zHZFAM89DD+9wd87yIELv54ayqIMGrstB8rf9y05niWlqZH9lot8UYt/glIKFegS8IEqB4ZG6veLXNBv4cxN8JzYbU3l7uI94sjvHvClB9xkyvzRbmtXdzMScj1YXLC1IJecx46bAmrEU2KONHDRq4wlDRJD2sPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772550860; c=relaxed/simple;
	bh=c2E9db8WMO1F/Vx/l+bk8rEJR3UZTw0VNHM3SEgTdug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4zehN/TQrnOvmSursICEGqv/ln4+Zd5NLhkM/h/vPy/7o3DBC1zyRo0+2xQNUKrNxIbHR4IFVhp1nd5X1ytMX7B8A9kua/PRDc5RDGU96fgbEXdRG4A3SdCyayScxIOcw5+8246cMcrVsuYo6VgbTgXBCJb1ZTOBTUUM3eirvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LO5DrlEH; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LO5DrlEH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772550854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=epOJM347BnS2GSPN2KnG+QaLN3DXOwHMH+3UoWeExQE=;
	b=LO5DrlEHPyN5sMiPsEbmz4l5N97X9dq5XQY/E6xbATsn0igYoda2fyPwfS2O1SGNqU06W/
	k/DxUmIhGecX1mB9Y14qLZW2x5jproCbmtsGnjwLj38MHJntWwtRxGCnMRbBl+xHvgx6Ek
	B32fxF+k96Rojlq8TOl3X/XdKYnLBu4=
From: zhang.guodong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v5 2/7] smb/client: fix buffer size for smb311_posix_qinfo in SMB311_posix_query_info()
Date: Tue,  3 Mar 2026 15:13:12 +0000
Message-ID: <20260303151317.136332-3-zhang.guodong@linux.dev>
In-Reply-To: <20260303151317.136332-1-zhang.guodong@linux.dev>
References: <20260303151317.136332-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

SMB311_posix_query_info() is currently unused, but it may still be used in
some stable versions, so these changes are submitted as a separate patch.

Use `sizeof(struct smb311_posix_qinfo)` instead of sizeof its pointer,
so the allocated buffer matches the actual struct size.

Fixes: b1bc1874b885 ("smb311: Add support for SMB311 query info (non-compounded)")
Reported-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 04e361ed2356..8a1fcc097606 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3996,7 +3996,7 @@ SMB311_posix_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 			u64 persistent_fid, u64 volatile_fid,
 			struct smb311_posix_qinfo *data, u32 *plen)
 {
-	size_t output_len = sizeof(struct smb311_posix_qinfo *) +
+	size_t output_len = sizeof(struct smb311_posix_qinfo) +
 			(sizeof(struct smb_sid) * 2) + (PATH_MAX * 2);
 	*plen = 0;
 
-- 
2.52.0

