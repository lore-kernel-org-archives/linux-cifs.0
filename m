Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E14B233956;
	Tue, 19 May 2026 10:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779187476; cv=none; b=qHDqFNe2NRzh13e8oByldo3RmKf1k4HdFfOSemOhoRjv/ZP/t0ATV0tLgxvAblS7+MyefYgeCr4q1iyjmrdj/JF8ytkqjWr9ohHzPCr+KtqUPF3OlcYQu1jaJMOK0BEvSJNZuVH/9HlOO2z28z+8dqTXaKBDatU4865eUPPRUxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779187476; c=relaxed/simple;
	bh=M6E16+9WcUBhQNEgEc7PGvV1JPAOHgKbaA8w3PpnA/8=;
	h=Message-ID:Date:MIME-Version:From:To:CC:Subject:Content-Type; b=n6RgquMQmin1tzZW9fqRTByo7MFRCRE+joRiA//N3sLhFgAPwCTGH4Tgb/9d5hWZpIHiwK/YMts8XqYzHdMZdzZMR7aYh6qjVUw+mYjYf2KUMzHMvyMOz47Nv2AV/QzKwsXwD3xe/BAMNpz9kw6Grayfh5Hs+bNNPEXCf8+04sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=eQQEj0Rh; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="eQQEj0Rh"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7BenvM+wpqH29W2mFeP6Af3H+6aB04VGByz4Gv/FIL0=;
	b=eQQEj0Rhbv6oE/IrbwDE//Sq7eTVInc/95wquqEgeBLCeikYsQ5LpJkKjUTBUhDbRJVNr/HYk
	lS+AFU0WNydUuBLnRH85tm/cNBVg8XAW8TQJHQJqrNQZuyCOD2movrdhpeLC1QiO4mMmG8VOm37
	JS6vOJIbR1drDHrveObBdJk=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gKWLd5llgzmV6W;
	Tue, 19 May 2026 18:36:41 +0800 (CST)
Received: from dggpemr100013.china.huawei.com (unknown [7.185.36.198])
	by mail.maildlp.com (Postfix) with ESMTPS id CC9AB402AB;
	Tue, 19 May 2026 18:44:23 +0800 (CST)
Received: from [10.174.186.66] (10.174.186.66) by
 dggpemr100013.china.huawei.com (7.185.36.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 19 May 2026 18:44:22 +0800
Message-ID: <616cbc26-d8a9-418a-91f3-11e470087aa4@huawei.com>
Date: Tue, 19 May 2026 18:44:22 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "zhangjian (CG)" <zhangjian496@huawei.com>
To: <sfrench@samba.org>
CC: <pc@manguebit.org>, <ronniesahlberg@gmail.com>, <sprasad@microsoft.com>,
	<tom@talpey.com>, <bharathsm@microsoft.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>
Subject: cifs: remove all cifs files before kill super
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemr100013.china.huawei.com (7.185.36.198)

Cifs files may be put into fileinfo_put_wq during umounting cifs.
After umount done, cifsFileInfo_put_final is called, which cause
following BUG:

BUG: kernel NULL pointer dereference, address: 0000000000000000
...
[  134.222152]  list_lru_add+0x64/0x1a0
[  134.222399]  ? cifs_put_tcon+0x171/0x340 [cifs]
[  134.222772]  d_lru_add+0x44/0x60
[  134.222997]  dput+0x1fc/0x210
[  134.223213]  cifsFileInfo_put_final+0x11a/0x140 [cifs]
[  134.223576]  process_one_work+0x17c/0x320
[  134.223843]  worker_thread+0x188/0x280
[  134.224084]  ? __pfx_worker_thread+0x10/0x10
[  134.224366]  kthread+0xcc/0x100
[  134.224576]  ? __pfx_kthread+0x10/0x10
[  134.224827]  ret_from_fork+0x30/0x50
[  134.225063]  ? __pfx_kthread+0x10/0x10
[  134.225328]  ret_from_fork_asm+0x1b/0x30

This can be reproduce by following:
unshare -n bash -c "
mkdir -p ${CIFS_MNT}
ip netns attach root 1
ip link add eth0 type veth peer veth0 netns root
ip link set eth0 up
ip -n root link set veth0 up
ip addr add 192.168.0.2/24 dev eth0
ip -n root addr add 192.168.0.1/24 dev veth0
ip route add default via 192.168.0.1 dev eth0
ip netns exec root sysctl net.ipv4.ip_forward=1
ip netns exec root iptables -t nat -A POSTROUTING -s 192.168.0.2 -o
${DEV} -j MASQUERADE
mount -t cifs ${CIFS_PATH} ${CIFS_MNT} -o
vers=3.0,sec=ntlmssp,credentials=${CIFS_CRED},rsize=65536,wsize=65536,cache=none,echo_interval=1
touch ${CIFS_MNT}/a.txt
ip netns exec root iptables -t nat -D POSTROUTING -s 192.168.0.2 -o
${DEV} -j MASQUERADE
"
umount ${CIFS_MNT}

Fixes: 340cea84f69 ("cifs: open files should not hold ref on superblock")

Signed-off-by: Jian Zhang <zhangjian496@huawei.com>
---
 fs/smb/client/connect.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index dcde25d..7d09f07 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3996,6 +3996,9 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);

+    flush_workqueue(serverclose_wq);
+    flush_workqueue(fileinfo_put_wq);
+
 	kfree(cifs_sb->prepath);
 	call_rcu(&cifs_sb->rcu, delayed_free);
 }
-- 
2.23.0

