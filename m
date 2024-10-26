Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA3ECA5A;
	Sat, 26 Oct 2024 07:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729926640; cv=none; b=HORpkyy1pCOU8UyG/xYE7gTcXOl/MY3RoKWAeEs0umVeZVKegnYqO9K+CUHYSB9Zz14rw70smudMEgnO2Yy7s/TwIOUd9MRp9IjfMQVc9Vr+Kz0azsvseQQVaAtmECJIQX96CTqHYCOV4ThZNb/5Ts4esytrpFwu3qY8Jv3oCLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729926640; c=relaxed/simple;
	bh=cM5safPaFgnLIsJYfrA1bFDUIVJtmhMNPSwryLqM/5s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FgmOk+E4l5IqXvtv1TIcY/i7/JXQoi/q3mCcX4rZMGaJWm8IFP0Yd44RG45dXkTIHg1L5B1cACbw4dUSfS5DRapCwEaGxGjYHopzO6P4FznhUSFq07Ve6fIul5BKyQXeeJAM/6mexAUc4UdyO6UZFoSIQ/Gmd/Nb9lnwM2SR1To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Xb9k347mgzyTkq;
	Sat, 26 Oct 2024 15:08:59 +0800 (CST)
Received: from kwepemg200008.china.huawei.com (unknown [7.202.181.35])
	by mail.maildlp.com (Postfix) with ESMTPS id 29439140258;
	Sat, 26 Oct 2024 15:10:34 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemg200008.china.huawei.com
 (7.202.181.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 26 Oct
 2024 15:10:33 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <linkinjeon@kernel.org>, <sfrench@samba.org>, <senozhatsky@chromium.org>,
	<tom@talpey.com>, <set_pte_at@outlook.com>, <linux-cifs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH] ksmbd: Fix the missing xa_store error check
Date: Sat, 26 Oct 2024 15:10:02 +0800
Message-ID: <20241026071002.118260-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemg200008.china.huawei.com (7.202.181.35)

xa_store() can fail, it return xa_err(-EINVAL) if the entry cannot
be stored in an XArray, or xa_err(-ENOMEM) if memory allocation failed,
so check error for xa_store() to fix it.

Cc: stable@vger.kernel.org
Fixes: b685757c7b08 ("ksmbd: Implements sess->rpc_handle_list as xarray")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 fs/smb/server/mgmt/user_session.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 1e4624e9d434..9756a4bbfe54 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -90,7 +90,7 @@ static int __rpc_method(char *rpc_name)
 
 int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name)
 {
-	struct ksmbd_session_rpc *entry;
+	struct ksmbd_session_rpc *entry, *old;
 	struct ksmbd_rpc_command *resp;
 	int method;
 
@@ -106,16 +106,19 @@ int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name)
 	entry->id = ksmbd_ipc_id_alloc();
 	if (entry->id < 0)
 		goto free_entry;
-	xa_store(&sess->rpc_handle_list, entry->id, entry, GFP_KERNEL);
+	old = xa_store(&sess->rpc_handle_list, entry->id, entry, GFP_KERNEL);
+	if (xa_is_err(old))
+		goto free_id;
 
 	resp = ksmbd_rpc_open(sess, entry->id);
 	if (!resp)
-		goto free_id;
+		goto erase_xa;
 
 	kvfree(resp);
 	return entry->id;
-free_id:
+erase_xa:
 	xa_erase(&sess->rpc_handle_list, entry->id);
+free_id:
 	ksmbd_rpc_id_free(entry->id);
 free_entry:
 	kfree(entry);
-- 
2.34.1

