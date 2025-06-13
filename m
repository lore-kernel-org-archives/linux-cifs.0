Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1E12D1F5F;
	Fri, 13 Jun 2025 10:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749811473; cv=none; b=jm6LZnd0hHeXSVxiqCsPIK60t0cT+niiqUUIOUxnOxlwCG0diLIhpFRI+6y0Jax312fxOO1b2zoFwx/TK5wsTrCOOcABFWyxT29L1vBYuHZgdzeNnB0xR29Lmyy/EEWyA8auOIlsl6Wc2xNulgoU4KctdHL9feRhgTOWFnySL8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749811473; c=relaxed/simple;
	bh=nRQZXFMlQ/F7stDH46h8oaoA80Lvp6SfsRdvBG+hgfI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:CC:
	 In-Reply-To:Content-Type; b=bZdAhE+b9k5VzDZidh3x/JItqbyZ3l0MfyKz9/kItB0Qc2cb2+C1HdmfC0DoD7TVQOsUl/z0jFGPvqAqa38tI92/E2+fQ4ayWoxVVNKllzgFAH7ytskdUExxS5GpZSV5utPF5lGHPqxzwhVPmRJOTqabHcgTiCj9jaqIxhGm5J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4bJbZ11ZvMz1GDmn;
	Fri, 13 Jun 2025 18:42:17 +0800 (CST)
Received: from kwepemp200004.china.huawei.com (unknown [7.202.195.99])
	by mail.maildlp.com (Postfix) with ESMTPS id 3B663180064;
	Fri, 13 Jun 2025 18:44:22 +0800 (CST)
Received: from [10.174.186.66] (10.174.186.66) by
 kwepemp200004.china.huawei.com (7.202.195.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 13 Jun 2025 18:44:21 +0800
Message-ID: <a4435153-eb55-4160-9b46-aa937cffa575@huawei.com>
Date: Fri, 13 Jun 2025 18:44:20 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH] smb: client: fix first failure in negotiation after server
 reboot
From: "zhangjian (CG)" <zhangjian496@huawei.com>
To: <stfrench@microsoft.com>, <smfrench@gmail.com>, <longli@microsoft.com>,
	<wangzhaolong1@huawei.com>, <metze@samba.org>, <dhowells@redhat.com>,
	<pc@manguebit.org>
References: <32686cd5-f149-4ea4-a13f-8b1fbb2cca44@huawei.com>
CC: <linux-kernel@vger.kernel.org>, <linux-cifs@vger.kernel.org>
In-Reply-To: <32686cd5-f149-4ea4-a13f-8b1fbb2cca44@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemp200004.china.huawei.com (7.202.195.99)

After fabc4ed200f9, server_unresponsive add a condition to check whether 
client need to reconnect depending on server->lstrp. When client failed 
to reconnect in 180s, client will abort connection and update server->lstrp 
for the last time. In the following scene, server->lstrp is too 
old, which may cause failure for the first negotiation.

client                                                 | server
-------------------------------------------------------+------------------
mount to cifs server                                   |
ls                                                     |
                                                       | reboot
    stuck for 180s and return EHOSTDOWN                |
    abort connection and update server->lstrp          |
                                                       | sleep 21s
                                                       | service smb restart
ls                                                     |
    smb_negotiate                                      |
        server_unresponsive cause reconnect [in cifsd] |
        ( tcpStatus == CifsInNegotiate &&              |
	            jiffies > server->lstrp + 20s )        |
        cifs_sync_mid_result return EAGAIN             |
    smb_negotiate return EHOSTDOWN                     |
ls failed                                              |

The condition (tcpStatus == CifsInNegotiate && jiffies > server->lstrp + 20s)
expect client stay in CifsInNegotiate state for more than 20s. So we update 
server->lstrp before last switching into CifsInNegotiate state to avoid 
this failure.

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
