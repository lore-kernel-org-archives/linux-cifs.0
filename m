Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143DE10942;
	Wed, 30 Apr 2025 03:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745982990; cv=none; b=ZPFulVVHBRVW1RykjspRbBoU0XkCTHlW+wD1+N0vC+GTPAWRA452akfbwHpInwqu8/ls7ZDoyVrlnzlTd5z/Ez8XbG5OhWaaxQYXuWJZ2yuKgUxO/wDgHBGjRUNRN34/eDyfTt6nTsOeux0UO7fIIyj9fAkXQZxFWm/YXYcRWfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745982990; c=relaxed/simple;
	bh=IKsZp9Rxn59bDLOwH2Vdp5ajC2h0CdrZLU3p3xxDh9s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ueZ0PqljHj64/M6LXmeGbm+uBrEotZTw/zairbxrvDR80FDNMpTW6IeQLgArdlVCHLNOcTacLbFe9J5PafE4jfBv5xd6n0XH0BO8HVQN15AVwWj9DfynzK7jPop6ymKyzLjfJkGuxJCUi/W1ZGR+NsJjZ8FjvkRbnI2480T2D44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZnMkY3s8Nz13LVd;
	Wed, 30 Apr 2025 11:15:17 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 4085E140134;
	Wed, 30 Apr 2025 11:16:25 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemg500010.china.huawei.com
 (7.202.181.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 30 Apr
 2025 11:16:24 +0800
From: Wang Zhaolong <wangzhaolong1@huawei.com>
To: <linkinjeon@kernel.org>, <smfrench@gmail.com>, <norbert@doyensec.com>
CC: <linux-cifs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wangzhaolong1@huawei.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>,
	<chengzhihao1@huawei.com>
Subject: [PATCH] ksmbd: fix memory leak in parse_lease_state()
Date: Wed, 30 Apr 2025 11:16:23 +0800
Message-ID: <20250430031623.744547-1-wangzhaolong1@huawei.com>
X-Mailer: git-send-email 2.34.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemg500010.china.huawei.com (7.202.181.71)

The previous patch that added bounds check for create lease context
introduced a memory leak. When the bounds check fails, the function
returns NULL without freeing the previously allocated lease_ctx_info
structure.

This patch fixes the issue by adding kfree(lreq) before returning NULL
in both boundary check cases.

Fixes: bab703ed8472 ("ksmbd: add bounds check for create lease context")
Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
---
 fs/smb/server/oplock.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 81a29857b1e3..03f606afad93 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1494,11 +1494,11 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 	if (sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)) {
 		struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
 
 		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
 		    sizeof(struct create_lease_v2) - 4)
-			return NULL;
+			goto err_out;
 
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 		lreq->req_state = lc->lcontext.LeaseState;
 		lreq->flags = lc->lcontext.LeaseFlags;
 		lreq->epoch = lc->lcontext.Epoch;
@@ -1510,19 +1510,22 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 	} else {
 		struct create_lease *lc = (struct create_lease *)cc;
 
 		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
 		    sizeof(struct create_lease))
-			return NULL;
+			goto err_out;
 
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 		lreq->req_state = lc->lcontext.LeaseState;
 		lreq->flags = lc->lcontext.LeaseFlags;
 		lreq->duration = lc->lcontext.LeaseDuration;
 		lreq->version = 1;
 	}
 	return lreq;
+err_out:
+	kfree(lreq);
+	return NULL;
 }
 
 /**
  * smb2_find_context_vals() - find a particular context info in open request
  * @open_req:	buffer containing smb2 file open(create) request
-- 
2.34.3

