Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3E3299A9C;
	Thu, 17 Jul 2025 11:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752752088; cv=none; b=UnHfl7ifeIShNhzzREQHZkDC8VOgJ5vlkj9JCoUDg9J1jbkMb1ettWeul0GrJ68M30G67L7wDz//vzpKKffPX/O/6k/SDoO2w+3OHh8qzMTwTJMarAQusajw/umG0PFVfhwRPCkOUm0YGXgGF0ifZ7ORoPDm84IdpzvP/+waxTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752752088; c=relaxed/simple;
	bh=q87xu0qKl0pgZ4FVa9gRqe6S1D5ezSfSkXLD0Hzt0j0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kwI1SxLO2gT3ylEBtXTir8bNCB8GyByVHvwDKIdHcQep3w7qrmgdLO4wj/+UdsQH9Yf8/mO57TGX16w8A46MFbhsRB8pVRbzpxTi/9vBSWg+kujWiNLebcwvfwbn6ZULOFWV/l/hsyI4Wh+0uUD+ehVbYRBfz15n4KBQoQv7Idk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bjW6p44wTzKHbqt;
	Thu, 17 Jul 2025 19:34:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2ABBD1A2403;
	Thu, 17 Jul 2025 19:34:41 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDnYhPK33ho1P1DAg--.41809S4;
	Thu, 17 Jul 2025 19:34:36 +0800 (CST)
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
To: sfrench@samba.org,
	kuniyu@google.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	chengzhihao1@huawei.com,
	wangzhaolong1@huawei.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH] smb: client: fix netns refcount leak after net_passive changes
Date: Thu, 17 Jul 2025 19:28:32 +0800
Message-Id: <20250717112832.1658564-1-wangzhaolong@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnYhPK33ho1P1DAg--.41809S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGr48Ww4rXrWxXF4DtFykuFg_yoWrtFy5pr
	4rKF9rCr48Xr18Zan5JF45Ca48Zr4fZ3W3G3s3Ww18Za98GFy7tanFvr4jgFW2krWkW34I
	gF4qgFWjvayqv3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsUUUUUU==
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/

After commit 5c70eb5c593d ("net: better track kernel sockets lifetime"),
kernel sockets now use net_passive reference counting. However, commit
95d2b9f693ff ("Revert "smb: client: fix TCP timers deadlock after rmmod"")
restored the manual socket refcount manipulation without adapting to this
new mechanism, causing a memory leak.

The issue manifests as multiple memory leaks when mounting/unmounting CIFS
in network namespaces:

unreferenced object 0xffff9951419f6b00 (size 256):
  comm "ip", pid 447, jiffies 4294692389 (age 14.730s)
  hex dump (first 32 bytes):
    1b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 80 77 c2 44 51 99 ff ff  .........w.DQ...
  backtrace:
    __kmem_cache_alloc_node+0x30e/0x3d0
    __kmalloc+0x52/0x120
    net_alloc_generic+0x1d/0x30
    copy_net_ns+0x86/0x200
    create_new_namespaces+0x117/0x300
    unshare_nsproxy_namespaces+0x60/0xa0
    ksys_unshare+0x148/0x360
    __x64_sys_unshare+0x12/0x20
    do_syscall_64+0x59/0x110
    entry_SYSCALL_64_after_hwframe+0x78/0xe2
...
unreferenced object 0xffff9951442e7500 (size 32):
  comm "mount.cifs", pid 475, jiffies 4294693782 (age 13.343s)
  hex dump (first 32 bytes):
    40 c5 38 46 51 99 ff ff 18 01 96 42 51 99 ff ff  @.8FQ......BQ...
    01 00 00 00 6f 00 c5 07 6f 00 d8 07 00 00 00 00  ....o...o.......
  backtrace:
    __kmem_cache_alloc_node+0x30e/0x3d0
    kmalloc_trace+0x2a/0x90
    ref_tracker_alloc+0x8e/0x1d0
    sk_alloc+0x18c/0x1c0
    inet_create+0xf1/0x370
    __sock_create+0xd7/0x1e0
    generic_ip_connect+0x1d4/0x5a0 [cifs]
    cifs_get_tcp_session+0x5d0/0x8a0 [cifs]
    cifs_mount_get_session+0x47/0x1b0 [cifs]
    dfs_mount_share+0xfa/0xa10 [cifs]
    cifs_mount+0x68/0x2b0 [cifs]
    cifs_smb3_do_mount+0x10b/0x760 [cifs]
    smb3_get_tree+0x112/0x2e0 [cifs]
    vfs_get_tree+0x29/0xf0
    path_mount+0x2d4/0xa00
    __se_sys_mount+0x165/0x1d0

Root cause:
When creating kernel sockets, sk_alloc() calls net_passive_inc() for
sockets with sk_net_refcnt=0. The CIFS code manually converts kernel
sockets to user sockets by setting sk_net_refcnt=1, but doesn't call
the corresponding net_passive_dec(). This creates an imbalance in the
net_passive counter, which prevents the network namespace from being
destroyed when its last user reference is dropped. As a result, the
entire namespace and all its associated resources remain allocated.

Timeline of patches leading to this issue:
- commit ef7134c7fc48 ("smb: client: Fix use-after-free of network
  namespace.") in v6.12 fixed the original netns UAF by manually
  managing socket refcounts
- commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock after
  rmmod") in v6.13 attempted to use kernel sockets but introduced
  TCP timer issues
- commit 5c70eb5c593d ("net: better track kernel sockets lifetime")
  in v6.14-rc5 introduced the net_passive mechanism with
  sk_net_refcnt_upgrade() for proper socket conversion
- commit 95d2b9f693ff ("Revert "smb: client: fix TCP timers deadlock
  after rmmod"") in v6.15-rc3 reverted to manual refcount management
  without adapting to the new net_passive changes

Fix this by using sk_net_refcnt_upgrade() which properly handles the
net_passive counter when converting kernel sockets to user sockets.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220343 [1]
Fixes: 95d2b9f693ff ("Revert "smb: client: fix TCP timers deadlock after rmmod"")
Cc: stable@vger.kernel.org
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
---
 fs/smb/client/connect.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 205f547ca49e..5eec8957f2a9 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3360,22 +3360,19 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		socket = server->ssocket;
 	} else {
 		struct net *net = cifs_net_ns(server);
 		struct sock *sk;
 
-		rc = __sock_create(net, sfamily, SOCK_STREAM,
-				   IPPROTO_TCP, &server->ssocket, 1);
+		rc = sock_create_kern(net, sfamily, SOCK_STREAM,
+				      IPPROTO_TCP, &server->ssocket);
 		if (rc < 0) {
 			cifs_server_dbg(VFS, "Error %d creating socket\n", rc);
 			return rc;
 		}
 
 		sk = server->ssocket->sk;
-		__netns_tracker_free(net, &sk->ns_tracker, false);
-		sk->sk_net_refcnt = 1;
-		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
-		sock_inuse_add(net, 1);
+		sk_net_refcnt_upgrade(sk);
 
 		/* BB other socket options to set KEEPALIVE, NODELAY? */
 		cifs_dbg(FYI, "Socket created\n");
 		socket = server->ssocket;
 		socket->sk->sk_allocation = GFP_NOFS;
-- 
2.39.2

