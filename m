Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01FE78F36;
	Wed, 18 Jun 2025 08:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750233906; cv=none; b=vArfygyw3BDVHeRiuc3eKYRUQy4Amtlq2K/WaFBxPKiSpkvzZ+0JOwcyxAViEMEs2T0aP8wfuEshZWvvrWMYRZyXtmVBvQoFeeWFSbtF7KtYxkGx1wFsI89x5ogF8kaQpWrwfBgMjfZGv9Z3C+DXt7vsD6fTb8A+4thp3SrHX4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750233906; c=relaxed/simple;
	bh=gXffrMPfgsMCgCQe73pN0NIFepYDPD11srf0ITm5lK4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uRP5ccFIXE+BNYkDkJbgTmIiIrRsxkVJfj6VPmlR5Qa10f/EooD7G8Lm25xYTVz8ABbqkLhXM3/lNWRWhny85+D7SX4mCgDRbIPkVvzIgT7R5HIm1PtXuF/V2J4oeX8WGGJiWVXsf/baK7AV5IKTStBqXcZ4lM1pnlP4l77nIco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bMblB4v1qzRkhZ;
	Wed, 18 Jun 2025 16:00:38 +0800 (CST)
Received: from kwepemp200004.china.huawei.com (unknown [7.202.195.99])
	by mail.maildlp.com (Postfix) with ESMTPS id 0895F18007F;
	Wed, 18 Jun 2025 16:04:55 +0800 (CST)
Received: from huawei.com (10.175.124.27) by kwepemp200004.china.huawei.com
 (7.202.195.99) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 18 Jun
 2025 16:04:54 +0800
From: zhangjian <zhangjian496@huawei.com>
To: <stfrench@microsoft.com>, <longli@microsoft.com>,
	<wangzhaolong1@huawei.com>, <metze@samba.org>, <dhowells@redhat.com>,
	<pc@manguebit.org>
CC: <linux-kernel@vger.kernel.org>, <linux-cifs@vger.kernel.org>
Subject: [PATCH] smb: client: fix first command failure during re-negotiation
Date: Thu, 19 Jun 2025 09:18:29 +0800
Message-ID: <20250619011829.561614-1-zhangjian496@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemp200004.china.huawei.com (7.202.195.99)

after fabc4ed200f9, server_unresponsive add a condition to check whether client
need to reconnect depending on server->lstrp. When client failed to reconnect
for some time and abort connection, server->lstrp is updated for the last time.
In the following scene, server->lstrp is too old. This cause next command
failure in re-negotiation rather than waiting for re-negotiation done.

1. mount -t cifs -o username=Everyone,echo_internal=10 //$server_ip/export /mnt
2. ssh $server_ip "echo b > /proc/sysrq-trigger &"
3. ls /mnt
4. sleep 21s
5. ssh $server_ip "service firewalld stop"
6. ls # return EHOSTDOWN

If the interval between 5 and 6 is too small, 6 may trigger sending negotiation
request. Before backgrounding cifsd thread try to receive negotiation response
from server in cifs_readv_from_socket, server_unresponsive may trigger
cifs_reconnect which cause 6 to be failed:

ls thread
----------------
  smb2_negotiate
    server->tcpStatus = CifsInNegotiate
    compound_send_recv
      wait_for_compound_request

cifsd thread
----------------
  cifs_readv_from_socket
    server_unresponsive
      server->tcpStatus == CifsInNegotiate && jiffies > server->lstrp + 20s
        cifs_reconnect
          cifs_abort_connection: mid_state = MID_RETRY_NEEDED

ls thread
----------------
      cifs_sync_mid_result return EAGAIN
  smb2_negotiate return EHOSTDOWN

Though server->lstrp means last server response time, it is updated in
cifs_abort_connection and cifs_get_tcp_session. We can also update server->lstrp
before switching into CifsInNegotiate state to avoid failure in 6.

Fixes: fabc4ed200f9 ("smb: client: fix hang in wait_for_response() for negproto")
Signed-off-by: zhangjian <zhangjian496@huawei.com>
---
 fs/smb/client/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 28bc33496..f9aef60f1 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4193,6 +4193,7 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 		return 0;
 	}
 
+	server->lstrp = jiffies;
 	server->tcpStatus = CifsInNegotiate;
 	spin_unlock(&server->srv_lock);
 
-- 
2.33.0

