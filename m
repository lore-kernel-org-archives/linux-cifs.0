Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7774EB50
	for <linux-cifs@vger.kernel.org>; Sat,  2 Nov 2024 20:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730579452; cv=none; b=KVkrKXZ47BiQjzGMIt3HoxbWyz5mvUVd5/0qC4gkZnGZGpih6DjAoG1v/uRswecKZVlW2LyWDzbjz4TmAVGx5cUli8KFXUUj+40+oLfWVQeUfe2wg93QlN8ykkOMuea0vNDzZ9eCR9eb0b5vqFxPyg7r+2NK0muqJQ3ASfDad1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730579452; c=relaxed/simple;
	bh=5Pswzc269cKfkKNYS+yeRgNoETTQG3iKz/L/YRPJBR8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IN2cUK+9QU6sTLb2Xs6Z8crYJWAkg+uDYy49IXX4CH0JWlxlWpfg29HVJvJyq0bba9522ezMRuHtsEGy9zNXn+yI9F3tRi/ZyAd9O3LPFj+beZDT/aA5pQnZHYT25aRC6tNuyA5u3tENihlLZNwbn50Ex6WkVvFTGmee3ovI8Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=t04ZKvIo; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="t04ZKvIo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730579450; x=1762115450;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NVZXQPIDP21lQsx7P4Rln5N4yGbncszdnXphYL4Okvc=;
  b=t04ZKvIoGsgPuN8sMzyK+vrifbcx7e5msYYZ7+yPAA52BR/uHjuso6ix
   Q67JRBKfaO0Kv//hwB2xcZC5Azw8hNvTXXjBI4WT74mP3vit2038nks9s
   utezHfI1IoQxymUDEhQMJTVq8hMaPSAcujJ8VXfSx+z3IhRT7p2iseMKR
   M=;
X-IronPort-AV: E=Sophos;i="6.11,253,1725321600"; 
   d="scan'208";a="143893700"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2024 20:30:48 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.21.151:23536]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.24.36:2525] with esmtp (Farcaster)
 id 6fd3c043-6280-4491-9a9c-373e66f25104; Sat, 2 Nov 2024 20:30:48 +0000 (UTC)
X-Farcaster-Flow-ID: 6fd3c043-6280-4491-9a9c-373e66f25104
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Sat, 2 Nov 2024 20:30:47 +0000
Received: from 6c7e67c6786f.amazon.com (10.187.170.38) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Sat, 2 Nov 2024 20:30:44 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <kuniyu@amazon.com>
CC: <bharathsm@microsoft.com>, <kuni1840@gmail.com>,
	<linux-cifs@vger.kernel.org>, <pc@manguebit.com>, <ronniesahlberg@gmail.com>,
	<samba-technical@lists.samba.org>, <sfrench@samba.org>,
	<sprasad@microsoft.com>, <tom@talpey.com>
Subject: Re: [PATCH v1] smb: client: Fix use-after-free of network namespace.
Date: Sat, 2 Nov 2024 13:30:41 -0700
Message-ID: <20241102203041.71353-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20241031175709.20111-1-kuniyu@amazon.com>
References: <20241031175709.20111-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D042UWB003.ant.amazon.com (10.13.139.135) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

From: Kuniyuki Iwashima <kuniyu@amazon.com>
Date: Thu, 31 Oct 2024 10:57:09 -0700
> @@ -3071,7 +3070,7 @@ generic_ip_connect(struct TCP_Server_Info *server)
>  		socket = server->ssocket;
>  	} else {
>  		rc = __sock_create(cifs_net_ns(server), sfamily, SOCK_STREAM,
> -				   IPPROTO_TCP, &server->ssocket, 1);
> +				   IPPROTO_TCP, &server->ssocket, 0);

I missed BPF inet_release() hook is invoked for sockets with
sk->sk_kern_sock 0.

This is trivial, but I'll post v2 with the diff below following the
SMC's approach I took in commit 9744d2bf1976 ("smc: Fix use-after-free
in tcp_write_timer_handler().").

---8<---
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 15d94ac4095e..0ce2d704b1f3 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1037,6 +1037,7 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 		 */
 	}
 
+	put_net(cifs_net_ns(server));
 	kfree(server->leaf_fullpath);
 	kfree(server);
 
@@ -1635,8 +1636,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	/* srv_count can never go negative */
 	WARN_ON(server->srv_count < 0);
 
-	put_net(cifs_net_ns(server));
-
 	list_del_init(&server->tcp_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
@@ -3070,13 +3069,22 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	if (server->ssocket) {
 		socket = server->ssocket;
 	} else {
-		rc = __sock_create(cifs_net_ns(server), sfamily, SOCK_STREAM,
+		struct net *net = cifs_net_ns(server);
+		struct sock *sk;
+
+		rc = __sock_create(net, sfamily, SOCK_STREAM,
 				   IPPROTO_TCP, &server->ssocket, 1);
 		if (rc < 0) {
 			cifs_server_dbg(VFS, "Error %d creating socket\n", rc);
 			return rc;
 		}
 
+		sk = server->ssocket->sk;
+		__netns_tracker_free(net, &sk->ns_tracker, false);
+		sk->sk_net_refcnt = 1;
+		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
+		sock_inuse_add(net, 1);
+
 		/* BB other socket options to set KEEPALIVE, NODELAY? */
 		cifs_dbg(FYI, "Socket created\n");
 		socket = server->ssocket;
---8<---
