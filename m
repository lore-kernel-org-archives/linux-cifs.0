Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D962A1EB1AE;
	Wed,  2 Apr 2025 20:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743625709; cv=none; b=PKZjdRYb6H8YVVSW1+SmptkGstXfLsTlI0SYUD2mB3KEfPA0NaltUEGxuDsHH7QGmfYDcPLWR+dkujC/jrCKOPjCQe7SaZUBa2FzUH/I9lUuHGU0Lfpf9h5dkqW26LH4y3Rm91sQoaUVnw0SIwflwluIXj/0CcNex/d3CWZvFZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743625709; c=relaxed/simple;
	bh=FtpCGEuNl17G2Ymfo+C2w/I1tsKwZ73izAJcOxmeRYk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QjHzdQwxXS+TtTNtu9Qi4iU8V2Y2JWtNHO/jBYxSG4+v3/hDqe46KVXy37ADYlCw5EMzWrM3KSgg7PlEll8n9KgNqFYeBg1oCoWo0ruSgub23U3JhZ3J8KDwqYks68IS8x5IVGpPOcd3VRQWZ2gTWQR9bOmmYmU1fIq9IWHIxa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=jbb72JOf; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="jbb72JOf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1743625708; x=1775161708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JfHRXdF+L8mUr6RrdICDegYzcpejtXH20I/ssCi5qYI=;
  b=jbb72JOf9h5Q0SbV35qhSvVDoX/DxwvikWk9SVNn1akUINYTP6oLpwb3
   647dJpZmVynphZpG33Sm5p05cXB2SIl2l5YcKkptH9c/kllMhDOMfVZLa
   P4cIimrYqn32nBc8WFdaS7B3+BtfSVuUHlXrSrs7M+/8JZG89sbkUh/d9
   A=;
X-IronPort-AV: E=Sophos;i="6.15,183,1739836800"; 
   d="scan'208";a="80242805"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 20:28:24 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:14155]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.40.54:2525] with esmtp (Farcaster)
 id 4995e443-ce1d-4d0d-a4f4-5604c14552a4; Wed, 2 Apr 2025 20:28:23 +0000 (UTC)
X-Farcaster-Flow-ID: 4995e443-ce1d-4d0d-a4f4-5604c14552a4
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 2 Apr 2025 20:28:23 +0000
Received: from 6c7e67bfbae3.amazon.com (10.106.101.8) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 2 Apr 2025 20:28:19 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: Steve French <sfrench@samba.org>
CC: Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg
	<ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, "Tom
 Talpey" <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, Enzo
 Matsumiya <ematsumiya@suse.de>, Wang Zhaolong <wangzhaolong1@huawei.com>,
	"Kuniyuki Iwashima" <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <stable@vger.kernel.org>
Subject: [PATCH v2 2/2] Revert "smb: client: fix TCP timers deadlock after rmmod"
Date: Wed, 2 Apr 2025 13:26:48 -0700
Message-ID: <20250402202714.6799-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250402202714.6799-1-kuniyu@amazon.com>
References: <20250402202714.6799-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D042UWA004.ant.amazon.com (10.13.139.16) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

This reverts commit e9f2517a3e18a54a3943c098d2226b245d488801.

Commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock after
rmmod") is intended to fix a null-ptr-deref in LOCKDEP, which is
mentioned as CVE-2024-54680, but is actually did not fix anything;
The issue can be reproduced on top of it. [0]

