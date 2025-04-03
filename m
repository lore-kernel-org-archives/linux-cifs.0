Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C261854
	for <linux-cifs@vger.kernel.org>; Thu,  3 Apr 2025 03:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743649969; cv=none; b=B41wTlmjjhFHcCCsPkp3xG7YVDY40trA5aGgougSCFj/krVl8uWp2m+KGgGj1ChnpC/FgwfI/OQw4aZiTVRx8Pl1zDI8o7pf13PtuBlsm4CyDRJJyVK2gqSaLN+qlAsHxZBJGlNeFjK0xsmm7FZJmI1QVO/F8k4BUfJJUVq1jwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743649969; c=relaxed/simple;
	bh=V6BBXq0ai2ubei8g+g67Wu7ckEKC+Vo12CFqIy26qXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Bj/gvQDpWJIS9074MwQVe7dLNb383rXsnbnFr+cCXVRPpUP/TkLYxnrOWAZ55CqmBB5kNfbj+2veMLzjvKQK4AYFzQ686FyF1tzRxcFd9Cfi3inyVNev7iPLEC+ziBJlECvy2WGWBbNgqlh2Xy1D/FcS2IVpbfFyELM2Jm0Aq9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ZSmt81mJ4z2CdTg;
	Thu,  3 Apr 2025 11:09:20 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 9E924140146;
	Thu,  3 Apr 2025 11:12:40 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 3 Apr 2025 11:12:39 +0800
Message-ID: <51c59271-c05f-4c36-a01b-4522cf47e2af@huawei.com>
Date: Thu, 3 Apr 2025 11:12:38 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] Revert "smb: client: fix TCP timers deadlock after
 rmmod"
To: Kuniyuki Iwashima <kuniyu@amazon.com>, Steve French <sfrench@samba.org>
CC: Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg
	<ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, Enzo Matsumiya
	<ematsumiya@suse.de>, Kuniyuki Iwashima <kuni1840@gmail.com>,
	<linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>
References: <20250402200319.2834-1-kuniyu@amazon.com>
 <20250402200319.2834-3-kuniyu@amazon.com>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
In-Reply-To: <20250402200319.2834-3-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg500010.china.huawei.com (7.202.181.71)

Thanks Kuniyuki for the thorough explanation and fix. Your analysis of
the TCP socket lifecycle and reference counting is excellent!

This reversion is definitely the right approach.

Acked-by: Wang Zhaolong <wangzhaolong1@huawei.com>

