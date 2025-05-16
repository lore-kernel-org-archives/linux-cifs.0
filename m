Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2E322DA07;
	Fri, 16 May 2025 09:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747387311; cv=none; b=H9H2AUkxDV2y2pcuPH+BEK0+XazE0tsVfD2g51kbryDzFvUtiGRCPmlrEKLwWn+rENbll6KfgDTYsIYMwrTTut6ycFOP/SQZsAsqFxyyAzk4oKlqua3cTIIAs25pz7oukWaIFhtkUUi3jnmKRO8qn1TVgcPvr2GsEutFCbZH6H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747387311; c=relaxed/simple;
	bh=LCRkojFXW3npo30sHbjFTCo9FEh0VftKeTU++mHTC0E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q6NuU85aRiKU1txJ7Bo6hMI/lkPD4xEBD7KuwHDoKVD5Vl36QoSOZWKmQLRcMg4vRpcaAntz8OgcqZ9Sc2vNRNc9GiayGux8zWbTdRsybj18p7dKd+cjUmzJ73QWX4D8twOgrjUlGsY6IDTD07DtV+hWAAyIX4WwNdkrMZ4xs7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4ZzM4K13D8z1d1CT;
	Fri, 16 May 2025 17:20:17 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id C32101800B3;
	Fri, 16 May 2025 17:21:45 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemg500010.china.huawei.com
 (7.202.181.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 16 May
 2025 17:21:44 +0800
From: Wang Zhaolong <wangzhaolong1@huawei.com>
To: <sfrench@samba.org>, <sfrench@us.ibm.com>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <chengzhihao1@huawei.com>,
	<wangzhaolong1@huawei.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH V2 2/2] smb: client: Reset all search buffer pointers when releasing buffer
Date: Fri, 16 May 2025 17:12:56 +0800
Message-ID: <20250516091256.2756826-3-wangzhaolong1@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250516091256.2756826-1-wangzhaolong1@huawei.com>
References: <20250516091256.2756826-1-wangzhaolong1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemg500010.china.huawei.com (7.202.181.71)

Multiple pointers in struct cifs_search_info (ntwrk_buf_start,
srch_entries_start, and last_entry) point to the same allocated buffer.
However, when freeing this buffer, only ntwrk_buf_start was set to NULL,
while the other pointers remained pointing to freed memory.

This is defensive programming to prevent potential issues with stale
pointers. While the active UAF vulnerability is fixed by the previous
patch, this change ensures consistent pointer state and more robust error
handling.

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
2.39.2

