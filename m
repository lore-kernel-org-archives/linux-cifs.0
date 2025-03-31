Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CCF1E5B67;
	Mon, 31 Mar 2025 13:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743428365; cv=none; b=Il3kSZeBF4cl6084gJZpdduxFnW2DbnR3WrzaZPQ6qrqfDCS5FSxMTo04v7aAP6FVbJemki1sZF3V4MMzRpYFiB/nGs1Ua0N/wB5qtEHSdGy8BYBTUDP3JZiyQpGttPMwUWGtOH1/25sjjLFHoEITnm8m1hbxWPhwfDnEsPOWU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743428365; c=relaxed/simple;
	bh=hwE5GiKE3zL2s2GG0JF3k9o7qrrnfq/qiZzBJzBHOHI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qfgQ8mbq6/uG1JlkbK+I598T1CcvGFIH9almnDsqlKIBKSVVYf6w/tVyKYYL/48EoKBZNuUuNIay58Qz8nejdmX756ilHGqc85afcut8VPJd1Ylh8NzT0/nk82Y8MwEP/S6woo/rVUBAND4JQXQiqsEZ9oK+ClvhOwDMa8vh7/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4ZRBty074tz1f1gQ;
	Mon, 31 Mar 2025 21:34:34 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 894441A016C;
	Mon, 31 Mar 2025 21:39:20 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemg500010.china.huawei.com
 (7.202.181.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 31 Mar
 2025 21:39:19 +0800
From: Wang Zhaolong <wangzhaolong1@huawei.com>
To: <sfrench@samba.org>, <linkinjeon@kernel.org>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <chengzhihao1@huawei.com>,
	<wangzhaolong1@huawei.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH next 3/3] smb: client: Update IO sizes after reconnection
Date: Mon, 31 Mar 2025 21:33:15 +0800
Message-ID: <20250331133315.117666-4-wangzhaolong1@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250331133315.117666-1-wangzhaolong1@huawei.com>
References: <20250331133315.117666-1-wangzhaolong1@huawei.com>
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

When a SMB connection is reset and reconnected, the negotiated IO
parameters (rsize/wsize) can become out of sync with the server's
current capabilities. This can lead to suboptimal performance or
even IO failures if the server's limits have changed.

This patch implements automatic IO size renegotiation:
1. Adds cifs_renegotiate_iosize() function to update all superblocks
   associated with a tree connection
2. Updates each mount's rsize/wsize based on current server capabilities
3. Calls this function after successful tree connection reconnection

With this change, all mount points will automatically maintain optimal
and reliable IO parameters after network disruptions, using the
bidirectional mapping added in previous patches.

This completes the series improving connection resilience by keeping
mount parameters synchronized with server capabilities.

Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
---
 fs/smb/client/smb2pdu.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index f9c521b3c65e..103319cdce00 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -41,10 +41,11 @@
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dfs_cache.h"
 #endif
 #include "cached_dir.h"
 #include "compress.h"
+#include "fs_context.h"
 
 /*
  *  The following table defines the expected "StructureSize" of SMB2 requests
  *  in order by SMB2 command.  This is similar to "wct" in SMB/CIFS requests.
  *
@@ -4089,10 +4090,28 @@ smb2_echo_callback(struct mid_q_entry *mid)
 
 	release_mid(mid);
 	add_credits(server, &credits, CIFS_ECHO_OP);
 }
 
+static void cifs_renegotiate_iosize(struct TCP_Server_Info *server,
+				    struct cifs_tcon *tcon)
+{
+	struct cifs_sb_info *cifs_sb;
+
+	if (server == NULL || tcon == NULL)
+		return;
+
+	spin_lock(&tcon->sb_list_lock);
+	list_for_each_entry(cifs_sb, &tcon->cifs_sb_list, tcon_sb_link) {
+		cifs_sb->ctx->rsize =
+			server->ops->negotiate_rsize(tcon, cifs_sb->ctx);
+		cifs_sb->ctx->wsize =
+			server->ops->negotiate_wsize(tcon, cifs_sb->ctx);
+	}
+	spin_unlock(&tcon->sb_list_lock);
+}
+
 void smb2_reconnect_server(struct work_struct *work)
 {
 	struct TCP_Server_Info *server = container_of(work,
 					struct TCP_Server_Info, reconnect.work);
 	struct TCP_Server_Info *pserver;
@@ -4174,13 +4193,14 @@ void smb2_reconnect_server(struct work_struct *work)
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
 		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true);
-		if (!rc)
+		if (!rc) {
+			cifs_renegotiate_iosize(server, tcon);
 			cifs_reopen_persistent_handles(tcon);
-		else
+		} else
 			resched = true;
 		list_del_init(&tcon->rlist);
 		if (tcon->ipc)
 			cifs_put_smb_ses(tcon->ses);
 		else
-- 
2.39.2

