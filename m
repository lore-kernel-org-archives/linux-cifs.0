Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CCB2C159E;
	Fri, 13 Jun 2025 10:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749810266; cv=none; b=N1+EyBTb49oFDL+0D+iaKtq2lgMuNfa5Gc2Q3rcfsNdu8ZZTZYAqdW8VEH4ixJokmWESaxEiLAYPFO7hMp+NtvWaqXmkXPhcXFHF+NTaVqvYjjRhzyN+sTruO7tvPH5iyA265hDUQkVmFErpSVVxXroZuZnja9i2FEcJSdpXvuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749810266; c=relaxed/simple;
	bh=r+Pw6OGjSvqJZafVknM0ZS/MfQV9KMjPB2PYzFWvCQo=;
	h=Message-ID:Date:MIME-Version:From:CC:To:Subject:Content-Type; b=Ic8yNSfDFiQo+RXfpiT/LXNZmqQnsUeMA5MMWtpqNMsYakReKRKPjDhQMUOQ58bY3aGhOqbtvGzUrv7McovNhngJ7rCdidphxkX/EuKeQpBmjNDe0gvrwo9r8cSY1zkALamN3y0I/xqgoUBXgq9VCj7cMlP8ZkNUII68PPn+VmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bJb7k3ptVz2TRxs;
	Fri, 13 Jun 2025 18:22:58 +0800 (CST)
Received: from kwepemp200004.china.huawei.com (unknown [7.202.195.99])
	by mail.maildlp.com (Postfix) with ESMTPS id 710621A016C;
	Fri, 13 Jun 2025 18:24:20 +0800 (CST)
Received: from [10.174.186.66] (10.174.186.66) by
 kwepemp200004.china.huawei.com (7.202.195.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 13 Jun 2025 18:24:19 +0800
Message-ID: <32686cd5-f149-4ea4-a13f-8b1fbb2cca44@huawei.com>
Date: Fri, 13 Jun 2025 18:24:19 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "zhangjian (CG)" <zhangjian496@huawei.com>
CC: <linux-cifs-client@lists.samba.org>, <linux-kernel@vger.kernel.org>,
	<linux-cifs@vger.kernel.org>
To: <stfrench@microsoft.com>, <smfrench@gmail.com>, <longli@microsoft.com>,
	<wangzhaolong1@huawei.com>, <metze@samba.org>, <dhowells@redhat.com>,
	<pc@manguebit.org>
Subject: [PATCH] smb: client: fix first failure in negotiation after server
 reboot
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemp200004.china.huawei.com (7.202.195.99)

after fabc4ed200f9, server_unresponsive add a condition to check whether
 client need to reconnect depending on server->lstrp. When client failed 
to reconnect in 180s, client will abort connection and update server-
>lstrp for the last time. In the following scene, server->lstrp is too 
old, which may cause failure for the first negotiation.

client                                         | server
-----------------------------------------------+-----------
mount to cifs server                           |
ls                                             |
                                               | reboot
    stuck for 180s and return EHOSTDOWN        |
    abort connection and update server->lstrp  |
                                               | service smb restart
ls                                             |
    smb_negotiate                              |
        server_unresponsive is true [in cifsd] |
        cifs_sync_mid_result return EAGAIN     |
    smb_negotiate return EHOSTDOWN             |
ls failed                                      |

we update server->lstrp before last switching into CifsInNegotiate state 
to avoid this failure.

Fixes: fabc4ed200f9 ("smb: client: fix hang in wait_for_response() for 
negproto")
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