Also, it reverted the change by commit ef7134c7fc48 ("smb: client:
Fix use-after-free of network namespace.") and introduced a real
issue by reviving the kernel TCP socket.

When a reconnect happens for a CIFS connection, the socket state
transitions to FIN_WAIT_1.  Then, inet_csk_clear_xmit_timers_sync()
in tcp_close() stops all timers for the socket.

If an incoming FIN packet is lost, the socket will stay at FIN_WAIT_1
forever, and such sockets could be leaked up to net.ipv4.tcp_max_orphans.

Usually, FIN can be retransmitted by the peer, but if the peer aborts
the connection, the issue comes into reality.

I warned about this privately by pointing out the exact report [1],
but the bogus fix was finally merged.

So, we should not stop the timers to finally kill the connection on
our side in that case, meaning we must not use a kernel socket for
TCP whose sk->sk_net_refcnt is 0.

The kernel socket does not have a reference to its netns to make it
possible to tear down netns without cleaning up every resource in it.

For example, tunnel devices use a UDP socket internally, but we can
destroy netns without removing such devices and let it complete
during exit.  Otherwise, netns would be leaked when the last application
died.

However, this is problematic for TCP sockets because TCP has timers to
close the connection gracefully even after the socket is close()d.  The
lifetime of the socket and its netns is different from the lifetime of
the underlying connection.

If the socket user does not maintain the netns lifetime, the timer could
be fired after the socket is close()d and its netns is freed up, resulting
in use-after-free.

Actually, we have seen so many similar issues and converted such sockets
to have a reference to netns.

That's why I converted the CIFS client socket to have a reference to
netns (sk->sk_net_refcnt == 1), which is somehow mentioned as out-of-scope
of CIFS and technically wrong in e9f2517a3e18, but **is in-scope and right
fix**.

Regarding the LOCKDEP issue, we can prevent the module unload by
bumping the module refcount when switching the LOCKDDEP key in
sock_lock_init_class_and_name(). [2]

For a while, let's revert the bogus fix.

Note that now we can use sk_net_refcnt_upgrade() for the socket
conversion, but I'll do so later separately to make backport easy.

Link: https://lore.kernel.org/all/20250402020807.28583-1-kuniyu@amazon.com/ #[0]
Link: https://lore.kernel.org/netdev/c08bd5378da647a2a4c16698125d180a@huawei.com/ #[1]
Link: https://lore.kernel.org/lkml/20250402005841.19846-1-kuniyu@amazon.com/ #[2]
Fixes: e9f2517a3e18 ("smb: client: fix TCP timers deadlock after rmmod")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/connect.c | 36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 137a611c5ab0..989d8808260b 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1073,13 +1073,9 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 	msleep(125);
 	if (cifs_rdma_enabled(server))
 		smbd_destroy(server);
-
 	if (server->ssocket) {
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
-
-		/* Release netns reference for the socket. */
-		put_net(cifs_net_ns(server));
 	}
 
 	if (!list_empty(&server->pending_mid_q)) {
@@ -1127,7 +1123,6 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 		 */
 	}
 
-	/* Release netns reference for this server. */
 	put_net(cifs_net_ns(server));
 	kfree(server->leaf_fullpath);
 	kfree(server->hostname);
@@ -1773,8 +1768,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 
 	tcp_ses->ops = ctx->ops;
 	tcp_ses->vals = ctx->vals;
-
-	/* Grab netns reference for this server. */
 	cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));
 
 	tcp_ses->sign = ctx->sign;
@@ -1902,7 +1895,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 out_err_crypto_release:
 	cifs_crypto_secmech_release(tcp_ses);
 
-	/* Release netns reference for this server. */
 	put_net(cifs_net_ns(tcp_ses));
 
 out_err:
@@ -1911,10 +1903,8 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 			cifs_put_tcp_session(tcp_ses->primary_server, false);
 		kfree(tcp_ses->hostname);
 		kfree(tcp_ses->leaf_fullpath);
-		if (tcp_ses->ssocket) {
+		if (tcp_ses->ssocket)
 			sock_release(tcp_ses->ssocket);
-			put_net(cifs_net_ns(tcp_ses));
-		}
 		kfree(tcp_ses);
 	}
 	return ERR_PTR(rc);
@@ -3356,20 +3346,20 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		socket = server->ssocket;
 	} else {
 		struct net *net = cifs_net_ns(server);
+		struct sock *sk;
 
-		rc = sock_create_kern(net, sfamily, SOCK_STREAM, IPPROTO_TCP, &server->ssocket);
+		rc = __sock_create(net, sfamily, SOCK_STREAM,
+				   IPPROTO_TCP, &server->ssocket, 1);
 		if (rc < 0) {
 			cifs_server_dbg(VFS, "Error %d creating socket\n", rc);
 			return rc;
 		}
 
-		/*
-		 * Grab netns reference for the socket.
-		 *
-		 * It'll be released here, on error, or in clean_demultiplex_info() upon server
-		 * teardown.
-		 */
-		get_net(net);
+		sk = server->ssocket->sk;
+		__netns_tracker_free(net, &sk->ns_tracker, false);
+		sk->sk_net_refcnt = 1;
+		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
+		sock_inuse_add(net, 1);
 
 		/* BB other socket options to set KEEPALIVE, NODELAY? */
 		cifs_dbg(FYI, "Socket created\n");
@@ -3383,10 +3373,8 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	}
 
 	rc = bind_socket(server);
-	if (rc < 0) {
-		put_net(cifs_net_ns(server));
+	if (rc < 0)
 		return rc;
-	}
 
 	/*
 	 * Eventually check for other socket options to change from
@@ -3423,7 +3411,6 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	if (rc < 0) {
 		cifs_dbg(FYI, "Error %d connecting to server\n", rc);
 		trace_smb3_connect_err(server->hostname, server->conn_id, &server->dstaddr, rc);
-		put_net(cifs_net_ns(server));
 		sock_release(socket);
 		server->ssocket = NULL;
 		return rc;
@@ -3441,9 +3428,6 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	    (server->rfc1001_sessinit == -1 && sport == htons(RFC1001_PORT)))
 		rc = ip_rfc1001_connect(server);
 
-	if (rc < 0)
-		put_net(cifs_net_ns(server));
-
 	return rc;
 }
 
-- 
2.48.1

