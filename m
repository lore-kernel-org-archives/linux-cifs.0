Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DD51804E
	for <linux-cifs@vger.kernel.org>; Wed, 23 Oct 2024 01:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729646677; cv=none; b=UW3APETN4CsnzPP8v4TK7etjH77NIPQcXAwTHECP8S9IFevYNxwVUsUCMgvCt7hNw/qViUCbt6iv/CEMLN7pWUM1wAqOjf0hEBoVikcp4gFUZFtDoGierJa+LiLiu+tGePrXDJ6J898SxNsw4eTnK50Ok59cfQ3jREmg+VfodxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729646677; c=relaxed/simple;
	bh=DFr8m+7xEcO2dsrBBtQG+LrjO07LMkEIxEFZanEzFRk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e0uEp/VTCpHs7XBb/g8GZwhrW7X8XQMHzybLuJB2Hx61wLHqs7IAIrM493AIlxARsQuOjyMuHI51Aqj9pHvwvQAgIiUQ4jxj4L0WV8TQZpiuDQtcQyx/fMJWH6TfMGRaxkGbM/FtRGGQQReIrYvCczcdp8ijXUJN9j2+7fj5rcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XYBCf3lBjz4f3jdm
	for <linux-cifs@vger.kernel.org>; Wed, 23 Oct 2024 09:24:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E9C341A0568
	for <linux-cifs@vger.kernel.org>; Wed, 23 Oct 2024 09:24:31 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.101.107])
	by APP4 (Coremail) with SMTP id gCh0CgDHR8ROUBhnZQVtEw--.15370S4;
	Wed, 23 Oct 2024 09:24:31 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	linux-cifs@vger.kernel.org,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: samba-technical@lists.samba.org,
	yebin@huaweicloud.com,
	zhangxiaoxu5@huawei.com
Subject: [PATCH] cifs: fix warning when destroy 'cifs_io_request_pool'
Date: Wed, 23 Oct 2024 09:24:30 +0800
Message-Id: <20241023012430.67183-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHR8ROUBhnZQVtEw--.15370S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tr4UAw4Utr1kZF4UurW3ZFb_yoW8Xr43pr
	WxK3s0krs5XwnxCw4vqa1Uu34kCFWv9F1avF4xKr13Z3Wqy3ykK3Wvy3s8KryIkrW8Aa1r
	WF1qvws0q3W5ZF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

There's a issue as follows:
WARNING: CPU: 1 PID: 27826 at mm/slub.c:4698 free_large_kmalloc+0xac/0xe0
RIP: 0010:free_large_kmalloc+0xac/0xe0
Call Trace:
 <TASK>
 ? __warn+0xea/0x330
 mempool_destroy+0x13f/0x1d0
 init_cifs+0xa50/0xff0 [cifs]
 do_one_initcall+0xdc/0x550
 do_init_module+0x22d/0x6b0
 load_module+0x4e96/0x5ff0
 init_module_from_file+0xcd/0x130
 idempotent_init_module+0x330/0x620
 __x64_sys_finit_module+0xb3/0x110
 do_syscall_64+0xc1/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Obviously, 'cifs_io_request_pool' is not created by mempool_create().
So just use mempool_exit() to revert 'cifs_io_request_pool'.

Fixes: edea94a69730 ("cifs: Add mempools for cifs_io_request and cifs_io_subrequest structs")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/smb/client/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 000e1ef3beea..20cafdff5081 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1780,7 +1780,7 @@ static int cifs_init_netfs(void)
 nomem_subreqpool:
 	kmem_cache_destroy(cifs_io_subrequest_cachep);
 nomem_subreq:
-	mempool_destroy(&cifs_io_request_pool);
+	mempool_exit(&cifs_io_request_pool);
 nomem_reqpool:
 	kmem_cache_destroy(cifs_io_request_cachep);
 nomem_req:
-- 
2.34.1

