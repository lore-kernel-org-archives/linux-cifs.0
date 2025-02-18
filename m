Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD7326A1A4;
	Tue, 18 Feb 2025 14:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739889013; cv=none; b=M0MBRHuXa/iPpBN4/lm95M1O2asuS4Cv4+5k1nloCygF7PtN42QPCtjtVBfUns/bzsXPHirahgcfY+VtRkL5svCkIAUZtRi0My9CCv51ynaa6UMwHrY5buOnbtBD862qp1g3sdRQ5zvlaUDeHE6stZAN5s647sJ9YMXp28A1PsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739889013; c=relaxed/simple;
	bh=6oT5QNYRay3daY57dj/1aLFeR6e5vZ7XBdTvElEpiNM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UbxV2A93vY28JFbHsFaaKS7mfqV1L0/Cz5Af5MzrQRmrW7zU7dPNLP14zvIxFDGP2KevFoeKjFDPkQWg2i5iV4ShLxqLKJ3wJiGcHJTIv66yj64S/I2cfEKBU9SB8dKFDTtIwcExdAifHtkJe+d84OTXkp5NgGzfPHtw2XPFAZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Yy24Z1tLQzpkCb;
	Tue, 18 Feb 2025 22:30:38 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 911971401F1;
	Tue, 18 Feb 2025 22:30:07 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemg500010.china.huawei.com
 (7.202.181.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 18 Feb
 2025 22:30:06 +0800
From: Wang Zhaolong <wangzhaolong1@huawei.com>
To: <sfrench@samba.org>, <tom@talpey.com>, <kuniyu@amazon.com>,
	<ematsumiya@suse.de>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <wangzhaolong1@huawei.com>,
	<yi.zhang@huawei.com>
Subject: [PATCH] smb: client: Fix netns refcount imbalance causing leaks and use-after-free
Date: Tue, 18 Feb 2025 22:30:05 +0800
Message-ID: <20250218143005.1318886-1-wangzhaolong1@huawei.com>
X-Mailer: git-send-email 2.34.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemg500010.china.huawei.com (7.202.181.71)

Commit ef7134c7fc48 ("smb: client: Fix use-after-free of network
namespace.") attempted to fix a netns use-after-free issue by manually
adjusting reference counts via sk->sk_net_refcnt and sock_inuse_add().

However, a later commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock
after rmmod") pointed out that the approach of manually setting
sk->sk_net_refcnt in the first commit was technically incorrect, as
sk->sk_net_refcnt should only be set for user sockets. It led to issues
like TCP timers not being cleared properly on close. The second commit
moved to a model of just holding an extra netns reference for
server->ssocket using get_net(), and dropping it when the server is torn
down.

But there remain some gaps in the get_net()/put_net() balancing added by
these commits. The incomplete reference handling in these fixes results
in two issues:

1. Netns refcount leaks[1]

The problem process is as follows:

```
mount.cifs                        cifsd

cifs_do_mount
  cifs_mount
    cifs_mount_get_session
      cifs_get_tcp_session
        get_net()  /* First get net. */
        ip_connect
          generic_ip_connect /* Try port 445 */
            get_net()
            ->connect() /* Failed */
            put_net()
          generic_ip_connect /* Try port 139 */
            get_net() /* Missing matching put_net() for this get_net().*/
      cifs_get_smb_ses
        cifs_negotiate_protocol
          smb2_negotiate
            SMB2_negotiate
              cifs_send_recv
                wait_for_response
                                 cifs_demultiplex_thread
                                   cifs_read_from_socket
                                     cifs_readv_from_socket
                                       cifs_reconnect
                                         cifs_abort_connection
                                           sock_release();
                                           server->ssocket = NULL;
                                           /* Missing put_net() here. */
                                           generic_ip_connect
                                             get_net()
                                             ->connect() /* Failed */
                                             put_net()
                                             sock_release();
                                             server->ssocket = NULL;
          free_rsp_buf
    ...
                                   clean_demultiplex_info
                                     /* It's only called once here. */
                                     put_net()
```

When cifs_reconnect() is triggered, the server->ssocket is released
without a corresponding put_net() for the reference acquired in
generic_ip_connect() before. it ends up calling generic_ip_connect()
again to retry get_net(). After that, server->ssocket is set to NULL
in the error path of generic_ip_connect(), and the net count cannot be
released in the final clean_demultiplex_info() function.

2. Potential use-after-free

The current refcounting scheme can lead to a potential use-after-free issue
in the following scenario:

```
 cifs_do_mount
   cifs_mount
     cifs_mount_get_session
       cifs_get_tcp_session
         get_net()  /* First get net */
           ip_connect
             generic_ip_connect
               get_net()
               bind_socket
	         kernel_bind /* failed */
               put_net()
         /* after out_err_crypto_release label */
         put_net()
         /* after out_err label */
         put_net()
```

In the exception handling process where binding the socket fails, the
get_net() and put_net() calls are unbalanced, which may cause the
server->net reference count to drop to zero and be prematurely released.

To address both issues, this patch ties the netns reference counting to
the server->ssocket and server lifecycles. The extra reference is now
acquired when the server or socket is created, and released when the
socket is destroyed or the server is torn down.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=219792

Fixes: ef7134c7fc48 ("smb: client: Fix use-after-free of network namespace.")
Fixes: e9f2517a3e18 ("smb: client: fix TCP timers deadlock after rmmod")
Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
---
 fs/smb/client/connect.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index f917de020dd5..0d454149f3b4 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -300,6 +300,7 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 			 server->ssocket->flags);
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
+		put_net(cifs_net_ns(server));
 	}
 	server->sequence_number = 0;
 	server->session_estab = false;
@@ -3115,8 +3116,12 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		/*
 		 * Grab netns reference for the socket.
 		 *
-		 * It'll be released here, on error, or in clean_demultiplex_info() upon server
-		 * teardown.
+		 * This reference will be released in several situations:
+		 * - In the failure path before the cifsd thread is started.
+		 * - In the all place where server->socket is released, it is
+		 *   also set to NULL.
+		 * - Ultimately in clean_demultiplex_info(), during the final
+		 *   teardown.
 		 */
 		get_net(net);
 
@@ -3132,10 +3137,8 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	}
 
 	rc = bind_socket(server);
-	if (rc < 0) {
-		put_net(cifs_net_ns(server));
+	if (rc < 0)
 		return rc;
-	}
 
 	/*
 	 * Eventually check for other socket options to change from
@@ -3181,9 +3184,6 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	if (sport == htons(RFC1001_PORT))
 		rc = ip_rfc1001_connect(server);
 
-	if (rc < 0)
-		put_net(cifs_net_ns(server));
-
 	return rc;
 }
 
-- 
2.34.3