> This reverts commit e9f2517a3e18a54a3943c098d2226b245d488801.
> 
> Commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock after
> rmmod") is intended to fix a null-ptr-deref in LOCKDEP, which is
> mentioned as CVE-2024-54680, but is actually did not fix anything;
> The issue can be reproduced on top of it. [0]
> 
> Also, it reverted the change by commit ef7134c7fc48 ("smb: client:
> Fix use-after-free of network namespace.") and introduced a real
> issue by reviving the kernel TCP socket.
> 
> When a reconnect happens for a CIFS connection, the socket state
> transitions to FIN_WAIT_1.  Then, inet_csk_clear_xmit_timers_sync()
> in tcp_close() stops all timers for the socket.
> 
> If an incoming FIN packet is lost, the socket will stay at FIN_WAIT_1
> forever, and such sockets could be leaked up to net.ipv4.tcp_max_orphans.
> 
> Usually, FIN can be retransmitted by the peer, but if the peer aborts
> the connection, the issue comes into reality.
> 
> I warned about this privately by pointing out the exact report [1],
> but the bogus fix was finally merged.
> 
> So, we should not stop the timers to finally kill the connection on
> our side in that case, meaning we must not use a kernel socket for
> TCP whose sk->sk_net_refcnt is 0.
> 
> The kernel socket does not have a reference to its netns to make it
> possible to tear down netns without cleaning up every resource in it.
> 
> For example, tunnel devices use a UDP socket internally, but we can
> destroy netns without removing such devices and let it complete
> during exit.  Otherwise, netns would be leaked when the last application
> died.
> 
> However, this is problematic for TCP sockets because TCP has timers to
> close the connection gracefully even after the socket is close()d.  The
> lifetime of the socket and its netns is different from the lifetime of
> the underlying connection.
> 
> If the socket user does not maintain the netns lifetime, the timer could
> be fired after the socket is close()d and its netns is freed up, resulting
> in use-after-free.
> 
> Actually, we have seen so many similar issues and converted such sockets
> to have a reference to netns.
> 
> That's why I converted the CIFS client socket to have a reference to
> netns (sk->sk_net_refcnt == 1), which is somehow mentioned as out-of-scope
> of CIFS and technically wrong in e9f2517a3e18, but **is in-scope and right
> fix**.
> 
> Regarding the LOCKDEP issue, we can prevent the module unload by
> bumping the module refcount when switching the LOCKDDEP key in
> sock_lock_init_class_and_name(). [2]
> 
> For a while, let's revert the bogus fix.
> 
> Note that now we can use sk_net_refcnt_upgrade() for the socket
> conversion, but I'll do so later separately to make backport easy.
> 
> Link: https://lore.kernel.org/all/20250402020807.28583-1-kuniyu@amazon.com/ #[0]
> Link: https://lore.kernel.org/netdev/c08bd5378da647a2a4c16698125d180a@huawei.com/ #[1]
> Link: https://lore.kernel.org/lkml/20250402005841.19846-1-kuniyu@amazon.com/ #[2]
> Fixes: e9f2517a3e18 ("smb: client: fix TCP timers deadlock after rmmod")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>   fs/smb/client/connect.c | 36 ++++++++++--------------------------
>   1 file changed, 10 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 137a611c5ab0..989d8808260b 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1073,13 +1073,9 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
>   	msleep(125);
>   	if (cifs_rdma_enabled(server))
>   		smbd_destroy(server);
> -
>   	if (server->ssocket) {
>   		sock_release(server->ssocket);
>   		server->ssocket = NULL;
> -
> -		/* Release netns reference for the socket. */
> -		put_net(cifs_net_ns(server));
>   	}
>   
>   	if (!list_empty(&server->pending_mid_q)) {
> @@ -1127,7 +1123,6 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
>   		 */
>   	}
>   
> -	/* Release netns reference for this server. */
>   	put_net(cifs_net_ns(server));
>   	kfree(server->leaf_fullpath);
>   	kfree(server->hostname);
> @@ -1773,8 +1768,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
>   
>   	tcp_ses->ops = ctx->ops;
>   	tcp_ses->vals = ctx->vals;
> -
> -	/* Grab netns reference for this server. */
>   	cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));
>   
>   	tcp_ses->sign = ctx->sign;
> @@ -1902,7 +1895,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
>   out_err_crypto_release:
>   	cifs_crypto_secmech_release(tcp_ses);
>   
> -	/* Release netns reference for this server. */
>   	put_net(cifs_net_ns(tcp_ses));
>   
>   out_err:
> @@ -1911,10 +1903,8 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
>   			cifs_put_tcp_session(tcp_ses->primary_server, false);
>   		kfree(tcp_ses->hostname);
>   		kfree(tcp_ses->leaf_fullpath);
> -		if (tcp_ses->ssocket) {
> +		if (tcp_ses->ssocket)
>   			sock_release(tcp_ses->ssocket);
> -			put_net(cifs_net_ns(tcp_ses));
> -		}
>   		kfree(tcp_ses);
>   	}
>   	return ERR_PTR(rc);
> @@ -3356,20 +3346,20 @@ generic_ip_connect(struct TCP_Server_Info *server)
>   		socket = server->ssocket;
>   	} else {
>   		struct net *net = cifs_net_ns(server);
> +		struct sock *sk;
>   
> -		rc = sock_create_kern(net, sfamily, SOCK_STREAM, IPPROTO_TCP, &server->ssocket);
> +		rc = __sock_create(net, sfamily, SOCK_STREAM,
> +				   IPPROTO_TCP, &server->ssocket, 1);
>   		if (rc < 0) {
>   			cifs_server_dbg(VFS, "Error %d creating socket\n", rc);
>   			return rc;
>   		}
>   
> -		/*
> -		 * Grab netns reference for the socket.
> -		 *
> -		 * It'll be released here, on error, or in clean_demultiplex_info() upon server
> -		 * teardown.
> -		 */
> -		get_net(net);
> +		sk = server->ssocket->sk;
> +		__netns_tracker_free(net, &sk->ns_tracker, false);
> +		sk->sk_net_refcnt = 1;
> +		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
> +		sock_inuse_add(net, 1);
>   
>   		/* BB other socket options to set KEEPALIVE, NODELAY? */
>   		cifs_dbg(FYI, "Socket created\n");
> @@ -3383,10 +3373,8 @@ generic_ip_connect(struct TCP_Server_Info *server)
>   	}
>   
>   	rc = bind_socket(server);
> -	if (rc < 0) {
> -		put_net(cifs_net_ns(server));
> +	if (rc < 0)
>   		return rc;
> -	}
>   
>   	/*
>   	 * Eventually check for other socket options to change from
> @@ -3423,7 +3411,6 @@ generic_ip_connect(struct TCP_Server_Info *server)
>   	if (rc < 0) {
>   		cifs_dbg(FYI, "Error %d connecting to server\n", rc);
>   		trace_smb3_connect_err(server->hostname, server->conn_id, &server->dstaddr, rc);
> -		put_net(cifs_net_ns(server));
>   		sock_release(socket);
>   		server->ssocket = NULL;
>   		return rc;
> @@ -3441,9 +3428,6 @@ generic_ip_connect(struct TCP_Server_Info *server)
>   	    (server->rfc1001_sessinit == -1 && sport == htons(RFC1001_PORT)))
>   		rc = ip_rfc1001_connect(server);
>   
> -	if (rc < 0)
> -		put_net(cifs_net_ns(server));
> -
>   	return rc;
>   }
>   

