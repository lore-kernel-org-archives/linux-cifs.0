Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8CF231CB0;
	Fri, 16 May 2025 03:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747365577; cv=none; b=oKWYvYOWBs5YM38F13t9zwWmFFCVbBEe9RyKqYV/NcLvb4nobhSjwvHWRjt0jNs5t1NHiPxtnvfqUpQFyl3FuOjI79aSIUveAZjB73NCY+ldJFOdsmdcKNdleNHwddo5oaOTOqHxkeHmz3lzbPcBudw5gRKrisleJEAKI8UuF6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747365577; c=relaxed/simple;
	bh=Ki9eoEwrRY5OB59ViUBqj0hp30LyxpOgkRGYcCndRKE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U2EtB0qnyJIgm6EdyYRBRbALd7YmJOGIL269ooSllPo+JRrURKJfxFlRDVajdl1MpTrbIGwuS5TzbNodC0s/OrZ+XG9qQIE3MvFSIr/4pVd+9kj6vi0JSIa3+9RDAA9xhM3HQcNwVcyVv8ynHdcpMtGlI/veNJul3lXmBaB5Sno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZzByz31G0zyVPT;
	Fri, 16 May 2025 11:15:07 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id B5E5C180B41;
	Fri, 16 May 2025 11:19:26 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemg500010.china.huawei.com
 (7.202.181.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 16 May
 2025 11:19:25 +0800
From: Wang Zhaolong <wangzhaolong1@huawei.com>
To: <sfrench@samba.org>, <sfrench@us.ibm.com>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <wangzhaolong1@huawei.com>,
	<yi.zhang@huawei.com>, <yangerkun@huawei.com>, <chengzhihao1@huawei.com>
Subject: [PATCH -next 2/2] cifs: Reset all search buffer pointers when releasing buffer
Date: Fri, 16 May 2025 11:19:23 +0800
Message-ID: <20250516031923.159247-3-wangzhaolong1@huawei.com>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20250516031923.159247-1-wangzhaolong1@huawei.com>
References: <20250516031923.159247-1-wangzhaolong1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg500010.china.huawei.com (7.202.181.71)

Multiple pointers in struct cifs_search_info (ntwrk_buf_start,
srch_entries_start, and last_entry) point to the same allocated buffer.
However, when freeing this buffer, only ntwrk_buf_start was set to NULL,
while the other pointers remained pointing to freed memory.

This is defensive programming to prevent potential issues with stale
pointers. While the active UAF vulnerability is fixed by the previous
patch.

Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
---
 fs/smb/client/readdir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 67d7dd64b5e2..787d6bcb5d1d 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -731,11 +731,14 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 				cifs_small_buf_release(cfile->srch_inf.
 						ntwrk_buf_start);
 			else
 				cifs_buf_release(cfile->srch_inf.
 						ntwrk_buf_start);
+			/* Reset all pointers to the network buffer to prevent stale references */
 			cfile->srch_inf.ntwrk_buf_start = NULL;
+			cfile->srch_inf.srch_entries_start = NULL;
+			cfile->srch_inf.last_entry = NULL;
 		}
 		rc = initiate_cifs_search(xid, file, full_path);
 		if (rc) {
 			cifs_dbg(FYI, "error %d reinitiating a search on rewind\n",
 				 rc);
-- 
2.34.3

